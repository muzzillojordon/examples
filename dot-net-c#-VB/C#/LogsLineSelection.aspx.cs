using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class LogsLineSelection : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       CPL_LinkID.HRef = "ProductionLineLogs.aspx?val=" + "Continuous Pickle Line";
        PPPL_LinkID.HRef = "ProductionLineLogs.aspx?val=" + "Push Pull Pickle Line";
        RM_LinkID.HRef = "ProductionLineLogs.aspx?val=" + "Reversing Mill";
    }
}