import pandas as pd
import numpy as np
import json
from .errors import *
from .utillity_tm_trueup import *
from .fhr_formulas import *


class MiddleSignals:
    """middle signal: Intermediate=True in, signal generated by test manager that a test signal ("condition") can be placed on.
    examples of middle signals: 14C2.1st Stage.dP_FHR_ForecastLimit,  14TI0664_ZScoreLimit__hi
    """

    def __init__(self, wb_sigs, fhr_formula_cls):

        self.zscore_parm_serch = {
            "WindowSize": "^[$]window = periods\((.*),.*",
            "WindowFreq": "^[$]window = periods\(.*,(.*)\).*",
            "MinStdDev": ".* = \(\([$]stddev[*].*\)[.]setUnits\(.*\)\)[.].*\(-?(.*)\)",
            "RunStatusCondition": ".*[$]running = \(\((.*)\)[.]move.*",
            "StartUpLag": ".*[$]running = \(\(.*\)[.]move\((.*), .*\)\)",
            "StdDevCountHi": ".*= \(\([$]stddev[*](.*)\)[.]setUnits\(",
            "StdDevCountLo": ".*= \(\([$]stddev[*](.*)\)[.]setUnits\(",
        }

        self.middle_signals_df = pd.DataFrame()
        self.updated_middle_signals = pd.DataFrame()

        self.get_signals(wb_sigs)
        if not self.middle_signals_df.empty:
            self.middle_signals_df["ParentID"] = get_parent_id(
                self.middle_signals_df["Formula Parameters"]
            )

            self.middle_signals_df = get_parent_fhr_tm(
                self.middle_signals_df, wb_sigs, self.middle_signals_df
            )
            self.update_formula_name_id()
            self.get_parms()
            self.compare_wbformula_fhrtm(fhr_formula_cls)

    def get_signals(self, wbSigs):
        """split out middle signals from all workbook signals and rows with issues (ie. if formula has no value)
        Middle signals have Intermediate field = true
        Args:
            wbSigs (Pandas DataFrame): DataFrame for all signals in workbook
        """
        # remove main signals and Test Signals
        self.middle_signals_df = wbSigs.loc[wbSigs["Intermediate"] == "true"]

        if not self.middle_signals_df.empty:
            # remove any rows with issues
            self.middle_signals_df = self.middle_signals_df[
                ~self.middle_signals_df["Formula"].isnull()
            ]
            self.middle_signals_df = self.middle_signals_df.loc[
                :,
                [
                    "ID",
                    "Name",
                    "Formula",
                    "Formula Parameters",
                    "Intermediate",
                    "Type",
                    "Scoped To",
                    "Path",
                ],
            ]

    def update_formula_name_id(self):
        """extract name and ID of formula used on signals. see standardize_formula_fhr_tm() for more information
        middle signals for zscores have a HI and LOW signal that get put into a ZscoreModifier column to help identify which FHR_TM item signal is for.
        """
        # parse out Test name and Test ID
        self.middle_signals_df[["TestID", "ZscoreModifier"]] = self.middle_signals_df[
            "Name"
        ].str.extract(r".*_(.*)__(.*)?")
        self.middle_signals_df["TestName"] = self.middle_signals_df["Name"].str.extract(
            r".*_FHR_([^_]*).*"
        )

        self.middle_signals_df[["TestID", "TestName"]] = standardize_formula_fhr_tm(
            self.middle_signals_df[["TestID", "TestName"]]
        )

    def get_parms(self):
        """function separates out test parameters from signals formula box, these are the values that need to be compared to associated FHR_TM instance
        Two cases:
            Zscore: have standard template. each parameter is put into a column with name of column being the parameter.
            User Defined Functions (UDF): template comes from Seeq Formula API. Order is same in worksheet formula box as in seeq API formula parameters
                each parameter is put into a comma separated list to be correlated with seeq API formula parameters later
                example: FHR_RateOfChangeRunningDelta($_14V4_14E5_Shell_Outlets_DT, 180d, 1.toSignal().toCondition(), 2d)
            zscore_parm_serch (dictionary): of Zscore parameter names and regex searches
        Args:
            key: name of parameter, Value: associated regex search to find value of parameter in a signals worksheet formula box.
        """
        # get formulas parameters for UDF type functions
        self.middle_signals_df["FormulaLst"] = self.middle_signals_df.loc[
            pd.isna(self.middle_signals_df["ZscoreModifier"]), "Formula"
        ].str.extract(r"^[^(]*\((.*)\)")

        #    drop any rows that have issues finding parameter list. Bug found through experimenting
        formula_issue_index = self.middle_signals_df.loc[
            (pd.isna(self.middle_signals_df["ZscoreModifier"]))
            & (pd.isna(self.middle_signals_df["FormulaLst"]))
        ].index
        if len(formula_issue_index) > 0:
            self.middle_signals_df.drop(formula_issue_index, inplace=True)

        # split parameters into list with order correlated to Seeq Formula API
        self.middle_signals_df["FormulaLst"] = self.middle_signals_df[
            "FormulaLst"
        ].str.split(pat=",")

        self.middle_signals_df = self.middle_signals_df[
            ~self.middle_signals_df["Formula"].isnull()
        ]

        # get formulas parameters for Zscore type functions
        for key, value in self.zscore_parm_serch.items():
            self.middle_signals_df[key] = self.middle_signals_df.loc[
                ~pd.isna(self.middle_signals_df.ZscoreModifier), "Formula"
            ].str.extract(value)
        # update Zscore hi and lo to null values were needed
        self.middle_signals_df.loc[
            self.middle_signals_df.ZscoreModifier == "lo", "StdDevCountHi"
        ] = np.nan
        self.middle_signals_df.loc[
            self.middle_signals_df.ZscoreModifier == "hi", "StdDevCountLo"
        ] = np.nan

    def compare_wbformula_fhrtm(self, fhr_formula_cls):
        """Function loops through all middle signals and compares current test parameter values to its corresponding FHR_TM test parameters values.
        if a parameter values do not match the parameter in FHR_TM is updated.

        Args:
            fhr_formula_cls (class): class containing all sdk.FormulasApi information
        """
        # get DF of seeq API formulas information
        formulas_df = fhr_formula_cls.fhr_formulas_df

        for i in self.middle_signals_df.index:
            possible_test_ids = []
            TestUpdated = False
            trueMidSig = False
            if pd.isna(self.middle_signals_df.loc[i, "FHR_TM"]):
                continue  #!!Could put this in an "issues" DF to keep track of and show users

            if pd.isna(self.middle_signals_df.loc[i, "ZscoreModifier"]):
                trueMidSig = True
            else:
                # test is Zscore tests, set up parameters to either hi or low signal
                parms_to_check = list(self.zscore_parm_serch.keys())
                if self.middle_signals_df.loc[i, "ZscoreModifier"] == "hi":
                    parms_to_check.pop(6)
                else:
                    parms_to_check.pop(5)

            # Get lists of dictionaries for possible tests on current testSignal in the FHR_TM field
            CurFhr_Tm = json.loads(self.middle_signals_df.loc[i, "FHR_TM"])

            # get list of all API formula IDs that match current test name
            possible_test_ids = formulas_df.loc[
                formulas_df.name == self.middle_signals_df.loc[i, "TestID"], ["id"]
            ]["id"].tolist()

            if len(possible_test_ids) == 0:
                #!Could put this in an "issues" DF to keep track of and show users
                continue

            # check all matching test manager dictionaries (FHR_TM) for current test or middle signal, check to see if they match
            for ii in range(len(CurFhr_Tm)):
                # if middle signal zscore test we do not need to match testName (ie test in formulas) instead we need to update max both (middle signal Zscore and Fixed limit )
                if trueMidSig:
                    if CurFhr_Tm[ii]["ID"] in possible_test_ids:
                        # now that exact middle signal is defined get parms from seeq API and add as columns to DF to compare
                        parms_to_check = fhr_formula_cls.get_formula_parameters(
                            CurFhr_Tm[ii]["ID"]
                        )
                        for udf_i in range(len(parms_to_check)):
                            if (
                                not parms_to_check[udf_i]
                                in self.middle_signals_df.columns
                            ):
                                self.middle_signals_df[parms_to_check[udf_i]] = np.nan

                            self.middle_signals_df.loc[
                                i, parms_to_check[udf_i]
                            ] = self.middle_signals_df.loc[i, "FormulaLst"][
                                udf_i
                            ].lstrip()

                    else:
                        continue  # current dict in list is not a match go to next Dict
                else:
                    if not (CurFhr_Tm[ii]["ID"] in possible_test_ids) or not (
                        CurFhr_Tm[ii]["Test"]
                        == self.middle_signals_df.loc[i, "TestName"]
                    ):
                        continue

                # found matching test, Check parms update if needed, then go to next middle signal Row
                updated_sigs, updated_tm = check_parms(
                    parms_to_check,
                    CurFhr_Tm[ii],
                    self.middle_signals_df.loc[i],
                    i,
                    ii,
                )
                # check if any parameter values needed updated
                if not updated_sigs.empty:
                    TestUpdated = True
                    self.updated_middle_signals = pd.concat(
                        [self.updated_middle_signals, updated_sigs], ignore_index=True
                    )
                    CurFhr_Tm[ii] = updated_tm

                # if true middle signal (ie. not Zscore) there may be two dictionaries that need updated and need to continue loop to check
                if not trueMidSig:
                    break

            # if any parms in FHR_TM were updated add updates back to original DF
            if TestUpdated == True:
                updated_fhr_tm = json.dumps(CurFhr_Tm)
                self.middle_signals_df.loc[i, "FHR_TM"] = updated_fhr_tm
