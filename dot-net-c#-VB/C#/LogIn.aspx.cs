using System;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;

public partial class LogIn : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected override void OnPreRender(EventArgs e)
    {
        base.OnPreRender(e);
        JavaScriptLibrary.JavaScriptHelper.Include_Modernizr(Page.ClientScript);
    }
    protected void LogInButt_Click(object sender, EventArgs e)
    {
        // Three valid username/password pairs: Scott/password, Jisun/password, and Sam/password.
        string[] users = { "user"};
        string[] passwords = { "pass" };
        for (int i = 0; i < users.Length; i++)
        {
            bool validUsername = (string.Compare(UserIdTB.Text, users[i], true) == 0);
            bool validPassword = (string.Compare(PasswordTB.Text, passwords[i], false) == 0);
            if (validUsername && validPassword)
            {
                FormsAuthenticationTicket tkt = default(FormsAuthenticationTicket);
                string cookiestr = null;
                HttpCookie ck = default(HttpCookie);

                string userData = "";
              
                tkt = new FormsAuthenticationTicket(1, "", DateTime.UtcNow, DateTime.Now.AddDays(3), RememberMeCB.Checked, userData);

                cookiestr = FormsAuthentication.Encrypt(tkt);
                ck = new HttpCookie(FormsAuthentication.FormsCookieName, cookiestr);

                if ((RememberMeCB.Checked))
                    ck.Expires = tkt.Expiration;

                Response.Cookies.Add(ck);

                // TODO: Redirect them to the appropriate page
                string strRedirect = null;
                strRedirect = FormsAuthentication.GetRedirectUrl("", false);

                if (!string.IsNullOrEmpty(strRedirect))
                {
                    Response.Redirect(strRedirect, true);
                }
                else
                {
                    strRedirect = "Dashboard.aspx";
                    Response.Redirect(strRedirect, true);
                }
            }
        }
        // If we reach here, the user's credentials were invalid
        InvalidMsg.Visible = true;
    }


       [WebMethod]
    public static string GetPassword(string[] data )
    {

        return "Pasword";
    }

}