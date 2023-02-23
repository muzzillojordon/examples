<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="LogsDashboard.aspx.cs" Inherits="LogsDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="large-12 column fullWidth">
        <h1 id="LogIDLable" runat="server">Log Dashboard</h1>
    </div>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">


    <%--Container for items Jtable widget--%>
    <div class="row">
        <div id="BoilerTableContainer" class="large-12 column">
        </div>
    </div>


    <%--BoilerLog Popup Modal--%>
    <div id="BoilerModal" class="reveal-modal" data-reveal="" aria-labelledby="" aria-hidden="true" role="dialog">
        <%--BOILER ONE--%>
        <div class="row">
            <div class="large-12 columns">
                <fieldset id="Fieldset1" runat="server">
                    <legend>Boiler One</legend>

                    <%--Boiler One Running--%>
                    <div class="row">
                        <div class="large-12 columns">
                            <label class="TextboxTitleText">Boiler One Running</label>
                            <div class="switch">
                                <input id="B1_BoilerRunningCB" type="checkbox" runat="server" />
                                <label for="B1_BoilerRunningCB">
                                </label>
                            </div>
                        </div>
                    </div>

                    <%--Boiler One Form--%>
                    <div class="row" id="B1_BoilerForm">

                        <%--Boiler One Visual Inspection--%>
                        <div class="row">
                            <div class="large-12 columns">
                                <label class="TextboxTitleText">Visual Inspection</label>
                                <div class="switch">
                                    <input id="B1_VisualInpectoinCB" type="checkbox" runat="server" />
                                    <label for="B1_VisualInpectoinCB"></label>
                                </div>
                            </div>
                        </div>

                        <%--Boiler One Pressure--%>
                        <div class="row">
                            <div class="large-3 columns">
                                <label class="TextboxTitleText">
                                    Boiler One Pressure
                                     <%--<input type="text" ID="pubNameText" placeholder="large-12.columns" />--%>
                                    <asp:TextBox Class="textboxs validate[required]" ClientIDMode="Static" type="Text" ID="NameTB" placeholder="Boiler 1 Pressure" runat="server"></asp:TextBox>
                                </label>
                            </div>
                        </div>

                        <%--Boiler One Burner Abnormalities--%>
                        <div class="row">
                            <div class="large-12 columns">
                                <label class="TextboxTitleText">Burner Abnormalities</label>
                                <div class="switch">
                                    <input id="B1_BurnerAbnormalitiesCB" type="checkbox" runat="server" />
                                    <label for="B1_BurnerAbnormalitiesCB"></label>
                                </div>
                            </div>
                        </div>

                        <%--Boiler One LWCO Blowdown--%>
                        <div class="row">
                            <div class="large-12 columns">
                                <label class="TextboxTitleText">LWCO Blowdown</label>
                                <div class="switch">
                                    <input id="B1_LWCOCBCB" type="checkbox" runat="server" />
                                    <label for="B1_LWCOCBCB"></label>
                                </div>
                            </div>
                        </div>

                        <%--Boiler One Bottom BlowDown--%>
                        <div class="row">
                            <div class="large-12 columns">
                                <label class="TextboxTitleText">Bottom Blowdown</label>
                                <div class="switch">
                                    <input id="B1_BottomBlwDwnCB" type="checkbox" runat="server" />
                                    <label for="B1_BottomBlwDwnCB"></label>
                                </div>
                            </div>
                        </div>

                        <%--Boiler One Conductivity--%>
                        <div class="row">
                            <div class="large-3 columns">
                                <label class="TextboxTitleText">
                                    Boiler One Conductivity Measurement (HandHeld)
                                <asp:TextBox Class="textboxs validate[required]" ClientIDMode="Static" type="Text" ID="TextBox1" placeholder="Boiler 1 Conductivity" runat="server"></asp:TextBox>
                                </label>
                            </div>
                        </div>

                        <%--Boiler One Conductivity Readout--%>
                        <div class="row">
                            <div class="large-3 columns">
                                <label class="TextboxTitleText">
                                    Boiler One Conductivity Measurement (Controller)
                                <asp:TextBox Class="textboxs validate[required]" ClientIDMode="Static" type="Text" ID="TextBox2" placeholder="Boiler 1 Conductivity Readout" runat="server"></asp:TextBox>
                                </label>
                            </div>
                        </div>

                    </div>
                </fieldset>
            </div>
        </div>

        <%--BOILER TWO--%>
        <div class="row">
            <div class="large-12 columns">
                <fieldset id="Fieldset2" runat="server">
                    <legend>Boiler Two</legend>

                    <%--Boiler Two Running--%>
                    <div class="row">
                        <div class="large-12 columns">
                            <label class="TextboxTitleText">Boiler Two Running</label>
                            <div class="switch">
                                <input id="B2_BoilerRunningCB" type="checkbox" runat="server" />
                                <label for="B2_BoilerRunningCB">
                                </label>
                            </div>
                        </div>
                    </div>

                    <%--Boiler Two Form--%>
                    <div class="row" id="B2_BoilerForm">

                        <%--Boiler Two Visual Inspection--%>
                        <div class="row">
                            <div class="large-12 columns">
                                <label class="TextboxTitleText">Visual Inspection</label>
                                <div class="switch">
                                    <input id="B2_VisualInpectoinCB" type="checkbox" runat="server" />
                                    <label for="B2_VisualInpectoinCB"></label>
                                </div>
                            </div>
                        </div>

                        <%--Boiler Two Pressure--%>
                        <div class="row">
                            <div class="large-3 columns">
                                <label class="TextboxTitleText">
                                    Boiler Two Pressure
                                     <%--<input type="text" ID="pubNameText" placeholder="large-12.columns" />--%>
                                    <asp:TextBox Class="textboxs validate[required]" ClientIDMode="Static" type="Text" ID="TextBox3" placeholder="Boiler 1 Pressure" runat="server"></asp:TextBox>
                                </label>
                            </div>
                        </div>

                        <%--Boiler Two Burner Abnormalities--%>
                        <div class="row">
                            <div class="large-12 columns">
                                <label class="TextboxTitleText">Burner Abnormalities</label>
                                <div class="switch">
                                    <input id="B2_BurnerAbnormalitiesCB" type="checkbox" runat="server" />
                                    <label for="B2_BurnerAbnormalitiesCB"></label>
                                </div>
                            </div>
                        </div>

                        <%--Boiler Two LWCO Blowdown--%>
                        <div class="row">
                            <div class="large-12 columns">
                                <label class="TextboxTitleText">LWCO Blowdown</label>
                                <div class="switch">
                                    <input id="B2_LWCOCBCB" type="checkbox" runat="server" />
                                    <label for="B2_LWCOCBCB"></label>
                                </div>
                            </div>
                        </div>

                        <%--Boiler Two Bottom BlowDown--%>
                        <div class="row">
                            <div class="large-12 columns">
                                <label class="TextboxTitleText">Bottom Blowdown</label>
                                <div class="switch">
                                    <input id="B2_BottomBlwDwnCB" type="checkbox" runat="server" />
                                    <label for="B2_BottomBlwDwnCB"></label>
                                </div>
                            </div>
                        </div>

                        <%--Boiler Two Conductivity--%>
                        <div class="row">
                            <div class="large-3 columns">
                                <label class="TextboxTitleText">
                                    Boiler Two Conductivity Measurement (HandHeld)
                                <asp:TextBox Class="textboxs validate[required]" ClientIDMode="Static" type="Text" ID="TextBox4" placeholder="Boiler 1 Conductivity" runat="server"></asp:TextBox>
                                </label>
                            </div>
                        </div>

                        <%--Boiler Two Conductivity Readout--%>
                        <div class="row">
                            <div class="large-3 columns">
                                <label class="TextboxTitleText">
                                    Boiler Two Conductivity Measurement (Controller)
                                <asp:TextBox Class="textboxs validate[required]" ClientIDMode="Static" type="Text" ID="TextBox5" placeholder="Boiler 1 Conductivity Readout" runat="server"></asp:TextBox>
                                </label>
                            </div>
                        </div>

                    </div>
                </fieldset>
            </div>
        </div>

        <div class="row hide-on-print">
            <ul class="stack-for-small button-group">
                <li><a id="PubModalCancelButt" class="button alert" href="#" onclick="closeModal('#BoilerModal')">Close</a></li>
                <li><a id="ModalPrintFormDataButt" class="button" onclick="printContent('#BoilerModal')">Print</a></li>
            </ul>
        </div>
        <a class="close-reveal-modal hide-on-print" aria-label="Close">&#215;</a>
    </div>


    <div class="row" id="RM_Logs_ButtonsID" runat="server">
        <div class="columns large-2">
            <ul class="stack button-group">
                <li><a href="BoilerLog.aspx" id="CPLBoilerLogNewButt" class="button" runat="server">New Log</a></li>
                <li><a id="BackButt" class="button alert" runat="server">Back</a></li>
            </ul>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="Server">

    <%--<script src="public/js/all-jtable-bundle.min.js"></script>--%>
    <script src="public/js/all-jtable-bundle.js"></script>
    <script src="public/js/nonmin/LogsDashboard.js"></script>


    <script type="text/javascript">
        window.onload = function () {
            LogsDashboardScript();
        };
    </script>
</asp:Content>

