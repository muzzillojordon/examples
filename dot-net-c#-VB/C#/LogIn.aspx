<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LogIn.aspx.cs" Inherits="LogIn" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>LogIn</title>
    <link href="CSS/jquery-ui-darkness.min.css" rel="stylesheet" />
    <link href="CSS/foundation.min.css" rel="stylesheet" />
    <link href="CSS/normalize.css" rel="stylesheet" />
    <link href="CSS/app.css" rel="stylesheet" />
    <link href="css/foundation-icons.css" rel="stylesheet" />
</head>
<body class="logInBody">
    <form id="myform" runat="server" style="background-color: #333" data-abide="">
        <%--Header Start--%>
        <header class="row">
            <div class="large-10 medium-7 small-centered columns">
                <div class="large-1 column">
                </div>
                <div class="large-11 column name">
                    <h1 class="LogoText"><a href="LogIn.aspx">Jordon<small>Muzzillo</small></a></h1>
                </div>
            </div>
        </header>
        <%--Header end--%>

        <%--Main SignIn/SignUp container--%>
        <div class="row">
            <div class="large-10 medium-10 small-centered columns panel logIn-signUp-container">
                <div class="row logIn-pannel">
                    <%--Secure logIn container--%>
                    <div id="logIn_container" class="large-6 column panel logIn-container">
                        <div class="row">
                            <div class="large-12 small-centered text-center columns">
                                <h2 class="h2_white">Secure Login</h2>
                            </div>
                        </div>
                        <div class="row collapse">
                            <div class="small-2 columns">
                                <span class="prefix large50 "><i class="fi-torso"></i></span>
                            </div>
                            <div class="small-10 columns">
                                <asp:TextBox Class="LargeTextBox" ID="UserIdTB" placeholder="UserID" runat="server" required=""></asp:TextBox>
                            </div>
                        </div>
                        <div class="row collapse">
                            <div class="small-2 columns">
                                <span class="prefix large50"><i class="fi-lock"></i></span>
                            </div>
                            <div class="small-10  columns ">
                                <asp:TextBox Class="LargeTextBox" Type="password" ID="PasswordTB" placeholder="Password" runat="server" required=""></asp:TextBox>
                            </div>
                        </div>
                        <div id="warnMsg" class="alert-box warning" style="display: none;">
                            <strong>Caution</strong> - All required fields.
                                 <a href="#" class="close">&times;</a>
                        </div>
                        <div class="alert-box alert radius" id="InvalidMsg" runat="server" visible="false">
                            <strong>Error</strong> - Incorrect login information.
                                 <a href="#" class="close">&times;</a>
                        </div>
                        <div class="row">
                            <div class="large-12 text-center columns">
                                <div class="checkbox small-7 medium-4 large-7 small-centered column">
                                    <label>
                                        <asp:CheckBox ID="RememberMeCB" runat="server" />
                                        Remember Me
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="medium-10 large-7 small-centered columns">
                                <asp:Button type="submit" Class="button large expand radius" ID="LogInButt" runat="server" Text="Sign In" OnClick="LogInButt_Click" />
                            </div>
                        </div>
                        <div class="row">
                            <%-- <div class="large-8 small-centered columns">
                                <a>Forgot Your Password?</a>
                            </div>--%>
                        </div>
                    </div>
                    <%--END Secure logIn container--%>

                    <%--Guest User--%>
                    <div class="large-6 columns">
                        <div class="row">
                            <div class="small-12 text-center">
                                <h2 class="h2_white">Need Login?</h2>
                            </div>
                        </div>
                        <div class="row">
                            <div class="small-12 text-center columns">
                                <p class="p-white">
                                    If you have received a resume there will be a user-name and password 
                                    listed after the URL for you to use.
                                </p>
                            </div>
                        </div>
                        <div class="row">
                            <div class="small-12 text-center columns">
                                <div class="dbl_button_group dbl_lrg" data-grouptype="OR">
                                    <a class="large button primary radius" href="Dashboard.aspx">Guest</a>
                                    <button data-reveal-id="Register_Modal" id="learnMoreButt" class="large button success radius">Get Password</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%--END New User--%>
                </div>
            </div>
        </div>
        <%--END Main SignIn/SignUp container--%>

        <footer class="footer LogIn">
            <div class="row">
                <div class="small-12 columns">
                    <p class="links">
                        <a data-reveal-id="Contact_Modal" href="#">Contact</a>
                        <a data-reveal-id="About_Modal" href="#">About</a>
                    </p>
                    <%--<p class="copywrite">Copywrite © 2015</p>--%>
                </div>
            </div>
        </footer>

        <%--MODALS--%>
        <%--Contact Modal For Footer--%>
        <div id="Contact_Modal" class="reveal-modal" data-reveal="" aria-labelledby="" aria-hidden="true" role="dialog">
            <div class="contact-container">
                <div class="medium-6 large-6 columns">
                    <div class="row">
                        <div class="small-12 columns">
                            <h4 class="location h4_white">Jordon Ford Muzzillo</h4>
                        </div>
                        <div class="small-12 columns">
                            <p>
                                6958 E Swan Rd<br />
                                Avilla, IN 46710
                            </p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="small-12 columns">
                            <h4 class="phone h4_white">+1 260 433 3589</h4>
                        </div>
                    </div>
                    <div class="row">
                        <div class="small-12 columns">
                            <div class="small-12 columns">
                                <h4 class="email h4_white">Email</h4>
                            </div>
                            <div class="small-12 columns">
                                <p>MuzzilloJordon@Outlook.com</p>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="small-12 columns">
                            <h4 class="h4_white">Social</h4>
                            <div class="social">
                                <ul class="inline-list">
                                    <li><a href="#"><i class="fi-social-linkedin"></i></a></li>
                                    <li><a href="#"><i class="fi-social-twitter"></i></a></li>
                                    <li><a href="#"><i class="fi-social-facebook"></i></a></li>
                                    <li><a href="#"><i class="fi-social-google-plus"></i></a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="medium-6 large-6 columns">
                    <div class="row">
                        <div class="small-12 columns text-center">
                            <p class="form-lead">Let's chat about what I am all about</p>
                            <p class="form-lead-in">and we will work together to see if I am a right fit for your company.</p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="small-12 columns">
                            <div class="round-inputs">
                                <div class="row">
                                    <div class="large-12 columns round-textbox">
                                        <input type="text" placeholder="Name" />
                                    </div>
                                    <div class="large-12 columns round-textbox">
                                        <input type="email" placeholder="Email" />
                                    </div>
                                    <div class="large-12 columns round-textbox">
                                        <input type="text" placeholder="Telephone" />
                                    </div>
                                    <div class="large-12 columns round-textbox">
                                        <textarea placeholder="Let me know what is on your mind..."></textarea>
                                        <a href="#" class="button round">Submit</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <a class="close-reveal-modal" aria-label="Close">&#215;</a>
        </div>

        <%--Register Modal For Footer--%>
        <div id="Register_Modal" class="reveal-modal" data-reveal="" data-options="close_on_background_click:false; multiple_opened:true;" aria-labelledby="" aria-hidden="true" role="dialog">

            <div class="register-container">
                <div class="row">
                    <div class="medium-8 columns medium-centered">
                        <form id="registerForm">
                            <div class="round-inputs">
                                <div class="row">
                                    <div class="large-12 columns round-textbox">
                                        <label>
                                            Company Name <small>required</small>
                                            <input id="CompanyNameTB" type="text" placeholder="Company Name" runat="server" />
                                        </label>
                                        <small id="CompError" style="display: none;" class="error">A company name is required.</small>
                                    </div>
                                    <div class="large-12 columns round-textbox">
                                        <input id="ContactNameTB" type="text" placeholder="Contact Name" />
                                    </div>
                                    <div class="large-12 columns round-textbox">
                                        <input id="ContactEmailTB" type="text" placeholder="Contact Email" />
                                    </div>
                                    <div class="large-12 columns round-textbox">
                                        <input id="ContactTelTB" type="text" placeholder="Contact Telephone" />
                                    </div>
                                    <div class="large-12 columns round-textbox">
                                        <textarea id="ContectMsgHolder" placeholder="Let me know if there is anything you would like from me..."></textarea>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="medium-12 columns">
                                        <a href="#" id="GetPaswordButt" class="button expand">Get Password</a>
                                    </div>

                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <a class="close-reveal-modal" aria-label="Close">&#215;</a>

        </div>

        <%--About Modal For Footer:--%>
        <div id="About_Modal" class="reveal-modal" data-reveal="" aria-labelledby="" aria-hidden="true" role="dialog">
            <div class="About-container">
                <div class="row">
                    <div class="small-12 columns text-left">
                        <h3>About the Site</h3>
                    </div>
                </div>
                <div class="small-12 columns">
                    <div class="row">
                        <div class="small-12 columns">
                            <p>
                                I created this site using Visual Studio asp.net, I wrote it in c#. 
                                I utilized jQuery as well as Zurb Foundation to aid in the responsive 
                                front-end framework. If you have any more questions about me or the 
                                site feel free to contact me
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            <a class="close-reveal-modal" aria-label="Close">&#215;</a>
        </div>

        <%--Error Modal Called from multiple places--%>
        <div id="errorModal" class="reveal-modal small warningModal" data-options="close_on_background_click:false; multiple_opened:true;" data-reveal="" aria-labelledby="modalTitle" aria-hidden="true" role="dialog">
            <div class="row collapse">
                <div class="small-12 columns">
                    <div id="ErrMsg" class="alert-box alert radius">
                        <h2><i class="fi-alert"></i><strong>Caution</strong></h2>
                    </div>
                </div>
            </div>
            <div style="padding: 0 1.875rem 1.875rem 1.875rem;">
                <div class="row collapse">
                    <div class="large12 columns">
                        <h2 id="err_modalTitle">There was a problem</h2>
                    </div>
                </div>
                <div class="row collapse text-center">
                    <div class="large6 columns large-centered">
                        <p id="err_modalBodyText" runat="server"></p>
                    </div>
                </div>
                <div class="row collapse">
                    <div class="small-12 columns text-center">
                        <a class="button  close-reveal-modal" href="#close">OK</a>
                    </div>
                </div>
            </div>
        </div>
        <%--END MODALS--%>

        <%  // This gets called during the render stage. Gets Jquery and foundation
            JavaScriptLibrary.JavaScriptHelper.Include_Foundation(Page.ClientScript, true);%>

        <script src="js/Login.js"></script>

        <script type="text/javascript">
            window.onload = function () {
                $(document).foundation({});
                LogInScript();
            };
        </script>
    </form>

</body>
</html>
