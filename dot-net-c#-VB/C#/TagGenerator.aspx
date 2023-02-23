<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="SDITagGenerator.aspx.cs" Inherits="SDITagGenerator" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="large-12 column fullWidth">
        <h1>SDI Tag Generator</h1>
    </div>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">

    <div class="row">
        <div class="large-4 columns">
            <fieldset id="Fieldset1" runat="server">
                <legend>Diagram Title Information</legend>
                <div class="row">
                    <div class="small-6 columns">
                        <label>
                            Line Abbreviation:
                <input id="LineAbbrTB" type="text" placeholder="X" runat="server" />
                        </label>
                    </div>
                    <div class="small-6 columns end">
                        <label>
                            Area Abbreviation:
                <input id="SubAreaTB" type="text" placeholder="X" runat="server" />
                        </label>
                    </div>
                </div>
            </fieldset>
        </div>
        <div class="large-5 column">
            <fieldset id="Fieldset2" runat="server">
                <legend>Tag Information</legend>
                <div class="row">
                        <div class="medium-2 columns">
                            <label>
                                Part 1:
                      <input id="Section1TB" type="text" placeholder="X" runat="server" />
                            </label>
                        </div>
                        <div class="medium-2 columns">
                            <label>
                                Part 2:
                        <input id="Section2TB" type="text" placeholder="XX" runat="server" />
                            </label>
                        </div>
                        <div class="medium-2 columns">
                            <label>
                                Part 3:
                <input id="Section3TB" type="text" placeholder="X" runat="server" />
                            </label>
                        </div>
                        <div class="medium-2 columns">
                            <label>
                                Part 4:
                <input id="Section4TB" disabled="disabled" type="text" placeholder="XXXXXX" runat="server" />
                            </label>
                        </div>
                        <div class="medium-2 columns end">
                            <label>
                                Part 5:
                <input id="Section5TB" type="text" placeholder="X" runat="server" />
                            </label>
                        </div>
                </div>
            </fieldset>
        </div>
    </div>
    <div class="large-6 columns">
        <fieldset id="Fieldset3" runat="server">
            <legend>Process</legend>
            <div class="row">
                <div class="large-6 columns">
                    <asp:fileupload id="FileUpload1" runat="server" accept=".csv" />
                    <asp:button id="Upload" runat="server" text="upload" onclick="Upload_Click" />
                    <asp:label id="AllGoodLab" runat="server" text="Label">Good</asp:label>
                </div>
            </div>
        </fieldset>
    </div>


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="Server">


    <script src="public/js/min/jquery.min.js"></script>
    <script src="public/js/min/foundation.min.js"></script>
    <script src="public/js/nonmin/app.js"></script>
    <script src="public/js/nonmin/TagGenerator.js"></script>

    <script type="text/javascript">
        window.onload = function () {
            TagGenerator();
        };
    </script>
</asp:Content>
