<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="LogsLineSelection.aspx.cs" Inherits="LogsLineSelection" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <div class="large-12 column fullWidth">
        <h1>SDI Logs Dashboard</h1>
    </div>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">

    <div class="row">
        <div class="large-12 columns">
            <fieldset id="Fieldset1" runat="server">
                <legend>Select Production Line</legend>
                <div id="WidgetDiv" class="row" data-equalizer="topWidgets">
                    <%--TOP WIDGET 1 --%>
                    <div class="large-4 column">
                        <a id="CPL_LinkID" class="button" runat="server">Continuous Pickle Line</a>
                    </div>
                    <%--TOP WIDGET 2 --%>
                    <div class="large-4 column">
                        <a id="PPPL_LinkID" class="button" runat="server">Push Pull Pickle Line</a>
                    </div>
                    <%--TOP WIDGET 3 --%>
                    <div class="large-4 column">
                        <a id="RM_LinkID" class="button" runat="server">ReversingMill</a>
                    </div>
                </div>
            </fieldset>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContentPlaceHolder" Runat="Server">
        <script src="public/js/min/jquery.min.js"></script>
    <script src="public/js/min/foundation.min.js"></script>
    <script src="public/js/nonmin/app.js"></script>
</asp:Content>

