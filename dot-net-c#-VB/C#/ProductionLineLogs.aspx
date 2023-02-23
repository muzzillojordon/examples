<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="ProductionLineLogs.aspx.cs" Inherits="ProductionLineLogs" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

        <div class="large-12 column fullWidth">
            <h1 id="ProdLineLable" runat="server">Logs</h1>
        </div>

    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">

        <div class="row" id="CPL_Logs_ButtonsID" runat="server" visible="false">
            <div class="columns large-6">
                <ul class="stack button-group">
                    <li><a id="CPL_BoilerLogbutt" class="button" runat="server">Boiler Log</a></li>
                    <li><a id="CPL_UtilityLogButt" class="button" runat="server">CPL Utility Daily Log</a></li>
                    <li><a id="BackButt" href="LogsLineSelection.aspx" class="button alert" runat="server">Back</a></li>
                </ul>
            </div>
        </div>

        <div class="row" id="PPPL_Logs_ButtonsID" runat="server" visible="false">
            <div class="columns large-6">
                <ul class="stack button-group">
                    <li><a id="PPPL_ROLogButt" class="button" runat="server">Reverse Osmosis Log</a></li>
                    <li><a id="PPPL_UtilityLogButt" class="button" runat="server">PPPL Utility Daily Log</a></li>
                </ul>
            </div>
        </div>

        <div class="row" id="RM_Logs_ButtonsID" runat="server" visible="false">
            <div class="columns large-6">
                <ul class="stack button-group">
                    <li><a id="RM_GreaseLog_Butt" class="button" runat="server">Mill Grease Log</a></li>
                    <li><a id="RM_UtilityLog_Butt" class="button" runat="server">RM Utility Daily Log</a></li>
                </ul>
            </div>
        </div>


    </asp:Content>
    <asp:Content ID="Content3" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="Server">
        <script src="public/js/min/jquery.min.js"></script>
        <script src="public/js/min/foundation.min.js"></script>
        <script src="public/js/nonmin/app.js"></script>
    </asp:Content>