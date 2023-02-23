<%@ Page Title="PasswordReset" Language="VB" AutoEventWireup="false" CodeFile="PasswordReset.aspx.vb" Inherits="PasswordReset" %>

<!DOCTYPE html>
<html lang="en">
<head id="Head1" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Password Reset</title>

    <link href="public/css/app.css" rel="stylesheet" />
    <script src="public/js/min/modernizer.min.js"></script>
</head>

<body>
    <form id="ResetPassForm" runat="server" style="background-color: #333" data-abide="ajax">
        <header class="row">
            <div class="large-10 medium-7 small-centered columns">
                <div class="large-1 column">
                </div>
                <div class="large-11 column name">
                    <h1 class="LogoText">PUB<small>reps</small></h1>
                </div>
            </div>
        </header>

        <div class="row">
            <div class="large-10 medium-10 small-centered columns panel PassResetMaincontainer">
                <div class="row PassReset-pannel">
                    <%--Password Reset container--%>
                    <div id="PassResetInnercontainer" class="large-6 column panel PassResetinnercontainer">
                        <div class="row">
                            <div class="large-12 small-centered text-center columns">
                                <h2 class="h2_white">Secure Login</h2>
                            </div>
                        </div>
                        <div class="row collapse">
                            <div class="small-2 columns">
                                <a id="newPassPreimg"><span class="prefix large50 "><i class="fi-eye"></i></span></a>
                            </div>
                            <div class="small-10 columns">
                                <asp:TextBox Class="LargeTextBox" ID="NewPasswordTB" Type="password" placeholder="New password" runat="server" required="" pattern="[a-zA-Z]+"></asp:TextBox>
                                <small class="error">Your password must match the requirements</small>
                            </div>
                        </div>
                        <div class="row collapse">
                            <div class="small-2 columns">
                                <a id="confirmPassPreimg"><span class="prefix large50"><i class="fi-eye"></i></span></a>
                            </div>
                            <div class="small-10  columns ">
                                <asp:TextBox Class="LargeTextBox" Type="password" ID="ConfirmPasswordTB" placeholder="Confirm new password" runat="server" required="" pattern="[a-zA-Z]+" data-equalto="NewPasswordTB"></asp:TextBox>
                                <small class="error">The password did not match</small>
                            </div>
                        </div>
                        <div class="row">
                            <div class="medium-10 large-7 small-centered columns">
                                <input id="ChangePassButt" type="submit" class="button large expand radius" value="CHANGE PASSWORD" />
                            </div>
                        </div>
                    </div>

                    <%--Password Info--%>
                    <div class="large-6 columns">
                        <div class="row">
                            <div class="small-12 text-center">
                                <h2 class="h2_white">New Password</h2>
                            </div>
                        </div>
                        <div class="row">
                            <div class="small-12 text-justify columns">
                                <p class="p-white">
                                    Choose a strong password and don't reuse it for other accounts
                                </p>
                            </div>
                        </div>
                        <div class="row">
                            <div class="small-12 text-justify columns">
                                <p class="p-white">
                                    Changing your password will sign you out of all your devices, including your phone. 
                                    You will need to enter your new password on all your devices.
                                </p>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <footer class="footer PassReset">
            <div class="row">
                <div class="small-12 columns">
                    <p class="links">
                        <a data-reveal-id="Contact_Modal" href="#">Contact</a>
                        <a href="#">About</a>
                        <a href="#">Faq</a>
                    </p>
                </div>
            </div>
        </footer>

        <%--Error Modal Called from multiple places. Mostly from Jtable edit, add, and other error points--%>
        <div id="errorModal" class="reveal-modal small warningModal" data-options="close_on_background_click:false;" data-reveal="" aria-labelledby="" aria-hidden="true" role="dialog">
            <div class="row collapse">
                <div class="small-12 columns">
                    <div id="ErrMsgContainer" class="alert-box alert radius">
                        <h2><i class="fi-alert"></i><strong>Caution</strong></h2>
                    </div>
                </div>
            </div>
            <div style="padding: 0 1.875rem 1.875rem 1.875rem;">
                <div class="row collapse">
                    <div class="small-12 columns">
                        <h4 id="err_modalTitle">There Was A Problem:</h4>
                    </div>
                </div>
                <div class="row collapse">
                    <div class="small-12 columns">
                        <p id="err_modalBodyText" runat="server"></p>
                    </div>
                </div>
                <div class="row collapse">
                    <div class="small-12 columns text-center">
                        <a class="button expand" href="LogIn.aspx">OK</a>
                    </div>
                </div>
            </div>
        </div>

        <%--Success Modal Called from multiple places--%>
        <div id="successModal" class="reveal-modal small warningModal" data-options="close_on_background_click:false;" data-reveal="" aria-labelledby="" aria-hidden="true" role="dialog">
            <div class="row collapse">
                <div class="small-12 columns">
                    <div id="successMsg" class="alert-box success alert radius">
                        <h2><i class="fi-checkbox"></i><strong>Success</strong></h2>
                    </div>
                </div>
            </div>
            <div style="padding: 0 1.875rem 1.875rem 1.875rem;">
                <div class="row collapse">
                    <div class="small-12 columns">
                        <h4 id="successMsgTitle">Your Action Has Been Successful:</h4>
                    </div>
                </div>
                <div class="row collapse">
                    <div class="small-12 columns large-centered">
                        <p id="success_modalBodyText" runat="server"></p>
                    </div>
                </div>
                <div class="row collapse">
                    <div class="small-12 columns text-center">
                        <a class="button expand" href="LogIn.aspx">OK</a>
                    </div>
                </div>
            </div>
        </div>

        <%--   BUSY MODAL--%>
        <div id="BusyModal" class="reveal-modal small BusyModal" data-options="close_on_background_click:false;" data-reveal="" aria-labelledby="LoeadingModal" aria-hidden="true" role="dialog">
            <div class="row">
                <div class="small-12 columns text-center">
                    <img alt="" src="/pubreps2_0/public/images/gears.gif" />
                </div>
            </div>
        </div>


        <%--Production Mode--%>
        <script src="public/js/all-foundation-bundle.min.js"></script>
            <script src="public/js/min/ResetPasswordScript.min.js"></script>
            <script src="public/js/min/resetPassword.js"></script>

        <%--Debug Mode--%>
<%--        <script src="public/js/nonmin/jquery.js"></script>
        <script src="public/js/nonmin/foundation.js"></script>
        <script src="public/js/nonmin/resetPassword.js"></script>--%>

        <script type="text/javascript">
            window.onload = function () {
                $(document).foundation({});
                ResetPasswordScript();
            }

            function errorModalCodeBehind(errorMsg) {
                //Note placement of all scripts must be above form tag when jQuery function is called from code behind
                $('#err_modalBodyText').html('' + errorMsg + '');
                $('#errorModal').foundation('reveal', 'open');
            }
        </script>

    </form>
</body>
</html>

