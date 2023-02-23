using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.OleDb;
using System.Data;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;
using System.Net.Mail;
using System.Data.SqlClient;
using System.Windows.Forms;


namespace PubRepUpload
{
    public partial class _Main : System.Web.UI.Page
    {

        public static DataTable DataToConvertDT = new DataTable();
        public static List<string> AlphLst = new List<string>();
        public static string fullsubForConvertFilesFolderPath = "";
        public static string fullConvertedFilesFolderPath = "";
        public static string todaysDate = "";
        public static string FileName = "";
        public static string FullFilePath = "";
        public static string PublisherName = "Test";
        public static int numOfColumnsRemoved = 0;

    /// <summary>
    /// Get File, savefile, select sheet(GetExcelSheetNames), LoadFile in datatable(DataToConvertDT) clean file (deleteEmptyRowColumn),
    /// dispay datagrid(GridView1_RowDataBound adds numbered header on top), fill textboxs with sugested index numbers (FillTextBoxs()) 
    /// IF statments:
    /// If there is a file selectedChecks to make sure FileUpload1 has file, if not display error message., 
    /// If File is xlsx/xls, get sheet in file; If null means could not get any sheets, use first sheet name if more than
    /// create Directorys.
    /// get sheets, one sheet exist, Make sure there is data in sheet, if not Delete file and directorys, then check if directory is empty if empty delete
    /// If more than one sheet, use first sheet
    /// Save file (submittedForConvert), then select data from sheet tab, then put into data table (DataToConvertDT)
    /// Clean up empty rows/columns
    /// Load Datagrid
    /// Fill texbox(FillTextBoxs() is called (uses Regex, (REGEX.cs)))
    /// 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    public void IndexButton_Click(object sender, EventArgs e)
    {
        try
        {
            //Make sure no errors or messages are still displayed. 
            noticeLabel.Visible = false;
            ErrorLabel.Visible = false;
            InfoLabel.Visible = false;

            if (FileUpload1.HasFile)
            {
                PublisherName = "Test";
                FileName = FileUpload1.FileName;
                string strExtension = Path.GetExtension(this.FileUpload1.FileName);

                if (strExtension == ".xlsx" || strExtension == ".xls")
                {
                    CreateDirectory(FileName);
                    FullFilePath = fullsubForConvertFilesFolderPath + "\\" + FileName;
                    FileUpload1.SaveAs(FullFilePath);

                    String[] sheetNames = GetExcelSheetNames(FullFilePath);

                    string sheetName = sheetNames.First();

                    if (sheetNames.Length > 1)
                    {
                        OtherSheetsDD.DataSource = sheetNames;
                        OtherSheetsDD.DataBind();

                        InfoLabel.Text = string.Format("File had more than one sheet, program is using the first sheet data. <br>" +
                            "If you would like to use a sheet other than {0} <br> check the Other Sheets checkbox and choose the sheet", sheetNames.First());
                        InfoLabel.Visible = true;
                        OtherSheetsCB.Enabled = true;
                    }
                    AddDataToDT(sheetName);

                    deleteEmptyRowColumn();

                    if (DataToConvertDT == null || DataToConvertDT.Rows.Count < 1)
                    {
                        ErrorMessage("File is empty, must submit file with data.");
                        DeleteDirectory();
                    }
                    else
                    {

                        GridView1.DataSource = DataToConvertDT;
                        GridView1.DataBind();

                        FillTextBoxs();
                        FileUpload1.Enabled = false;
                        IndexButton.Enabled = false;
                        UploadButton.Enabled = true;
                        AlphCB.Enabled = true;
                        AuthorCB.Enabled = true;
                    }
                }
                else
                    ErrorMessage("File Must be a .xlsx or xls File.");
            }
            else
                ErrorMessage("No File selected.");
        }
        catch (FileNotFoundException ex)
        {
            ErrorMessage("The File specified could not be found. Please check to make sure file exist and has proper permissions.Error message has been sent to administrator.");
            ErrorLogEmail(ex.Message.ToString(), ex.Source.ToString(), ex.StackTrace.ToString(), ex.TargetSite.ToString(), FileName + "<BR>" + FullFilePath);
        }
        catch (DirectoryNotFoundException ex)
        {
            ErrorMessage("The directory could not be found. Error message has been sent to administrator.");
            ErrorLogEmail(ex.Message.ToString(), ex.Source.ToString(), ex.StackTrace.ToString(), ex.TargetSite.ToString(), FileName + "<BR>" + FullFilePath);
        }
        catch (IOException ex)
        {
            ErrorMessage("Unable to handle this error. <br> File: " + FileName + " was NOT uploaded" + " <br> Error message has been sent to administrator.");
            ErrorLogEmail(ex.Message.ToString(), ex.Source.ToString(), ex.StackTrace.ToString(), ex.TargetSite.ToString(), FileName + "<BR>" + FullFilePath);
        }
        catch (Exception ex)
        {
            ErrorMessage("Unable to handle this error. <br> File: " + FileName + " was NOT uploaded" + " <br> Error message has been sent to administrator.");
            ErrorLogEmail(ex.Message.ToString(), ex.Source.ToString(), ex.StackTrace.ToString(), ex.TargetSite.ToString(), FileName + "<BR>" + FullFilePath);
        }
    }
    /// <summary>
    /// Create directory with todays date if no directory yet exists.
    /// </summary>
    /// <param name="FileName"></param>
    public void CreateDirectory(string FileName)
    {
        string submittedForConvertFilesFolderPath = Server.MapPath(@"UploadedFiles\SubmittedForConvert");
        string convertedFilesFolderPath = Server.MapPath(@"UploadedFiles\ConvertedFile");
        todaysDate = DateTime.Now.ToString("MM-dd-yyyy");
        fullsubForConvertFilesFolderPath = Path.Combine(submittedForConvertFilesFolderPath, todaysDate);
        fullConvertedFilesFolderPath = Path.Combine(convertedFilesFolderPath, todaysDate);

        if (!Directory.Exists(fullsubForConvertFilesFolderPath))
            Directory.CreateDirectory(fullsubForConvertFilesFolderPath);

        if (!Directory.Exists(fullConvertedFilesFolderPath))
            Directory.CreateDirectory(fullConvertedFilesFolderPath);
    }
    /// <summary>
        /// The excell sheet is loaded in to data table from the specified sheet tab
        /// </summary>
        /// <param name="sheetName"></param>
    public void AddDataToDT(string sheetName)
    {
        try
        {
            DataToConvertDT = new DataTable();

            var excelConnection = @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + @FullFilePath + ";Extended Properties=Excel 12.0";

            string sql = "SELECT * FROM [" + sheetName + "]";

            using (OleDbDataAdapter adaptor = new OleDbDataAdapter(sql, excelConnection))
            {
                adaptor.Fill(DataToConvertDT);
            }
        }
        catch (Exception)
        {
            throw;
        }
    }
    /// <summary>
    ///Delete file and directory if file trying to be loaded was empty
    /// //Delete File bc its tryign to load empty file, If directory was created and no files inside then delete whole directory both SubmittedForconvert
    /// and ConvertedFile
    /// </summary>
    public void DeleteDirectory()
    {
        if (File.Exists(FullFilePath))
        {
            File.Delete(FullFilePath);

            if (Directory.Exists(fullsubForConvertFilesFolderPath))
            {
                string[] allFiles = Directory.GetFiles(fullsubForConvertFilesFolderPath);

                if (allFiles.Length == 0)
                {
                    Directory.Delete(fullsubForConvertFilesFolderPath);

                    if (Directory.Exists(fullConvertedFilesFolderPath))
                    {
                        string[] allFiles2 = Directory.GetFiles(fullConvertedFilesFolderPath);

                        if (allFiles2.Length == 0)
                            Directory.Delete(fullConvertedFilesFolderPath);
                    }
                }
            }
        }
    }
    /// <summary>
    /// Gets Sheet names from submitted file. Puts names into List (excellSheets)
    /// </summary>
    /// <param name="excelFile"></param>
    /// <returns></returns>
    public static String[] GetExcelSheetNames(string excelFile)
    {
        OleDbConnection objConn = null;
        System.Data.DataTable dt = null;
        try
        {        //Conect to file      
            String connString = @"Provider=Microsoft.ACE.OLEDB.12.0;" +
              "Data Source=" + @excelFile + ";Extended Properties=Excel 12.0";
            objConn = new OleDbConnection(connString);
            objConn.Open();

            dt = objConn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);

            String[] excelSheets = new String[dt.Rows.Count];
            int i = 0;
            //array containing sheet names
            foreach (DataRow row in dt.Rows)
            {
                excelSheets[i] = row["TABLE_NAME"].ToString();
                i++;
            }
            return excelSheets;
        }
        catch (Exception)
        {
            throw;
        }
        finally
        {
            if (objConn != null)
            {
                objConn.Close();
                objConn.Dispose();
            }
            if (dt != null)
            {
                dt.Dispose();
            }
        }
    }
    protected void OtherSheetsDD_SelectedIndexChanged(object sender, EventArgs e)
    {
        InfoLabel.Visible = false;
        ErrorLabel.Visible = false;
        

        string sheetName = OtherSheetsDD.SelectedItem.Text;

        AddDataToDT(sheetName);

        deleteEmptyRowColumn();

        if (DataToConvertDT == null || DataToConvertDT.Rows.Count < 1)
        {
            Resetscreen();
            ErrorMessage("Sheet is empty, must choose another sheet with data.");
            OtherSheetsCB.Enabled = true;
            IndexButton.Enabled = false;
            FileUpload1.Enabled = false;
            AuthorCB.Enabled = false;
            AlphCB.Enabled = false;
        }
        else
        {
            GridView1.DataSource = DataToConvertDT;
            GridView1.DataBind();

            FillTextBoxs();
            FileUpload1.Enabled = false;
            IndexButton.Enabled = false;
            UploadButton.Enabled = true;
            AlphCB.Enabled = true;
            AuthorCB.Enabled = true;
        }
    }
    /// <summary>
    /// Adds top header row of numbers. and builds datagrid
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void GridView1_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
    {
        try
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (e.Row.RowIndex == 0)
                {
                    GridView ProductGrid = (GridView)sender;
                    GridViewRow HeaderRow = new GridViewRow(0, 0, DataControlRowType.DataRow, DataControlRowState.Insert);
                    TableCell HeaderCell; //= new TableCell();

                    if (AlphCB.Checked)
                    {
                        GridViewRow HeaderRow2 = new GridViewRow(1, 0, DataControlRowType.DataRow, DataControlRowState.Insert);

                        for (int i = 0; i < DataToConvertDT.Columns.Count; i++)
                        {

                            HeaderCell = new TableCell();
                            if (AlphCB.Checked)
                            {
                                HeaderCell.Text = AlphLst[i];
                            }
                            else
                            {
                                HeaderCell.Text = (i + 1).ToString();
                            }
                            HeaderRow2.Cells.Add(HeaderCell);

                            ProductGrid.Controls[0].Controls.AddAt(0, HeaderRow2);
                        }
                    }
                   
                    for (int i = 0; i < DataToConvertDT.Columns.Count; i++)
                    {

                        HeaderCell = new TableCell();

                        HeaderCell.Text = (i + 1).ToString();

                        HeaderRow.Cells.Add(HeaderCell);

                        ProductGrid.Controls[0].Controls.AddAt(0, HeaderRow);
                    }

                }
            }
        }
        catch
        {
            GridView1.DataSource = null;
            GridView1.DataBind();
            throw;
        }
    }
    /// <summary>
    /// when page changing occours
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        InfoLabel.Visible = false;
        GridView1.DataSource = DataToConvertDT;       
        GridView1.PageIndex = e.NewPageIndex;
        GridView1.DataBind();
    }
    
    /// <summary>
    /// Delete empty rows and columns
    /// For Rows: loop through each row, then each item in each row, if all items are empty remove row.
    /// For Columns:loop throguh each Column in datatable, starting at last column, look at each row Cell in that column, if all are empty, Remove column
    /// </summary>
    /// <param name="row"></param>
    /// <returns></returns>
    public void deleteEmptyRowColumn()
    {
        bool removeRow = false;
        bool removeCol = false;
        numOfColumnsRemoved = 0;

        foreach (DataRow row in DataToConvertDT.Rows)
        {
            for (int i = row.Table.Columns.Count - 1; i >= 0; i--)
            {
                if (!row.IsNull(i))
                {
                    removeRow = false;
                    break;
                }
                removeRow = true;
            }
            if (removeRow)
            {
                row.Delete();
            }
        }
        DataToConvertDT.AcceptChanges();

        for (int col = DataToConvertDT.Columns.Count - 1; col >= 0; col--)
        {
            foreach (DataRow row in DataToConvertDT.Rows)
            {
                if (!row.IsNull(col))
                {
                    removeCol = false;
                    break;
                }
                removeCol = true;
            }
            if (removeCol)
            {
                DataToConvertDT.Columns.RemoveAt(col);
                numOfColumnsRemoved++;
            }
        }
    }
    /// <summary>
    /// Fill text boxes on screen for the correct index in the DataToConvertDT.
    /// Loops through DataToConvertDT colums trims the names of the columns for search
    /// does a search by calling RegEx class.
    /// loops through dictionary containing the fild names/textboxes (serchcriteria.searchfildsDic) for a match on the MatchOn
    /// if match was found switch case is done to find what fild name the match was on.
    /// Calls Priority() to set each textbox to the column index in DataToConvertDT.
    /// sets the column in DataToConvertDT that ShortCut will be formed off of.
    /// </summary>
    public void FillTextBoxs()
    {

        string oringDatacolname = "";
        string trimedDatacolname = "";
        string serchBy = SearchByMeth();
        string matchedFild = "";

        for (int i = 0; i < DataToConvertDT.Columns.Count; i++)
        {
            oringDatacolname = DataToConvertDT.Columns[i].ColumnName.ToLower().Trim(' ');
            trimedDatacolname = (oringDatacolname.Replace(" ", string.Empty));

            string matchOn = (RegEx.MatchKey(serchBy, trimedDatacolname));
            if (matchOn == string.Empty)
                matchOn = (RegEx2.MatchKey(serchBy, trimedDatacolname));

            if (matchOn != string.Empty)
            {
                foreach (KeyValuePair<string, List<string>> kv in searchCriteria.SearchFiledsDic)
                {
                    if (kv.Value.Contains(matchOn))
                    {
                        matchedFild = kv.Key;

                        switch (matchedFild)
                        {
                            case "sku":
                                priority(SKUTextBox, "sku", oringDatacolname, trimedDatacolname);
                                break;
                            case "title":
                                priority(TitleTextBox, "title", oringDatacolname, trimedDatacolname);
                                break;
                            case "author1":
                                priority(Author1TextBox, "author1", oringDatacolname, trimedDatacolname);
                                break;
                            case "author1last":
                                priority(Author1LastNameTB, "author1last", oringDatacolname, trimedDatacolname);
                                break;
                            case "author2":
                                priority(Author2TextBox, "author2", oringDatacolname, trimedDatacolname);
                                break;
                            case "author2last":
                                priority(Author2LastNameTB, "author2last", oringDatacolname, trimedDatacolname);
                                break;
                            case "retailprice":
                                priority(RetailPriceTextBox, "retailprice", oringDatacolname, trimedDatacolname);
                                break;
                            case "type":
                                priority(TypeTextBox, "type", oringDatacolname, trimedDatacolname);
                                break;
                            case "category":
                                priority(CategoryTextBox, "category", oringDatacolname, trimedDatacolname);
                                break;
                            case "releasedate":
                                priority(ReleaseDateTextBox, "releasedate", oringDatacolname, trimedDatacolname);
                                break;
                            case "isbn":
                                priority(ISBNTextBox, "isbn", oringDatacolname, trimedDatacolname);
                                break;
                            case "isbn13":
                                priority(ISBN13TextBox, "isbn13", oringDatacolname, trimedDatacolname);
                                break;
                            case "upc":
                                priority(UPCTextBox, "upc", oringDatacolname, trimedDatacolname);
                                break;
                            case "minqty":
                                priority(MinQtyTextBox, "minqty", oringDatacolname, trimedDatacolname);
                                break;
                            case "shortcut":
                                priority(MinQtyTextBox, "shortcut", oringDatacolname, trimedDatacolname);
                                break;
                            default:
                                break;
                        }
                        break;
                    }
                }
            }
        }
        if (string.IsNullOrEmpty(ShortCutTextBox.Text))
        {
            if (!string.IsNullOrEmpty(ISBN13TextBox.Text))
            {
                ShortCutTextBox.Text = ISBN13TextBox.Text;
            }
            else if (!string.IsNullOrEmpty(UPCTextBox.Text))
            {
                ShortCutTextBox.Text = UPCTextBox.Text;
            }
        }
        if (!string.IsNullOrEmpty(Author1LastNameTB.Text))
        {
            AuthorCB.Checked = true;
        }
    }
    /// <summary>
    /// Builds SearchBy string. this is the string used in the RegEX search.
    /// </summary>
    /// <returns></returns>
    public static string SearchByMeth()
    {
        searchCriteria.MakeSearchFildDic();
        string searchBy = "";

        foreach (var pair in searchCriteria.SearchFiledsDic)
        {
            for (int i = 0; i < pair.Value.Count; i++)
            {
                searchBy += (pair.Value[i] + "|");
            }
        }
        searchBy = searchBy.Substring(0, searchBy.Length - 1);

        return searchBy;
    }
    /// <summary>
    /// if, else if: Makes sure the field name takes priority over other match identifier names
    /// Example: the match was on retailPrice, it will set the textbox "retailPrice" to that index, then later it finds another match on NetTotal
    /// it will keep the index of the match on RetailPrice not changeing to the new match index on NetTotal. but if there was no match 
    /// on "retailPrice" it will set the index of the textbox to the match NetTotal index. If no match on "retailPrice" but has more than one match
    ///on "net" and "WholeSale" will set text box to what ever was first.
    /// (priortiy of what name is set by the name of the Fild (textbox name) Ex: RetailPrice, Min qty, Auther1 are the priority, but could have matches
    /// on Contributor, price, min, ect...)
    /// </summary>
    /// <param name="tbName"></param>
    /// <param name="name"></param>
    /// <param name="oringDatacolname"></param>
    /// <param name="trimedDatacolname"></param>
    public void priority(System.Web.UI.WebControls.TextBox tbName, string name, string oringDatacolname, string trimedDatacolname)
    {
        if (trimedDatacolname != name && string.IsNullOrEmpty(tbName.Text))
        {
            tbName.Text = (DataToConvertDT.Columns.IndexOf(oringDatacolname) + 1).ToString();
        }
        else if (trimedDatacolname == name)
        {
            tbName.Text = (DataToConvertDT.Columns.IndexOf(oringDatacolname) + 1).ToString();
        }
    }

    /// <summary>
    /// Get indexs for data, create output with correct data indexes
    /// when format button clicked, calls the GetColumnIndex (). Adds the index of each filds textbox to IndexDictionary. This is used for selecting 
    /// what columns and Positions in the file that is to be uploaded is for what fild. 
    /// FormatData () is then called. This loops through DataToConvertDT, then formats each fild, Then once one full row has been Formatted 
    /// it inserts it into rowClassLst.
    /// Calles UpdateDeletes() or UploadData() depending on IsDelete variable. UpdateDelets changes status of existing items to "D". UploadData inserts new items.
    /// WriteOutPutFile() is called. writes log to convertedFiles folder, tells what type of upload it was, who it was for, and date it was done
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    public void UploadButton_Click(object sender, EventArgs e)
    {
        try
        {
            bool IsChangeDelete = false;
            bool IsChangeActive = false;
            
            if (!string.IsNullOrEmpty(SKUTextBox.Text))
            {
                if (ChangeDeleteCB.Checked)
                    IsChangeDelete = true;
                else if (ChangeActiveCB.Checked)
                    IsChangeActive = true;

                if (GetColumnIndex(IsChangeDelete, IsChangeActive))
                {
                    FormatData(IsChangeDelete, IsChangeActive);
                    if (DeleteQryCB.Checked)
                        InsertDeleteQry();

                    UploadInsertData();
                    writeOutputFile(IsChangeDelete, IsChangeActive);
                    if (IsChangeDelete == true)
                        NoticeMessage("Updated existing items status to Delete");
                    else if (IsChangeActive == true)
                        NoticeMessage("Updated existing items status to Active");
                    else
                        NoticeMessage("Uploaded new items");
                }
                else
                {
                    // invalid index input by user Error message displayed in ValidateAddIndex() User needs to re-try
                    GridView1.DataSource = DataToConvertDT;
                    GridView1.DataBind();
                }
            }
            else
                ErrorMessage("File: <br> File: " + FileName + " was NOT uploaded" + " <br> Must have valid SKU to insert or update.");
        }
        catch (SqlException ex)
        {
            ErrorMessage("Unable to handle error. <br> File: " + FileName + " was NOT uploaded" + " <br> Error message has been sent to administrator.");
            ErrorLogEmail(ex.Message.ToString(), ex.Source.ToString(), ex.StackTrace.ToString(), ex.TargetSite.ToString(), FileName + "<BR>" + FullFilePath);
        }
        catch (Exception ex)
        {
            ErrorMessage("Unable to handle error. <br> File: " + FileName + " was NOT uploaded" + " <br> Error message has been sent to administrator.");
            ErrorLogEmail(ex.Message.ToString(), ex.Source.ToString(), ex.StackTrace.ToString(), ex.TargetSite.ToString(), FileName + "<BR>" + FullFilePath);
        }
    }
    /// <summary>
    /// Gets the index of fild names inside datatable DataToConvertDT by each textbox on form1. 
    /// Puts the index into a dictionary (Index.indexDictionary inside FildNamesClass. 
    /// Key being the fild name(ex:sku), the value being the index from corresponding textbox. (ex:1)
    /// If no index from Textbox Sets the index inside dictionary to -99. 
    /// This tells that the file to upload does not have a value for the particular fild
    /// </summary>
    public bool GetColumnIndex(bool IsChangeDelete, bool IsChangeActive)
    {
        Index.indexDictionary.Clear();

        if (!ValidateAddIndex("sku", SKUTextBox, IsChangeDelete, IsChangeActive))
            return false;
        if (!ValidateAddIndex("title", TitleTextBox, IsChangeDelete, IsChangeActive))
            return false;
        if (!ValidateAddIndex("author1", Author1TextBox, IsChangeDelete, IsChangeActive))
            return false;
        if (!ValidateAddIndex("author1lastname", Author1LastNameTB, IsChangeDelete, IsChangeActive))
            return false;
        if (!ValidateAddIndex("author2", Author2TextBox, IsChangeDelete, IsChangeActive))
            return false;
        if (!ValidateAddIndex("author2lastname", Author2LastNameTB, IsChangeDelete, IsChangeActive))
            return false;
        if (!ValidateAddIndex("retailprice", RetailPriceTextBox, IsChangeDelete, IsChangeActive))
            return false;
        if (!ValidateAddIndex("type", TypeTextBox, IsChangeDelete, IsChangeActive))
            return false;
        //see if Category is a index row number or input text
        int num1;
        if (int.TryParse(CategoryTextBox.Text, out num1))
        {
            if (!ValidateAddIndex("category", CategoryTextBox, IsChangeDelete, IsChangeActive))
                return false;
        }
        else //Category is a string input for all reccords or has nothing in TB
            if (string.IsNullOrEmpty(CategoryTextBox.Text))//If nothign in TB
                Index.indexDictionary.Add("category", -99);
            else//IF somthing in TB
                Index.indexDictionary.Add("category", -1);
        if (!ValidateAddIndex("releasedate", ReleaseDateTextBox, IsChangeDelete, IsChangeActive))
            return false;
        if (!ValidateAddIndex("isbn", ISBNTextBox, IsChangeDelete, IsChangeActive))
            return false;
        if (!ValidateAddIndex("isbn13", ISBN13TextBox, IsChangeDelete, IsChangeActive))
            return false;
        if (!ValidateAddIndex("upc", UPCTextBox, IsChangeDelete, IsChangeActive))
            return false;
        if (!ValidateAddIndex("minqty", MinQtyTextBox, IsChangeDelete, IsChangeActive))
            return false;
        if (!ValidateAddIndex("shortcut", ShortCutTextBox, IsChangeDelete, IsChangeActive))
            return false;
        return true;
    }
    /// <summary>
    /// validate user input for textbox index.
    /// checks to see if TB is null, if yes then set to -99, if no then check to make sure it is numberic, then make sure it is a valid coulmn number
    /// 
    /// If string not empty, and its not a update status to delete or active (becuase if it is an update to change status to delete or active, all we need is SKU, Publisher (we get from sign in).
    /// If it is delete or active all we need is SKU and if it is a update to delete or active, and assign everying els -99(which = null)
    /// anything else (update or insert) we need all filds that have data, any fild with no data is assigned -99
    /// </summary>
    /// <param name="keyName"></param>
    /// <param name="TB"></param>
    public bool ValidateAddIndex(string keyName, System.Web.UI.WebControls.TextBox TB, bool IsChangeDelete, bool IsChangeActive)
    {
     int output;

     if ((!string.IsNullOrEmpty(TB.Text) & (IsChangeDelete == false) & (IsChangeActive == false)) | (keyName == "sku"))
        {
            if (int.TryParse(TB.Text, out output))
            {
                if (output <= DataToConvertDT.Columns.Count && output > 0)
                    Index.indexDictionary.Add(keyName, Convert.ToInt32((TB.Text)) - 1);
                else
                {
                    ErrorMessage("Invalid input in textbox: " + keyName + "<br>Input must be a valid column number and larger than 0.");
                    return false;
                }
            }
            else
            {
                ErrorMessage("Invalid input in textbox: " + keyName + "<br>Input must be numeric.");
                return false;
            }
        }
        else
        {
            Index.indexDictionary.Add(keyName, -99);
        }
        return true;
    }
    /// <summary>
    /// Loop through rows in datatable DataToConvertDT(File that needs uploaded).
    /// if row in DT DataToConvertDT has column for corrisponding fild (not -99) then add to RowToInsert class
    /// then add class to listofRows.rowClassLst
    /// if shortcut has value sets it by only takeing last 5 characters
    /// !!!!!!Author!!!!!!
    /// if author first name and last man in diffrent cells, combins them into one cell to insert into author1 and author2 for database
    /// </summary>
    public void FormatData(bool IsChangeDelete, bool IsChangeActive)
    {
        try
        {
            listofRows.rowClassLst.Clear();
            DateTime d;
            string dateStr = "";

            foreach (DataRow dr in DataToConvertDT.Rows)
            {
                RowToInsert Row = new RowToInsert();

                foreach (KeyValuePair<string, int> pair in Index.indexDictionary)
                {
                    int Indexofvalue = Index.indexDictionary[pair.Key];
                    if (pair.Value != -99)
                    {
                        switch (pair.Key)
                        {
                            case "sku":
                                if (!DashCB.Checked)
                                {
                                    char[] arr = dr[Indexofvalue].ToString().Where(c => (char.IsLetterOrDigit(c))).ToArray();
                                    string str = new string(arr);
                                    Row.sku = str;
                                }
                                else
                                    Row.sku = dr[Indexofvalue].ToString();
                                break;
                            case "title":
                                Row.title = dr[Indexofvalue].ToString();
                                break;
                            case "author1":
                                if (Index.indexDictionary["author1lastname"] != -99)
                                {
                                    string temp = dr[Index.indexDictionary["author1"]].ToString() + " " + dr[Index.indexDictionary["author1lastname"]].ToString();
                                    if (temp != " ")
                                        Row.author1 = temp;
                                }
                                else
                                    Row.author1 = dr[Indexofvalue].ToString();
                                break;
                            case "author2":
                                if (Index.indexDictionary["author2lastname"] != -99)
                                {
                                    string temp = dr[Indexofvalue].ToString() + " " + dr[Index.indexDictionary["author2lastname"]].ToString();
                                    if (temp != " ")
                                        Row.author2 = temp;
                                }
                                else
                                    Row.author2 = dr[Indexofvalue].ToString();
                                break;
                            case "retailprice":
                                Row.retailprice = dr[Indexofvalue].ToString();
                                break;
                            case "type":
                                Row.type = dr[Indexofvalue].ToString();
                                break;
                            case "category":
                                if (Index.indexDictionary["category"] != -1)
                                    Row.category = dr[Indexofvalue].ToString();
                                else
                                    Row.category = CategoryTextBox.Text.ToString();
                                break;
                            case "releasedate":
                                dateStr = (dr[Index.indexDictionary["releasedate"]]).ToString();
                                if (DateTime.TryParse(dateStr, out d))
                                    Row.releasedate = d.ToShortDateString();
                                break;
                            case "isbn":
                                char[] arr2 = dr[Indexofvalue].ToString().Where(c => (char.IsLetterOrDigit(c))).ToArray();
                                string str2 = new string(arr2);
                                Row.isbn = str2;
                                break;
                            case "isbn13":
                                char[] arr3 = dr[Indexofvalue].ToString().Where(c => (char.IsLetterOrDigit(c))).ToArray();
                                string str3 = new string(arr3);
                                Row.isbn13 = str3;
                                break;
                            case "upc":
                                char[] arr4 = dr[Indexofvalue].ToString().Where(c => (char.IsLetterOrDigit(c))).ToArray();
                                string str4 = new string(arr4);
                                Row.upc = str4;
                                break;
                            case "minqty":
                                if (!string.IsNullOrEmpty(dr[Indexofvalue].ToString())) // if the on row has a value
                                    Row.minqty = int.Parse(dr[Indexofvalue].ToString());//set the dictionary to the on row value,
                                break;
                            case "shortcut":
                                int isbn = Index.indexDictionary["isbn"];
                                int isbn13 = Index.indexDictionary["isbn13"];
                                int upc = Index.indexDictionary["upc"];
                                if (pair.Value == isbn)
                                {
                                    if (Row.isbn.Length >= 5)
                                        Row.shortcut = Row.isbn.Substring(Row.isbn.Length - 5);
                                }
                                else if (pair.Value == isbn13)
                                {
                                    if (Row.isbn13.Length >= 5)
                                        Row.shortcut = Row.isbn13.Substring(Row.isbn13.Length - 5);
                                }
                                else if (pair.Value == upc)
                                {
                                    if (Row.upc.Length >= 5)
                                        Row.shortcut = Row.upc.Substring(Row.upc.Length - 5);
                                }
                                break;
                        }
                    }
                }
                if (IsChangeDelete)
                {
                    Row.status = "D";
                }
                else
                    Row.status = "A";
                listofRows.rowClassLst.Add(Row);
            }
            DataToConvertDT.Dispose();
        }
        catch (Exception)
        {
            throw;
        }
    }
    /// <summary>
        /// Fills datatable(databaseMatchDT) from database for items that need to be updated from the sku's of the data to be uploaded
        /// for each item in rowToInsert, check to see if item exists in databaseMatchDT, if so update the row, if not add a new row and insert data.
        /// update dabase for the changes to databaseMatchDT datatable.
        /// </summary>
    public void UploadInsertData()
    {
        try
        {
            int SkuIndex = Index.indexDictionary["sku"];
            StringBuilder StringSkuLst = new StringBuilder();
            DataTable databaseMatchDT = new DataTable();
            int ii = 0;
            int i = listofRows.rowClassLst.Count;
             foreach (RowToInsert x in listofRows.rowClassLst)     
            {
                StringSkuLst.Append("'" + x.sku.ToString() + "'");
                ii++;

                if (ii < i)
                    StringSkuLst.Append(" or SKU=");
            }

            SqlConnection conn = new SqlConnection();
            conn.ConnectionString = "Data Source=..com;Network Library=DBMSSOCN;Initial Catalog=;User ID=pubrep;Password=;";

            using (SqlConnection sqlconn = new SqlConnection(conn.ConnectionString))
            {
                string SQL = "Select * FROM TestInventory WHERE Publisher='" + PublisherName + "' and (SKU=" + StringSkuLst + ")";
                sqlconn.Open();
                using (SqlDataAdapter dtAdapter = new SqlDataAdapter(SQL, sqlconn))
                {
                    SqlCommandBuilder builder = new SqlCommandBuilder(dtAdapter);

                    dtAdapter.Fill(databaseMatchDT);

                    databaseMatchDT.PrimaryKey = new DataColumn[] { databaseMatchDT.Columns["SKU"] };

                    foreach (RowToInsert x in listofRows.rowClassLst)
                    {
                        DataRow result = FindByPrimaryKey(databaseMatchDT, x.sku);
                        if (result != null)
                            AddUpdateToDT(result, x);
                        else
                        {
                            result = databaseMatchDT.NewRow();
                            result["Publisher"] = PublisherName;
                            result["SKU"] = x.sku;
                            result["ProductPackFlag"] = false;
                            AddUpdateToDT(result, x);
                            databaseMatchDT.Rows.Add(result);
                        }
                    }
                    builder.GetUpdateCommand();
                    dtAdapter.Update(databaseMatchDT);
                }
            }
        }
        catch
        {
            throw;
        }
    }
    /// <summary>
        /// checks to see if item in rowstoinsert is also in databaseMatchDT
        /// </summary>
        /// <param name="value"></param>
        /// <param name="key"></param>
        /// <returns></returns>
    public static DataRow FindByPrimaryKey(DataTable value, object key)
    {
        try
        {
            return value.Rows.Find(key);
        }
        catch
        {
            throw;
        }
    }
    public static void AddUpdateToDT(DataRow result, RowToInsert x)
    {
        try
        {

            if (!string.IsNullOrEmpty(x.isbn))
                result["ISBN"] = x.isbn;         
            if (!string.IsNullOrEmpty(x.title))
                result["Title"] = x.title;
            if (!string.IsNullOrEmpty(x.author1))
                result["Author"] = x.author1;
            if (!string.IsNullOrEmpty(x.author2))
                result["Author2"] = x.author2;
            if (!string.IsNullOrEmpty(x.retailprice))
                result["RetailPrice"] = x.retailprice;
            if (!string.IsNullOrEmpty(x.type))
                result["ProductType"] = x.type;
            if (!string.IsNullOrEmpty(x.category))
                result["ProductCategory"] = x.category;
            if (!string.IsNullOrEmpty(x.releasedate))
                result["ReleaseDate"] = x.releasedate;
            if (!string.IsNullOrEmpty(x.status))
                result["Status"] = x.status;
            if (!string.IsNullOrEmpty(x.upc))
                result["UPC"] = x.upc;
            if (!string.IsNullOrEmpty(x.isbn13))
                result["ISBN13"] = x.isbn13;
            if(x.minqty != -1)//Will be -1 if no index to column was given or no value in the particualr row for column given
                result["MinQty"] = x.minqty;
            if (!string.IsNullOrEmpty(x.shortcut))
                result["ShortCut"] = x.shortcut;
            result["LastUpdatedBy"] = PublisherName;
            result["LastUpdateDate"] = DateTime.Now;
        }
        catch
        {
            throw;
        }
    }

    public void InsertDeleteQry()
    {
        try
        {
            SqlConnection conn = new SqlConnection();
            conn.ConnectionString =
                "Data Source=ixia.arvixe.com;Network Library=DBMSSOCN;Initial Catalog=;User ID=;Password=;";
            string insertStmt = "INSERT INTO TestUpdateAccessSQL(sSql, UpdateDate)VALUES(@sSql, @UpdateDate)";

            using (SqlConnection connection = new SqlConnection(conn.ConnectionString))
            {
                SqlCommand cmd = new SqlCommand(insertStmt, connection);

                connection.Open();

                cmd.Parameters.Add("@sSql", SqlDbType.NVarChar);
                cmd.Parameters.Add("@UpdateDate", SqlDbType.DateTime);

                cmd.Parameters["@sSql"].Value = "delete from Inventory where publisher = " + "'"  + PublisherName + "'" + " and productpackflag = 0";
                cmd.Parameters["@UpdateDate"].Value = DateTime.Now;
 
                cmd.ExecuteNonQuery();
            }
        }
        catch (SqlException)
        {
            throw;
        }
    }   
    /// <summary>
        /// writes log file to converted files folder. tells what type up upload was done (upload new items, or Updated status of existing items)
        ///tells who the file was uploaded for, date was uploaded, and name of file uploaded
        /// </summary>
        /// <param name="IsChangeDelete"></param>
        /// <param name="IsChangeActive"></param>
        /// <param name="IsChangeItems"></param>
    public void writeOutputFile(bool IsChangeDelete, bool IsChangeActive)
    {
        try
        {
            string Line = "";
            string fileNoExtension = "";
            string UploadType = "";
            StringBuilder skuList = new StringBuilder();

            fileNoExtension = (Path.GetFileNameWithoutExtension(FileName) + ".txt");

            StreamWriter outputFile = new StreamWriter(fullConvertedFilesFolderPath + "\\" + fileNoExtension);

            if (IsChangeDelete == true)
                UploadType = "Updated existing inventory status to Delete";
            else if (IsChangeActive == true)
                UploadType = "Updated existing inventory status to Active";
            else
                UploadType = "Uploaded inventory";

            foreach (RowToInsert x in listofRows.rowClassLst)
            {
                skuList.Append(x.sku);
                skuList.Append(Environment.NewLine);
            }

            Line = string.Format("SUCCESSFUL: {0}" + Environment.NewLine + Environment.NewLine +
                     "For Publisher: {3}" + Environment.NewLine +
                     "File: {1}" + Environment.NewLine +
                     "On Date: {2}" + Environment.NewLine + Environment.NewLine +
                     "SKU For Items that were updated or inserted: " + Environment.NewLine +
                     "{4} ", UploadType, FileName, DateTime.Now, PublisherName, skuList.ToString());

            outputFile.WriteLine(Line);

            outputFile.Close();
        }
        catch (Exception)
        {
            throw;
        }
    }
    /// <summary>
    /// Message telling user that file has uploaded succefully or if updated succefully
    /// </summary>
    /// <param name="strMessage"></param>
    public void NoticeMessage(string strMessage)
    {
        try
        {
            if (!string.IsNullOrEmpty(strMessage))
            {
                Resetscreen();
                noticeLabel.Text = string.Format("Sucessfull!: {0}", strMessage);
                noticeLabel.Visible = true;
            }
        }
        catch (Exception)
        {
            throw;
        }
    }
    /// <summary>
    /// error displaying & error logging
    /// Write error message on screen to user.
    /// </summary>
    /// <param name="strMessage"></param>
    public void ErrorMessage(string strMessage)
    {
        try
        {
            if (!string.IsNullOrEmpty(strMessage))
            {
                ErrorLabel.Text = string.Format("Error: {0}", strMessage);
                ErrorLabel.Visible = true;
            }
        }
        catch (Exception)
        {
            throw;
        }
    }
    /// <summary>
    /// </summary>
    /// <param name="message"></param>
    /// <param name="source"></param>
    /// <param name="stacktrace"></param>
    /// <param name="targetsite"></param>
    /// <param name="onFile"></param>
    public void ErrorLogEmail(string message, string source, string stacktrace, string targetsite, string onFile)
    {
        try
        {
            var fromAddress = new MailAddress("", "");
            var toAddress = new MailAddress("", "");
            const string fromPassword = "";
            const string subject = "Error Report";

            string body = string.Format("<b>Message:</b> {0} <br><br>" +
           "<b>Source:</b> {1}<br><br>" +
           "<b>StackTrace:</b> {2}<br><br>" +
           "<b>TargetSite:</b> {3}<br><br>" +
           "<b>On File:</b> {4}", message, source, stacktrace, targetsite, onFile);

            var smtp = new SmtpClient
            {
                Host = "smtp.gmail.com",
                Port = 587,
                EnableSsl = true,
                DeliveryMethod = SmtpDeliveryMethod.Network,
                UseDefaultCredentials = false,
                Credentials = new System.Net.NetworkCredential(fromAddress.Address, fromPassword)
            };
            using (var Emailmessage = new MailMessage(fromAddress, toAddress)
            {
                Subject = subject,
                Body = body,
                IsBodyHtml = true,
                BodyEncoding = System.Text.Encoding.UTF8,
            })
            {
                smtp.Send(Emailmessage);
            }
        }
        catch (Exception)
        {
            throw;
        }
    }
    /// <summary>
    /// Resets screen calles resetScreen()
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ResetButton_Click(object sender, EventArgs e)
    {
        try
        {
            Resetscreen();
        }
        catch (Exception ex)
        {
            ErrorMessage("Unable to handle error. <br> File: " + FileName + " was NOT uploaded" + " <br> Error message has been sent to administrator.");
            ErrorLogEmail(ex.Message.ToString(), ex.Source.ToString(), ex.StackTrace.ToString(), ex.TargetSite.ToString(), FileName + "<BR>" + FullFilePath);
        }
    }
    protected void AlphCB_CheckedChanged(object sender, EventArgs e)
    {
        if (DataToConvertDT.Rows.Count != 0)
        {
            InfoLabel.Visible = false;

            if (AlphLst.Count == 0)
                AlphabetCollection();

            GridView1.DataSource = DataToConvertDT;
            GridView1.DataBind();

            if (numOfColumnsRemoved >= 1 && AlphCB.Checked)
            {
                InfoLabel.Text = "Aphabet does not match original files aphabet, <br> empty columns were removed.";
                InfoLabel.Visible = true;
            }
        }
        else
        {
            ErrorMessage("No file submited. <br>" +
                        "Or file submited has no data.");
        }
    }
    protected void AlphabetCollection()
    {
        const string alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        int length = 0;
        char[] chars = null;
        int[] indexes = null;
        for (int ii = DataToConvertDT.Columns.Count - 1; ii >= 0; ii--)     
        {
            int position = length - 1;
            // Try to increment the least significant
            // value.
            while (position >= 0)
            {
                indexes[position]++;
                if (indexes[position] == alphabet.Length)
                {
                    for (int i = position; i < length; i++)
                    {
                        indexes[i] = 0;
                        chars[i] = alphabet[0];
                    }
                    position--;
                }
                else
                {
                    chars[position] = alphabet[indexes[position]];
                    break;
                }
            }
            // If we got all the way to the start of the array,
            // we need an extra value
            if (position == -1)
            {
                length++;
                chars = new char[length];
                indexes = new int[length];
                for (int i = 0; i < length; i++)
                {
                    chars[i] = alphabet[0];
                }
            }

            AlphLst.Add(new string(chars));
        }
        
    }
    /// <summary>
    /// Resets screen, clears all textboxs and resets enabled/visiblity settings
    /// </summary>
    protected void Resetscreen()
    {
        try
        {
            FileUpload1.Enabled = true;
            IndexButton.Enabled = true;
            UploadButton.Enabled = false;
            ErrorLabel.Visible = false;
            noticeLabel.Visible = false;
            AuthorCB.Checked = false;

            SKUTextBox.Text = string.Empty;
            TitleTextBox.Text = string.Empty;
            Author1TextBox.Text = string.Empty;
            Author1LastNameTB.Text = string.Empty;
            Author2TextBox.Text = string.Empty;
            Author2LastNameTB.Text = string.Empty;
            RetailPriceTextBox.Text = string.Empty;
            TypeTextBox.Text = string.Empty;
            CategoryTextBox.Text = string.Empty;
            ReleaseDateTextBox.Text = string.Empty;
            ISBNTextBox.Text = string.Empty;
            ISBN13TextBox.Text = string.Empty;
            UPCTextBox.Text = string.Empty;
            MinQtyTextBox.Text = string.Empty;
            ShortCutTextBox.Text = string.Empty;
            AlphCB.Checked = false;
            AlphCB.Enabled = false;
            OtherSheetsCB.Enabled = false;
            InfoLabel.Visible = false;
            AuthorCB.Enabled = false;

            AlphLst.Clear();
            DataToConvertDT.Clear();
            Index.indexDictionary.Clear();
            listofRows.rowClassLst.Clear();

            GridView1.DataSource = null;
            GridView1.DataBind();
        }
        catch (Exception)
        {
            throw;
        }
    }
}
}
