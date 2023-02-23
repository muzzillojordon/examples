using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ProductionLineLogs : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string value = Request.QueryString["val"].ToString();

        ProdLineLable.InnerText = value + " Logs";

        if (value == "Continuous Pickle Line")
        {
            CPL_Logs_ButtonsID.Visible = true; ;
        }
        else if (value == "Push Pull Pickle Line")
        {
            PPPL_Logs_ButtonsID.Visible = true;
        }
        else if (value == "Reversing Mill")
        {
            RM_Logs_ButtonsID.Visible = true;
        }


        CPL_BoilerLogbutt.HRef = "LogsDashboard.aspx?val=" + "CPL Boiler Log Dashboard";
        CPL_UtilityLogButt.HRef = "LogsDashboard.aspx?val=" + "CPL Utility Log Dashboard";
        PPPL_ROLogButt.HRef = "LogsDashboard.aspx?val=" + "PPPL RO Log Dashboard";

       
    }
}