<%@ Page Language="VB" AutoEventWireup="false" CodeFile="RawMaterialsList.aspx.vb" Inherits="RawMaterialsList" %>

<%@ Register assembly="DevExpress.Web.v13.1, Version=13.1.8.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxRoundPanel" tagprefix="dxrp" %>
<%@ Register assembly="DevExpress.Web.v13.1, Version=13.1.8.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxPanel" tagprefix="dxp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Furniture First - RawMaterialsList</title>
    <link REL="stylesheet" HREF="include/Styles.css" TYPE="text/css">

    <style type="text/css">
        .style1
        {
            width: 894px;
            height: 277px;
        }
        .style2
        {
            width: 652px;
            height: 330px;
        }
        .style3
        {
            width: 655px;
            height: 101%;
        }
        .style8
        {
            height: 101%;
        }
        .style9
        {
            width: 652px;
            height: 71px;
        }
    </style>

</head>
<!-- Orange=#CC6600, Blue=#336699, Silver=#CCCCCC -->
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="white">
    <form id="form1" runat="server">
<!--#include file="include/menuBanner.aspx"-->

<table border="0" cellpadding="0" cellspacing="0" width="100%">

<!--#include file="include/MainMenu.aspx"-->

<tr>
<td align="left" class="style1">
	<table border="0" cellpadding="0" cellspacing="0">
	<tr>
		<!-- LEFT Column -->
		<td align="left" valign="top" bgcolor="white" width="170" class="style8">
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
		<td bgcolor="#336699" class="style8">&nbsp;
			<!--<table border=0 cellpadding=0 cellspacing=0 width='100%'><tr><td bgcolor=white>			<table border=0 cellpadding=0 cellspacing=0><tr><td height=1></td></tr></table></td></tr></table>			-->
		</td>
		
		<!-- Middle Area -->
<!--  Page code begins here...   -->
		<td align="left" valign="top" class="style3">
		
  <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
            DeleteCommand="Delete from RawMaterials where Type=@Type">
            <DeleteParameters>
            <asp:Parameter Type="String" Name="Type"></asp:Parameter>
            </DeleteParameters>
  </asp:SqlDataSource>

  <table>
    <tr>
      <td align="center"><font class="Font8Boldv">
         &nbsp;&nbsp;Location: <a href="RawMaterialsList.aspx">RawMaterials List</a></font>&nbsp;&nbsp;
     </td>
    </tr>
  </table>


 <table>
     
     <tr>
      <td width="5"></td>
      <td width="800">
     
        <table>
          <tr>
            <td>
              <table>
               <tr>
                  <td>
                  <asp:DropDownList ID="drpField" runat="server" > 
                     <asp:ListItem Value="Type">Matl. Type</asp:ListItem>
                     <asp:ListItem Value="Diameter">Diameter</asp:ListItem>
                  </asp:DropDownList>
                  </td>
                  <td>
                  <asp:DropDownList ID="drpOp" runat="server" >
                     <asp:ListItem Value="EQ">Equals</asp:ListItem>
                     <asp:ListItem Value="B">Begins with</asp:ListItem>
                     <asp:ListItem Value="E">Ends with</asp:ListItem>
                     <asp:ListItem Value="Con">Contains</asp:ListItem>
                  </asp:DropDownList>
                  </td>
                  <td>
                     <asp:TextBox ID="txtValue" size="25" runat="server"></asp:TextBox>
                    
                  
                     
                     <asp:Button ID="SearchButton" runat="server" Text="Search" />
                     <asp:Button ID="ResetButton" runat="server" Text="Reset" />
                  </td>
               </tr>
            </table>  
            </td>
         </tr>
        </table>
       </td>
     </tr>

  
  
  
      
     <tr>
      <td width="5"></td>
      <td width="800">
        <table>
          <tr>
            <td>
            
            <table align="center" >
             <tr>
              <td>
                  <asp:Button ID="AddButton" runat="server" Text="Add New Raw Material" />
              </td>
             </tr>
            </table>
            
            <br />
                  
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="#EEF2FB"
            BorderColor="Black" BorderWidth="2px" CellPadding="2" DataKeyNames="Type,Diameter,BarCoilInd" DataSourceID="SqlDataSource1"
            ForeColor="black" GridLines="None" Width="700px" align="center" AllowPaging="True" 
                    AllowSorting="True" PageSize="20" style="margin-top: 18px">
                    <PagerSettings Position="Top" />
            <FooterStyle BackColor="Tan" />
            <Columns>
                <asp:BoundField DataField="Type" HeaderText="Type" ReadOnly="True" SortExpression="Type" HtmlEncode="false" HeaderStyle-HorizontalAlign="Left">
                    <ItemStyle HorizontalAlign="left" />
                </asp:BoundField>
                
                <asp:BoundField DataField="Diameter" HeaderText="Diameter" ReadOnly="True" SortExpression="Diameter" HtmlEncode="false" HeaderStyle-HorizontalAlign="Left">
                    <ItemStyle HorizontalAlign="left" />
                </asp:BoundField>
                <asp:BoundField DataField="BarCoilInd" HeaderText="Bar Coil Ind" ReadOnly="True" SortExpression="BarCoilInd" HeaderStyle-HorizontalAlign="Left">
                    <ItemStyle HorizontalAlign="left" />
                    </asp:BoundField>
                <asp:BoundField DataField="LbsOnHand" HeaderText="Lbs On Hand" ReadOnly="True" SortExpression="LbsOnHand" HtmlEncode="false" HeaderStyle-HorizontalAlign="Left">
                    <ItemStyle HorizontalAlign="left"  />
                </asp:BoundField>
                <asp:BoundField DataField="LbsOnRelease" HeaderText="Lbs On Release" ReadOnly="True" SortExpression="LbsOnRelease" HtmlEncode="false" HeaderStyle-HorizontalAlign="Left">
                    <ItemStyle HorizontalAlign="left"  />
                </asp:BoundField>
                <asp:BoundField DataField="LbsCommitted" HeaderText="Lbs Committed" ReadOnly="True" SortExpression="LbsCommitted" HtmlEncode="false" HeaderStyle-HorizontalAlign="Left">
                    <ItemStyle HorizontalAlign="left"  />
                </asp:BoundField>
                <asp:BoundField DataField="SaftyStockLbs" HeaderText="Safty Stock Lbs" ReadOnly="True" SortExpression="SaftyStockLbs" HtmlEncode="false" HeaderStyle-HorizontalAlign="Left">
                    <ItemStyle HorizontalAlign="left"  />
                </asp:BoundField>
                 <asp:BoundField DataField="MinOrderQty" HeaderText="Min Order Qty" ReadOnly="True" SortExpression="MinOrderQty" HtmlEncode="false" HeaderStyle-HorizontalAlign="Left">
                    <ItemStyle HorizontalAlign="left"  />
                </asp:BoundField>
               
                <asp:HyperLinkField DataNavigateUrlFields="Type,Diameter,BarCoilInd" DataNavigateUrlFormatString="RawMaterialsEdit.aspx?Type={0}&Diameter={1}&BarCoilInd={2}&R=C"
                    HeaderText="Actions" Text="Edit">
                    <ItemStyle HorizontalAlign="Center" />
                </asp:HyperLinkField>
                
                <asp:TemplateField HeaderText="Delete" HeaderStyle-HorizontalAlign="Center">
                <ItemTemplate >
                    <asp:Button ID="btnDelete" Text="Delete" runat="server"
                    OnClientClick="return confirm('Are you sure you want to delete this Raw Materials?');"
                    CommandName="Delete" />
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
                
            </Columns>
            <SelectedRowStyle BackColor="DarkSlateBlue" ForeColor="GhostWhite" />
            <PagerStyle BackColor="#EEF2FB" ForeColor="DarkSlateBlue" HorizontalAlign="Center" />
            <HeaderStyle BackColor="#0066FF" Font-Bold="True" />
            <AlternatingRowStyle BackColor="#DDE9FB" />
        </asp:GridView>
             
                  
                 
                     
                  
              </td>
               
               <tr>
                  <td class="style2">
                      &nbsp;</td>
               
            </table>  
            </td>
         </tr>
        </table>
       </td>
     </tr>
  
  
      
     </td>
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

				    
				    
