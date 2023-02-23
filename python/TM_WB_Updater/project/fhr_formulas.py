import pandas as pd
from seeq import spy, sdk
from .errors import *
from .utillity_tm_trueup import *


class FhrFormulas:
    # package_name = 'fhr'
    # formula_id = '2FBAA1EE-648A-4341-ABF0-98F83DEA90D2'
    def __init__(self):
        self.formulas_api = sdk.FormulasApi(spy.client)
        self.Fhr_package_names = pd.DataFrame()
        self.fhr_formulas_df = pd.DataFrame()

        self.get_fhr_packages()

        if len(self.Fhr_package_names) == 0:
            raise NoDataFound("No FHR Formula Packages Found from Seeq API")

        self.create_formula_df()

        if self.fhr_formulas_df.empty:
            raise NoDataFound("No FHR Formulas Found from Seeq API")

        self.add_standard_package()

    def get_fhr_packages(self):
        """gets all seeq API packages"""
        self.Fhr_package_names = [
            package.name for package in self.formulas_api.get_packages().items
        ]

    def create_formula_df(self):
        """function creates DataFrame to hold all seeq API formulas and metadata for easy access"""
        for i in range(len(self.Fhr_package_names)):
            tempdf = pd.DataFrame()
            cur_pac_formulas = self.formulas_api.get_package(
                package_name=self.Fhr_package_names[i]
            ).functions
            if not len(cur_pac_formulas) == 0:
                cur_form_dict = [item.to_dict() for item in cur_pac_formulas]
                if not len(cur_form_dict) == 0:
                    tempdf = pd.DataFrame(cur_form_dict)
                    tempdf["PackageName"] = self.Fhr_package_names[i]
                    self.fhr_formulas_df = pd.concat([self.fhr_formulas_df, tempdf])
                    self.fhr_formulas_df.reset_index(drop=True)

    def add_standard_package(self):
        """Function adds formulas that are hard coaded into Test Manager to fhr_formulas_df"""
        self.Fhr_package_names.append("Standard")
        new_row_fixed = pd.Series(
            {
                "id": "Fixed Limit Test",
                "is_archived": "false",
                "is_redacted": "false",
                "name": "Fixed Limit Test",
                "type": "TM_Defined",
                "PackageName": "Standard",
            }
        )
        new_row_zscore = pd.Series(
            {
                "id": "ZScore Limit Test",
                "is_archived": "false",
                "is_redacted": "false",
                "name": "ZScore Limit Test",
                "type": "TM_Defined",
                "PackageName": "Standard",
            }
        )

        self.fhr_formulas_df = pd.concat(
            [
                self.fhr_formulas_df,
                new_row_fixed.to_frame().T,
                new_row_zscore.to_frame().T,
            ]
        )
        self.fhr_formulas_df.reset_index(drop=True, inplace=True)

    def get_formula_parameters(self, formula_id):
        """Function retuns parameters for a Seeq API formula

        Args:
            formula_id (string): ID for Seeq API formula

        Returns:
            list: list of parameters defined for Seeq API formula
        """
        formula = self.formulas_api.get_function(id=formula_id)
        return [(parm.name) for index, parm in enumerate(formula.parameters)]
