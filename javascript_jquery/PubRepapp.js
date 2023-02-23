
function pubRepApp() {
    //Restore Button for dataForms click function
    $('.restoreFormDataBut').bind('click', function () {
        var Urlpath = $(location).attr('pathname');
        var pagePath = Urlpath.split('/');
        var pageName = pagePath[pagePath.length - 1];
        var URL = '' + pageName + '/ResetTextBox';
        FormInfoReset(URL, 'All fields will be restored with original data.');
    });

    //Change event for publisherInfo Email orders check box
    $("#EmailOrdersCB").change(function () {
        if ($('#EmailOrdersCB').is(':checked'))
            $("#OrderCCEmailTB").show(100);
        else
            $("#OrderCCEmailTB").hide(100);
    });
  
    SBActiveTab();
}


//Sets active class for sidebar depending on what page is loaded
//NOTE the ID of each sidebar tab must match its Page name + Sidebar or SBsmall
function SBActiveTab() {
    var Urlpath = "";
    var pagePath = "";
    var pageName = "";

    Urlpath = $(location).attr('pathname');
    pagePath = Urlpath.split('/');
    pageName = pagePath[pagePath.length - 1].split('.')[0];

    $("#" + pageName + "SideBar").addClass("active");
    $("#" + pageName + "SBSmall").css({ 'backgroundColor': '#0078A0' });
}

//Show subNave option at bottom of sideBar
//function show(elem) {
//    $("#bottomSubNav").show("fast");
//    $(elem).show("fast", function showNext() {
//        if (!$(this).next().hasClass("divider")) {
//            $(this).next("li").show("fast", function showNext() {
//            }
//            }
        
//        $(this).next(".divider").show("fast", function showNext() {
//            $(this).next(".divider").show("fast", showNext);
//        })});
   
//    $("#SideBar").mouseleave("fast", function () {
//        $(elem).hide("fast", function showNext() {
//            $(this).next(".divider").hide("fast", showNext);
//        });
//    });
//    EqualizerReflow();
//}

//$(elem).show("fast", function showNext() {
//    $(this).next("li").show("fast", function showNext() {
//        $(this).next("li").show("fast", showNext);
//    })
//});

//$("#SideBar").mouseleave("fast", function () {
//    $(elem).hide("fast", function showNext() {
//        $(this).next("li").hide("fast", showNext);
//    });
//});

//Successfully save complete message 
function SuccessMessage(message) {
    $('<div id="SuccessMessageDialog"></div>').appendTo('body')
    .html('<div><h3 class="subheader">' + message + '</span></h3>')
    .dialog({
        modal: true,
        title: 'Success',
        zIndex: 10000,
        autoOpen: true,
        width: '400px',
        resizable: true,
        buttons: {
            Ok: function () {
                $(this).dialog("close");
            }
        },
        close: function (event, ui) {
            $(this).remove();
        }
    });
}
//Error message 
function ErrorMessage(message) {

    $('<div id="ErrorMessageDialog"></div>').appendTo('body')
    .html('<div><h3 class="subheader">' + message + '</span></h3>')
    .dialog({
        modal: true,
        title: 'Error',
        zIndex: 10000,
        autoOpen: true,
        width: '400px',
        resizable: true,
        buttons: {
            Ok: function () {
                $(this).dialog("close");
            }
        },
        close: function (event, ui) {
            $(this).remove();
        }
    });
}

//Reset all text fields for publisher information
function FormInfoReset(URL, message) {

    $('<div></div>').appendTo('body')
    .html('<div><h3 class="subheader">' + message + '</span></h3>')
    .dialog({
        modal: true,
        title: 'Reset',
        zIndex: 10000,
        autoOpen: true,
        width: '300px',
        resizable: true,
        buttons: {
            Continue: function () {
                var self = this;
                $.ajax({
                    type: "POST",
                    url: URL,
                    data: "{}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        ResetText(data.d);
                        $(self).dialog("close");
                    },
                    failure: function (Message) {
                        alert(Message.d);
                    }
                });
            },
            Cancel: function () {
                $(this).dialog("close");
            }
        },
        close: function (event, ui) {
            $(this).remove();
        }
    });
}
//NOTE the ID of each text-box must match its Property name + TB
function ResetText(data) {
    var OriginalFormData = data.Record
    var textboxes = $('.InfoForm').find("input[type = 'text']");
    var checkBoxes = $('.InfoForm').find("input[type = 'checkbox']");

    if (textboxes.length != 0) {
        textboxes.each(function () {
            var TexboxID = this.id;
            var fieldVal = TexboxID.replace('TB', '');
            $("input[name*='" + TexboxID + "']").val(OriginalFormData['' + fieldVal + '']);
        });
    }
    if (checkBoxes.length != 0) {
        checkBoxes.each(function () {
            var CheckBoxID = this.id;
            var CheckBoxvalue = CheckBoxID.replace('CB', '');
            $("input[name*='" + CheckBoxID + "']").prop('checked', true);

            $("input[name*='" + CheckBoxID + "']").trigger("change");
        });
    }
}


//_________________________________________________________________________________________
//START JTABLE FUNCTION
//_________________________________________________________________________________________
//PUBLISHERINFO.ASPX: JTABLE
function PublisherInfojtable() {
    //Prepare jtable plugin
    $('#PublisherTableContainer').jtable({
        title: 'The Publisher LIST',
        paging: true, //Enables paging
        pageSize: 10, //Actually this is not needed since default value is 10.
        sorting: true, //Enables sorting
        defaultSorting: 'Publisher ASC', //Optional. Default sorting on first load.
        filteringBar: true,
        filterElement: $('#FilterContainer'),
        defaultDateFormat: 'm/dd/yy',
        actions: {
            listAction: 'PublisherInfo.aspx/listAction_PubInfo',
            filterAction: 'PublisherInfo.aspx/filterAction_PubInfo',
            filterReload: 'PublisherInfo.aspx/filterReload_PubInfo'
        },
        toolbar: {
            hoverAnimation: true, //Enable/disable small animation on mouse hover to a toolbar item.
            hoverAnimationDuration: 60, //Duration of the hover animation.
            hoverAnimationEasing: undefined, //Easing of the hover animation. Uses jQuery's default animation ('swing') if set to undefined.            
        },
        fields: {
            Publisher: {
                key: true,
                title: 'Publisher',
                create: false,
                list: false,
            },
            //CHILD TABLE DEFINITION FOR "OrderLines"
            pubLines: {
                title: '',
                width: '3%',
                sorting: false,
                display: function (PubData) {
                    //Create an image that will be used to open child table
                    var $img = $('<i class="fa fa-list-ul"></i>');
                    //change cursor to pointer when hover over child icon
                    $($img).css({ 'cursor': 'pointer' });
                    //Open child table when user clicks the image
                    $img.click(function () {
                        $('#PublisherTableContainer').jtable('openChildTable',
                                $img.closest('tr'), //Parent row
                                {
                                    title: PubData.record.Publisher + ' - Publisher Information',
                                    edit: false,
                                    create: false,
                                    actions: {
                                        listAction: 'PublisherInfo.aspx/ChildListAction_PI?key=' + PubData.record.Publisher,
                                    },
                                    fields: {
                                        Publisher: {
                                            defaultValue: PubData.record.Publisher,
                                            key: true,
                                            create: false,
                                            edit: false,
                                            list: true,
                                            title: 'Publisher'
                                        },
                                        Name: {
                                            title: 'Publisher Name',
                                            width: '10%'
                                        },
                                        ContactName: {
                                            title: 'Contact Name',
                                            width: '10%'
                                        },
                                        Address1: {
                                            title: 'Address',
                                            width: '10%'
                                        },
                                        Phone1: {
                                            title: 'Phone1',
                                            width: '10%'
                                        },
                                        Fax: {
                                            title: 'Fax',
                                            width: '10%'
                                        },
                                        OrderCCEmail: {
                                            title: 'Orders Email',
                                            width: '15%',
                                        },
                                        Email1: {
                                            title: 'Contact Email',
                                            width: '15%',
                                        },
                                        LastUpdateDateTime: {
                                            title: 'Last Updated',
                                            width: '20%',
                                            type: 'date'
                                        }
                                    }
                                }, function (data) { //opened handler
                                    data.childTable.jtable('load');
                                });
                    });
                    //Return image to show on the Order row
                    return $img;
                }
            },
            Name: {
                title: 'Publisher Name',
                width: '10%',
            },
            ContactName: {
                title: 'Contact Name',
                width: '10%',
            },
            Phone1: {
                title: 'Phone',
                width: '10%'
            },
            Fax: {
                title: 'Fax',
                width: '10%'
            },
            Email1: {
                title: 'Email',
                width: '10%'
            }
        },
    });

    //Load publisher list from server
    $('#PublisherTableContainer').jtable('load');
}


//_________________________________________________________________________________________
//RepInfo.ASPX: JTABLE
//_________________________________________________________________________________________
function RepInfojtable() {
    //Prepare jtable plugin
    $('#RepInfoTableContainer').jtable({
        title: 'The Rep LIST',
        paging: true, //Enables paging
        pageSize: 10, //Actually this is not needed since default value is 10.
        sorting: true, //Enables sorting
        defaultSorting: 'LastName ASC', //Optional. Default sorting on first load.
        filteringBar: true,
        filterElement: $('#FilterContainer'),
        defaultDateFormat: 'm/dd/yy',
        actions: {
            listAction: 'RepInfo.aspx/listAction_RepInfo',
            filterAction: 'RepInfo.aspx/filterAction_RepInfo',
            filterReload: 'RepInfo.aspx/filterReload_RepInfo'
        },
        toolbar: {
            hoverAnimation: true, //Enable/disable small animation on mouse hover to a toolbar item.
            hoverAnimationDuration: 60, //Duration of the hover animation.
            hoverAnimationEasing: undefined, //Easing of the hover animation. Uses jQuery's default animation ('swing') if set to undefined.            
        },
        fields: {
            RepID: {
                key: true,
                title: 'RepID',
                create: false,
                list: false,
            },
            //CHILD TABLE DEFINITION FOR "OrderLines"
            pubLines: {
                title: '',
                width: '3%',
                sorting: false,
                display: function (RepData) {
                    //Create an image that will be used to open child table
                    var $img = $('<i class="fa fa-list-ul"></i>');
                    //change cursor to pointer when hover over child icon
                    $($img).css({ 'cursor': 'pointer' });
                    //Open child table when user clicks the image
                    $img.click(function () {
                        $('#RepInfoTableContainer').jtable('openChildTable',
                                $img.closest('tr'), //Parent row
                                {
                                    title: RepData.record.RepID + ' - Rep Information',
                                    edit: false,
                                    create: false,
                                    actions: {
                                        listAction: 'RepInfo.aspx/ChildListAction_RI?key=' + RepData.record.RepID,
                                    },
                                    fields: {
                                        RepID: {
                                            defaultValue: RepData.record.RepID,
                                            key: true,
                                            create: false,
                                            edit: false,
                                            list: false,
                                            title: 'RepID'
                                        },
                                        LastName: {
                                            title: 'Last Name',
                                            width: '10%'
                                        },
                                        FirstName: {
                                            title: 'First Name',
                                            width: '10%'
                                        },
                                        Address1: {
                                            title: 'Address',
                                            width: '10%'
                                        },
                                        Phone1: {
                                            title: 'Phone1',
                                            width: '10%'
                                        },
                                        Phone2: {
                                            title: 'Phone',
                                            width: '10%'
                                        },
                                        Fax: {
                                            title: 'Fax',
                                            width: '10%'
                                        },
                                        Email1: {
                                            title: 'Email',
                                            width: '15%',
                                        },
                                        LastUpdateDateTime: {
                                            title: 'Last Updated',
                                            width: '20%',
                                            type: 'date'
                                        }
                                    }
                                }, function (data) { //opened handler
                                    data.childTable.jtable('load');
                                });
                    });
                    //Return image to show on the Order row
                    return $img;
                }
            },
            LastName: {
                title: 'Last Name',
                width: '10%',
            },
            FirstName: {
                title: 'First Name',
                width: '10%',
            },
            Phone1: {
                title: 'Phone',
                width: '10%'
            },
            Fax: {
                title: 'Fax',
                width: '10%'
            },
            Email1: {
                title: 'Email',
                width: '10%'
            }
        },
    });

    //Load publisher list from server
    $('#RepInfoTableContainer').jtable('load');
}


//_________________________________________________________________________________________
//Customer.ASPX: JTABLE
//_________________________________________________________________________________________
function CustomerInfojtable() {
    //Prepare jtable plugin
    $('#CustomerTableContainer').jtable({
        title: 'Customers For Reps',
        paging: true, //Enables paging
        pageSize: 10, //Actually this is not needed since default value is 10.
        sorting: true, //Enables sorting
        defaultSorting: 'LastName ASC', //Optional. Default sorting on first load.
        filteringBar: true,
        filterElement: $('#FilterContainer'),
        defaultDateFormat: 'mm/dd/yy',
        actions: {
            listAction: 'Customers.aspx/listAction_CustInfo',
            filterAction: 'Customers.aspx/filterAction_CustInfo',
            filterReload: 'Customers.aspx/filterReload_CustInfo'
        },
        toolbar: {
            hoverAnimation: true, //Enable/disable small animation on mouse hover to a toolbar item.
            hoverAnimationDuration: 60, //Duration of the hover animation.
            hoverAnimationEasing: undefined, //Easing of the hover animation. Uses jQuery's default animation ('swing') if set to undefined.                       
        },
        fields: {
            TerritoryID: {
                key: true,
                title: '',
                create: false,
                visibility: 'hidden',
            },
            //CHILD TABLE DEFINITION
            CustLines: {
                title: '',
                width: '1%',
                sorting: false,
                display: function (CustomerData) {
                    //Create an image that will be used to open child table
                    var $img = $('<i class="fa fa-list-ul "></i>');
                    //change cursor to pointer when hover over child icon
                    $($img).css({ 'cursor': 'pointer' });
                    //Open child table when user clicks the image
                    $img.click(function () {
                        $('#CustomerTableContainer').jtable('openChildTable',
                                $img.closest('tr'), //Parent row
                                {
                                    title: 'Customers For: ' + CustomerData.record.Name,
                                    sorting: true,
                                    defaultSorting: 'ClientID ASC', //Optional. Default sorting on first load.
                                    paging: true,
                                    pageSize: 10,
                                    defaultDateFormat: 'mm/dd/yy',
                                    actions: {
                                        listAction: 'Customers.aspx/ChildListAction_CustInfo?key=' + CustomerData.record.TerritoryID + '&includeDelets=' + false + '&reloadFlag=' + false + '',
                                        updateAction: 'Customers.aspx/ChildUpdateAction_CustInfo',
                                    },
                                    toolbar: {
                                        hoverAnimation: true, //Enable/disable small animation on mouse hover to a toolbar item.
                                        hoverAnimationDuration: 60, //Duration of the hover animation.
                                        hoverAnimationEasing: undefined, //Easing of the hover animation. Uses jQuery's default animation ('swing') if set to undefined.            
                                        items: [{
                                            icon: false,
                                            text: 'Include Deletes',
                                            cssClass: 'IncDelets fa fa-square-o',
                                            click: function () {
                                                //Toggle Icon showing check-mark or x
                                                $('span.IncDelets').toggleClass('fa-check-square-o fa-square-o');
                                                //check what if check-mark or x is chosen, the url sent to code behind depends on what icon is displayed
                                                if ($('span.IncDelets').hasClass('fa-check-square-o')) {
                                                    //Reload Child Table with Deleted customers
                                                    var temp = $img.parent().parent().next().find('.jtable-child-table-container');
                                                    var leJtable = $(temp).data('hik-jtable');
                                                    //if check-mark icon displyed then deletes are to be shown and must reload customers
                                                    leJtable.options.actions.listAction = 'Customers.aspx/ChildListAction_CustInfo?key=' + CustomerData.record.TerritoryID + '&includeDelets=' + true + '&reloadFlag=' + true + '';
                                                    temp.jtable('reload');
                                                }
                                                else {
                                                    //Reload Child Table with Deleted customers
                                                    var temp = $img.parent().parent().next().find('.jtable-child-table-container');
                                                    var leJtable = $(temp).data('hik-jtable');
                                                    //If x icon displayed then deletes are NOT to be shown and must reload customers
                                                    leJtable.options.actions.listAction = 'Customers.aspx/ChildListAction_CustInfo?key=' + CustomerData.record.TerritoryID + '&includeDelets=' + false + '&reloadFlag=' + true + '';
                                                    temp.jtable('reload');
                                                }
                                                //Reset the URL for jtable back to original, this is so when sorting is done program does not reload all customers
                                                leJtable.options.actions.listAction = 'Customers.aspx/ChildListAction_CustInfo?key=' + CustomerData.record.TerritoryID + '&includeDelets=' + false + '&reloadFlag=' + false + '';
                                            }
                                        },
                                          {
                                              icon: true,
                                              text: 'View Credit App',
                                              cssClass: '',
                                              click: function () {
                                                  //perform your custom job...
                                              }
                                          }
                                        ]
                                    },
                                    fields: {
                                        ClientID: {
                                            key: true,
                                            create: false,
                                            edit: true,
                                            visibility: 'hidden',
                                            title: 'Client ID',
                                            EditFormRowIndex: '1',
                                            EditFormColumnIndex: '1',
                                            columnSize: '4'
                                        },
                                        Client: {
                                            title: 'Client Name',
                                            width: '15%',
                                            EditFormRowIndex: '1',
                                            EditFormColumnIndex: '2',
                                            columnSize: '4'
                                        },
                                        TerritoryID: {
                                            visibility: 'hidden',
                                            edit: true,
                                            title: 'Territory',
                                            EditFormRowIndex: '2',
                                            EditFormColumnIndex: '1',
                                            columnSize: '4'
                                        },
                                        RepName: {
                                            visibility: 'hidden',
                                            edit: true,
                                            title: 'Rep',
                                            EditFormRowIndex: '2',
                                            EditFormColumnIndex: '2',
                                            columnSize: '4'
                                        },
                                        Type: {
                                            title: 'Cust. Type',
                                            width: '8%',
                                            options: 'Customers.aspx/GetCustTypeDDwn',
                                            EditFormRowIndex: '2',
                                            EditFormColumnIndex: '3',
                                            columnSize: '4'
                                        },
                                        Buyer: {
                                            title: 'Buyer',
                                            width: '13%',
                                            EditFormRowIndex: '3',
                                            EditFormColumnIndex: '1',
                                            columnSize: '4'
                                        },
                                        Buyer2: {
                                            visibility: 'hidden',
                                            edit: true,
                                            title: 'Buyer2',
                                            EditFormRowIndex: '3',
                                            EditFormColumnIndex: '2',
                                            columnSize: '4'
                                        },
                                        Address: {
                                            visibility: 'hidden',
                                            edit: true,
                                            title: 'Address',
                                            EditFormRowIndex: '4',
                                            EditFormColumnIndex: '1',
                                            columnSize: '4'
                                        },
                                        Address2: {
                                            visibility: 'hidden',
                                            edit: true,
                                            title: 'Address2',
                                            EditFormRowIndex: '4',
                                            EditFormColumnIndex: '2',
                                            columnSize: '4'
                                        },
                                        City: {
                                            title: 'City',
                                            width: '10%',
                                            EditFormRowIndex: '5',
                                            EditFormColumnIndex: '1',
                                            columnSize: '4'
                                        },
                                        State: {
                                            title: 'State',
                                            width: '7%',
                                            EditFormRowIndex: '5',
                                            EditFormColumnIndex: '2',
                                            columnSize: '1'
                                        },
                                        Zip: {
                                            visibility: 'hidden',
                                            edit: true,
                                            title: 'Zip',
                                            EditFormRowIndex: '5',
                                            EditFormColumnIndex: '3',
                                            columnSize: '2'
                                        },
                                        Phone: {
                                            title: 'Phone',
                                            width: '10%',
                                            EditFormRowIndex: '6',
                                            EditFormColumnIndex: '1',
                                            columnSize: '4'
                                        },
                                        Fax: {
                                            visibility: 'hidden',
                                            edit: true,
                                            title: 'Fax',
                                            EditFormRowIndex: '6',
                                            EditFormColumnIndex: '2',
                                            columnSize: '4'
                                        },
                                        Email: {
                                            visibility: 'hidden',
                                            edit: true,
                                            title: 'Email',
                                            EditFormRowIndex: '7',
                                            EditFormColumnIndex: '1',
                                            columnSize: '4'
                                        },
                                        Email2: {
                                            visibility: 'hidden',
                                            edit: true,
                                            title: 'Email2',
                                            EditFormRowIndex: '7',
                                            EditFormColumnIndex: '2',
                                            columnSize: '4'
                                        },
                                        Status: {
                                            title: 'Status',
                                            width: '6%',
                                            type: 'checkbox',
                                            values: { 'D': 'Deleted', 'A': 'Active' },
                                            defaultValue: 'A',
                                            EditFormRowIndex: '8',
                                            EditFormColumnIndex: '1',
                                            columnSize: '1',
                                        },
                                        CreditAppID: {
                                            visibility: 'hidden',
                                            edit: true,
                                            title: 'CreditAppID',
                                            EditFormRowIndex: '8',
                                            EditFormColumnIndex: '2',
                                            columnSize:'1',
                                            input: function (data) {
                                                return '<input type="text" name="Name" value="' + data.record.CreditAppID + '" disabled/>';
                                            }
                                        },
                                        AddDate: {
                                            title: 'Add Date',
                                            width: '10%',
                                            type: 'date',
                                            EditFormRowIndex: '9',
                                            EditFormColumnIndex: '1',
                                            columnSize:'2',
                                            input: function (data) {
                                                var dateForm = data.record.AddDate;
                                                var datedString;
                                                
                                                if (dateForm.indexOf('Date') >= 0) { //Format: /Date(1320259705710)/
                                                    datedString = (parseInt(dateForm.substr(6), 10));
                                                }

                                                var date = new Date(datedString),
                                                    yr = date.getFullYear(),
                                                        month = +date.getMonth() < 10 ? '0' + date.getMonth() : date.getMonth(),
                                                        day = +date.getDate() < 10 ? '0' + date.getDate() : date.getDate(),
                                                        newDate = month + '/' + day + '/' + yr;

                                                return '<h3>' + newDate + '</h3>';
                                                //return '<span class= "label" name="adddate" style="width:auto">' + newDate + '</span>';
                                            }
                                        },
                                        LastUpdateDate: {
                                            title: 'Last Updated',
                                            width: '10%',
                                            type: 'date',
                                            EditFormRowIndex: '9',
                                            EditFormColumnIndex: '2',
                                            columnSize:'2',
                                            input: function (data) {
                                                var dateForm = data.record.AddDate;
                                                var datedString;
                                                if (dateForm.indexOf('Date') >= 0) { //Format: /Date(1320259705710)/
                                                    datedString = (parseInt(dateForm.substr(6), 10));
                                                }
                                                var date = new Date(datedString),
                                                    yr = date.getFullYear(),
                                                        month = +date.getMonth() < 10 ? '0' + date.getMonth() : date.getMonth(),
                                                        day = +date.getDate() < 10 ? '0' + date.getDate() : date.getDate(),
                                                        newDate = month + '/' + day + '/' + yr;

                                                return '<h3>' + newDate + '</h3>';
                                            }
                                        },
                                        LastUpdatedBy: {
                                            title: 'Last Updated By',
                                            width: '12%',
                                            EditFormRowIndex: '9',
                                            EditFormColumnIndex: '3',
                                            columnSize: '3',
                                            input: function (data) {
                                                return '<h3>' + data.record.LastUpdatedBy + '</h3>';
                                            }
                                        },
                                        About: {
                                            title: 'Notes',
                                            type: 'textarea',
                                            visibility: 'hidden',
                                            EditFormRowIndex: '10',
                                            EditFormColumnIndex: '1',
                                            columnSize:'6'
                                        },
                                    },
                                    formCreated: function (event, data) {
                                      
                                    },
                                    formClosed: function (event, data) {
                                     
                                    },
                                },
                                function (data) { //opened handler
                                    data.childTable.jtable('load');
                                });
                    });
                    //Return image to show on the child row
                    return $img;
                }
            },
            FirstName: {
                title: 'First Name',
                width: '5%'
            },
            LastName: {
                title: 'Last Name',
                width: '5%'
            },
            Name: {
                title: 'Territorys',
                width: '10%'
            }
        }
    });
    //Load publisher list from server
    $('#CustomerTableContainer').jtable('load');
}
//_________________________________________________________________________________________
//END JTABLE FUNCTION
//_________________________________________________________________________________________



//Cool dialog
//$("#dialog-message").dialog({
//    modal: true,
//    draggable: true,
//    resizable: true,
//    position: ['center', 'top'],
//    show: 'blind',
//    hide: 'blind',
//    autoOpen: true,
//    width: 400,
//    dialogClass: 'ui-dialog-osx',
//    buttons: {
//        "I've read and understand this": function () {
//            $(this).dialog("close");
//        }
//    }
//});
//}

//String to Date JavaScript
//if (dateString.indexOf('Date') >= 0) { //Format: /Date(1320259705710)/
//    date = (
//        parseInt(dateString.substr(6), 10)
//    );
//} else if (dateString.length == 10) { //Format: 2011-01-01
//    date = (
//        parseInt(dateString.substr(0, 4), 10),
//        parseInt(dateString.substr(5, 2), 10) - 1,
//        parseInt(dateString.substr(8, 2), 10)
//    );
//} else if (dateString.length == 19) { //Format: 2011-01-01 20:32:42
//    date = (
//        parseInt(dateString.substr(0, 4), 10),
//        parseInt(dateString.substr(5, 2), 10) - 1,
//        parseInt(dateString.substr(8, 2, 10)),
//        parseInt(dateString.substr(11, 2), 10),
//        parseInt(dateString.substr(14, 2), 10),
//        parseInt(dateString.substr(17, 2), 10)
//    );
//Control dialog
//// Getter
//var position = $(".selector").dialog("option", "position");

//// Setter
//$(".selector").dialog("option", "position", { my: "left top", at: "left bottom", of: button });
//data.form.parent().dialog("option", "height", "auto");
//data.form.parent().dialog("option", "resizable", false);