
function RepTable() {
    //Dismiss any busy modal when page loads
    var BusyModal = $('#BusyModal');
    BusyModal.foundation('reveal', 'close');

  //check if a publisher or rep is logged in
    if ($('#RepInfoBottomSideBar').is(':visible')) {
        //when rep logged in must show side menu tabs and add functions for switching sections(tabs)
        //Handles highlighting bottom sidebar tab for current displayed tab
        var RepLefOffCanTabs = $('#RepInfo_LefOffCan_Tabs');
        var RepBottomSideBar = $('#RepInfoBottomSideBar');
        var TopTabs = $('#Tabswitch');

        var RepOffCanTabsLi = RepLefOffCanTabs.find("li");
        var RepBottomSideBarLi = RepBottomSideBar.find("li");
        var TopTabsli = TopTabs.find("li");
        var top_page_tabTitle = $('#top_page_tabTitle').find('h1');

        //Handles switching between sections(tabs) when left bottom sub nave is changed
        $(document).foundation({
            tab: {
                callback: function (tab) {
                    var TabIndex = $(tab).index();

                    if (TabIndex === 2) {
                        if (!$('#RepInfoTableContainer').hasClass('jtable-main-container')) {
                            RepInfojtable();
                        }
                    }
                    else if (TabIndex === 3) {
                        if (!$('#AccNbrTableContainer').hasClass('jtable-main-container')) {
                            AccNbrJTable();
                        }
                    }

                    //Change Active tab labels
                    $(RepOffCanTabsLi).removeClass("active2").eq(TabIndex).addClass('active2');
                    $(RepBottomSideBarLi).removeClass("active2").eq(TabIndex).addClass('active2');
                    $(TopTabsli).removeClass("active").eq(TabIndex).addClass('active');

                    //Top Page Title
                    $(top_page_tabTitle).hide().eq(TabIndex - 1).show();

                    EqualizerReflow();
                }
            }
        });

        //Get Form object
        var RepForm = $('#RepInfoForm');
        //set up edit button change event
        //Shows or hides Save and Restore button as well as enables or disable textboxs:in PubRepapp.js
        EditButBarChange(RepForm);

        ////Set up event for reset button:in PubRepapp.js 
        ResetFormFields(RepForm, 'RepInfo.aspx/ResetTextBox');

        //Start busy modal when save button is clicked
        $(RepForm).find('#saveButtContainer').on('click', function (e) {
            BusyModal.foundation('reveal', 'open');
        });
    }
    else {
        //When Publishers log in just show rep info table
        RepInfojtable();
    }
}

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
        multiSorting: true,
        filteringBar: true,
        filterElement: $('#FilterContainer'),
        defaultDateFormat: 'm/dd/yy',
        actions: {
            listAction: 'RepInfo.aspx/listAction_RepInfo',
            filterAction: 'RepInfo.aspx/filterAction_RepInfo',
            filterReload: 'RepInfo.aspx/filterReload_RepInfo',
            filterTypeAhead: 'RepInfo.aspx/JTRemoteTypeAhead_rep'
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
            LastName: {
                title: 'Last Name',
                width: '10%',
                display: function (RepData) { //Display Rep Detail Modal
                    var $cellData = RepData['record']['LastName'];
                    if ($cellData !== null) {
                        var $cell = $('<a href="#RepData">' + $cellData + '<a>');

                        $cell.click(function () {
                            $('#RepModal').foundation('reveal', 'open');//Open modal

                            var FormData = RepData.record;
                            var FormFields = $('#RepModal').find(".RepItem");

                            if (FormFields.length != 0) {
                                FormFields.each(function () {//loop through all items with class RepItem on modal and use the id to get data
                                    var FormFieldsID = this.id;
                                    var fieldVal = FormData['' + FormFieldsID + ''];

                                    if (fieldVal === undefined || fieldVal === null) {
                                        fieldVal = "";
                                    }
                                    else if ($(this).hasClass("emailLink")) {
                                        $(this).replaceWith(function () {
                                            return '<a id="' + FormFieldsID + '" href="mailto:' + fieldVal + '?subject=PubReps" ' +
                                                'class="RepItem emailLink"></a>';
                                        });
                                    }
                                    else if (fieldVal.toString().indexOf('/Date(') == 0) {
                                        fieldVal = FormatDateString('mm/dd/yy', fieldVal);
                                    }
                                    $('#' + FormFieldsID + '').text(fieldVal);
                                });
                                if (FormData['City'] === null) {//add comma if address exists
                                    $('#City').removeClass("comma");
                                }
                                else {
                                    $('#City').addClass("comma");
                                }
                            }
                        });
                        return $cell;
                    }
                }
            },
            FirstName: {
                title: 'First Name',
                width: '10%',
            },
            Address1: {
                title: 'Address',
                width: '10%',
                visibility: 'hidden',
            },
            City: {
                title: 'City',
                width: '10%',
                visibility: 'hidden',
            },
            State: {
                title: 'State',
                width: '10%',
                visibility: 'hidden',
            },
            Phone1: {
                title: 'Phone',
                width: '10%'
            },
            Phone2: {
                title: 'Phone',
                width: '10%',
                visibility: 'hidden',
            },
            Fax: {
                title: 'Fax',
                width: '10%'
            },
            Email1: {
                title: 'Email',
                width: '10%',
                type: 'email',
            },
            LastUpdateDateTime: {
                title: 'Last Updated',
                width: '20%',
                type: 'date',
                visibility: 'hidden',
            }
        },
    });

    //Load publisher list from server
    $('#RepInfoTableContainer').jtable('load');
}


//_________________________________________________________________________________________
//AccNbrTableContainer: JTABLE
//_________________________________________________________________________________________
function AccNbrJTable() {
    //Prepare jtable plugin
    $('#AccNbrTableContainer').jtable({
        title: 'Publisher Account Numbers',
        paging: true, //Enables paging
        pageSize: 10, //Actually this is not needed since default value is 10.
        sorting: true, //Enables sorting
        defaultSorting: 'Publisher ASC', //Optional. Default sorting on first load.
        multiSorting: true,
        filteringBar: true,
        filterElement: $('#AccNbrJtableFilter'),
        defaultDateFormat: 'm/dd/yy',
        actions: {
            listAction: 'RepInfo.aspx/listAction_AccNbr',
            //updateAction: 'RepInfo.aspx/UpdateAction_AccNbr',
            //createAction: 'RepInfo.aspx/CreateAction_AccNbr',
            //deleteAction: 'RepInfo.aspx/DeleteAction_AccNbr',
            filterAction: 'RepInfo.aspx/filterAction_AccNbr',
            filterReload: 'RepInfo.aspx/filterReload_AccNbr'
        },
        toolbar: {
            hoverAnimation: true, //Enable/disable small animation on mouse hover to a toolbar item.
            hoverAnimationDuration: 60, //Duration of the hover animation.
            hoverAnimationEasing: undefined, //Easing of the hover animation. Uses jQuery's default animation ('swing') if set to undefined.            
        },
        fields: {
            Publisher: {
                title: 'Publisher',
                width: '10%',
            },
            SalsRepID: {
                title: 'Sales Rep ID',
                width: '10%',
            },
            SalesRepName: {
                title: 'Display Name',
                width: '10%',
            },
            
        },
    });

    //Load AccNbr Table list from server
    $('#AccNbrTableContainer').jtable('load');
}

