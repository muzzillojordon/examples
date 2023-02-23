
/*********************************************************************** 
Initial App Jquery runs called at load of each page
sets up initial screen dimensions
Sets utility classes
***********************************************************************/

$(document).foundation({});

function app() {


    //Fixes problem with off canvis getting stuck
    var $window = $(window);
    var $offCanvas = $('#offCanvas');

    $(document).foundation({
        offcanvas: {
            // Sets method in which offcanvas opens.
            open_method: 'move',
            // Should the menu close when a menu link is clicked?
            close_on_click: 'true',
        },
        abide: {
            live_validate: true, // validate the form as you go
            validate_on_blur: false, // validate whenever you focus/blur on an input field
            focus_on_invalid: true, // automatically bring the focus to an invalid input field
            timeout: 10,
        },
        //Contact modal must open in different form than main form because it uses a different abide validation but it would
        //mess up other modals because it would cause them open in different forms. but below works, all modals open in modalForm
        reveal: {
            root_element: '#ModalForm'
        }
    });

    //Makes sure that offCanvas does not get stuck open
    SetMainContentWidth();

    //resize event wait for time before running 
    $(window).resize(function () {
        waitForFinalEvent(function () {
            if ($window.width() > 623) {
                $offCanvas.foundation('offcanvas', 'hide', 'move-right');
                $offCanvas.foundation('offcanvas', 'hide', 'move-left');
                //$offCanvas.removeClass("move-right");
                //$offCanvas.removeClass("move-left");
            }
            SetMainContentWidth();
        }, 200, "mainFormWindowResize");
    });

    //Jump to top of screen when off-canvas is clicked
    $(document).on('open.fndtn.offcanvas', '[data-offcanvas]', function () {
        window.scrollTo(0, 0);
    });

    //reflow class for elements that require a doc reflow when clicked
    $('.reflow').on('click', function () {
        EqualizerReflow();
    });

}

/*********************************************************************** 
Reflow foundations Equalizer: recalculate hight for page
***********************************************************************/
function EqualizerReflow() {
    $(document).foundation('equalizer', 'reflow');
}

//Setting the content div to fill screen - sideBar
//NOTE: Because Foundation does not use column widths for iconBar so it
//leaves open space for content div
function SetMainContentWidth() {
    var $window = $(window);
    var SideBarWidth = 0;
    var contentwidth = 0;
    var newContentWidth = 0;

    SideBarWidth = ($('#SideBar').width()) + 12;
    contentwidth = $('#Content').width();
    newContentWidth = (1 - (SideBarWidth / $($window).width())) * 100;
    $('#Content').css({ 'width': '' + newContentWidth + '%' });
    EqualizerReflow();
}

//Timer event to keep events from firring multiple times
var waitForFinalEvent = (function () {
    var timers = {};
    return function (callback, ms, uniqueId) {
        if (!uniqueId) {
            uniqueId = "Don't call this twice without a uniqueId";
        }
        if (timers[uniqueId]) {
            clearTimeout(timers[uniqueId]);
        }
        timers[uniqueId] = setTimeout(callback, ms);
    };
})();


//function pubRepApp() {
//    //Sets active class for sidebar depending on what page is loaded
//    //NOTE the ID of each sidebar tab must match its Page name + Sidebar or SBsmall
//    SetMainContentWidth();
//}

//CLOSE MODALS
function closeModal(modal) {
    $(modal).foundation('reveal', 'close');
}

//CLOSE ALERTS
function closeAlert(alert) {
    $(alert).parent().hide();
}

//Fill in and show warning modal. Warn Modal is defined in master page
function ShowWarningModal(title, msg, continueFunc, cancelFunc) {
    var warnModal = $('#warningModal');

    $(warnModal).find('#warn_modalTitle').html(title);
    $(warnModal).find('#warn_modalBodyText').html(msg);
    $(warnModal).foundation('reveal', 'open');

    $(warnModal).find('#WrnModalcancButt').off().on('click', function (e) {
        e.preventDefault();
        cancelFunc();
    });
    $(warnModal).find('#WrnModalcontButt').off().on('click', function (e) {
        e.preventDefault();
        continueFunc();
    });
}

//Fill in and show Error modal. Error Modal is defined in master page
function ShowErrorModal(msg) {
    var errorModal = $('#errorModal');
    $(errorModal).find('#err_modalBodyText').html(msg);
    $(errorModal).foundation('reveal', 'open');
}

//Fill in and show success modal. success Modal is defined in master page
function ShowSuccessModal(msg) {
    var successModal = $('#SuccessModal');
    $(successModal).find('#successMsgText').html(msg);
    $(successModal).foundation('reveal', 'open');
}


//Edit/Save/Cancel Button Bar Change event. Used at bottom of forms, such as publisher info and rep info
//Shows or hides Save and Restore button as well as enables or disable textboxs
function EditButBarChange(FormID) {
    var $saveButtContainer = $(FormID).find('#saveButtContainer');
    var $restoreButtContainer = $(FormID).find('#restoreButtContainer');
    var $textBoxs = $(FormID).find("input:text, input:checkbox, select");

    $(FormID).find('#EditBut').on('click', function (e) {
        if ($($saveButtContainer).css('visibility') == 'hidden') {
            $($saveButtContainer).css('visibility', 'visible');
            $($restoreButtContainer).css('visibility', 'visible');
            $($textBoxs).removeAttr("disabled");
            $(this).text("Cancel");
        }
        else {
            $($saveButtContainer).css('visibility', 'hidden');
            $($restoreButtContainer).css('visibility', 'hidden');
            $($textBoxs).attr("disabled", "disabled");
            $(this).text("Edit");
        }
    });
}

function ResetFormFields(form, URL) {
    //Set up event for reset button: ResetFormButton(URL, $textBoxs, $checkBoxes) in PubRepapp.js
    $('#restoreFormDataButt').on('click', function (e) {
        var title = "Reset Form Data"
        var msg = "All fields will be restored with original data."
        var modal = $('#warningModal');

        var continueFunc = function () {
            //var URL = 'PublisherInfo.aspx/ResetTextBox';
            $.ajax({
                type: "POST",
                url: URL,
                data: "{}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    if (data.d.Result == "OK") {
                        // var form = pubForm;
                        //Replace each text box with orginal data
                        $.each(data.d.Record, function (key, value) {
                            form.find('#' + key + 'TB').val(value);
                        });
                        //Close warning modal
                        modal.foundation('reveal', 'close');
                        //show success message: NEED TO CHANGE TO USE SUCCESSMODAL() FUNCTION
                        var resetMsgox = $('#Reset_Success');
                        resetMsgox.show();
                        $(resetMsgox).find("#successMsgText").html('- Data was reset.');
                    }
                    else {//ERROR in code behind
                        //Close reset form modal
                        modal.foundation('reveal', 'close');
                        //show error modal. function in PubRepApps.js
                        ShowErrorModal(data.d.Message);
                    }
                },
                error: function (xhr, status, error) {//Error in calling code behind
                    //Close reset form modal
                    modal.foundation('reveal', 'close');
                    //show error modal. function in PubRepApps.js
                    ShowErrorModal(xhr.statusText);
                }
            });
        }
        //Cancel button function
        var cancelFunc = function () {
            $(modal).foundation('reveal', 'close');
        }

        //show warning modal passing in data, warning for data reset. In PubRepApps.js
        ShowWarningModal(title, msg, continueFunc, cancelFunc)
    });
}

//Function to format string as date, used by Jtable and other forms. 
function FormatDateString(displayFormat, datestr) {
    if (!datestr) {
        return '';
    }
    var dateVal;
    if (datestr.indexOf('Date') >= 0) { //Format: /Date(1320259705710)/
        dateVal = new Date(
            parseInt(datestr.substr(6), 10));
    } else if (datestr.length == 10) { //Format: 2011-01-01
        dateVal = new Date(
            parseInt(datestr.substr(0, 4), 10),
            parseInt(datestr.substr(5, 2), 10) - 1,
            parseInt(datestr.substr(8, 2), 10)
        );
    } else if (datestr.length == 19) { //Format: 2011-01-01 20:32:42
        dateVal = new Date(
            parseInt(datestr.substr(0, 4), 10),
            parseInt(datestr.substr(5, 2), 10) - 1,
            parseInt(datestr.substr(8, 2, 10)),
            parseInt(datestr.substr(11, 2), 10),
            parseInt(datestr.substr(14, 2), 10),
            parseInt(datestr.substr(17, 2), 10)
        );
    } else {
        //this._logWarn('Given date is not properly formatted: ' + datestr);
        return 'format error!';
    }

    return $.datepicker.formatDate(displayFormat, dateVal);

}

//Prints continence of given print area. Uses "jQuery_print.js"
function printContent(printArea) {
    // $('#PrintModal').foundation('reveal', 'open');
    $(printArea).print({
        iframe: false,
    });

}
//CONTACTMODAL EMAIL
function SendContactInfo(CName, CEmail, CTel, CMsg) {
    //get modal for referencing, set URL
    var modal = $('#Contact_Modal');
    var URL = "Dashboard.aspx/ContactMe";

    //format contact information for Ajax call
    var dataValue = "{ContactName: '" + CName + "', ContactEmail: '" + CEmail + "', ContactTel: '" + CTel + "', " +
        "ContactMsg: '" + CMsg + "'}";

    $.ajax({
        type: "POST",
        url: URL,
        data: dataValue,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            if (data.d.Result == "OK") {
                modal.foundation('reveal', 'close');
                $("#Success_modalBodyText").html('- Your information was successfully sent, we will be contacted soon. Thank you.');
                $('#SuccessModal').foundation('reveal', 'open'); //: NEED TO CHANGE TO USE SUCCESSMODAL() FUNCTION
            }
            else {
                modal.foundation('reveal', 'close');
                $('#err_modalBodyText').html('Sorry about the inconveniences, please try to contact us by phone or send us an email' +
                    ' <br /> Error: <br />' + data.d.Message);
                $('#errorModal').foundation('reveal', 'open');
            }
        },
        error: function (xhr, status, error) {
            $('#err_modalBodyText').html('Sorry about the inconveniences, please try to contact us by phone or send us an email');
            $('#errorModal').foundation('reveal', 'open');
        }
    });
}
