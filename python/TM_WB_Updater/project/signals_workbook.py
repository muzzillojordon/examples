import pandas as pd
from seeq import spy
from pathlib import Path
from .errors import *


class WorkBookSignals:
    """raw signals from workbook
    Consists of 3 types of signals:
    main Signal: calculated signal, the signal test manager runs on and builds all other signals. Middle signal and test Signal need to update Main Signal. IE. 47AI0041
    middle signal: Intermediate=True, may or may not exists for a given FHR_TM instance signal generated by test manager that a test signal ("condition") can be placed on.
    test Signal: Calculated Condition, the final condition that is placed on a middle signal or main signal. IE. Fixed Limit Zscore
    """

    def __init__(self, search_from_pkl=False):
        self.wb_signals_df = pd.DataFrame()
        self.workbook_id = ""
        self.workbook_path = ""
        self.search_from_pkl = search_from_pkl
        self.pkl_file_name = Path("datsadfrch.pkl").resolve()

    def get_all_signals_by_path(self, path, name):
        """function to retrieve all signals for single workbook path and name

        Args:
            path (string): file path to seeq workbook
            name (string): name of seeq workbook
        """
        self.get_workbook_by_path_name(path, name)
        self.get_all_signals_by_wb_ids(self.workbook_id)

    def get_all_signals_by_wb_ids(self, wb_ids):
        """function to retrieve all signals for one or many workbook ids. function will also pickle result of search for debugging if  search_from_pkl=True

        Args:
            wb_id (list): list of workbooks IDs to get signals from
        """
        if not isinstance(wb_ids, list):
            wb_ids = [wb_ids]

        self.workbook_id = wb_ids
        self.get_wb_signals_by_ids(self.workbook_id)

        if self.search_from_pkl:
            self.pkl_signals(self.wb_signals_df)

    def get_workbook_by_path_name(self, path, name):
        """internal use function to retrieve all signals for single workbook path and name
        Args:
            path (string): file path to seeq workbook
            name (string): name of seeq workboo
        Raises:
            MissingInputError: if no path or name given
            NoDataFound: if spy.search returns no values
        """
        if path == "" or name == "":
            raise MissingInputError("Must have name and path of workbook")

        wb = spy.workbooks.search(
            {
                "Path": path,
                "Workbook Type": "asdf",
                "Name": name,
            },
            content_filter="all",
            recursive=True,
        )
        if wb.empty:
            raise NoDataFound("NO Workbooks Found")

        self.workbook_path = path
        self.workbook_id = wb["ID"].iloc[0]

    def get_wb_signals_by_ids(self, workbook_id):
        """internal use function to perform seeq.search by list of workbook ids.
        Args:
            workbook_id (List): _description_
        Raises:
            NoDataFound: if spy.search returns no values
        """
        self.wb_signals_df = spy.search(
            {
                "Name": "*",
                "Type": ["asdf", "asdftion"],
                # 'Path': path,
                "Scoped To": workbook_id,
            },
            all_properties=True,
        )

        if self.wb_signals_df.empty:
            raise NoDataFound("NO Signals Found in Workbook")

    def get_wb_signals_by_df(self, spy_search_df):
        """gets all signal metadata from given DataFrame meeting Seeq.search requirements

        Args:
            spy_search_df (pandas DataFrame): DataFrame of signals to get metadata for meeting spy.search requirements

        Raises:
            NoDataFound: if spy.search returns no values
        """
        # get all signals by pandas dataframe, dataframe must have required spy.search columns
        self.wb_signals_df = spy.search(spy_search_df, all_properties=True)
        if self.wb_signals_df.empty:
            raise NoDataFound("NO Workbooks and or Signals Found")

        self.workbook_id = spy_search_df["SsadfTo"].iloc[0]

    def pkl_signals(self, df_to_Pkl):
        """function will pickle DataFrame of spy.search results for later use to aid in debugging

        Args:
            df_to_Pkl(Pandas DataFrame): returned DataFrame from a spy.search

        Raises:
            MissingInputError: if passed empty dataframe to pickle
        """
        if df_to_Pkl.empty:
            raise MissingInputError("Must have name and path of workbook")

        df_to_Pkl.to_pickle(self.pkl_file_name)

    def un_Pkl_signals(self):
        """will unpickle saved pickle file for debugging. must call un_Pkl_signals() directly

        Raises:
            NoDataFound: if no pickle file was found
        """
        if not Path(self.pkl_file_name).exists():
            raise NoDataFound("NO Pickle File for Workbook Signals Found")

        self.wb_signals_df = pd.read_pickle(self.pkl_file_name)
        self.workbook_id = self.wb_signals_df["Scoped To"].iloc[0]
