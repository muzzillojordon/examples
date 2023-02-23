function ResetPasswordScript() {
    var form = $('#ResetPassForm');
    var newPassTB = $('#NewPasswordTB');
    var NewPassPreimg = $('#newPassPreimg');
    var ConfirmPassTB = $('#ConfirmPasswordTB');
    var confirmPassPreimg = $('#confirmPassPreimg');
    
    //RESET PASSWORD FORM INPUTS: toggle VISIBILITY 
    NewPassPreimg.on('click', function () {
        if (newPassTB.attr("type") == "password"){
            newPassTB.attr('type', 'text');
            NewPassPreimg.find('span').addClass("active2");
        }
        else {
            newPassTB.attr('type', 'password');
            NewPassPreimg.find('span').removeClass("active2");
        }
    });
    confirmPassPreimg.on('click', function () {
        if (ConfirmPassTB.attr("type") == "password") {
            ConfirmPassTB.attr('type', 'text');
            confirmPassPreimg.find('span').addClass("active2");
        }
        else {
            ConfirmPassTB.attr('type', 'password');
            confirmPassPreimg.find('span').removeClass("active2");
        }
    });

    //FORM HAS VALID SUBMISSION
    form.on('valid.fndtn.abide', function (e) {
        $('#BusyModal').foundation('reveal', 'open');
        var NewPassword = newPassTB.val();
        ResetPassword(NewPassword);   
    });
}

//CALL CODE BEHIND TO UPDATE PASSWORD AND SEND CONFORMATION EMAIL 
function ResetPassword(NewPassword) {
    var URL = "PasswordReset.aspx/ResetPass";
    var dataValue = "{NewPassword: '" + NewPassword + "'}";

    $.ajax({
        type: "POST",
        url: URL,
        data: dataValue,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            if (data.d.Result == "OK") {
                $("#success_modalBodyText").html('Your password has successfully been reset.');
                $('#successModal').foundation('reveal', 'open');
            }
            else {
                $('#err_modalBodyText').html('<b>Error</b>: ' + data.d.Message + '<br/><br/>' +
                             'Sorry about the inconveniences, please try again or contact us.');
                $('#errorModal').foundation('reveal', 'open');
            }
        },
        error: function (xhr, status, error) {
            $('#err_modalBodyText').html('<b>Error</b>: ' + error + '<br/><br/>' +
                      'Sorry about the inconveniences, please try to contact us or try again later');
            $('#errorModal').foundation('reveal', 'open');
        }
    });
}