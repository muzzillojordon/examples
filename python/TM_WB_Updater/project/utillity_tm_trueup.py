# **********TM True Up Functions**********
import pandas as pd
import json
import numpy as np
from .errors import *

# example of an FHR_TM MetaData Field
# [{"Name": "Zscore", "Hash": "951cadb83c00415ea14d495ec9357ae6", "ID": "ZScore Limit Test", "Package": "Standard", "Test": "None", "StdDevCountLo": "-3",
# "StdDevCountHi": "3", "WindowSize": null, "WindowFreq": null, "MinStdDev": null, "Deadband": "2h", "RunStatusCondition": "1.toSignal().toCondition()",
# "StartUpLag": "2h", "_status": "\u2713", "_rules": ""}, {"Name": "ROCRunningDeltaZscore", "Hash": "0361f7e2910b4b3c8a91e5952f81bb23",
# "ID": "331856D8-2BF5-47B4-9EF1-DCA9C515120A", "Package": "FHR", "Test": "ZScore Limit Test", "Duration": "180d", "StdDevCountLo": "-99999", "StdDevCountHi": "10",
# "WindowSize": null, "WindowFreq": null, "MinStdDev": null, "Deadband": "2h", "RunStatusCondition": "1.toSignal().toCondition()", "StartUpLag": "2d",
# "_status": "\u2713", "_rules": ""}, {"Name": "ROCRegFixedLimit", "Hash": "25064bed6fbe4e36b41858a04774d6b1", "ID": "2FBAA1EE-648A-4341-ABF0-98F83DEA90D2",
# "Package": "FHR", "Test": "Fixed Limit Test", "Duration": "180d", "Lo": "-9999", "Hi": "10", "Deadband": "1h", "RunStatusCondition": "1.toSignal().toCondition()",
# "StartUpLag": "2d", "_status": "\u2713", "_rules": ""}, {"Name": "ROCRegZscore", "Hash": "7798269f06da439bbf949864e08f8d53",
# "ID": "2FBAA1EE-648A-4341-ABF0-98F83DEA90D2", "Package": "FHR", "Test": "ZScore Limit Test", "Duration": "180d", "StdDevCountLo": "-99999",
# "StdDevCountHi": "10", "WindowSize": null, "WindowFreq": null, "MinStdDev": null, "Deadband": "2d", "RunStatusCondition": "1.toSignal().toCondition()",
# "StartUpLag": "2d", "_status": "\u2713", "_rules": ""}]


def standardize_formula_fhr_tm(test_id_name_df):
    """Function formats test name and TestID given in the signal name to match the FHR_TM format.
    In order to check if parameters of a test have changed we need to know which test parameters inside FHR_TM to check (each FHR_TM can contain multiple tests).

    There is a unique match by the signal and its associated FHR_TM instance by formula name and ID:
    example: 47AI0041_FixedLimit_ can only exist 1 time in assetTree. If another FixedLimit test is added (47AI0041_FixedLimit_), with a different name in TM,
        the signal 47AI0041_FixedLimit_ in asset tree will be over written or the new test will not get added

    within the FHR_TM metadata field there are two items needed to correlate the seeq api formula:
    TestID ==>(FHR_TM: 'ID'):
        A Formula ID can be used only once in an FHR_TM field instance, ie, there can only be one 'Fixed Limit Test' or one 'forcastFixedLimit'.
        for standard tests (fixed limit and Zscore) TestID value will be 'Fixed Limit Test' or 'ZScore Limit Test'
        for non standard test (rateOfChangeRegression, etc.) TestID value will be the seeq api formula ID ('3B5DFE52-69CA-49DF-BA2F-923F5488A677', etc.)
        NOTE: as of now only the name of the test is known, later it will be converted to the Test ID in seeq api.
    TestName ==> (FHR_TM: 'Test'):
        Test name can be used multiple times in an FHR_TM field instance but only once for a TestID, ie (TestID = forcastFixedLimit and Test Name ='fixed limit')
        for standard tests (fixed limit / Zscore) value will be 'None'
        for non standard test 'forcastFixedLimit' value will be the standard test(condition) to put on testID signal ie. 'Fixed Limit Test', or 'ZScore Limit Test'
    Args:
        test_id_name_df (Pandas DataFrame): containing "TestID" and "TestName" columns filled with values from the signal name given in a Seeq workbook

    Returns:
        Pandas DataFrame: containing "TestID" and "TestName" columns formatted to match FHR_TM
    """
    df_to_standardize = test_id_name_df.copy()

    df_to_standardize.loc[
        df_to_standardize["TestID"] == "ZScoreLimit", ["TestID"]
    ] = "ZScore Limit Test"
    df_to_standardize.loc[
        df_to_standardize["TestID"] == "FixedLimit", ["TestID"]
    ] = "Fixed Limit Test"

    # Temperary hold standard Test names to put back in for non standard tests name
    df_to_standardize.loc[
        ~pd.isna(df_to_standardize["TestID"]), ["TestNameTemp"]
    ] = df_to_standardize["TestID"]

    # fill Test ID with non standard Tests
    df_to_standardize.loc[
        ~pd.isna(df_to_standardize["TestName"]), ["TestID"]
    ] = df_to_standardize["TestName"]

    # fill TestName for non standard Tests with Standard Test Names
    df_to_standardize.loc[
        ~pd.isna(df_to_standardize["TestName"]), ["TestName"]
    ] = df_to_standardize["TestNameTemp"]
    df_to_standardize.drop(columns=["TestNameTemp"], inplace=True)

    # For standard tests Fill TestName with 'None'
    df_to_standardize.loc[pd.isna(df_to_standardize["TestName"]), ["TestName"]] = "None"

    return df_to_standardize


def check_parms(parms_check, tm_parms, seeqformula_parms, seeqformula_index, tm_index):
    """
    testID from DF == ID from Package Formulas:
    Test Name from DF ==Test from package  ===>>>> FixedLimitSimpleHi': '3B5DFE52-69CA-49DF-BA2F-923F5488A677'
    for middle signals:
    two possible: Z score hi/low, or the created signals that tests run on (ie. forcast or ROC)
    EdgeCase: a created signal that tests run on having a zscore and fixed limit. for this case get both matches and compare the formula. This is better than
    current Test manager method, which is to only update the middle signal for currently selected test, leaving other singals FHR_TM with incorrect values.

    Args:
        parms_check (list): list of parameters to check
        tm_parms (dictionary): the matching single dictionary for signal from FHR_TM list of dictionaries
        seeqformula_parms (Pandas Series): current signal (or row) to be compared against FHR_TM dictionary
        seeqformula_index (int): index for row in DataFrame currently checking parameters for
        tm_index (int): index of dictionary in FHR_TM for row currently checking parameters for

    Returns:
        _type_: _description_
    """
    updated_signals = pd.DataFrame(
        columns=[
            "SignalID",
            "ParentID",
            "ParentType",
            "SignalName",
            "SignalIndex",
            "FHR_TMIndex",
            "ParameterUpdated",
            "OriginalValue",
            "ValueUpdateTo",
            "Scoped To",
            "Path",
        ]
    )

    # Loop each parameter inside matching dictionary and compare each parameter between current tests parameter and FHR_TM parameter
    for parm in parms_check:
        if parm in tm_parms:
            currentTmParmVal = tm_parms[parm]
            currentTestParmVal = seeqformula_parms.loc[parm]
            # both values null go to next (np.nan != np.nan, so values will try to update)
            if (pd.isna(currentTmParmVal) or (currentTmParmVal == "")) and (
                pd.isna(currentTestParmVal) or (currentTestParmVal == "")
            ):
                continue

            if isinstance(currentTmParmVal, str):
                currentTmParmVal = currentTmParmVal.strip()
            if isinstance(currentTestParmVal, str):
                currentTestParmVal = currentTestParmVal.strip()

            if not (currentTmParmVal == currentTestParmVal):
                # Update FHR_TM to current value
                tm_parms[parm] = currentTestParmVal

                updated_row = pd.Series(
                    {
                        "SignalID": seeqformula_parms.loc["ID"],
                        "ParentID": seeqformula_parms.loc["ParentID"],
                        "ParentType": seeqformula_parms.loc["ParentType"],
                        "SignalName": seeqformula_parms.loc["Name"],
                        "SignalIndex": seeqformula_index,
                        "FHR_TMIndex": tm_index,
                        "ParameterUpdated": parm,
                        "OriginalValue": currentTmParmVal,
                        "ValueUpdateTo": currentTestParmVal,
                        "Scoped To": seeqformula_parms.loc["Scoped To"],
                        "Path": seeqformula_parms.loc["Path"],
                    }
                )

                updated_signals = pd.concat(
                    [updated_signals, updated_row.to_frame().T],
                    ignore_index=True,
                )

    return (updated_signals, tm_parms)


def get_parent_fhr_tm(df_looing_up, df_looking_in_main, df_looking_in_middle):
    # Populate 'FHR_TM' from Main Signals, if signal parent is another middle signal mapped value will be null bc it will not have FHR_TM
    df_looing_up["FHR_TM"] = df_looing_up["ParentID"].map(
        df_looking_in_main.set_index("ID")["FHR_TM"]
    )

    # add parent Type column for reference when updating final changes to main signals:
    mask = pd.isna(df_looing_up["FHR_TM"])
    df_looing_up.loc[mask, ["ParentType"]] = "MiddleSignal"
    df_looing_up.loc[~mask, ["ParentType"]] = "MainSignal"

    # get all from middle signals
    df_looing_up.loc[mask, "FHR_TM"] = df_looing_up["ParentID"].map(
        df_looking_in_middle.set_index("ID")["FHR_TM"]
    )
    # any null FHR_TM left are signals not in Test manager (TM has someties does not fully deleating signals)
    df_looing_up = df_looing_up.dropna(axis=0, subset=["FHR_TM"])

    return df_looing_up


def get_parent_id(formula_parms):
    """get parentSignal ID for each signal. Formula Perameters is a list, with first item being parent ID.
        Parent ID will be either main signal or middle signal

    Args:
        formula_parms (Pandas Series): with each item being lists of formula parameters with first item being parent ID.

    Returns:
        Pandas Series: string containing parent ID of the Parent Signal ID for each signal in series
    """
    formula_parms = formula_parms.apply(
        lambda x: x[0] if np.all(pd.notna(x)) and type(x) == list and len(x) > 0 else x
    )
    formula_parms = formula_parms.str.extract(r".*=(.*)").iloc[:, 0]

    return formula_parms
