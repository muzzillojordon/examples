using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Net.Mail;

public partial class Dashboard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static object ContactMe(string ContactName, string ContactEmail, string ContactTel, string ContactMsg)
    {
        try{

            string subject = "Resume Contact Request";
            string message = "Name: "+ ContactName + System.Environment.NewLine+"Contact Email: "+
                ContactEmail +  System.Environment.NewLine +
                 "Contact Tel: "+ ContactTel+ System.Environment.NewLine + "Message: "+ ContactMsg + "";
            string recipient = "";

            string _sender = ";
            string _password = "";

            SmtpClient client = new SmtpClient("smtp-mail.outlook.com");

            client.Port = 587;
            client.DeliveryMethod = SmtpDeliveryMethod.Network;
            client.UseDefaultCredentials = false;
            System.Net.NetworkCredential credentials =
                new System.Net.NetworkCredential(_sender, _password);
            client.EnableSsl = true;
            client.Credentials = credentials;

            var mail = new MailMessage(_sender.Trim(), recipient.Trim());
            mail.Subject = subject;
            mail.Body = message;
            client.Send(mail);
		return new  {
			Result = "OK",
		};
	} catch (Exception ex) {
		return new {
			Result = "ERROR",
			Message = ex.Message
		};
	}
    }

}