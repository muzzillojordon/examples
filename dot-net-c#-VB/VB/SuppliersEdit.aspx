<%@ Page Language="VB" AutoEventWireup="false" CodeFile="SuppliersEdit.aspx.vb" Inherits="SuppliersEdit" %>

<%@ Register assembly="DevExpress.Web.v13.1, Version=13.1.8.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxRoundPanel" tagprefix="dxrp" %>
<%@ Register assembly="DevExpress.Web.v13.1, Version=13.1.8.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxPanel" tagprefix="dxp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Furniture First - Suppliers Edit</title>
    <link REL="stylesheet" HREF="include/Styles.css" TYPE="text/css">

</head>
<!-- Orange=#CC6600, Blue=#336699, Silver=#CCCCCC -->
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="white">
    <form id="form1" runat="Server">
<!--#include file="include/menuBanner.aspx"-->

<table border="0" cellpadding="0" cellspacing="0" width="100%">

<!--#include file="include/MainMenu.aspx"-->

<tr>
<td align="left">
	<table border="0" cellpadding="0" cellspacing="0">
	<tr>
		<!-- LEFT Column -->
		<td align="left" valign="top" bgcolor="white" height="100%" width="170">
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

   <!--#include file="include/UserLeftNav.aspx"-->
   

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
			    

   <!--#include file="include/cssLeftNav.asp"-->
	

				
				<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td>
				<table border="0" cellpadding="0" cellspacing="0"><tr><td height="8"></td></tr></table></td></tr></table>
								

				<!-- Content End -->
				</td>
				<td width="3"></td>
				</tr>
				</table>

				</td>
			</tr>
			</table>
		</td>
		<!-- LEFT Column -->
		
		<!-- Middle Line #CECECE -->
		<td bgcolor="#336699" height="100%" width="1">&nbsp;
			<!--<table border=0 cellpadding=0 cellspacing=0 width='100%'><tr><td bgcolor=white>			<table border=0 cellpadding=0 cellspacing=0><tr><td height=1></td></tr></table></td></tr></table>			-->
		</td>
		
		<!-- Middle Area -->
<!--  Page code begins here...   -->
		<td align="left" valign="top" width="*">

  <table>
    <tr>
      <td align="center"><font class="Font8Boldv">
         &nbsp;&nbsp;Location: <a href="SuppliersListing.aspx">Suppliers List</a> > Suppliers Edit</font>&nbsp;&nbsp;
      </td>
    </tr>
  </table>
  
    <table>
      
     <tr>
      <td width="30"></td>
      <td width="500"><br />
        <table>
          <tr>
            <td width="20"></td> 
            <td >
               <b>SupplierNbr:</b>
            </td>
            <td>
                <asp:TextBox ID="SupplierNbrTextBox" runat="Server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="SupplierNbrTextBoxRequiredFieldValidator1" runat="Server" ErrorMessage="This field cannot be blank." ControlToValidate="SupplierNbrTextBox"></asp:RequiredFieldValidator>
            </td>
          </tr>
          <tr>
            <td width="20"></td> 
            <td >
               <b>Name:</b>
            </td>
            <td>
                <asp:TextBox ID="NameTextBox" runat="Server"></asp:TextBox>
            </td>
          </tr>
          <tr>
            <td width="20"></td> 
            <td >
               
                <b>Address1:</b>
            </td>
            <td>
                <asp:TextBox ID="Address1TextBox" runat="Server"></asp:TextBox>
            </td>
          </tr>
          <tr>
            <td width="20"></td> 
            <td >
            <b>Address2:</b>
            </td>
            <td>
                <asp:TextBox ID="Address2TextBox" runat="Server"></asp:TextBox>
            </td>
          </tr>
          <tr>
            <td width="20"></td> 
            <td >
            <b>City:</b>
            </td>
            <td>
                <asp:TextBox ID="CityTextBox" runat="Server"></asp:TextBox>
            </td>
          </tr>
          <tr>
            <td width="20"></td> 
            <td >
            <b>State:</b>
            </td>
            <td>
                <asp:TextBox ID="StateTextBox" runat="Server"></asp:TextBox>
            </td>
          </tr>
          <tr>
            <td width="20"></td> 
            <td >
            <b>Zip Code:</b>
            </td>
            <td>
                <asp:TextBox ID="ZipCodeTextBox" runat="Server"></asp:TextBox>
            </td>
          </tr>
          <tr>
            <td width="20"></td> 
            <td >
            <b>Contact Name:</b>
            </td>
            <td>
                <asp:TextBox ID="ContactNameTextBox" runat="Server"></asp:TextBox>
            </td>
          </tr>
          <tr>
            <td width="20"></td> 
            <td >
              <b>Phone1:</b>
            </td>
            <td>
                <asp:TextBox ID="Phone1TextBox" runat="Server"></asp:TextBox>
            </td>
          </tr>
          <tr>
            <td width="20"></td> 
            <td >
              <b>FaxPhone:</b>
            </td>
            <td>
                <asp:TextBox ID="FaxPhoneTextBox" runat="Server"></asp:TextBox>
            </td>
          </tr>
          <tr>
            <td width="20"></td> 
            <td >
            
   
    <table align="center" border="0" cellspacing="0" cellpadding="3" > 
       <tr>
         <td width="20"></td> 
         <td >
            <asp:Label ID="ErrorMessageLabel1" runat="Server" ForeColor="Red"></asp:Label>
         </td>
       </tr>
    </table>
    
    <table align="center">
        <tr>
         <td align="center" colspan="3">
             <asp:Button ID="SaveButton" runat="Server" Text="Save" />
         </td>
         <td align="center" colspan="3">
             <asp:Button ID="ReturnButton" runat="Server" Text="Return" CausesValidation="False" />
         </td>
       </tr> 
    </table> 
        
             
          
          <br /><br /><br /><br /><br /><br /><br /><br /><br /></td>
      <td></td>
    </tr>
   
  
    
   
  </table>
  
  <!--  Page code ends  -->
		<!-- Middle Area END -->
	</td>
	</tr>
	</table>
</td>
</tr>
<tr>
<td align="left">

	<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td>
	<table border="0" cellpadding="0" cellspacing="0"><tr><td height="1"></td></tr></table></td></tr></table>

	<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td bgcolor="#336699">
	<table border="0" cellpadding="0" cellspacing="0"><tr><td height="1"></td></tr></table></td></tr></table>

	<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td>
	<table border="0" cellpadding="0" cellspacing="0"><tr><td height="2"></td></tr></table></td></tr></table>
	<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td>
	<table border="0" cellpadding="0" cellspacing="0"><tr><td height="2"></td></tr></table></td></tr></table>

   <!--#include file="include/copyright2.asp"-->


	</center>
	<br><br>
	
</td>
</tr>
</table>
    </form>
</body>
</html>

