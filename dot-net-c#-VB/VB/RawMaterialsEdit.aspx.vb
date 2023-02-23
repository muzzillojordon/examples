Imports System.Data.SqlClient
Imports System.Data
Partial Class RawMaterialsEdit
    Inherits System.Web.UI.Page
    Public Type As String
    Public Diameter As String
    Public BarCoilInd As String
    Public userType As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then




            Dim Add = Request.QueryString("A")
            Dim Type = Request.QueryString("Type")
            Dim Diameter = Request.QueryString("Diameter")
            Dim BarCoilInd = Request.QueryString("BarCoilInd")

            Dim myRS As RawMaterialsEditLocdb = New RawMaterialsEditLocdb

            'Drop Down lists**********************************
            'Type DownList 
            TypeDownList.DataSource = myRS.GetTypeDownList() 'Getting Info for Type dropdown
            TypeDownList.DataBind()
            TypeDownList.Items.Insert(0, "") 'Setting the first row in Type drop down blank

            'Diameter DropDownList 
            DiameterDropDownList.DataSource = myRS.GetDiameterDropDownList() 'Getting Info for Diameter dropdown
            DiameterDropDownList.DataBind()
            DiameterDropDownList.Items.Insert(0, "") 'Setting the first row in Diameter drop down blank


            'BarCoilInd DownList
            BarCoilIndDropDownList.DataSource = myRS.GetBarCoilIndDropDownList() 'Getting Info for BarCoilInd dropdown
            BarCoilIndDropDownList.DataBind()
            BarCoilIndDropDownList.Items.Insert(0, "") 'Setting the first row in BarCoilInd drop down blank

            'UnitofMeasureDropDownList DownList
            UnitofMeasureDropDownList.DataSource = myRS.GetUnitofMeasureDropDownList() 'Getting Info for BarCoilInd dropdown
            UnitofMeasureDropDownList.DataBind()
            UnitofMeasureDropDownList.Items.Insert(0, "") 'Setting the first row in BarCoilInd drop down blank


            If Add = "Y" Then  'Adding
                


            Else  'Editing


                Dim myRawMaterialsReader As SqlDataReader
                myRawMaterialsReader = myRS.GetRawMaterialsRec(Type, Diameter, BarCoilInd)

                If myRawMaterialsReader.Read Then

                   

                    'TypeDownList
                    If myRawMaterialsReader.Item("Type") Is System.DBNull.Value Then
                        TypeDownList.Text = ""
                    Else
                        TypeDownList.Text = myRawMaterialsReader.Item("Type")
                    End If
                    'make TypeDownList unable to make changes in edit mode
                    TypeDownList.Enabled = False

                    'DiameterDropDownList
                    If myRawMaterialsReader.Item("Diameter") Is System.DBNull.Value Then
                        DiameterDropDownList.Text = ""
                    Else
                        DiameterDropDownList.Text = myRawMaterialsReader.Item("Diameter")
                    End If
                    'make DiameterDropDownList unable to make changes in edit mode
                    DiameterDropDownList.Enabled = False

                    'BarCoilIndDropDownList
                    If myRawMaterialsReader.Item("BarCoilInd") Is System.DBNull.Value Then
                        BarCoilIndDropDownList.Text = ""
                    Else
                        BarCoilIndDropDownList.Text = myRawMaterialsReader.Item("BarCoilInd")
                    End If
                    'make BarCoilIndDropDownList unable to make changes in edit mode
                    BarCoilIndDropDownList.Enabled = False
                    'UnitofMeasureDropDownList
                    If myRawMaterialsReader.Item("UOM") Is System.DBNull.Value Then
                        UnitofMeasureDropDownList.Text = ""
                    Else
                        UnitofMeasureDropDownList.Text = myRawMaterialsReader.Item("UOM")
                    End If
                    If myRawMaterialsReader.Item("SaftyStockLbs") Is System.DBNull.Value Then
                        SaftyStockLbsTextBox.Text = ""
                    Else
                        SaftyStockLbsTextBox.Text = myRawMaterialsReader.Item("SaftyStockLbs")
                    End If
                    If myRawMaterialsReader.Item("MinOrderQty") Is System.DBNull.Value Then
                        MinOrderQtyTextBox.Text = ""
                    Else
                        MinOrderQtyTextBox.Text = myRawMaterialsReader.Item("MinOrderQty")
                    End If
                    If myRawMaterialsReader.Item("LbsOnHand") Is System.DBNull.Value Then
                        LbsOnHandLabel.Text = ""
                    Else
                        LbsOnHandLabel.Text = myRawMaterialsReader.Item("LbsOnHand")
                    End If
                    If myRawMaterialsReader.Item("LbsOnRelease") Is System.DBNull.Value Then
                        LbsOnReleaseLabel.Text = ""
                    Else
                        LbsOnReleaseLabel.Text = myRawMaterialsReader.Item("LbsOnRelease")
                    End If
                    If myRawMaterialsReader.Item("LbsCommitted") Is System.DBNull.Value Then
                        LbsCommittedLabel.Text = ""
                    Else
                        LbsCommittedLabel.Text = myRawMaterialsReader.Item("LbsCommitted")
                    End If
                    If myRawMaterialsReader.Item("UnCommitted") Is System.DBNull.Value Then
                        UnCommittedLabel.Text = ""
                    Else
                        UnCommittedLabel.Text = myRawMaterialsReader.Item("UnCommitted")
                    End If
                   
                End If

                myRawMaterialsReader.Close()
                myRawMaterialsReader.Dispose()

            End If
        End If

    End Sub

    Protected Sub ReturnButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ReturnButton.Click
        Response.Redirect("RawMaterialsList.aspx")
    End Sub

    Protected Sub SaveButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles SaveButton.Click

        Dim mySaveBook As RawMaterialsEditLocdb = New RawMaterialsEditLocdb

        Dim Type = Request.QueryString("Type")
        Dim Diameter = Request.QueryString("Diameter")
        Dim BarCoilInd = Request.QueryString("BarCoilInd")
        Dim rsp

        If Page.IsValid = True Then

            If Request.QueryString("A") = "Y" Then 'Adding

                Dim objRawMaterialsAdd As RawMaterials = New RawMaterials

                objRawMaterialsAdd.Type = TypeDownList.Text
                objRawMaterialsAdd.Diameter = DiameterDropDownList.Text
                objRawMaterialsAdd.BarCoilInd = BarCoilIndDropDownList.Text
                objRawMaterialsAdd.UOM = UnitofMeasureDropDownList.Text
                objRawMaterialsAdd.SaftyStockLbs = SaftyStockLbsTextBox.Text
                objRawMaterialsAdd.MinOrderQty = MinOrderQtyTextBox.Text
                objRawMaterialsAdd.LbsOnHand = LbsOnHandLabel.Text
                objRawMaterialsAdd.LbsOnRelease = LbsOnReleaseLabel.Text
                objRawMaterialsAdd.LbsCommitted = LbsCommittedLabel.Text

                
                rsp = mySaveBook.AddRawMaterials(objRawMaterialsAdd)
                If rsp <> "" Then
                    If Left(rsp, 24) = "Violation of PRIMARY KEY" Then
                        ErrorMessageLabel1.Text = "This Part ID already exists."
                    Else
                        ErrorMessageLabel1.Text = rsp
                    End If
                    Exit Sub
                End If

            Else 'Editing

                Dim objRawMaterialsUpdate As RawMaterials = New RawMaterials

                objRawMaterialsUpdate.Type = TypeDownList.Text
                objRawMaterialsUpdate.Diameter = DiameterDropDownList.Text
                objRawMaterialsUpdate.BarCoilInd = BarCoilIndDropDownList.Text
                objRawMaterialsUpdate.UOM = UnitofMeasureDropDownList.Text
                objRawMaterialsUpdate.SaftyStockLbs = SaftyStockLbsTextBox.Text
                objRawMaterialsUpdate.MinOrderQty = MinOrderQtyTextBox.Text
                objRawMaterialsUpdate.LbsOnHand = LbsOnHandLabel.Text
                objRawMaterialsUpdate.LbsOnRelease = LbsOnReleaseLabel.Text
                objRawMaterialsUpdate.LbsCommitted = LbsCommittedLabel.Text
                objRawMaterialsUpdate.UnCommitted = UnCommittedLabel.Text

                rsp = mySaveBook.UpdateRawMaterials(objRawMaterialsUpdate, Type, Diameter, BarCoilInd)
                If rsp <> "" Then
                    ErrorMessageLabel1.Text = rsp
                    Exit Sub
                End If

            End If

            Response.Redirect("RawMaterialsList.aspx")

        End If

    End Sub
End Class

Public Class RawMaterials
    Public Type As String
    Public Diameter As String
    Public BarCoilInd As String
    Public UOM As String
    Public SaftyStockLbs As String
    Public MinOrderQty As String
    Public LbsOnHand As String
    Public LbsOnRelease As String
    Public LbsCommitted As String
    Public UnCommitted As String
   
End Class

Public Class RawMaterialsEditLocdb
    Inherits System.Web.UI.Page

    Private ConnStr = ConfigurationSettings.AppSettings("ConnStr")

    '*******************************************************
    '
    ' GetRawMaterialsRec() Method 
    '
    '*******************************************************
    Public Function GetRawMaterialsRec(ByVal Type As String, ByVal Diameter As String, ByVal BarCoilInd As String) As SqlDataReader

        ' Create Instance of Connection and Command Object
        Dim oSQLConn As SqlConnection = New SqlConnection(ConnStr)
        oSQLConn.Open()
        Dim myCommand As New SqlCommand

        myCommand.CommandText = "SELECT *, LbsOnRelease-LbsCommitted as UnCommitted FROM RawMaterials WHERE Type = '" & Type & "' And Diameter = '" & Diameter & "' And BarCoilInd = '" & BarCoilInd & "'"
        myCommand.Connection = oSQLConn

        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        'oSQLConn.Close()

        ' Return the datareader result
        Return result
    End Function

    '*******************************************************
    '
    ' UpdateRawMaterials () Method 
    '
    '*******************************************************
    Public Function UpdateRawMaterials(ByVal RawMaterials As RawMaterials, ByVal Type As String, ByVal Diameter As String, ByVal BarCoilInd As String) As String

        Dim myconnection
        Dim myCommand
        Dim ra
        Dim DBReturnMessage As String = ""

        myconnection = New SqlConnection(ConnStr)
        myconnection.Open()
        Dim sql = "UPDATE RawMaterials set " & _
        "Diameter = '" & RawMaterials.Diameter & "'" & ",BarCoilInd = '" & RawMaterials.BarCoilInd & "', " & _
        "UOM = '" & RawMaterials.UOM & "'" & ",SaftyStockLbs = '" & RawMaterials.SaftyStockLbs & "'" & ",MinOrderQty = '" & RawMaterials.MinOrderQty & "', " & _
        "LbsOnHand = '" & RawMaterials.LbsOnHand & "'" & ",LbsOnRelease = '" & RawMaterials.LbsOnRelease & "', " & _
        "LbsCommitted = '" & RawMaterials.LbsCommitted & "' " & _
        "Where Type = '" & Type & "' AND Diameter = '" & Diameter & "' AND BarCoilInd = '" & BarCoilInd & "'"

        myCommand = New SqlCommand(sql, myconnection)



        ra = myCommand.ExecuteNonQuery()
        myconnection.Close()

        Return DBReturnMessage

    End Function

    '*******************************************************
    '
    ' AddRawMaterials () Method 
    '
    '*******************************************************
    Public Function AddRawMaterials(ByVal RawMaterials As RawMaterials) As String
        Dim myconnection2
        Dim myCommand2
        Dim ra
        Dim DBReturnMessage As String = ""

        myconnection2 = New SqlConnection(ConnStr)
        myconnection2.Open()

        myCommand2 = New SqlCommand("Insert into RawMaterials (Type,Diameter,BarCoilInd,UOM,SaftyStockLbs,MinOrderQty,LbsOnHand,LbsOnRelease,LbsCommitted) " & _
        "Values ('" & RawMaterials.Type & "', '" & RawMaterials.Diameter & "', " & _
        "'" & RawMaterials.BarCoilInd & "','" & RawMaterials.UOM & "', " & _
        "'" & RawMaterials.SaftyStockLbs & "','" & RawMaterials.MinOrderQty & "', " & _
        "'" & RawMaterials.LbsOnHand & "','" & RawMaterials.LbsOnRelease & "', " & _
        "'" & RawMaterials.LbsCommitted & "')", myconnection2)

        Try
            ra = myCommand2.ExecuteNonQuery()
        Catch ex As Exception
            DBReturnMessage = ex.Message
        End Try

        myconnection2.Close()

        Return DBReturnMessage
    End Function

    '*******************************************************
    '
    ' GetTypeDownList() Method 
    '
    '*******************************************************
    Public Function GetTypeDownList() As SqlDataReader
        Dim dbconn, dbread
        dbconn = New SqlConnection(ConnStr)
        dbconn.Open()

        Dim dbcomm As New SqlCommand

        dbcomm.CommandText = "Select *, Type from ValTypes"
        dbcomm.Connection = dbconn
        '
        Dim result As SqlDataReader = dbcomm.ExecuteReader(CommandBehavior.CloseConnection)
        'oSQLConn.Close()

        ' Return the datareader result
        Return result
    End Function

    '*******************************************************
    '
    ' GetDiameterDropDownList() Method 
    '
    '*******************************************************
    Public Function GetDiameterDropDownList() As SqlDataReader
        Dim dbconn, dbread
        dbconn = New SqlConnection(ConnStr)
        dbconn.Open()

        Dim dbcomm As New SqlCommand

        dbcomm.CommandText = "Select *, Diameter from ValDiameters"
        dbcomm.Connection = dbconn
        '
        Dim result As SqlDataReader = dbcomm.ExecuteReader(CommandBehavior.CloseConnection)
        'oSQLConn.Close()

        ' Return the datareader result
        Return result
    End Function

    '*******************************************************
    '
    ' GetBarCoilIndDropDownList() Method 
    '
    '*******************************************************
    Public Function GetBarCoilIndDropDownList() As SqlDataReader
        Dim dbconn, dbread
        dbconn = New SqlConnection(ConnStr)
        dbconn.Open()

        Dim dbcomm As New SqlCommand

        dbcomm.CommandText = "Select * from UserCodes_Values where ModuleCode = '01' and UC_Code = 'RM'"
        dbcomm.Connection = dbconn
        '
        Dim result As SqlDataReader = dbcomm.ExecuteReader(CommandBehavior.CloseConnection)
        'oSQLConn.Close()

        ' Return the datareader result
        Return result
    End Function

    '*******************************************************
    '
    ' GetUnitofMeasureDropDownList() Method 
    '
    '*******************************************************
    Public Function GetUnitofMeasureDropDownList() As SqlDataReader
        Dim dbconn, dbread
        dbconn = New SqlConnection(ConnStr)
        dbconn.Open()

        Dim dbcomm As New SqlCommand

        dbcomm.CommandText = "Select * from UserCodes_Values where ModuleCode = '02' and UC_Code = 'UM'"
        dbcomm.Connection = dbconn
        '
        Dim result As SqlDataReader = dbcomm.ExecuteReader(CommandBehavior.CloseConnection)
        'oSQLConn.Close()

        ' Return the datareader result
        Return result
    End Function
End Class
