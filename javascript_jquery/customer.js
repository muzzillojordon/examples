
function CustomerScript() {

    //REP LOG-IN; SHOW JTABLE FOR LOGGED IN REP AND DROPDOWN OF REPS
    if ($('#CustomersBottomSideBar').is(':visible')) {
        //Off canvas tabs
        var CustLefOffCanTabs = $('#Cust_LefOffCan_Tabs');
        var CustOffCanTabsLi = CustLefOffCanTabs.find("li");
        //left Bottom bar tabs
        var CustBottomSideBar = $('#CustomersBottomSideBar');
        var CustBottomSideBarLi = CustBottomSideBar.find("li");
        //Top tab/title
        var TopTabs = $('#Tabswitch');
        var TopTabsli = TopTabs.find("li");
        var top_page_tabTitle = $('#top_page_tabTitle').find('h1');

        var custDrpDwn = $('#panel1').find('#CustSelcDrpDwn');
        var startDate = $('#panel2').find('#CCHStartDate');
        var endDate = $('#panel2').find('#CCHEndDate');

        startDate.val('');
        endDate.val('');

        //Tab change event
        $(document).foundation({
            tab: {
                callback: function (tab) {
                    if (tab !== undefined) {
                        var TabIndex = $(tab).index();

                        //Change Active tab labels
                        $(CustOffCanTabsLi).removeClass("active2").eq(TabIndex).addClass('active2');
                        $(CustBottomSideBarLi).removeClass("active2").eq(TabIndex).addClass('active2');
                        $(TopTabsli).removeClass("active").eq(TabIndex).addClass('active');
                        //Top Page Title
                        $(top_page_tabTitle).hide().eq(TabIndex - 1).show();

                        //CUSTOMER JTABLE TAB
                        if (TabIndex == 1) {
                            //If no jtable created yet
                            if (!$('#CustomerTableContainer').hasClass('jtable-main-container')) {
                                newCustJtableList(custDrpDwn)
                            }
                        }
                        else if (TabIndex == 2) {//CUSTOMER CHANGES TAB
                            if (startDate.val().length == 0) {
                                CustomerChanges(startDate, endDate);
                            }
                        }
                        else if (TabIndex == 3) {//CUSTOMER CHANGES TAB
                            //if (!$('#CustomerTableContainer').hasClass('jtable-main-container')) {
                            //    newCustUserFieldsJtable()
                            //}
                        }

                        EqualizerReflow();
                    }
                }
            }
        });

    }
    //else if publisher

    //Customer changes Go button event
    $('#CChGoButt').off('click').on('click', function () {
        var startDateVal = startDate.val();
        var endDateVal = endDate.val();

        NewCustChangesJtable(startDateVal, endDateVal)
    });
}

//Deletes any current instance of rep customers Jtable and calls function to create new one
function newCustJtableList(custDrpDwn) {
    var selecText = custDrpDwn.find('option:selected').text();
    var selcVal = custDrpDwn.val();
    //Create new Customer Jtable For Rep
    CustJtable(selecText, selcVal);
}

//Deletes any current instance of customer changes Jtable and calls function to create new one
function NewCustChangesJtable(startDate, endDate) {
    if ($('#CustChangesJtable').children().length !== 0) {
        $('#CustChangesJtable').jtable('destroy');
    }
    //Create new Customer changes Jtable
    CustChangesJtable(startDate, endDate)
}

function newCustUserFieldsJtable() {

}


function CustomerChanges(startDate, endDate) {
    //Set initial date to today
    var nowTemp = new Date();
    var month = nowTemp.getMonth() + 1; var day = nowTemp.getDate(); var year = nowTemp.getFullYear();
    var now = TodayDate = (month < 10 ? '0' : '') + month + '/' +
                          (day < 10 ? '0' : '') + day + '/' +
                           year;
    startDate.val(now);
    endDate.val(now);
    //Initialize date pickers
    var checkin = startDate.fdatepicker({
    }).off('changeDate').on('changeDate', function (ev) {
        if (ev.date.valueOf() > checkout.date.valueOf()) {
            var newDate = new Date(ev.date)
            newDate.setDate(newDate.getDate() + 1);
            checkout.update(newDate);
        }
        checkin.hide();
        endDate[0].focus();
    }).data('datepicker');
    var checkout = endDate.fdatepicker({
        onRender: function (date) {
            return date.valueOf() < checkin.date.valueOf() ? 'disabled' : '';
        }
    }).off('changeDate').on('changeDate', function (ev) {
        checkout.hide();
    }).data('datepicker');
}


//DROPDOWN SELECTION FOR Customer LISTING JTABLE: 
function CustChange_drpDwn(sel) {
    if ($('#CustomerTableContainer').children().length !== 0) {
        $('#CustomerTableContainer').jtable('destroy');
    }

    if (sel.selectedIndex !== 0) {
        newCustJtableList($(sel));
    }
}


//********************CUSTOMER JTABLE**************************
function CustJtable(selecText, SelectedTerritory) {
    //Prepare jtable plugin
    $('#CustomerTableContainer').jtable({
        title: 'Customers For: ' + selecText,
        paging: true, //Enables paging
        pageSize: 10, //Actually this is not needed since default value is 10.
        sorting: true, //Enables sorting
        defaultSorting: 'Client, ASC', //Optional. Default sorting on first load.
        multiSorting: true,
        filteringBar: true,
        showEditButton: false,
        filterElement: $('#FilterContainer'),
        defaultDateFormat: 'mm/dd/yy',
        actions: {
            listAction: 'Customers.aspx/listAction_CustInfo?SelectedTerritory=' + SelectedTerritory + '&includeDeletes=' + false + '',
            updateAction: 'Customers.aspx/UpdateAction_CustInfo',
            filterAction: 'Customers.aspx/filterAction_CustInfo',
            filterReload: 'Customers.aspx/filterReload_CustInfo',
            filterTypeAhead: 'Customers.aspx/JTRemoteTypeAhead_CustInfo'
        },
        toolbar: {
            items: [{
                icon: false, //Using own image from Font Awesome
                text: 'Include Deletes',
                cssClass: 'IncDelets secondary',
                click: function () {
                    var leJtable = $('#CustomerTableContainer').data('hik-jtable');
                    //Default value for including deleted records is False  
                    var includeDeletes = false
                    //Tool-bar include deleted records button color:secondary(gray)=no deleted records, Active(green)=deleted records
                    var IncDeletsButt = $('#CustomerTableContainer').find('.IncDelets');
                    //$('#jT_toolBar_bgrp').find('.IncDelets');
                    if (IncDeletsButt.hasClass('secondary')) {
                        $(IncDeletsButt).removeClass('secondary').addClass('success');
                        includeDeletes = true;
                    } else {
                        $(IncDeletsButt).removeClass('success').addClass('secondary');
                    }

                    //Set the URL in jtable options to reflect user choice to include deleted records or not.
                    leJtable.options.actions.listAction = 'Customers.aspx/listAction_CustInfo?SelectedTerritory=' + SelectedTerritory + '&includeDeletes=' + includeDeletes + '';
                    //reload jtable, makes Ajax call to code behind
                    $('#CustomerTableContainer').jtable('reload');
                }
            }]
        },
        fields: {
            Client: {
                title: 'Client Name',
                width: '15%',
                visibility: 'fixed',
                FormRowIndex: '1',
                FormColumnIndex: '2',
                columnSize: '6',
                display: function (custData) { //Display Customer Detail Modal
                    var $cellData = custData['record']['Client'];
                    var $cell = $('<a href="#ClientData">' + $cellData + '<a>');

                    $cell.click(function () {
                        $('#CustomerTableContainer').jtable('showEditForm', custData.record);
                    });
                    return $cell;
                }
            },
            ClientID: {
                key: true,
                title: 'ClientID',
                create: true,
                disabled: true,
                edit: true,
                visibility: 'hidden',
                title: 'Client ID',
                FormRowIndex: '1',
                FormColumnIndex: '1',
                columnSize: '3'
            },
            Type: {
                title: 'Cust. Type',
                width: '8%',
                options: 'Customers.aspx/GetCustTypeDDwn',
                FormRowIndex: '1',
                FormColumnIndex: '3',
                columnSize: '3'
            },
            RepName: {
                visibility: 'hidden',
                edit: true,
                title: 'Rep',
                FormRowIndex: '2',
                FormColumnIndex: '1',
                columnSize: '3',
                input: function (data) {
                    return '<h5 style="margin-top: 0;">' + data.record.RepName + '</h5>';
                }
            },
            TerritoryID: {
                visibility: 'hidden',
                edit: true,
                title: 'Territory',
                FormRowIndex: '2',
                FormColumnIndex: '2',
                columnSize: '6',
                options: 'Customers.aspx/GetTerritoryDDwn'
            },
            TerritoryStates: {
                title: 'Current',
                create: false,
                edit: true,
                //list: false,
                visibility: 'hidden',
                FormRowIndex: '2',
                FormColumnIndex: '3',
                columnSize: '3',
                input: function (data) {
                    return '<span style="margin-top: 0;">' + data.record.TerritoryID + ': ' + data.record.TerritoryStates + '</span>';
                }
            },
            Buyer: {
                title: 'Buyer',
                width: '13%',
                FormRowIndex: '3',
                FormColumnIndex: '1',
                columnSize: '4'
            },
            Buyer2: {
                visibility: 'hidden',
                edit: true,
                title: 'Buyer2',
                FormRowIndex: '3',
                FormColumnIndex: '2',
                columnSize: '4'
            },
            Address: {
                visibility: 'hidden',
                edit: true,
                title: 'Address',
                FormRowIndex: '4',
                FormColumnIndex: '1',
                columnSize: '4',
                FildSetStart: true,
                FildSetName: "Address"
            },
            Address2: {
                visibility: 'hidden',
                edit: true,
                title: 'Address2',
                FormRowIndex: '4',
                FormColumnIndex: '2',
                columnSize: '4'
            },
            City: {
                title: 'City',
                width: '10%',
                FormRowIndex: '5',
                FormColumnIndex: '1',
                columnSize: '4'
            },
            State: {
                title: 'State',
                width: '7%',
                FormRowIndex: '5',
                FormColumnIndex: '2',
                columnSize: '1'
            },
            Zip: {
                visibility: 'hidden',
                edit: true,
                title: 'Zip',
                FormRowIndex: '5',
                FormColumnIndex: '3',
                columnSize: '2',
                FieldSetEnd: true
            },
            Phone: {
                title: 'Phone',
                width: '10%',
                FormRowIndex: '6',
                FormColumnIndex: '1',
                columnSize: '4',
                FildSetStart: true,
                FildSetName: "Contact Information"
            },
            Fax: {
                visibility: 'hidden',
                edit: true,
                title: 'Fax',
                FormRowIndex: '6',
                FormColumnIndex: '2',
                columnSize: '4'
            },
            Email: {
                visibility: 'hidden',
                edit: true,
                title: 'Email',
                type: 'email',
                FormRowIndex: '7',
                FormColumnIndex: '1',
                columnSize: '4'
            },
            Email2: {
                visibility: 'hidden',
                edit: true,
                title: 'Email2',
                type: 'email',
                FormRowIndex: '7',
                FormColumnIndex: '2',
                columnSize: '4',
                FieldSetEnd: true
            },
            Status: {
                title: 'Status',
                width: '6%',
                type: 'checkbox',
                values: { 'D': 'NOT Active', 'A': 'Active' },
                defaultValue: 'A',
                FormRowIndex: '8',
                FormColumnIndex: '1',
                columnSize: '2',
            },
            CreditAppID: {
                visibility: 'hidden',
                edit: true,
                title: 'CreditAppID',
                FormRowIndex: '8',
                FormColumnIndex: '2',
                columnSize: '2',
                input: function (data) {
                    return '<input type="text" name="Name" value="' + data.record.CreditAppID + '" disabled/>';
                }
            },
            AddDate: {
                title: 'Add Date',
                width: '10%',
                type: 'date',
                FormRowIndex: '8',
                FormColumnIndex: '3',
                columnSize: '2',
                input: function (data) {
                    var fieldVal = data.record.AddDate;
                    var dateForm = "";

                    if (fieldVal === undefined || fieldVal === null || fieldVal.legth != 0) {
                        dateForm = FormatDateString('mm/dd/yy', fieldVal);
                        return '<h5 style="margin-top: 0;">' + dateForm + '</h5>';
                    }
                    return '<h5 style="margin-top: 0;"></h5>';
                }
            },
            LastUpdateDate: {
                title: 'Last Updated',
                width: '10%',
                type: 'date',
                visibility: 'hidden',
                FormRowIndex: '8',
                FormColumnIndex: '4',
                columnSize: '2',
                input: function (data) {
                    var fieldVal = data.record.LastUpdateDate;
                    var dateForm = "";

                    if (fieldVal === undefined || fieldVal === null || fieldVal.legth != 0) {
                        dateForm = FormatDateString('mm/dd/yy', fieldVal);
                        return '<h5 style="margin-top: 0;">' + dateForm + '</h5>';
                    }
                    return '<h5 style="margin-top: 0;"></h5>';
                }
            },
            LastUpdatedBy: {
                title: 'Last Updated By',
                width: '12%',
                visibility: 'hidden',
                FormRowIndex: '8',
                FormColumnIndex: '5',
                columnSize: '3',
                input: function (data) {
                    return '<h5 style="margin-top: 0;">' + data.record.LastUpdatedBy + '</h5>';
                }
            },
            PermNote: {
                title: 'Notes',
                type: 'textarea',
                visibility: 'hidden',
                FormRowIndex: '9',
                FormColumnIndex: '1',
                columnSize: '12'
            },
            CreditCardApp: {
                title: 'Credit App',
                width: '5%',
                sorting: false,
                edit: false,
                create: false,
                display: function (CustomerDataCredit) {
                    var $img;
                    ////Create an image that will be used to open Credit application   
                    $img = $('<div title="Edit Credit App" class="button jtable-command-button expand jtable-edit-command-button" />');
                    //'style="margin-bottom: 0; padding: .05rem; cursor: pointer;" />');
                    //Check if customer has existing credit app
                    if (CustomerDataCredit.record.CreditAppID == "0") {
                        //Add create credit app button
                        $img.append('<i class="fi-plus jtable-command-button"></i>');
                        //Change tool tip to create credit application. Default is set to Edit Credit app
                        $($img).attr("title", "Create Credit Application");
                    }
                    else {
                        //Add edit credit app button
                        $img.append('<i class="fi-credit-card jtable-command-button"></i>');
                    }
                    //Open child table when user clicks the Parent row img.
                    $img.click(function (e) {//OpenChildTable(parent row, TableOptions, Opened callBack)
                        $('#CustomerTableContainer').jtable('openChildTable',
                             $img.closest('tr'), //Jtable Parent row
                            {
                                title: 'Credit App For: ' + CustomerDataCredit.record.Client,
                                //showCloseButton: false,
                                //we are open child as modal but because there is only one credit app per parent row we
                                //want to open straight to edit. so do not show child row
                                ShowChildRow: false,
                                actions: {
                                    listAction: 'Customers.aspx/ChildListingAction_CrdApp?key=' + CustomerDataCredit.record.CreditAppID + '',
                                    updateAction: 'Customers.aspx/ChildUpdateAction_CrdApp?ChildKey=' + CustomerDataCredit.record.CreditAppID + '',
                                    createAction: 'Customers.aspx/ChildCreateAction_CrdApp?ParentKey=' + CustomerDataCredit.record.ClientID + '',
                                },
                                messages: {
                                    editRecord: 'Edit Credit Card App',
                                    addNewRecord: 'Add Credit Card App',
                                },
                                fields: {
                                    id: {
                                        key: true,
                                        create: true,
                                        edit: false,
                                        list: false,
                                        title: 'credit App ID',
                                        FormRowIndex: '1',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        defaultValue: CustomerDataCredit.record.CreditAppID,
                                    },
                                    YearEstablished: {
                                        title: 'Year Established',
                                        width: '10%',
                                        FormRowIndex: '1',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                    },
                                    YearsAtCurrentLocation: {
                                        title: 'Years At Current Location',
                                        width: '10%',
                                        FormRowIndex: '1',
                                        FormColumnIndex: '2',
                                        columnSize: '4'
                                    },
                                    FederalTaxId: {
                                        title: 'Federal Tax Id',
                                        width: '25%',
                                        FormRowIndex: '1',
                                        FormColumnIndex: '3',
                                        columnSize: '4'
                                    },
                                    SaleTaxExemptionNumber1: {
                                        title: 'Sale Tax Exemption Number',
                                        visibility: 'hidden',
                                        FormRowIndex: '2',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                    },
                                    CorporateName: {
                                        title: 'Corporate Name',
                                        visibility: 'hidden',
                                        FormRowIndex: '3',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        FildSetStart: true,
                                        FildSetName: "Corporate Data"
                                    },
                                    CorporateStreetAddr: {
                                        title: 'Corporate Street Addr',
                                        width: '35%',
                                        FormRowIndex: '3',
                                        FormColumnIndex: '2',
                                        columnSize: '4'
                                    },
                                    CorporateStreetCityStateZip: {
                                        title: 'Corp. Street, City, State, Zip',
                                        visibility: 'hidden',
                                        FormRowIndex: '3',
                                        FormColumnIndex: '3',
                                        columnSize: '4',
                                    },
                                    CorporateStreetPhone: {
                                        title: 'Corporate Street Phone',
                                        visibility: 'hidden',
                                        FormRowIndex: '4',
                                        FormColumnIndex: '1',
                                        columnSize: '4'
                                    },
                                    CorporateStreetFax: {
                                        title: 'Fax',
                                        visibility: 'hidden',
                                        FormRowIndex: '4',
                                        FormColumnIndex: '2',
                                        columnSize: '4',
                                        FieldSetEnd: true
                                    },
                                    CorporateMailName: {
                                        title: 'Corp. Mail Name',
                                        visibility: 'hidden',
                                        type: 'email',
                                        FormRowIndex: '5',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        FildSetStart: true,
                                        FildSetName: "Mailing Data"
                                    },
                                    CorporateMailAddr: {
                                        title: 'Corp. Mail Address',
                                        visibility: 'hidden',
                                        type: 'email',
                                        FormRowIndex: '5',
                                        FormColumnIndex: '2',
                                        columnSize: '4'
                                    },
                                    CorporateMailCityStateZip: {
                                        title: 'Corp. Mail City,State,Zip',
                                        visibility: 'hidden',
                                        type: 'email',
                                        FormRowIndex: '5',
                                        FormColumnIndex: '3',
                                        columnSize: '4'
                                    },
                                    CorporateMailPhone: {
                                        title: 'Corp. Mail Phone',
                                        visibility: 'hidden',
                                        type: 'email',
                                        FormRowIndex: '6',
                                        FormColumnIndex: '1',
                                        columnSize: '4'
                                    },
                                    CorporateMailFax: {
                                        title: 'Corp. Mail Fax',
                                        visibility: 'hidden',
                                        type: 'email',
                                        FormRowIndex: '6',
                                        FormColumnIndex: '2',
                                        columnSize: '4',
                                        FieldSetEnd: true
                                    },
                                    BankNameOfAccountHolder: {
                                        title: 'Bank Name Of Account Holder',
                                        visibility: 'hidden',
                                        FormRowIndex: '7',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        FildSetStart: true,
                                        FildSetName: "Bank Info"
                                    },
                                    BankName: {
                                        title: 'Bank Name',
                                        visibility: 'hidden',
                                        FormRowIndex: '7',
                                        FormColumnIndex: '2',
                                        columnSize: '4'
                                    },
                                    BankAddr: {
                                        title: 'Bank Address',
                                        visibility: 'hidden',
                                        FormRowIndex: '7',
                                        FormColumnIndex: '3',
                                        columnSize: '4'
                                    },
                                    BankCityStateZip: {
                                        title: 'Bank City,State,Zip',
                                        visibility: 'hidden',
                                        FormRowIndex: '8',
                                        FormColumnIndex: '1',
                                        columnSize: '4'
                                    },
                                    BankAccountNumber: {
                                        title: 'Bank Account Number',
                                        visibility: 'hidden',
                                        FormRowIndex: '8',
                                        FormColumnIndex: '2',
                                        columnSize: '4'
                                    },
                                    BankPhone: {
                                        title: 'Bank Phone',
                                        visibility: 'hidden',
                                        FormRowIndex: '8',
                                        FormColumnIndex: '3',
                                        columnSize: '4'
                                    },
                                    BankOfficer: {
                                        title: 'Bank Officer',
                                        visibility: 'hidden',
                                        FormRowIndex: '9',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        FieldSetEnd: true
                                    },
                                    TradeRef1Name: {
                                        title: 'Trade Ref1 Name',
                                        visibility: 'hidden',
                                        FormRowIndex: '10',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        FildSetStart: true,
                                        FildSetName: "Trade Reference 1"
                                    },
                                    TradeRef1Addr: {
                                        title: 'Trade Ref1 Address',
                                        visibility: 'hidden',
                                        FormRowIndex: '10',
                                        FormColumnIndex: '2',
                                        columnSize: '4'
                                    },
                                    TradeRef1CityStateZip: {
                                        title: 'Trade Ref1 City,State,Zip',
                                        visibility: 'hidden',
                                        FormRowIndex: '10',
                                        FormColumnIndex: '3',
                                        columnSize: '4'
                                    },
                                    TradeRef1Phone: {
                                        title: 'Trade Ref1 Phone',
                                        visibility: 'hidden',
                                        FormRowIndex: '11',
                                        FormColumnIndex: '1',
                                        columnSize: '4'
                                    },
                                    TradeRef1Acct: {
                                        title: 'Trade Ref1 Acct',
                                        visibility: 'hidden',
                                        FormRowIndex: '11',
                                        FormColumnIndex: '2',
                                        columnSize: '4'
                                    },
                                    TradeRef2Name: {
                                        title: 'Trade Ref2 Name',
                                        visibility: 'hidden',
                                        FormRowIndex: '11',
                                        FormColumnIndex: '3',
                                        columnSize: '4',
                                        FieldSetEnd: true
                                    },
                                    TradeRef2Addr: {
                                        title: 'Trade Ref2 Address',
                                        visibility: 'hidden',
                                        FormRowIndex: '12',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        FildSetStart: true,
                                        FildSetName: "Trade Reference 2"
                                    },
                                    TradeRef2CityStateZip: {
                                        title: 'Trade Ref2 City,State,Zip',
                                        visibility: 'hidden',
                                        FormRowIndex: '12',
                                        FormColumnIndex: '2',
                                        columnSize: '4'
                                    },
                                    TradeRef2Phone: {
                                        title: 'Trade Ref2 Phone',
                                        visibility: 'hidden',
                                        FormRowIndex: '12',
                                        FormColumnIndex: '3',
                                        columnSize: '4'
                                    },
                                    TradeRef2Acct: {
                                        title: 'Trade Ref2 Acct',
                                        visibility: 'hidden',
                                        FormRowIndex: '13',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        FieldSetEnd: true
                                    },
                                    TradeRef3Name: {
                                        title: 'Trade Ref3 Name',
                                        visibility: 'hidden',
                                        FormRowIndex: '14',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        FildSetStart: true,
                                        FildSetName: "Trade Reference 3"
                                    },
                                    TradeRef3Addr: {
                                        title: 'Trade Ref3 Address',
                                        visibility: 'hidden',
                                        FormRowIndex: '14',
                                        FormColumnIndex: '2',
                                        columnSize: '4'
                                    },
                                    TradeRef3CityStateZip: {
                                        title: 'Trade Ref3 City,State,Zip',
                                        visibility: 'hidden',
                                        FormRowIndex: '14',
                                        FormColumnIndex: '3',
                                        columnSize: '4'
                                    },
                                    TradeRef3Phone: {
                                        title: 'Trade Ref3 Phone',
                                        visibility: 'hidden',
                                        FormRowIndex: '15',
                                        FormColumnIndex: '1',
                                        columnSize: '4'
                                    },
                                    TradeRef3Acct: {
                                        title: 'Trade Ref3 Acct',
                                        visibility: 'hidden',
                                        FormRowIndex: '15',
                                        FormColumnIndex: '2',
                                        columnSize: '4',
                                        FieldSetEnd: true
                                    },
                                    TradeRef4Name: {
                                        title: 'Trade Ref4 Name',
                                        visibility: 'hidden',
                                        FormRowIndex: '16',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        FildSetStart: true,
                                        FildSetName: "Trade Reference 4"
                                    },
                                    TradeRef4Addr: {
                                        title: 'Trade Ref4 Address',
                                        visibility: 'hidden',
                                        FormRowIndex: '16',
                                        FormColumnIndex: '2',
                                        columnSize: '4',
                                    },
                                    TradeRef4CityStateZip: {
                                        title: 'Trade Ref4 City,State,Zip',
                                        visibility: 'hidden',
                                        FormRowIndex: '16',
                                        FormColumnIndex: '3',
                                        columnSize: '4'
                                    },
                                    TradeRef4Phone: {
                                        title: 'Trade Ref4 Phone',
                                        visibility: 'hidden',
                                        FormRowIndex: '17',
                                        FormColumnIndex: '1',
                                        columnSize: '4'
                                    },
                                    TradeRef4Acct: {
                                        title: 'Trade Ref4 Acct',
                                        visibility: 'hidden',
                                        FormRowIndex: '17',
                                        FormColumnIndex: '2',
                                        columnSize: '4',
                                        FieldSetEnd: true
                                    },
                                },
                                recordsLoaded: function (event, data) {
                                    //Get Icon that was clicked
                                    var icon = $($img).find('i');
                                    //Open edit form or add form
                                    if (icon.hasClass("fi-credit-card")) {
                                        $(event.target).jtable('showEditForm', data.records[0]);
                                    }
                                    else {
                                        $(event.target).jtable('showAddForm');
                                    }
                                },

                                rowInserted: function (event, data) {
                                    //Check if row inserted is a new record, added by user.
                                    if (data.isNewRow) {
                                        //only gets run if user added item, which is the only time to change icon from
                                        //plus sign to credit card (add to edit)
                                        //Change img from add credit app to edit credit app
                                        var icon = $($img).find('i');
                                        icon.removeClass('fi-plus').addClass('fi-credit-card');
                                    }
                                },
                                //If a child item is added the parent item must be updated. 
                                //The CredID of parent item must match that of the child Item.
                                recordAdded: function (event, data) {
                                    //Customer create function returns the updated parent row as "ParentRecord" with is used here
                                    //to make jTable updated the record in table without reloading whole table
                                    $('#CustomerTableContainer').jtable('updateRecord', {
                                        clientOnly: true,
                                        record: data.serverResponse.ParentRecord
                                    });
                                },
                                recordUpdated: function (event, data) {
                                    $('#CustomerTableContainer').jtable('updateRecord', {
                                        clientOnly: true,
                                        record: data.serverResponse.ParentRecord
                                    });
                                },
                                //}, recordDeleted: function (event, data) {
                                //    $('#CustomerTableContainer').jtable('updateRecord', {
                                //        clientOnly: true,
                                //        record: data.serverResponse.ParentRecord
                                //    });
                                //}
                            }, function (data) { //opened handler
                                data.childTable.jtable('load');
                            });
                    });
                    //Return image to show on the customer row
                    return $img;
                }
            },
        },
        recordsLoaded: function (event, data) {
            $('#CustomerTableContainer').find('.jtable-command-button').closest('td').addClass("jtable-command-column");
        }
    });

    //Load Customer list from server
    $('#CustomerTableContainer').jtable('load');
};


//********************CUSTOMER Changes JTABLE**************************
function CustChangesJtable(startDate, endDate) {
    //Prepare jtable plugin
    $('#CustChangesJtable').jtable({
        title: 'Customers Master Changes',
        paging: true, //Enables paging
        pageSize: 10, //Actually this is not needed since default value is 10.
        sorting: true, //Enables sorting
        defaultSorting: 'Client, ASC', //Optional. Default sorting on first load.
        multiSorting: true,
        filteringBar: false,
        showEditButton: false,
        defaultDateFormat: 'mm/dd/yy',
        actions: {
            listAction: 'Customers.aspx/CClistAction_CustInfo?startDate=' + startDate + '&endDate=' + endDate + '&includeDeletes=' + false + '',
            updateAction: 'Customers.aspx/CCUpdateAction_CustInfo',
        },
        toolbar: {
            items: [{
                icon: false,
                text: 'Include Deletes',
                cssClass: 'IncDelets secondary',
                click: function () {
                    var leJtable = $('#CustChangesJtable').data('hik-jtable');
                    //Default value for including deleted records is False  
                    var includeDeletes = false
                    //Tool-bar include deleted records button color:secondary(gray)=no deleted records, Active(green)=deleted records
                    var IncDeletsButt = $('#CustChangesJtable').find('.IncDelets');
                    if (IncDeletsButt.hasClass('secondary')) {
                        $(IncDeletsButt).removeClass('secondary').addClass('success');
                        includeDeletes = true;
                    } else {
                        $(IncDeletsButt).removeClass('success').addClass('secondary');
                    }

                    //Set the URL in jtable options to reflect user choice to include deleted records or not.
                    leJtable.options.actions.listAction = 'Customers.aspx/CClistAction_CustInfo?startDate=' + startDate + '&endDate=' + endDate + '&includeDeletes=' + includeDeletes + '';
                    //reload jtable, makes Ajax call to code behind
                    $('#CustChangesJtable').jtable('reload');
                }
            }]
        },
        fields: {
            Client: {
                title: 'Client Name',
                width: '15%',
                visibility: 'fixed',
                FormRowIndex: '1',
                FormColumnIndex: '2',
                columnSize: '6',
                display: function (custData) { //Display Customer Detail Modal
                    var $cellData = custData['record']['Client'];
                    var $cell = $('<a href="#ClientData">' + $cellData + '<a>');

                    $cell.click(function () {
                        $('#CustChangesJtable').jtable('showEditForm', custData.record);
                    });
                    return $cell;
                }
            },
            ClientID: {
                key: true,
                title: 'ClientID',
                create: true,
                disabled: true,
                edit: true,
                visibility: 'hidden',
                title: 'Client ID',
                FormRowIndex: '1',
                FormColumnIndex: '1',
                columnSize: '3'
            },
            Type: {
                title: 'Cust. Type',
                width: '8%',
                options: 'Customers.aspx/GetCustTypeDDwn',
                FormRowIndex: '1',
                FormColumnIndex: '3',
                columnSize: '3'
            },
            RepName: {
                visibility: 'hidden',
                edit: true,
                title: 'Rep',
                FormRowIndex: '2',
                FormColumnIndex: '1',
                columnSize: '3',
                input: function (data) {
                    return '<h5 style="margin-top: 0;">' + data.record.RepName + '</h5>';
                }
            },
            TerritoryID: {
                visibility: 'hidden',
                edit: true,
                title: 'Territory',
                FormRowIndex: '2',
                FormColumnIndex: '2',
                columnSize: '6',
                options: 'Customers.aspx/GetTerritoryDDwn'
            },
            TerritoryStates: {
                title: 'Current',
                create: false,
                edit: true,
                //list: false,
                visibility: 'hidden',
                FormRowIndex: '2',
                FormColumnIndex: '3',
                columnSize: '3',
                input: function (data) {
                    return '<span style="margin-top: 0;">' + data.record.TerritoryID + ': ' + data.record.TerritoryStates + '</span>';
                }
            },
            Buyer: {
                title: 'Buyer',
                width: '13%',
                FormRowIndex: '3',
                FormColumnIndex: '1',
                columnSize: '4'
            },
            Buyer2: {
                visibility: 'hidden',
                edit: true,
                title: 'Buyer2',
                FormRowIndex: '3',
                FormColumnIndex: '2',
                columnSize: '4'
            },
            Address: {
                visibility: 'hidden',
                edit: true,
                title: 'Address',
                FormRowIndex: '4',
                FormColumnIndex: '1',
                columnSize: '4',
                FildSetStart: true,
                FildSetName: "Address"
            },
            Address2: {
                visibility: 'hidden',
                edit: true,
                title: 'Address2',
                FormRowIndex: '4',
                FormColumnIndex: '2',
                columnSize: '4'
            },
            City: {
                title: 'City',
                width: '10%',
                FormRowIndex: '5',
                FormColumnIndex: '1',
                columnSize: '4'
            },
            State: {
                title: 'State',
                width: '7%',
                FormRowIndex: '5',
                FormColumnIndex: '2',
                columnSize: '1'
            },
            Zip: {
                visibility: 'hidden',
                edit: true,
                title: 'Zip',
                FormRowIndex: '5',
                FormColumnIndex: '3',
                columnSize: '2',
                FieldSetEnd: true
            },
            Phone: {
                title: 'Phone',
                width: '10%',
                FormRowIndex: '6',
                FormColumnIndex: '1',
                columnSize: '4',
                FildSetStart: true,
                FildSetName: "Contact Information"
            },
            Fax: {
                visibility: 'hidden',
                edit: true,
                title: 'Fax',
                FormRowIndex: '6',
                FormColumnIndex: '2',
                columnSize: '4'
            },
            Email: {
                visibility: 'hidden',
                edit: true,
                title: 'Email',
                type: 'email',
                FormRowIndex: '7',
                FormColumnIndex: '1',
                columnSize: '4'
            },
            Email2: {
                visibility: 'hidden',
                edit: true,
                title: 'Email2',
                type: 'email',
                FormRowIndex: '7',
                FormColumnIndex: '2',
                columnSize: '4',
                FieldSetEnd: true
            },
            Status: {
                title: 'Status',
                width: '6%',
                type: 'checkbox',
                values: { 'D': 'NOT Active', 'A': 'Active' },
                defaultValue: 'A',
                FormRowIndex: '8',
                FormColumnIndex: '1',
                columnSize: '2',
            },
            CreditAppID: {
                visibility: 'hidden',
                edit: true,
                title: 'CreditAppID',
                FormRowIndex: '8',
                FormColumnIndex: '2',
                columnSize: '2',
                input: function (data) {
                    return '<input type="text" name="Name" value="' + data.record.CreditAppID + '" disabled/>';
                }
            },
            AddDate: {
                title: 'Add Date',
                width: '10%',
                type: 'date',
                visibility: 'hidden',
                FormRowIndex: '8',
                FormColumnIndex: '3',
                columnSize: '2',
                input: function (data) {
                    var fieldVal = data.record.AddDate;
                    var dateForm = "";

                    if (fieldVal === undefined || fieldVal === null || fieldVal.legth != 0) {
                        dateForm = FormatDateString('mm/dd/yy', fieldVal);
                        return '<h5 style="margin-top: 0;">' + dateForm + '</h5>';
                    }
                    return '<h5 style="margin-top: 0;"></h5>';
                }
            },
            LastUpdateDate: {
                title: 'Last Updated',
                width: '10%',
                type: 'date',
                FormRowIndex: '8',
                FormColumnIndex: '4',
                columnSize: '2',
                input: function (data) {
                    var fieldVal = data.record.LastUpdateDate;
                    var dateForm = "";

                    if (fieldVal === undefined || fieldVal === null || fieldVal.legth != 0) {
                        dateForm = FormatDateString('mm/dd/yy', fieldVal);
                        return '<h5 style="margin-top: 0;">' + dateForm + '</h5>';
                    }
                    return '<h5 style="margin-top: 0;"></h5>';
                }
            },
            LastUpdatedBy: {
                title: 'Last Updated By',
                width: '12%',
                visibility: 'hidden',
                FormRowIndex: '8',
                FormColumnIndex: '5',
                columnSize: '3',
                input: function (data) {
                    return '<h5 style="margin-top: 0;">' + data.record.LastUpdatedBy + '</h5>';
                }
            },
            PermNote: {
                title: 'Notes',
                type: 'textarea',
                visibility: 'hidden',
                FormRowIndex: '9',
                FormColumnIndex: '1',
                columnSize: '12'
            },
            CreditCardApp: {
                title: 'Credit App',
                width: '5%',
                sorting: false,
                edit: false,
                create: false,
                display: function (CustomerDataCredit) {
                    var $img;
                    ////Create an image that will be used to open Credit application   
                    $img = $('<div title="Edit Credit App" class="button jtable-command-button expand jtable-edit-command-button" />');
                    //'style="margin-bottom: 0; padding: .05rem; cursor: pointer;" />');
                    //Check if customer has existing credit app
                    if (CustomerDataCredit.record.CreditAppID == "0") {
                        //Add create credit app button
                        $img.append('<i class="fi-plus jtable-command-button"></i>');
                        //Change tool tip to create credit application. Default is set to Edit Credit app
                        $($img).attr("title", "Create Credit Application");
                    }
                    else {
                        //Add edit credit app button
                        $img.append('<i class="fi-credit-card jtable-command-button"></i>');
                    }
                    //Open Jtable child table when user clicks the image
                    //This opens either create or edit credit application modal
                    $img.click(function (e) {
                        $('#CustChangesJtable').jtable('openChildTable',
                             $img.closest('tr'), //Jtable Parent row
                            {
                                title: 'Credit App For: ' + CustomerDataCredit.record.Client,
                                // showCloseButton: false,
                                //we are open child as modal but because there is only one credit app per parent row we
                                //want to open straight to edit. so do not show child row
                                ShowChildRow: false,
                                actions: {
                                    listAction: 'Customers.aspx/ChildListingAction_CrdApp?key=' + CustomerDataCredit.record.CreditAppID + '',
                                    updateAction: 'Customers.aspx/ChildUpdateAction_CrdApp?ChildKey=' + CustomerDataCredit.record.CreditAppID + '',
                                    createAction: 'Customers.aspx/ChildCreateAction_CrdApp?ParentKey=' + CustomerDataCredit.record.ClientID + '',
                                },
                                messages: {
                                    editRecord: 'Edit Credit Card App',
                                    addNewRecord: 'Add Credit Card App',
                                },
                                fields: {
                                    id: {
                                        key: true,
                                        create: true,
                                        edit: false,
                                        list: false,
                                        title: 'credit App ID',
                                        FormRowIndex: '1',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        defaultValue: CustomerDataCredit.record.CreditAppID,
                                    },
                                    YearEstablished: {
                                        title: 'Year Established',
                                        width: '10%',
                                        FormRowIndex: '1',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                    },
                                    YearsAtCurrentLocation: {
                                        title: 'Years At Current Location',
                                        width: '10%',
                                        FormRowIndex: '1',
                                        FormColumnIndex: '2',
                                        columnSize: '4'
                                    },
                                    FederalTaxId: {
                                        title: 'Federal Tax Id',
                                        width: '25%',
                                        FormRowIndex: '1',
                                        FormColumnIndex: '3',
                                        columnSize: '4'
                                    },
                                    SaleTaxExemptionNumber1: {
                                        title: 'Sale Tax Exemption Number',
                                        visibility: 'hidden',
                                        FormRowIndex: '2',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                    },
                                    CorporateName: {
                                        title: 'Corporate Name',
                                        visibility: 'hidden',
                                        FormRowIndex: '3',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        FildSetStart: true,
                                        FildSetName: "Corporate Data"
                                    },
                                    CorporateStreetAddr: {
                                        title: 'Corporate Street Addr',
                                        width: '35%',
                                        FormRowIndex: '3',
                                        FormColumnIndex: '2',
                                        columnSize: '4'
                                    },
                                    CorporateStreetCityStateZip: {
                                        title: 'Corp. Street, City, State, Zip',
                                        visibility: 'hidden',
                                        FormRowIndex: '3',
                                        FormColumnIndex: '3',
                                        columnSize: '4',
                                    },
                                    CorporateStreetPhone: {
                                        title: 'Corporate Street Phone',
                                        visibility: 'hidden',
                                        FormRowIndex: '4',
                                        FormColumnIndex: '1',
                                        columnSize: '4'
                                    },
                                    CorporateStreetFax: {
                                        title: 'Fax',
                                        visibility: 'hidden',
                                        FormRowIndex: '4',
                                        FormColumnIndex: '2',
                                        columnSize: '4',
                                        FieldSetEnd: true
                                    },
                                    CorporateMailName: {
                                        title: 'Corp. Mail Name',
                                        visibility: 'hidden',
                                        type: 'email',
                                        FormRowIndex: '5',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        FildSetStart: true,
                                        FildSetName: "Mailing Data"
                                    },
                                    CorporateMailAddr: {
                                        title: 'Corp. Mail Address',
                                        visibility: 'hidden',
                                        type: 'email',
                                        FormRowIndex: '5',
                                        FormColumnIndex: '2',
                                        columnSize: '4'
                                    },
                                    CorporateMailCityStateZip: {
                                        title: 'Corp. Mail City,State,Zip',
                                        visibility: 'hidden',
                                        type: 'email',
                                        FormRowIndex: '5',
                                        FormColumnIndex: '3',
                                        columnSize: '4'
                                    },
                                    CorporateMailPhone: {
                                        title: 'Corp. Mail Phone',
                                        visibility: 'hidden',
                                        type: 'email',
                                        FormRowIndex: '6',
                                        FormColumnIndex: '1',
                                        columnSize: '4'
                                    },
                                    CorporateMailFax: {
                                        title: 'Corp. Mail Fax',
                                        visibility: 'hidden',
                                        type: 'email',
                                        FormRowIndex: '6',
                                        FormColumnIndex: '2',
                                        columnSize: '4',
                                        FieldSetEnd: true
                                    },
                                    BankNameOfAccountHolder: {
                                        title: 'Bank Name Of Account Holder',
                                        visibility: 'hidden',
                                        FormRowIndex: '7',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        FildSetStart: true,
                                        FildSetName: "Bank Info"
                                    },
                                    BankName: {
                                        title: 'Bank Name',
                                        visibility: 'hidden',
                                        FormRowIndex: '7',
                                        FormColumnIndex: '2',
                                        columnSize: '4'
                                    },
                                    BankAddr: {
                                        title: 'Bank Address',
                                        visibility: 'hidden',
                                        FormRowIndex: '7',
                                        FormColumnIndex: '3',
                                        columnSize: '4'
                                    },
                                    BankCityStateZip: {
                                        title: 'Bank City,State,Zip',
                                        visibility: 'hidden',
                                        FormRowIndex: '8',
                                        FormColumnIndex: '1',
                                        columnSize: '4'
                                    },
                                    BankAccountNumber: {
                                        title: 'Bank Account Number',
                                        visibility: 'hidden',
                                        FormRowIndex: '8',
                                        FormColumnIndex: '2',
                                        columnSize: '4'
                                    },
                                    BankPhone: {
                                        title: 'Bank Phone',
                                        visibility: 'hidden',
                                        FormRowIndex: '8',
                                        FormColumnIndex: '3',
                                        columnSize: '4'
                                    },
                                    BankOfficer: {
                                        title: 'Bank Officer',
                                        visibility: 'hidden',
                                        FormRowIndex: '9',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        FieldSetEnd: true
                                    },
                                    TradeRef1Name: {
                                        title: 'Trade Ref1 Name',
                                        visibility: 'hidden',
                                        FormRowIndex: '10',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        FildSetStart: true,
                                        FildSetName: "Trade Reference 1"
                                    },
                                    TradeRef1Addr: {
                                        title: 'Trade Ref1 Address',
                                        visibility: 'hidden',
                                        FormRowIndex: '10',
                                        FormColumnIndex: '2',
                                        columnSize: '4'
                                    },
                                    TradeRef1CityStateZip: {
                                        title: 'Trade Ref1 City,State,Zip',
                                        visibility: 'hidden',
                                        FormRowIndex: '10',
                                        FormColumnIndex: '3',
                                        columnSize: '4'
                                    },
                                    TradeRef1Phone: {
                                        title: 'Trade Ref1 Phone',
                                        visibility: 'hidden',
                                        FormRowIndex: '11',
                                        FormColumnIndex: '1',
                                        columnSize: '4'
                                    },
                                    TradeRef1Acct: {
                                        title: 'Trade Ref1 Acct',
                                        visibility: 'hidden',
                                        FormRowIndex: '11',
                                        FormColumnIndex: '2',
                                        columnSize: '4'
                                    },
                                    TradeRef2Name: {
                                        title: 'Trade Ref2 Name',
                                        visibility: 'hidden',
                                        FormRowIndex: '11',
                                        FormColumnIndex: '3',
                                        columnSize: '4',
                                        FieldSetEnd: true
                                    },
                                    TradeRef2Addr: {
                                        title: 'Trade Ref2 Address',
                                        visibility: 'hidden',
                                        FormRowIndex: '12',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        FildSetStart: true,
                                        FildSetName: "Trade Reference 2"
                                    },
                                    TradeRef2CityStateZip: {
                                        title: 'Trade Ref2 City,State,Zip',
                                        visibility: 'hidden',
                                        FormRowIndex: '12',
                                        FormColumnIndex: '2',
                                        columnSize: '4'
                                    },
                                    TradeRef2Phone: {
                                        title: 'Trade Ref2 Phone',
                                        visibility: 'hidden',
                                        FormRowIndex: '12',
                                        FormColumnIndex: '3',
                                        columnSize: '4'
                                    },
                                    TradeRef2Acct: {
                                        title: 'Trade Ref2 Acct',
                                        visibility: 'hidden',
                                        FormRowIndex: '13',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        FieldSetEnd: true
                                    },
                                    TradeRef3Name: {
                                        title: 'Trade Ref3 Name',
                                        visibility: 'hidden',
                                        FormRowIndex: '14',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        FildSetStart: true,
                                        FildSetName: "Trade Reference 3"
                                    },
                                    TradeRef3Addr: {
                                        title: 'Trade Ref3 Address',
                                        visibility: 'hidden',
                                        FormRowIndex: '14',
                                        FormColumnIndex: '2',
                                        columnSize: '4'
                                    },
                                    TradeRef3CityStateZip: {
                                        title: 'Trade Ref3 City,State,Zip',
                                        visibility: 'hidden',
                                        FormRowIndex: '14',
                                        FormColumnIndex: '3',
                                        columnSize: '4'
                                    },
                                    TradeRef3Phone: {
                                        title: 'Trade Ref3 Phone',
                                        visibility: 'hidden',
                                        FormRowIndex: '15',
                                        FormColumnIndex: '1',
                                        columnSize: '4'
                                    },
                                    TradeRef3Acct: {
                                        title: 'Trade Ref3 Acct',
                                        visibility: 'hidden',
                                        FormRowIndex: '15',
                                        FormColumnIndex: '2',
                                        columnSize: '4',
                                        FieldSetEnd: true
                                    },
                                    TradeRef4Name: {
                                        title: 'Trade Ref4 Name',
                                        visibility: 'hidden',
                                        FormRowIndex: '16',
                                        FormColumnIndex: '1',
                                        columnSize: '4',
                                        FildSetStart: true,
                                        FildSetName: "Trade Reference 4"
                                    },
                                    TradeRef4Addr: {
                                        title: 'Trade Ref4 Address',
                                        visibility: 'hidden',
                                        FormRowIndex: '16',
                                        FormColumnIndex: '2',
                                        columnSize: '4',
                                    },
                                    TradeRef4CityStateZip: {
                                        title: 'Trade Ref4 City,State,Zip',
                                        visibility: 'hidden',
                                        FormRowIndex: '16',
                                        FormColumnIndex: '3',
                                        columnSize: '4'
                                    },
                                    TradeRef4Phone: {
                                        title: 'Trade Ref4 Phone',
                                        visibility: 'hidden',
                                        FormRowIndex: '17',
                                        FormColumnIndex: '1',
                                        columnSize: '4'
                                    },
                                    TradeRef4Acct: {
                                        title: 'Trade Ref4 Acct',
                                        visibility: 'hidden',
                                        FormRowIndex: '17',
                                        FormColumnIndex: '2',
                                        columnSize: '4',
                                        FieldSetEnd: true
                                    },
                                },
                                recordsLoaded: function (event, data) {
                                    //Get Icon that was clicked
                                    var icon = $($img).find('i');
                                    //Open edit form or add form
                                    if (icon.hasClass("fi-credit-card")) {
                                        $(event.target).jtable('showEditForm', data.records[0]);
                                    }
                                    else {
                                        $(event.target).jtable('showAddForm');
                                    }
                                },

                                rowInserted: function (event, data) {
                                    //Check if row inserted is a new record, added by user.
                                    if (data.isNewRow) {
                                        //only gets run if user added item, which is the only time to change icon from
                                        //plus sign to credit card (add to edit)
                                        //Change img from add credit app to edit credit app
                                        var icon = $($img).find('i');
                                        icon.removeClass('fi-plus').addClass('fi-credit-card');
                                    }
                                },
                                //If a child item is added the parent item must be updated. 
                                //The CredID of parent item must match that of the child Item.
                                recordAdded: function (event, data) {
                                    //Customer create function returns the updated parent row as "ParentRecord" with is used here
                                    //to make jTable updated the record in table without reloading whole table
                                    $('#CustChangesJtable').jtable('updateRecord', {
                                        clientOnly: true,
                                        record: data.serverResponse.ParentRecord
                                    });
                                },
                                recordUpdated: function (event, data) {
                                    $('#CustChangesJtable').jtable('updateRecord', {
                                        clientOnly: true,
                                        record: data.serverResponse.ParentRecord
                                    });
                                },
                                //}, recordDeleted: function (event, data) {
                                //    $('#CustChangesJtable').jtable('updateRecord', {
                                //        clientOnly: true,
                                //        record: data.serverResponse.ParentRecord
                                //    });
                                //}
                            }, function (data) { //opened handler
                                data.childTable.jtable('load');
                            });
                    });
                    //Return image to show on the customer row
                    return $img;
                }
            },
        },
        recordsLoaded: function (event, data) {
            $('#CustChangesJtable').find('.jtable-command-button').closest('td').addClass("jtable-command-column");
        }
    });

    //Load Customer list from server
    $('#CustChangesJtable').jtable('load');
};





//$(document).foundation({
//    tab: {
//        callback: function (tab) {
//            var TabIndex = $(tab).index();

//            //Change Active tab labels
//            $(CustOffCanTabsLi).removeClass("active2").eq(TabIndex).addClass('active2');
//            $(CustBottomSideBarLi).removeClass("active2").eq(TabIndex).addClass('active2');
//            $(TopTabsli).removeClass("active").eq(TabIndex).addClass('active');
//            //Top Page Title
//            $(top_page_tabTitle).hide().eq(TabIndex - 1).show();

//            //CUSTOMER JTABLE TAB
//            if (TabIndex == 1) {
//                if (!$('#CustomerTableContainer').hasClass('jtable-main-container')) {
//                    var custDrpDwn = $('#CustSelcDrpDwn');
//                    if (custDrpDwn.selectedIndex !== 0) {
//                        var selecText = custDrpDwn.find('option:selected').text();
//                        var selcVal = custDrpDwn.val();
//                        console.log('calling Jtable');

//                        CustJtable(selecText, selcVal).done();

//                        console.log("DoneCalling Jatable");
//                    }
//                }
//            }
//            else if (TabIndex == 2) {//CUSTOMER CHANGES TAB
//                if (startDate.val().length == 0) {
//                    //Set initial date to today
//                    var nowTemp = new Date();
//                    var month = nowTemp.getMonth() + 1; var day = nowTemp.getDate(); var year = nowTemp.getFullYear();
//                    var now = TodayDate = (month < 10 ? '0' : '') + month + '/' +
//                                          (day < 10 ? '0' : '') + day + '/' +
//                                           year;
//                    startDate.val(now);
//                    endDate.val(now);
//                    //Initialize date pickers
//                    var checkin = startDate.fdatepicker({
//                    }).off('changeDate').on('changeDate', function (ev) {
//                        if (ev.date.valueOf() > checkout.date.valueOf()) {
//                            var newDate = new Date(ev.date)
//                            newDate.setDate(newDate.getDate() + 1);
//                            checkout.update(newDate);
//                        }
//                        checkin.hide();
//                        endDate[0].focus();
//                    }).data('datepicker');
//                    var checkout = endDate.fdatepicker({
//                        onRender: function (date) {
//                            return date.valueOf() <= checkin.date.valueOf() ? 'disabled' : '';
//                        }
//                    }).off('changeDate').on('changeDate', function (ev) {
//                        checkout.hide();
//                    }).data('datepicker');

//                }
//            }
//            EqualizerReflow();
//            console.log("EqualizerReflow");
//        }
//    }
//});
