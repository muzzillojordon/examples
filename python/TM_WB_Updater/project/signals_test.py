import pandas as pd
import numpy as np
import json
from .errors import *
from .utillity_tm_trueup import *
from .fhr_formulas import *


class TestSignals:
    def __init__(self, wb_sigs, main_sigs, middle_sigs, fhr_formula_cls):

        self.fixed_lim_parm = {
            # "Lo": ".* < ([^)]*)\).*",
            "Lo": ".*\(.* < ([^)]*)\).*",
            # "Hi": ".*\(.* > ([^)]*)\)\)\..*\(.*",
            "Hi": ".*\(.* > ([^)]*)\).*",
            "Deadband": ".*\.removeShorterThan\((.*)\)",
            "RunStatusCondition": ".*\.intersect\(\((.*)\)\.move.*",
            "StartUpLag": ".*.move\((.*)\,0.*",
        }

        self.updated_test_signals = pd.DataFrame()
        self.test_signals_df = pd.DataFrame()

        self.create_test_signals(wb_sigs)
        if not self.test_signals_df.empty:
            self.test_signals_df["ParentID"] = get_parent_id(
                self.test_signals_df["Formula Parameters"]
            )
            self.test_signals_df = get_parent_fhr_tm(
                self.test_signals_df, main_sigs, middle_sigs
            )
            self.update_formula_name_id()
            self.get_parms()
            self.compare_wbformula_fhrtm(fhr_formula_cls)

    def create_test_signals(self, wb_sigs):
        """split out Test signals from all workbook signals and rows with issues (ie. if formula has no value)
            Test signals are signals with type as CalculatedCondition
        Args:
            wb_sigs (Pandas DataFrame): DataFrame for all signals in workbook
        """
        self.test_signals_df = wb_sigs.loc[wb_sigs["Type"] == "CalculatedCondition"]
        if not self.test_signals_df.empty:
            self.test_signals_df = self.test_signals_df.loc[
                :,
                [
                    "ID",
                    "Type",
                    "Name",
                    "Formula",
                    "Formula Parameters",
                    "Scoped To",
                    "Data ID",
                    "Intermediate",
                    "Path",
                ],
            ]

    def update_formula_name_id(self):
        """extract name and ID of formula used on signals. see standardize_formula_fhr_tm() for more information"""
        self.test_signals_df["TestID"] = self.test_signals_df["Name"].str.extract(
            r".*_(.*)_"
        )
        self.test_signals_df["TestName"] = self.test_signals_df["Name"].str.extract(
            r".*_FHR_([^_]*).*"
        )

        self.test_signals_df[["TestID", "TestName"]] = standardize_formula_fhr_tm(
            self.test_signals_df[["TestID", "TestName"]]
        )

    def get_parms(self):
        """Get parameters for test from signals formula box, these are the values that need to be compared to associated FHR_TM instance
        "TestSignals" can only be fixed limits and zscore conditions, and will only have the parameters in self.fixed_lim_parm
        Any other parameters for tests that may be in the FHR_TM instance will be handled in MiddleSignals
        """
        # get formulas parameters for Zscore type functions
        for key, value in self.fixed_lim_parm.items():
            self.test_signals_df[key] = self.test_signals_df["Formula"].str.extract(
                value
            )

        # special case some signals were found not to have .move after runstatus id no runstatus. all mid signals will have move for zscore:
        mask = pd.isna(self.test_signals_df["RunStatusCondition"])
        self.test_signals_df.loc[
            mask, ["RunStatusCondition"]
        ] = self.test_signals_df.loc[mask, "Formula"].str.extract(
            r".*\.intersect\(\((.*)\)\)[.]removeSh.*"
        )[
            0
        ]

    def compare_wbformula_fhrtm(self, fhr_formula_cls):
        """Function loops through all middle signals and compares current test parameter values to its corresponding FHR_TM test parameters values.
        if a parameter values do not match the parameter in FHR_TM is updated.

        Args:
            fixed_lim_parm_lst (List): List of parameters for fixed limit tests
            fhr_formula_cls (class): class containing all sdk.FormulasApi information
        """
        formulas_df = fhr_formula_cls.fhr_formulas_df
        parms_to_check = list(self.fixed_lim_parm.keys())

        for i in self.test_signals_df.index:
            possible_test_ids = []
            Test_updated = False

            if pd.isna(self.test_signals_df.loc[i, "FHR_TM"]):
                continue  #!!Could put this in an "issues" DF to keep track of and show users

            possible_test_ids = formulas_df.loc[
                formulas_df.name == self.test_signals_df.loc[i, "TestID"], ["id"]
            ]["id"].tolist()

            # Get lists of dictionaries for possible tests on current testSignal in the FHR_TM field
            CurFhr_Tm = json.loads(self.test_signals_df.loc[i, "FHR_TM"])

            # loop through each dictionary and find correct test the FHR_TM dict for current test ID
            for ii in range(len(CurFhr_Tm)):
                if (CurFhr_Tm[ii]["ID"] in possible_test_ids) and (
                    CurFhr_Tm[ii]["Test"] == self.test_signals_df.loc[i, "TestName"]
                ):
                    updated_sigs, updated_tm = check_parms(
                        parms_to_check,
                        CurFhr_Tm[ii],
                        self.test_signals_df.loc[i],
                        i,
                        ii,
                    )
                    # check if any parameter values needed updated
                    if not updated_sigs.empty:
                        Test_updated = True
                        self.updated_test_signals = pd.concat(
                            [self.updated_test_signals, updated_sigs], ignore_index=True
                        )
                        CurFhr_Tm[ii] = updated_tm

                    break

            # if FHR_TM was Updated add updates back to test DF
            if Test_updated == True:
                updated_fhr_tm = json.dumps(CurFhr_Tm)
                self.test_signals_df.loc[i, "FHR_TM"] = updated_fhr_tm

    #    self.test_signals_df["Lo"] = self.test_signals_df["Formula"].str.extract(
    #         r".* < ([^)]*)\).*"
    #     )

    #     self.test_signals_df["Hi"] = self.test_signals_df["Formula"].str.extract(
    #         r".*\(.* > ([^)]*)\)\)\..*\(.*"
    #     )

    #     self.test_signals_df["Deadband"] = self.test_signals_df["Formula"].str.extract(
    #         r".*\.removeShorterThan\((.*)\)"
    #     )

    #     self.test_signals_df["RunStatusCondition"] = self.test_signals_df[
    #         "Formula"
    #     ].str.extract(r".*\.intersect\(\((.*)\)\.move.*")

    #     self.test_signals_df["StartUpLag"] = self.test_signals_df[
    #         "Formula"
    #     ].str.extract(r".*.move\((.*)\,0.*")
