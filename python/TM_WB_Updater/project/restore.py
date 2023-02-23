import pandas as pd
from seeq import spy
from .errors import *
from .signals_workbook import *
from .updates import *


class RestoreBackups:
    def __init__(self, wb_ids):
        #!may have to change once on server
        self.mypath = "backups/"
        self.workbook_ids = wb_ids
        self.backups_match = []
        self.restore_signals = pd.DataFrame()

        self.get_backup_files_for_wb()

    def get_backup_files_for_wb(self):
        """Function finds all backups for given work book IDs."""
        saved_backups = listdir(self.mypath)
        self.backups_match = [
            backup
            for wb_id in self.workbook_ids
            for backup in saved_backups
            if wb_id in backup
        ]

    def show_signals_in_backupfile(self, file_names):
        """Function reads backupd csv file for backup file names into dataframe
        Args:
            file_names (list): list of backup file names
        """
        if not file_names == "" or not len(file_names) == 0:
            self.restore_signals = pd.concat(
                [
                    pd.read_csv(self.mypath + filename, index_col=0)
                    for filename in file_names
                ]
            )

    # could pass in dataframe with user selected updates from backup but that would require how to handle partial restores.
    def push_backup(self):
        """function pushes updates to seeq and write new backup file and remove all backups up to and including date of file that was restored

        Args:
            file_names (_type_): _description_
        """
        if self.restore_signals.empty:
            raise NoDataFound("Must select backup file")

        # do spy.search to get all original metadata and set sudo updated_main_signals_flt for updates class
        wb_signals_cls = WorkBookSignals()
        sudo_main_signals_updated = self.restore_signals[
            ["SignalID", "SignalName", "Scoped To", "FHR_TM_Orig"]
        ].rename(
            columns={"SignalID": "ID", "SignalName": "Name", "FHR_TM_Orig": "FHR_TM"}
        )
        wb_signals_cls.get_wb_signals_by_df(sudo_main_signals_updated)

        # set required metadata and backup file for Update class to to push updates
        updates_cls = Updates(wb_signals_cls)
        updates_cls.original_metadata_df = wb_signals_cls.wb_signals_df.copy()

        # Create new Backup File:
        updates_cls.backup_df = self.reverse_updates()

        # update metadata and push updates
        updates_cls.update_meta_fhr_tm(
            sudo_main_signals_updated["ID"].tolist(), sudo_main_signals_updated
        )
        updates_cls.push_updates_to_seeq()

        #!possible Remove old backup file and not add new becasue we are pack to that point in time

    def reverse_updates(self):
        # swap updated to original FHR_TM columns for adding new backup
        restore_signals_updated = self.restore_signals.copy()
        restore_signals_updated[
            ["FHR_TM_Orig", "FHR_TM_Updated"]
        ] = self.restore_signals[["FHR_TM_Updated", "FHR_TM_Orig"]]

        # reverse order of Update To and Update From inside parmValues backup file
        if (
            self.restore_signals[["parmValues"]]
            .iloc[0]
            .str.contains(pat="ValUpdateTo:")[0]
        ):
            # first time backup file is reversed.
            restore_signals_updated["parmValues"] = restore_signals_updated[
                "parmValues"
            ].str.replace("ValUpdateFrom", "ValUpdateTo", regex=False)
            restore_signals_updated["parmValues"] = restore_signals_updated[
                "parmValues"
            ].str.replace("ValUpdateTo:", "ValUpdateFrom:", regex=False)
        else:
            # if restoring a backup of a restore (ie. ValUpdateFrom and ValUpdateTo already reversed once)
            restore_signals_updated["parmValues"] = restore_signals_updated[
                "parmValues"
            ].str.replace("ValUpdateTo", "ValUpdateFrom", regex=False)
            restore_signals_updated["parmValues"] = restore_signals_updated[
                "parmValues"
            ].str.replace("ValUpdateFrom:", "ValUpdateTo:", regex=False)

        return restore_signals_updated
