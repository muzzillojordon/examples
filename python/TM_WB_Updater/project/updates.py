import pandas as pd
import numpy as np
import json
import time
from seeq import spy
from os import listdir
from openpyxl import Workbook
from .errors import *


class Updates:
    def __init__(self, wb_signals_cls):
        """
        self.combined_updates = DF of all individual updates(test and middle signals)
        self.backup_df = DF of only main signals with all updates reflected in FHR_TM.
        self.updated_main_signals = all main signals (updated and non updated) with with updated FHR_TM
        self.original_metadata_df = meta for all main signals before any updates
        self.updated_metadata_df = only metadata for signals that were updated with updated FHR_TM
        Args:
            wb_signals_cls (_type_): _description_

        Raises:
            NoDataFound: _description_
        """
        self.combined_updates = pd.DataFrame()
        self.backup_df = pd.DataFrame()
        self.updated_main_signals = pd.DataFrame()
        self.updated_metadata_df = pd.DataFrame()
        self.original_metadata_df = pd.DataFrame()

        if wb_signals_cls.workbook_id == "" or len(wb_signals_cls.workbook_id) == 0:
            raise NoDataFound("Must have Workbook ID to Perform Update")

        self.workbook_id = wb_signals_cls.workbook_id

    def prep_signals_for_update(
        self, main_signals_cls, mid_signals_cls, test_signals_cls
    ):
        """Function combines all updates into one DataFrame having the main signals ID as parent ID.
        With all updates having main signal ID each signal can directly push its contribution to the main singals FHR_TM without going through middle signal.
        this avoids any issues if the an update needs to be pushed to a middle signal but the middle signal did not have an update to main signal.
        (ie. test signal had an update and would be in updated_test_signals DF but the middle signal did not so would not be in updated_middle_signals)
        Args:
            main_signals_cls (class): main signals class
            mid_signals_cls (class): middle signals class
            test_signals_cls (class): test signals class

        Raises:
            NoDataFound: make sure there are updates that need to be made
            NoDataFound: Workbook Must have TestManager Signals
        """
        if (
            test_signals_cls.updated_test_signals.empty
            and mid_signals_cls.updated_middle_signals.empty
        ):
            raise NoDataFound("No Updates to be Made")

        if (
            main_signals_cls.main_signals_df.empty
            or main_signals_cls.original_metadata.empty
        ):
            raise NoDataFound("Workbook Must have TestManager Signals")

        self.updated_main_signals = main_signals_cls.main_signals_df
        self.original_metadata_df = main_signals_cls.original_metadata

        test_to_mid = pd.DataFrame()
        test_to_main = pd.DataFrame()
        mid_to_mid = pd.DataFrame()
        mid_to_main = pd.DataFrame()

        # separate signals that update to a main signal from signals that update to a middle signal
        if not test_signals_cls.updated_test_signals.empty:
            test_to_mid = test_signals_cls.updated_test_signals.loc[
                test_signals_cls.updated_test_signals["ParentType"] == "MiddleSignal"
            ]
            test_to_main = test_signals_cls.updated_test_signals.loc[
                test_signals_cls.updated_test_signals["ParentType"] == "MainSignal"
            ]

        if not mid_signals_cls.updated_middle_signals.empty:
            mid_to_mid = mid_signals_cls.updated_middle_signals.loc[
                mid_signals_cls.updated_middle_signals["ParentType"] == "MiddleSignal"
            ]
            mid_to_main = mid_signals_cls.updated_middle_signals.loc[
                mid_signals_cls.updated_middle_signals["ParentType"] == "MainSignal"
            ]

        # replace parent ID for all updates to middle signals with main signal ID.
        self.combined_updates = pd.concat([test_to_mid, mid_to_mid])
        if not self.combined_updates.empty:
            self.combined_updates = self.combined_updates.rename(
                columns={"ParentID": "ParentID_Orig"}
            )
            self.combined_updates["ParentID"] = np.nan
            self.combined_updates["ParentID"] = self.combined_updates[
                "ParentID_Orig"
            ].map(mid_signals_cls.middle_signals_df.set_index("ID")["ParentID"])
            self.combined_updates.drop(columns=["ParentID_Orig"], inplace=True)

        # add rest of the updates to dataframe
        self.combined_updates = pd.concat(
            [self.combined_updates, test_to_main, mid_to_main]
        )

        #!Trial, May not be correcet to do this....
        # Special Catch for treating null and 0 as same thing. StartUpLag for zscore HI and LO defaults to 0 but for the condition of the Zscore
        # it can be null. This creates a lot of false positives or possible issues. To error on the side safety do not update.
        # find and remove any rows that ValueUpdateTo and OriginalValue are zero and null (note if both null or both zero they would not be in list)
        mask = (
            (pd.isna(self.combined_updates["ValueUpdateTo"]))
            & (self.combined_updates["OriginalValue"] == "0")
        ) | (
            (pd.isna(self.combined_updates["OriginalValue"]))
            & (self.combined_updates["ValueUpdateTo"] == "0")
        )
        self.combined_updates = self.combined_updates.loc[~mask]

        #!Trial, remove all runstatus from updates
        self.combined_updates = self.combined_updates.loc[
            ~(self.combined_updates["ParameterUpdated"] == "RunStatusCondition")
        ]

        if self.combined_updates.empty:
            raise NoDataFound("No Updates to be Made")

        #!need to know if it better to favor condition???
        # clean duplicates (ie if both zscore hi and lo have same parameter to update for same parent.)
        self.combined_updates = self.combined_updates.drop_duplicates(
            subset=["ParentID", "ParameterUpdated", "FHR_TMIndex"]
        )

        self.combined_updates.reset_index(drop=True, inplace=True)

    def update_main_sig_fhr_tm(self):
        """Function updates all user selected individual updates to each main signals FHR_TM in self.updated_main_signals
        Function also creates the Backup File with only main signals that have been updated and their corresponding final updated FHR_TM
        Args:
            main_signals_df (Pandas DataFrame): DataFrame containing all main signals
        """
        main_signal_ids_to_update = self.combined_updates["ParentID"].unique().tolist()
        for i in range(len(main_signal_ids_to_update)):
            updated_row = pd.DataFrame(
                {
                    "SignalID": "",
                    "SignalName": "",
                    "FHR_TM_Orig": "",
                    "FHR_TM_Updated": "",
                    "Scoped To": "",
                    "parmValues": "",
                },
                index=[0],
            )

            # get main signal row to be updated and unpack FHR_TM
            parentID = main_signal_ids_to_update[i]
            main_sig_fhr_row = self.updated_main_signals.loc[
                self.updated_main_signals["ID"] == parentID
            ]
            orig_fhr_tm = main_sig_fhr_row["FHR_TM"].iloc[0]
            parent_fhr_tm_upack = json.loads(orig_fhr_tm)

            # get all rows of parameters needing to be updated for this main signal
            cur_vals_to_update = self.combined_updates.loc[
                self.combined_updates["ParentID"] == main_signal_ids_to_update[i]
            ]

            #!Update using .join and **
            # for each fhr_tm dictionary (FHR_TM_index) update the associated parameter
            for parm, updateVal, fhr_tm_ind, OriginalValue in cur_vals_to_update[
                ["ParameterUpdated", "ValueUpdateTo", "FHR_TMIndex", "OriginalValue"]
            ].itertuples(index=False):
                parent_fhr_tm_upack[fhr_tm_ind][parm] = updateVal
                updated_row["parmValues"] = (
                    updated_row["parmValues"]
                    + f",FHRTMIndex: {fhr_tm_ind} -Parameter: {parm} -ValUpdateFrom {OriginalValue} -ValUpdateTo: {updateVal}\n"
                )

            # upated back to main signal
            self.updated_main_signals.loc[
                main_sig_fhr_row.index, "FHR_TM"
            ] = json.dumps(parent_fhr_tm_upack)

            updated_row["SignalID"] = self.updated_main_signals.loc[
                main_sig_fhr_row.index, "ID"
            ].item()
            updated_row["SignalName"] = self.updated_main_signals.loc[
                main_sig_fhr_row.index, "Name"
            ].item()
            updated_row["FHR_TM_Updated"] = self.updated_main_signals.loc[
                main_sig_fhr_row.index, "FHR_TM"
            ].item()
            updated_row["FHR_TM_Orig"] = orig_fhr_tm
            updated_row["Scoped To"] = self.updated_main_signals.loc[
                main_sig_fhr_row.index, "Scoped To"
            ].item()

            self.backup_df = pd.concat([self.backup_df, updated_row], ignore_index=True)
            self.backup_df.reset_index(drop=True, inplace=True)

    def update_metadata(self):
        """function gets only updated signals from self.updated_main_signals and self.original_metadata_df, then replaces
        self.original_metadata_df with updated FHR_TM and pust in self.updated_metadata for seeq push.
        original metadata is used to make sure all metadata expect the updated 'FHR_TM' field remains unchanged update

        Args:
            main_signals_cls (Class): Main Signals Class
        """
        update_lst = self.backup_df["SignalID"].tolist()
        # get DF of updated main signals for only updated signals
        updated_main_signals_flt = self.updated_main_signals.loc[
            self.updated_main_signals["ID"].isin(update_lst)
        ]

        self.update_meta_fhr_tm(update_lst, updated_main_signals_flt)

    def update_meta_fhr_tm(self, update_lst, updated_main_signals_flt):
        # get DF of original metadata for only updated signals
        self.updated_metadata = self.original_metadata_df.loc[
            self.original_metadata_df["ID"].isin(update_lst)
        ].copy(deep=True)

        # updated FHR_TM in filtered metadata
        self.updated_metadata["FHR_TM"] = self.updated_metadata["ID"].map(
            updated_main_signals_flt.set_index("ID")["FHR_TM"]
        )

    def write_backup_file(self):
        """writes backup file to csv file"""
        timestr = time.strftime("%Y%m%d-%H%M%S")
        if not isinstance(self.workbook_id, list):
            self.workbook_id = [self.workbook_id]
        # if multiple workbooks are updated split out into seperate backup files (each file = 1 workbook)
        for wb_id in self.workbook_id:
            cur_wb_sigs = self.backup_df.loc[self.backup_df["Scoped To"] == wb_id]
            filename = f"{timestr}_{wb_id}"
            cur_wb_sigs.to_csv(f"backups/{filename}.csv")

    def push_updates_to_seeq(self):
        if self.updated_metadata.empty:
            raise NoDataFound("No updated Metadata found")
        self.write_backup_file()
        #!will need to uncomment to push to seeq, for testing leave commented
        for wb_id in self.workbook_id:
            pass
            # spy.push(
            #     metadata=self.updated_metadata.loc[
            #         self.updated_metadata["Scoped To"] == wb_id
            #     ],
            #     workbook=wb_id,
            #     quiet=False,
            # )

    def push_user_selected_updates(self, user_selected_updates_df):
        """Function calls all necessary functions to:
        updated main signal's FHR_TM with all user selected updates
        update orginal metadata FHR_TM field with updated values
        Write backup file
        Push updates to Seeq

        Args:
            user_selected_updates_df (Pandas DataFrame): of user selected updates to push to Seeq

        Raises:
            MissingInputError: if user does not select update
        """
        if user_selected_updates_df.empty:
            raise MissingInputError(
                "No User Selected Updates, Must have at least one update"
            )

        self.combined_updates = user_selected_updates_df.copy()

        self.update_main_sig_fhr_tm()
        self.update_metadata()
        self.push_updates_to_seeq()
