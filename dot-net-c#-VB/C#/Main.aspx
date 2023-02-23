<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Main.aspx.cs" Inherits="PubRepUpload._Main" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 
 

<%@ Register TagPrefix="ctr" TagName="TopMenu" Src="Include/mainMenueC.ascx" %>
<%@ Register TagPrefix="ctr" TagName="UserLeftNav" Src="Include/UserLeftNavC.ascx" %>
<%@ Register TagPrefix="ctr" TagName="MenuBanner" Src="Include/MenuBanner.ascx" %>
<%@ Register TagPrefix="ctr" TagName="InventoryLeftNavNew" Src="Include/InventoryLeftNavNew.ascx" %>
<%@ Register TagPrefix="ctr" TagName="CssLeftNavNew" Src="Include/CssLeftNavNew.ascx" %>
<%@ Register TagPrefix="ctr" TagName="copyright2" Src="Include/copyright2.ascx" %>


<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

<link type="text/css" href="css/jquery-ui-1.10.3.custom.min.css" rel="stylesheet"/>
<link type="text/css" href="css/jquery.qtip.min.css" rel="stylesheet"/>
<link type="text/css" href="css/Spinner.css" rel="stylesheet"/>



    <title>PubReps - Upload Inventory</title>  
    <style type="text/css">         
        .style1
        {
            width: 441px;
            height: 106%;
        }
        .style3
        {
            width: 430px;
        }
        .style4
        {
            width: 25px;
        }    
          .styleLeftCell1
        {
            width: 8px;           
        } 
           .styleLeftCell2
        {
            width: 110px;          
        }
          .styleLeftCell3
        {
            width: 220px;         
        }         
        .styleRightCell1
        {
            width: 2px
        } 
          .styleRighCell2
        {
            width: 75px;          
            font-size:small;
            text-decoration: underline; 
            font-family: calibri;  
            text-align:center;            
        } 
        .styleRightTB
        {
            width: 75px;   
            height: 20px;            
        }                
        .style5
        {
            width: 222px;
        }
        .style6
        {
            width: 68px;
        }
        .style7
        {
            width: 73px;
        }
        .style8
        {
            width: 26px;
        }
        .style9
        {
            width: 141px;
        }
        .style10
        {
            width: 105px;
        }
        .style11
        {
            width: 192px;
        }
        </style>

</head>
<!-- Orange=#CC6600, Blue=#336699, Silver=#CCCCCC -->
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="white">
    <form id="form1" runat="server">
    
    <script type="text/javascript" src="Script/JQ1.10.2.min.js"></script>
    <script type="text/javascript" src="Script/jquery-ui-1.10.3.custom.min.js"></script>
    <script type="text/javascript" src="Script/jquery.qtip.min.js"></script>
     <script type="text/javascript" src="Script/spin.min.js"></script>
    
   
<!--/MenuBanner-->
<ctr:MenuBanner runat="server" id="MenuBanner" />

<table border="0" cellpadding="0" cellspacing="0" width="100%"> 

<!--TopMenu-->
<ctr:TopMenu runat="server" id="TopMenu" />

<tr>
    <td align="left">
	    <table border="0" cellpadding="0" cellspacing="0" width="100%">
	    <tr>
		    <!-- LEFT Column -->
		    <td align="left" valign="top" bgcolor="white" width="170" class="style4">
			    <table border="0" cellpadding="0" cellspacing="0" width="170">
			    <tr><td>
					    <table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td bgcolor="white">
					    <table border="0" cellpadding="0" cellspacing="0"><tr><td height="1"></td></tr></table></td></tr></table>
				    </td>
			    </tr>

			    <tr><td bgcolor="white" width="100%">

				    <table border="0" cellpadding="0" cellspacing="0" width="160">
				      <tr><td width="3"></td>
				      <td width="172">

    				    <!-- Content Start -->
	    			    <table border="0" cellpadding="0" cellspacing="0" width="100%">
		    		      <tr><td>
			    	       <table border="0" cellpadding="0" cellspacing="0">
				            <tr><td height="10">
				            </td></tr>
				           </table>
				          </td></tr>
				        </table>
      <!--UserLeftNav-->
       <ctr:UserLeftNav runat="server" id="UserLeftNav" />
     
			        <!--   Line   -->
			        <table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#336699">
			          <tr><td>
			            <table border="0" cellpadding="0" cellspacing="0">
			              <tr><td height="2">
			              </td></tr>
			            </table>
			          </td></tr>
			        </table>
    			    
			        <table border="0" cellpadding="0" cellspacing="0" width="100%">
			          <tr><td>
			            <table border="0" cellpadding="0" cellspacing="0">
			              <tr><td height="8">
			              </td></tr>
			            </table>
			          </td></tr>
			        </table>
    			    
			        <!--InventoryLeftNavNew-->
			        <ctr:InventoryLeftNavNew runat="server" id="InventoryLeftNavNew" />

			        <!--   Line   -->
			        <table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#336699">
			          <tr><td>
			            <table border="0" cellpadding="0" cellspacing="0">
			              <tr><td height="2">
			              </td></tr>
			            </table>
			          </td></tr>
			        </table>
    			    
			        <table border="0" cellpadding="0" cellspacing="0" width="100%">
			          <tr><td>
			            <table border="0" cellpadding="0" cellspacing="0">
			              <tr><td height="8">
			              </td></tr>
			            </table>
			          </td></tr>
			        </table>
    			    
    			    
       <!--CssLeftNavNew-->
       <ctr:CssLeftNavNew runat="server" id="CssLeftNavNew" />
    			
				    <table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td>
				    <table border="0" cellpadding="0" cellspacing="0"><tr><td height="8"></td></tr></table></td></tr></table>
    								
    </td>
				    <td width="3"></td>
				    </tr>
				    </table>
				    </td>
			    </tr>
			    </table>
		        </td>

		    <!-- Content End -->
		    <!-- Middle Line #CECECE -->
		    <td bgcolor="#336699" height="100%" class="style19">&nbsp;
			    <!--<table border=0 cellpadding=0 cellspacing=0 width='100%'><tr><td bgcolor=white>			<table border=0 cellpadding=0 cellspacing=0><tr><td height=1></td></tr></table></td></tr></table>			-->
		    </td>
		    
	 <!-- Middle Area -->
    <!--  Page code begins here...   -->

 
 <script type="text/javascript" language="javascript">
 
     $(document).ready(function() {

         var StatusEffectfLst = $("#ChangeDeleteCB , #ChangeActiveCB");

         $("#OtherSheetsCB").qtip({
             content:'Check to change Sheet data will be taken from.',
             position: {my: 'top right', at: 'left bottom'},
             style: {classes: 'qtip-dark qtip-youtube'}
         });
         $("#AlphCB").qtip({
             content:'Check to change data grid header to Alphabet',
              position: {my: 'top right', at: 'left bottom'},
             style: {classes: 'qtip-dark qtip-youtube'}
         });
         $("#AuthorCB").qtip({
             content: 'Check if author is in two filds',
             position: {my: 'top right', at: 'left center'},
             style: {classes: 'qtip-dark qtip-youtube'}
         });
         $("#Author1label").qtip({
             content: 'Check Author CheckBox if author name is in two filds',
             position: {my: 'bottom center', at: 'top center'},
             style: {classes: 'qtip-dark qtip-youtube'}
         });
         $("#Author2label").qtip({
             content: 'Check Author CheckBox if author name is in two filds',
             position: {my: 'bottom center', at: 'top center'},
             style: {classes: 'qtip-dark qtip-youtube'}
         });
         $("#StatusCB").qtip({
             content: 'Check to change status:<br>This will update existing items.',
             position: { my: 'top right', at: 'left bottom'},
             style: {classes: 'qtip-dark qtip-youtube'}
         });
         $("#ChangeDeleteCB").qtip({
             content: 'Check to update items to delete',
             position: {my: 'top right', at: 'left center'},
             style: {classes: 'qtip-dark qtip-youtube'}
         });
         $("#ChangeActiveCB").qtip({
             content: 'Check to update items to active',
             position: {my: 'top right', at: 'left center'},
             style: {classes: 'qtip-dark qtip-youtube'}
         });
         $("#DashCB").qtip({
             content: 'Check to allow dashes in SKU',
             position: {my: 'top center', at: 'bottom center'},
             style: {classes: 'qtip-dark qtip-youtube'}
         });
         $("#DeleteQryCB").qtip({
             content: 'Check to Insert delete statment into database',
             position: {my: 'top center', at: 'bottom center'},
             style: {classes: 'qtip-dark qtip-youtube'}
         });

         $('#IndexButton').click(function() {
            startLoadSpin();
        });
        
        $('#UploadButton').click(function() {
            startLoadSpin();
        });
        
        $('#ResetButton').click(function() {
            startLoadSpin();
        });
         
         $('#OtherSheetsCB').change(function() {
             runSheetsEffect();
             return false;
         });

         $('#StatusCB').change(function() {
             runStatusEffect();
             return false;
         });

         $('#AuthorCB').change(function() {
             runAuthorEffect();
             return false;
         });

         runAuthorEffect();
         
         $('#ChangeDeleteCB').change(function() {
             $("#ChangeActiveCB").prop("checked", false);
             $("#ChangeItemsCB").prop("checked", false);
         });
         $('#ChangeActiveCB').change(function() {
             $("#ChangeDeleteCB").prop("checked", false);
             $("#ChangeItemsCB").prop("checked", false);
         });

         $("#OtherSheetsDDTable").hide();
         $("#StatusTable").hide();
         $("#OtherSheetsCB").prop("checked", false);
         $("#StatusCB").prop("checked", false);
         $("#DeleteQryCB").prop("checked", false);
         $("#DashCB").prop("checked", false);
         $(StatusEffectfLst).prop("checked", false);
         
     });
     var spinner;

     function startLoadSpin() {
             var opts = {
                 lines: 12, // The number of lines to draw
                 length: 12, // The length of each line
                 width: 7, // The line thickness
                 radius: 23, // The radius of the inner circle
                 color: '#fff', // #rgb or #rrggbb
                 speed: 1, // Rounds per second
                 trail: 60, // Afterglow percentage
                 shadow: true, // Whether to render a shadow
                 hwaccel: false // Whether to use hardware acceleration
             };
              target = document.getElementById('processing');
             $("#processing").fadeIn();
              spinner = new Spinner(opts).spin(target);
     };

     $(document).ajaxStop(function() {
     $('#processing').fadeOut();
         spinner.stop();
     });

     function runStatusEffect() {
         if ($('#StatusCB').is(":checked")) {
             $("#StatusTable").show('blind', 100);
         }
         else {
             $("#StatusTable").hide('blind', 100);
             $("#ChangeDeleteCB , #ChangeActiveCB").prop("checked", false);
         }
     };
      
     function runSheetsEffect() {
         if ($('#OtherSheetsCB').is(":checked")) {
             $("#OtherSheetsDDTable").show('blind', 100);
         }
         else {
             $("#OtherSheetsDDTable").hide('blind', 100);
         }
     };

     function runAuthorEffect() {
         if ($('#AuthorCB').is(":checked")) {
             $("#AuthorEffect").show('blind', 100);
             $('#Panel2').height('120')
             $('#Author1Label').text("Author 1 First Name")
             $('#Author2Label').text("Author 2 First Name")
         }
         else {
             $("#AuthorEffect").hide('blind', 100);
             $('#Author1Label').text("Author 1")
             $('#Author2Label').text("Author 2")
             $('#Panel2').height('55');
         }
     };
        
</script>
    <td align="left" valign="top" class="style32">
 
          <table>
            <tr>
              <td <font class="Font8Boldv">
                 Location: <a href="MainNew.aspx" 
                <font color="#336699"> </font> Home page</a> > Upload Inventory</font>         
              </td>
            </tr>
            </table> 
       
        <asp:Panel ID="Panel1" runat="server" BorderColor="#99CCFF" BorderStyle="Solid" 
                    BorderWidth="2px" Font-Bold="True" 
                    Font-Size="Medium" style="margin-left: 4px; margin-top: 5px;">
                    <b style="font-family: calibri; font-size: x-large; font-weight: 800; text-decoration: underline"> Inventory Upload Process:</b> 
                  
                                
                 <table style="margin-top: 10px; width: 355px; height: 28px">  
                    <tr>
                        <td class="styleLeftCell1">           
                        </td> 

                        <td class="styleLeftCell2" >
                           <b style="font-weight: 400; font-family: Calibri; font-size: medium;">1) Select File:</b>
                        </td>  
                         <td class="styleLeftCell3">
                           <asp:FileUpload ID="FileUpload1" runat="server" Width="219px" Height="26px" />
                      </td>     
                    </tr>                   
                </table>
                  
                <table>
                    <tr>
                        <td class="styleLeftCell1"></td> 
                        <td class="styleLeftCell2" >                     
                         <b style="font-weight: 400; font-family: Calibri; font-size: medium;">2) Show File:</b>
                         </td>
                        <td class="styleLeftCell3">
                          <asp:Button ID="IndexButton" runat="server" Text="Show File" 
                            onclick="IndexButton_Click" Width="126px"  />
                          </td>
                    </tr>
                </table>
             
                 <table>
                    <tr>
                        <td class="styleLeftCell1"></td> 
                        <td class="styleLeftCell2">
                        
                         <b style="font-weight: 400; font-family: Calibri; font-size: medium;">3) Upload File:</b>
                         </td>
                        <td class="styleLeftCell3">
                          <asp:Button ID="UploadButton" 
                                runat="server" Text="Upload"  
                            onclick="UploadButton_Click" Width="126px" />  
                            </td>
                      </tr>
                </table>   
                              
                 <table>
                    <tr>
                        <td class="styleLeftCell1">                          
                        </td>                       
                        <td align="center" width="355px">
                          <asp:Button ID="ResetButton" runat="server" Text="Reset" Width="300px"
                           onclick="ResetButton_Click" />  
                          </td>
                    </tr>
                </table>                  
        </asp:Panel>  
               <!--Loading Spinner-->
        <div id="processing">
               <div id="content">
                   <p id="loadingspinner">
                       Loading Please wait...
                   </p>
                </div>
            </div>             
            <div id="loading">
            </div> 
        
       <div id="CBDiv" style="width: 262px">
            
           <table id="OtherSheetsCBTable">
                 <tr>
                    <td class="style10">
                      <asp:CheckBox ID="OtherSheetsCB" runat="server" Text="Other Sheets" 
                       style="font-weight: 400; font-family: Calibri; font-size: medium;" 
                            Enabled="False" />
                     </td>
                  </tr>
           </table>
           <table id="OtherSheetsDDTable">
                   <tr>
                       <td class="style8"></td>
                        <td class="style9">
                         <asp:DropDownList ID="OtherSheetsDD" runat="server" Height="19px" Width="89px" 
                                AutoPostBack="True" onselectedindexchanged="OtherSheetsDD_SelectedIndexChanged">
                         </asp:DropDownList>
                        </td>
                     </tr>
            </table>
            
            <table>
                 <tr>
                     <td>
                     <asp:CheckBox ID="AlphCB" runat="server" Text="Alphabet" 
                       style="font-weight: 400; font-family: Calibri; font-size: medium;" 
                       oncheckedchanged="AlphCB_CheckedChanged" AutoPostBack="True" Enabled="False" />
                     </td>
                  </tr>

                  <tr>
                     <td class="style5">
                     <asp:CheckBox ID="AuthorCB" runat="server" Text="Author First & Last Name" 
                       style="font-weight: 400; font-family: Calibri; font-size: medium;" 
                             Enabled="False" />
                     </td>
                  </tr>
                  <tr>
                    <td class="style6">
                         <asp:CheckBox ID="StatusCB" runat="server" Text="Status" 
                          style="font-weight: 400; font-family: Calibri; font-size: medium;" />
                    </td>
                 </tr>
                  </table>   
              
               <table id="StatusTable">
                 <tr>
                    <td class="style8"></td>
                    <td class="style7">
                         <asp:CheckBox ID="ChangeDeleteCB" runat="server" Text="Delete" 
                         style="font-weight: 400; font-family: Calibri; font-size: medium;" />
                    </td>
                  </tr>
                   <tr>
                     <td class="style8"></td>
                      <td>
                         <asp:CheckBox ID="ChangeActiveCB" runat="server" Text="Active" 
                          style="font-weight: 400; font-family: Calibri; font-size: medium;"/>
                     </td>
                    </tr>
                   <tr>       
                        
                   </tr>
               </table>
            <table id="Table1">
                <tr>
                     <td class="style11">                        
                      <asp:CheckBox ID="DashCB" runat="server" Text="Dashes in SKU" 
                        style="font-weight: 400; font-family: Calibri; font-size: medium;"/>
                    </td>
                </tr>
                <tr>
                    <td class="style11">                        
                      <asp:CheckBox ID="DeleteQryCB" runat="server" Text="Insert Delete Query" 
                        style="font-weight: 400; font-family: Calibri; font-size: medium;"/>
                     </td>
                 </tr>
            </table>                   
         </div> 
                 
        <table>
        <tr>                     
            <td>           
                <asp:Label ID="noticeLabel" runat="server" Font-Bold="True" 
                    Font-Names="Calibri" Font-Size="X-Large" Visible="False"></asp:Label>
            </td>                                                           
        </tr>
        <tr>
        <td>
        <asp:Label ID="ErrorLabel" runat="server" Font-Bold="True" 
                Font-Names="Calibri" Font-Size="Medium" ForeColor="Red" Visible="False"></asp:Label>
                <tr>                     
            <td>           
                <asp:Label ID="InfoLabel" runat="server" Font-Bold="True" 
                Font-Names="Calibri" Font-Size="Medium" Visible="False"></asp:Label>
            </td>                                                           
        </tr>
        </td>
        </tr>
        </table>                   
    </td>
    
    <!-- Right Area -->  
     <td align="left" valign="top" class="style1">                   
        <asp:Panel ID="Panel2" runat="server" BorderColor="#99CCFF" BorderStyle="Solid" 
                    BorderWidth="2px" Font-Bold="True" Height="55px"
                    Font-Size="Medium" style="margin-left: 4px; margin-top: 31px;">
                <table>
                     <tr>
                        <td class="styleRightCell1">
                        </td> 
                        <td class="styleRighCell2">
                            <asp:Label ID="SkuLabel" runat="server" Text="SKU"></asp:Label>
                        </td>       
                        <td class="styleRighCell2" align="center">
                            <asp:Label ID="TitleLabel" runat="server" Text="Title"></asp:Label>
                        </td>
                        <td class="styleRighCell2" align="center">
                             <asp:Label ID="Author1Label" runat="server" Text="Author 1"></asp:Label>
                        </td>
                        <td class="styleRighCell2" align="center">
                             <asp:Label ID="Author2Label" runat="server" Text="Author 2"></asp:Label>
                        </td>
                        <td class="styleRighCell2" align="center">
                             <asp:Label ID="RetailPriceLabel" runat="server" Text="Retail Price"></asp:Label>
                        </td>
                        <td class="styleRighCell2" align="center">
                             <asp:Label ID="TypeLabel" runat="server" Text="Type"></asp:Label>
                        </td>
                        <td class="styleRighCell2" align="center">
                             <asp:Label ID="CategoryLabel" runat="server" Text="Category"></asp:Label>
                        </td>
                        <td class="styleRighCell2" align="center">
                            <asp:Label ID="ReleaseDateLabel" runat="server" Text="Release Date"></asp:Label>
                        </td>
                        <td class="styleRighCell2" align="center">
                              <asp:Label ID="ISBNLabel" runat="server" Text="ISBN"></asp:Label>
                        </td>
                        <td class="styleRighCell2" align="center">
                             <asp:Label ID="ISBN13Label" runat="server" Text="ISBN 13"></asp:Label>
                        </td>
                        <td class="styleRighCell2" align="center">
                            <asp:Label ID="UPCLabel" runat="server" Text="UPC"></asp:Label>
                        </td>
                        <td class="styleRighCell2" align="center">
                            <asp:Label ID="MinQtyLabel" runat="server" Text="Min Qty"></asp:Label>
                        </td>
                        <td class="styleRighCell2" align="center">
                            <asp:Label ID="ShortCutLabel" runat="server" Text="Short Cut"></asp:Label>
                        </td>       
                    </tr>
                    <tr>                   
                        <td class="styleRightCell1">
                         </td>      
                        <td class="styleRighCell2">
                            <asp:TextBox ID="SKUTextBox" runat="server" class="styleRightTB" ></asp:TextBox>
                        </td>
                         <td class="styleRighCell2">
                            <asp:TextBox ID="TitleTextBox" runat="server" class="styleRightTB" ></asp:TextBox>
                        </td>
                        <td class="styleRighCell2">
                            <asp:TextBox ID="Author1TextBox" runat="server" class="styleRightTB" ></asp:TextBox>
                        </td>
                        <td class="styleRighCell2">
                            <asp:TextBox ID="Author2TextBox" runat="server" class="styleRightTB" ></asp:TextBox>
                        </td>
                        <td class="styleRighCell2">
                            <asp:TextBox ID="RetailPriceTextBox" runat="server" class="styleRightTB" ></asp:TextBox>
                        </td>
                        <td class="styleRighCell2">
                            <asp:TextBox ID="TypeTextBox" runat="server" class="styleRightTB" ></asp:TextBox>
                        </td>
                        <td class="styleRighCell2">
                            <asp:TextBox ID="CategoryTextBox" runat="server" class="styleRightTB" ></asp:TextBox>
                        </td>
                        <td class="styleRighCell2">
                            <asp:TextBox ID="ReleaseDateTextBox" runat="server" class="styleRightTB" ></asp:TextBox>
                        </td>
                        <td class="styleRighCell2">
                            <asp:TextBox ID="ISBNTextBox" runat="server" class="styleRightTB" ></asp:TextBox>
                        </td>
                        <td class="styleRighCell2" align="left">
                            <asp:TextBox ID="ISBN13TextBox" runat="server" class="styleRightTB" ></asp:TextBox>
                        </td>
                        <td class="styleRighCell2">
                            <asp:TextBox ID="UPCTextBox" runat="server" class="styleRightTB" ></asp:TextBox>
                        </td>
                        <td class="styleRighCell2">
                            <asp:TextBox ID="MinQtyTextBox" runat="server" class="styleRightTB" ></asp:TextBox>
                        </td>
                        <td class="styleRighCell2">
                            <asp:TextBox ID="ShortCutTextBox" runat="server" class="styleRightTB" ></asp:TextBox>
                        </td>    
                  </tr>        
             </table>
             
             <div id="AuthorEffect" style="width: 1117px; height: 56px; margin-bottom: 0px;">
             <table>
                     <tr>
                        <td >
                        </td> 
                        <td class="styleRighCell2">
                            </td>       
                        <td class="styleRighCell2" align="center">
                            </td>
                        <td class="styleRighCell2" align="center">
                             <asp:Label ID="Author1LastName" runat="server" Text="Author 1 Last"></asp:Label>
                        </td>
                        <td class="styleRighCell2" align="center">
                             <asp:Label ID="Author2LastName" runat="server" Text="Author 2 Last"></asp:Label>
                        </td>
                        <td class="styleRighCell2" align="center">
                             </td>
                        <td class="styleRighCell2" align="center">
                             </td>
                        <td class="styleRighCell2" align="center">
                             </td>
                        <td class="styleRighCell2" align="center">
                            </td>
                        <td class="styleRighCell2" align="center">
                             </td>
                        <td class="styleRighCell2" align="center">
                              </td>
                        <td class="styleRighCell2" align="center">
                             </td>
                        <td class="styleRighCell2" align="center">
                            </td>
                        <td class="styleRighCell2" align="center">
                            </td>
                        <td class="styleRighCell2" align="center">
                            </td>       
                    </tr>
                    
                    <tr>                   
                        <td class="styleRightCell1">
                         </td>      
                        <td class="styleRighCell2">
                            </td>
                         <td class="styleRighCell2">
                             </td>
                        <td class="styleRighCell2">
                            <asp:TextBox ID="Author1LastNameTB" runat="server" class="styleRightTB" ></asp:TextBox>
                        </td>
                        <td class="styleRighCell2">
                            <asp:TextBox ID="Author2LastNameTB" runat="server" class="styleRightTB" ></asp:TextBox>
                        </td>
                        <td class="styleRighCell2">
                            </td>
                        <td class="styleRighCell2">
                            </td>
                        <td class="styleRighCell2">
                            </td>
                        <td class="styleRighCell2">
                            </td>
                        <td class="styleRighCell2">
                            </td>
                        <td class="styleRighCell2">
                            </td>
                        <td class="styleRighCell2" align="left">
                            </td>
                        <td class="styleRighCell2">
                            </td>
                        <td class="styleRighCell2">
                            </td>
                        <td class="styleRighCell2">
                            </td>    
                  </tr>        
             </table>           
             </div>
                                                                      
        </asp:Panel> 
    <div style="overflow:auto;width:1124px; margin-top: 0px;">
            <table align="center">  
                <tr>         
                    <td class="style3">   
                         <asp:GridView ID="GridView1" runat="server" CellPadding="4"     
                                ForeColor="#333333" Width="692px" align="center" 
                                style="margin-Left: 6px" Height="121px" 
                                BorderStyle="Solid" ShowFooter="True" 
                             onrowdatabound="GridView1_RowDataBound" AllowPaging="True" 
                             onpageindexchanging="GridView1_PageIndexChanging" PageSize="5" >
                                <FooterStyle BackColor="#507CD1" BorderColor="Black" Font-Bold="True" 
                                    ForeColor="White" />
                                <RowStyle BackColor="#EFF3FB" BorderStyle="None" BorderWidth="1px" 
                                    HorizontalAlign="Center" />
                                <SelectedRowStyle BackColor="#D1DDF1" ForeColor="#333333" Font-Bold="True" />
                                <PagerStyle BackColor="#2461BF" ForeColor="White" 
                                    HorizontalAlign="Center" />
                                <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                <EditRowStyle BorderColor="White" BorderStyle="None" BorderWidth="5px" 
                                    BackColor="#2461BF" />
                                <AlternatingRowStyle BackColor="White" BorderColor="White" BorderStyle="None" />
                         </asp:GridView>                        
                       </td> 
                    </tr>                            
            </table>
            </div>
    </td>            
</table>
	</td>
</tr>
   <!--  Page code ends  -->
    <tr>
    <td align="left"></td>
    </tr>
<tr>
	<td align="left">
	<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td>
	<table border="0" cellpadding="0" cellspacing="0"><tr><td height="1"></td></tr></table></td></tr></table>

	<table border="0" cellpadding="0" cellspacing="0" style="width: 100%"><tr><td bgcolor="#336699">
	<table border="0" cellpadding="0" cellspacing="0"><tr><td height="1"></td></tr></table></td></tr></table>

	<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td>
	<table border="0" cellpadding="0" cellspacing="0"><tr><td height="2"></td></tr></table></td></tr></table>
	<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td>
	<table border="0" cellpadding="0" cellspacing="0"><tr><td height="2"></td></tr></table></td></tr></table>

   <!--copyright2-->
   <ctr:copyright2 runat="server" id="copyright2" />
    <center>
	</center>
	<br><br/>
</td>
</tr>
</table>
    </form>
</body>
</html>

