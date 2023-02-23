using System;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

public partial class LogsDashboard : System.Web.UI.Page
{
    public string connStr;

    protected void Page_Load(object sender, EventArgs e)
    {

        BackButt.HRef = "ProductionLineLogs.aspx?val=" + "Continuous Pickle Line";


        string value = Request.QueryString["val"].ToString();

        if (value == "CPL Boiler Log Dashboard")
        {
            LogIDLable.InnerText = value;
            // CPL_Logs_ButtonsID.Visible = true; ;
        }
        else if (value == "CPL Utility Log Dashboard")
        {
            LogIDLable.InnerText = value;
            //PPPL_Logs_ButtonsID.Visible = true;
        }
        else if (value == "PPPL RO Log Dashboard")
        {
            LogIDLable.InnerText = value;
            //RM_Logs_ButtonsID.Visible = true;
        }
    }

    [WebMethod(EnableSession = true)]
    public static object listAction_BoilerLog(string jtStartIndex, int jtPageSize, string jtSorting)
    {
        try
        {
            int TotalItems;

            string connStr = ConfigurationManager.ConnectionStrings["LogsConnectionString"].ConnectionString;

            //Set stored procedure name or string SQL statement for listing query
            string StoredProc = "SELECT * FROM CPLBoilerRoomLog";

            var BoilerLoglist = new List<BoilerRoomLog>();

            using (SqlConnection Con = new SqlConnection(connStr))
            {
                ;
                SqlCommand oCmd = new SqlCommand(StoredProc, Con);


                Con.Open();
                using (SqlDataReader oReader = oCmd.ExecuteReader())
                {
                    while (oReader.Read())
                    {
                        BoilerRoomLog Log = new BoilerRoomLog();

                        Log.logeddate = oReader["logdate"].ToString();

                        BoilerLoglist.Add(Log);
                    }

                    Con.Close();
                }
            }

            TotalItems = BoilerLoglist.Count;

            //Return result to jTable
            return new { Result = "OK", Records = BoilerLoglist, TotalRecordCount = TotalItems };
        }
        catch (Exception ex)
        {
            return new { Result = "ERROR", Message = ex.Message };
        }
    }


}

