
Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.Net.Mail


Partial Class PasswordReset
    Inherits System.Web.UI.Page

    Public Shared ConnStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("asdf").ConnectionString
    Private Shared userID As String
    Private Shared tokenHash As String
    ''' <summary>
    ''' Parses URL for user name and ticket token.
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not IsPostBack Then
                'Get user ID and token hash from URL, and set global variables 
                userID = Request.QueryString("userId")
                tokenHash = Request.QueryString("token")

                If Not userID Is Nothing OrElse Not tokenHash Is Nothing Then
                    'Get token data
                    If isTicketValid() = False Then
                        'Ticket is invalid, Show Error
                        Throw New Exception("The URL for this password request has expired or has already been used. " & _
                                        "Please submit a new password change request.")
                    End If
                Else
                    'Ticket is valid
                    'check if user is currently logged in
                    Dim ident As CustomIdentity = TryCast(Context.User.Identity, CustomIdentity)
                    If ident Is Nothing Then
                        Response.Redirect("LogIn.aspx", True)
                    Else
                        'Log user out, and destroy current user ticket
                        LogOut()
                        Response.Redirect("~/LogIn.aspx", True)
                    End If
                End If
            End If
        Catch ex As Exception
            'Show error message: Call JS function errorMCodeBehind(ErrorMsg); Located in PasswordReset.aspx
            Dim script As String = "errorModalCodeBehind('" + ex.Message + "')"
            Dim errorMsg As String = ex.Message

            'Note placement of all scripts must be above form tag when jQuery function is called from code behind
            If Not Page.ClientScript.IsStartupScriptRegistered(Me.GetType(), "errorMCodeBehind") Then
                Page.ClientScript.RegisterStartupScript(Me.GetType(), "errorMCodeBehind", script, True)
            End If
        End Try
    End Sub

    ''' <summary>
    ''' Resets password for a user and sends conformation email
    ''' </summary>
    ''' <param name="NewPassword">New password to be used for database update</param>
    ''' <returns>success or failure of update. or error if ticket is not valid</returns>
    ''' <remarks></remarks>
    <System.Web.Services.WebMethod(EnableSession:=True)> _
    Public Shared Function ResetPass(NewPassword As String) As Object
        Try
            Dim userName As String = ""
            Dim emailAddress As String = ""

            'If somehow a user got to page without proper tickets 
            If Not userID Is Nothing OrElse Not tokenHash Is Nothing Then
                'Check if ticket is valid
                If isTicketValid() = True Then
                    'Update users password in database, Update hash token used
                    UpdatePassword(NewPassword)
                    'Update ticket
                    UpdateTicket()
                    'Get user email address to send conformation that password was update.
                    Dim d As Tuple(Of String, String) = GetUserData()
                    emailAddress = d.Item1
                    userName = d.Item2
                    'check if email address exists
                    If Not emailAddress = "" Then
                        'Send conformation email
                        ConformationEmail(emailAddress, userName)
                    End If
                Else
                    'Ticket is invalid, show error
                    Throw New Exception("The URL for this password request has expired or has already been used. " & _
                                        "Please submit a new password change request.")
                End If
            Else
                'No ticket, show error
                Throw New Exception("There has been an issue getting your userID please try again later or contact us.")
            End If
            'Return result
            Return New With { _
                Key .Result = "OK"}
        Catch ex As Exception
            Return New With { _
                Key .Result = "ERROR",
                Key .Message = ex.Message
            }
        End Try
    End Function

    ''' <summary>
    ''' Checks if current ticket is valid
    ''' </summary>
    ''' <returns>boolean value</returns>
    ''' <remarks>True if ticket is valid and false if ticket is not valid</remarks>
    Private Shared Function isTicketValid() As Boolean
        Dim validTicket As Boolean = False
        Dim CheckTickSql = "SELECT expirationDate, tokenUsed FROM ResetTickets WHERE userId=@userId AND tokenHash=@tokenHash"

        'Check user name and token hash with database
        Using con As New SqlConnection(ConnStr)
            Using cmd = New SqlCommand(CheckTickSql, con)
                cmd.Parameters.Add(New SqlParameter("@userId", userID))
                cmd.Parameters.Add(New SqlParameter("@tokenHash", tokenHash))
                con.Open()
                Dim dr = cmd.ExecuteReader()
                If dr.HasRows Then
                    While dr.Read()
                        Dim used As Boolean = dr("tokenUsed")
                        Dim expirDate As Date = dr("expirationDate")
                        'Check if ticket has been used or is expired
                        If (used = False) OrElse (expirDate < DateTime.Now) Then
                            validTicket = True
                        Else
                            validTicket = False
                        End If
                    End While
                Else
                    validTicket = False
                End If
            End Using
        End Using

        Return validTicket
    End Function

    ''' <summary>
    ''' Updates database with new password value
    ''' </summary>
    ''' <param name="NewPassword"></param>
    ''' <remarks></remarks>
    Private Shared Sub UpdatePassword(NewPassword As String)
        Dim upPassSql As String = "Update users Set Password=@Password WHERE UserID=@UserID"

        Using con As New SqlConnection(ConnStr)
            Using cmd = New SqlCommand(upPassSql, con)
                cmd.Parameters.Add(New SqlParameter("@UserID", userID))
                cmd.Parameters.Add(New SqlParameter("@Password", NewPassword))
                con.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    ''' <summary>
    ''' Updates a password-reset ticket.
    ''' </summary>
    ''' <remarks>A ticket can only be used one time</remarks>
    Private Shared Sub UpdateTicket()
        Dim upTokenUsedSql As String = "Update ResetTickets Set TokenUsed=@TokenUsed WHERE userId=@userId AND tokenHash=@tokenHash"

        Using con As New SqlConnection(ConnStr)
            Using cmd = New SqlCommand(upTokenUsedSql, con)
                cmd.Parameters.Add(New SqlParameter("@userId", userID))
                cmd.Parameters.Add(New SqlParameter("@tokenHash", tokenHash))
                cmd.Parameters.Add(New SqlParameter("@TokenUsed", True))
                con.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    ''' <summary>
    ''' Gets user email address and name, based off of user ID
    ''' </summary>
    ''' <returns>String Tuple</returns>
    ''' <remarks>Tuple is of users email address, users name</remarks>
    Private Shared Function GetUserData() As Tuple(Of String, String)

        Dim emailSql As String = "SELECT Email, Name FROM users WHERE UserId=@UserId"
        Dim emailAddress As String = Nothing
        Dim userName As String = Nothing

        Using con As New SqlConnection(ConnStr)
            Using cmd = New SqlCommand(emailSql, con)
                cmd.Parameters.Add(New SqlParameter("@UserId", userID))
                con.Open()
                Dim dr = cmd.ExecuteReader()
                If dr.HasRows Then
                    While dr.Read()
                        If Not IsDBNull(dr("Email")) Then
                            emailAddress = dr("Email").ToString()
                        Else
                            emailAddress = ""
                        End If
                        If Not IsDBNull(dr("Name")) Then
                            userName = dr("Name").ToString()
                        Else
                            userName = ""
                        End If
                    End While
                End If
            End Using
        End Using
        Dim tuple As Tuple(Of String, String) = New Tuple(Of String, String)(emailAddress, userName)
        Return tuple
    End Function

    ''' <summary>
    ''' Sends user a conformation email that their password has been changed
    ''' </summary>
    ''' <param name="emailAddress">User Email Address</param>
    ''' <param name="userName">name of user</param>
    ''' <remarks></remarks>
    Private Shared Sub ConformationEmail(emailAddress As String, userName As String)

        Dim _sender As String = ""
        Dim _password As String = ""
        Dim subject As String = "PubReps account password updated"
        Dim message As String = ""

        'Build conformation email
        Dim sb As New StringBuilder
        sb.AppendLine("Hello " + userName + ",<br /><br />")
        sb.AppendLine("Your Pubreps account password has been reset.<br/>")
        sb.AppendLine("If you have any questions or trouble logging on please contact us.<br/><br/>")
        sb.AppendLine("Thank you!<br/><br/><hr>")
        sb.AppendLine("Please do not reply to this email")
        message = sb.ToString()

        'Send conformation email
        Dim client As New SmtpClient("smtp-mail.outlook.com")
        client.Port = 587
        client.DeliveryMethod = SmtpDeliveryMethod.Network
        client.UseDefaultCredentials = False
        Dim credentials As New System.Net.NetworkCredential(_sender, _password)
        client.EnableSsl = True
        client.Credentials = credentials

        Dim mail = New MailMessage(_sender.Trim(), emailAddress.Trim())
        mail.Subject = subject
        mail.Body = message
        mail.IsBodyHtml = True
        client.Send(mail)
    End Sub

    ''' <summary>
    ''' Logs user out, and destroys users ticket
    ''' </summary>
    ''' <remarks></remarks>
    Sub LogOut()
        Session.Abandon()
        FormsAuthentication.SignOut()

        ' clear authentication cookie
        Dim cookie1 As New HttpCookie(FormsAuthentication.FormsCookieName, "")
        cookie1.Expires = DateTime.Now.AddYears(-1)
        Response.Cookies.Add(cookie1)

        ' clear session cookie (not necessary for your current problem but i would recommend you do it anyway)
        Dim cookie2 As New HttpCookie("ASP.NET_SessionId", "")
        cookie2.Expires = DateTime.Now.AddYears(-1)
        Response.Cookies.Add(cookie2)

        Response.Redirect("~/LogIn.aspx", True)
    End Sub
End Class
