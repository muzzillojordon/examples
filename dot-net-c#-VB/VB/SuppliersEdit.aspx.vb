Imports System.Data.SqlClient
Imports System.Data
Partial Class SuppliersEdit
    Inherits System.Web.UI.Page
    Public SupplierNbr As String
    Public userType As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then




            Dim Add = Request.QueryString("A")
            Dim SupplierNbr = Request.QueryString("SupplierNbr")

            Dim myRS As SuppliersEditLocdb = New SuppliersEditLocdb

            If Add = "Y" Then  'Adding

            Else  'Editing

                Dim mySuppliersReader As SqlDataReader
                mySuppliersReader = myRS.GetSuppliersRec(SupplierNbr)

                If mySuppliersReader.Read Then



                    If mySuppliersReader.Item("SupplierNbr") Is System.DBNull.Value Then
                        SupplierNbrTextBox.Text = ""
                    Else
                        SupplierNbrTextBox.Text = mySuppliersReader.Item("SupplierNbr")
                    End If
                    SupplierNbrTextBox.Enabled = False

                    If mySuppliersReader.Item("Name") Is System.DBNull.Value Then
                        NameTextBox.Text = ""
                    Else
                        NameTextBox.Text = mySuppliersReader.Item("Name")
                    End If
                    If mySuppliersReader.Item("Address1") Is System.DBNull.Value Then
                        Address1TextBox.Text = ""
                    Else
                        Address1TextBox.Text = mySuppliersReader.Item("Address1")
                    End If
                    If mySuppliersReader.Item("Address2") Is System.DBNull.Value Then
                        Address2TextBox.Text = ""
                    Else
                        Address2TextBox.Text = mySuppliersReader.Item("Address2")
                    End If
                    If mySuppliersReader.Item("City") Is System.DBNull.Value Then
                        CityTextBox.Text = ""
                    Else
                        CityTextBox.Text = mySuppliersReader.Item("City")
                    End If
                    If mySuppliersReader.Item("State") Is System.DBNull.Value Then
                        StateTextBox.Text = ""
                    Else
                        StateTextBox.Text = mySuppliersReader.Item("State")
                    End If
                    If mySuppliersReader.Item("ZipCode") Is System.DBNull.Value Then
                        ZipCodeTextBox.Text = ""
                    Else
                        ZipCodeTextBox.Text = mySuppliersReader.Item("ZipCode")
                    End If

                    If mySuppliersReader.Item("ContactName") Is System.DBNull.Value Then
                        ContactNameTextBox.Text = ""
                    Else
                        ContactNameTextBox.Text = mySuppliersReader.Item("ContactName")
                    End If
                    If mySuppliersReader.Item("Phone1") Is System.DBNull.Value Then
                        Phone1TextBox.Text = ""
                    Else
                        Phone1TextBox.Text = mySuppliersReader.Item("Phone1")
                    End If
                    If mySuppliersReader.Item("FaxPhone") Is System.DBNull.Value Then
                        FaxPhoneTextBox.Text = ""
                    Else
                        FaxPhoneTextBox.Text = mySuppliersReader.Item("FaxPhone")
                    End If

                End If

                mySuppliersReader.Close()
                mySuppliersReader.Dispose()

            End If
        End If

    End Sub

    Protected Sub ReturnButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ReturnButton.Click
        Response.Redirect("SuppliersListing.aspx")
    End Sub

    Protected Sub SaveButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles SaveButton.Click

        Dim mySaveBook As SuppliersEditLocdb = New SuppliersEditLocdb

        Dim SupplierNbr = Request.QueryString("SupplierNbr")
        Dim rsp

        If Page.IsValid = True Then

            If Request.QueryString("A") = "Y" Then 'Adding

                Dim objSuppliersAdd As Suppliers = New Suppliers

                objSuppliersAdd.SupplierNbr = SupplierNbrTextBox.Text
                objSuppliersAdd.Name = NameTextBox.Text
                objSuppliersAdd.Address1 = Address1TextBox.Text
                objSuppliersAdd.Address2 = Address2TextBox.Text
                objSuppliersAdd.City = CityTextBox.Text
                objSuppliersAdd.State = StateTextBox.Text
                objSuppliersAdd.ZipCode = ZipCodeTextBox.Text
                objSuppliersAdd.ContactName = ContactNameTextBox.Text
                objSuppliersAdd.Phone1 = Phone1TextBox.Text
                objSuppliersAdd.FaxPhone = FaxPhoneTextBox.Text

                rsp = mySaveBook.Addsuppliers(objSuppliersAdd)
                If rsp <> "" Then
                    If Left(rsp, 24) = "Violation of PRIMARY KEY" Then
                        ErrorMessageLabel1.Text = "This SupplierNbr already exists."
                    Else
                        ErrorMessageLabel1.Text = rsp
                    End If
                    Exit Sub
                End If

            Else 'Editing

                Dim objSuppliersUpdate As Suppliers = New Suppliers

                objSuppliersUpdate.SupplierNbr = SupplierNbrTextBox.Text
                objSuppliersUpdate.Name = NameTextBox.Text
                objSuppliersUpdate.Address1 = Address1TextBox.Text
                objSuppliersUpdate.Address2 = Address2TextBox.Text
                objSuppliersUpdate.City = CityTextBox.Text
                objSuppliersUpdate.State = StateTextBox.Text
                objSuppliersUpdate.ZipCode = ZipCodeTextBox.Text
                objSuppliersUpdate.ContactName = ContactNameTextBox.Text
                objSuppliersUpdate.Phone1 = Phone1TextBox.Text
                objSuppliersUpdate.FaxPhone = FaxPhoneTextBox.Text

                rsp = mySaveBook.UpdateSuppliers(objSuppliersUpdate, SupplierNbr)
                If rsp <> "" Then
                    ErrorMessageLabel1.Text = rsp
                    Exit Sub
                End If

            End If

            Response.Redirect("SuppliersListing.aspx")

        End If

    End Sub
End Class

Public Class Suppliers
    Public SupplierNbr As String
    Public Name As String
    Public Address1 As String
    Public Address2 As String
    Public City As String
    Public State As String
    Public ZipCode As String
    Public ContactName As String
    Public Phone1 As String
    Public FaxPhone As String
End Class

Public Class SuppliersEditLocdb
    Inherits System.Web.UI.Page

    Private ConnStr = ConfigurationSettings.AppSettings("ConnStr")

    '*******************************************************
    '
    ' GetSuppliersRec() Method 
    '
    '*******************************************************
    Public Function GetSuppliersRec(ByVal SupplierNbr As String) As SqlDataReader

        ' Create Instance of Connection and Command Object
        Dim oSQLConn As SqlConnection = New SqlConnection(ConnStr)
        oSQLConn.Open()
        Dim myCommand As New SqlCommand

        myCommand.CommandText = "SELECT * FROM Suppliers WHERE SupplierNbr = '" & SupplierNbr & "'"
        myCommand.Connection = oSQLConn

        Dim result As SqlDataReader = myCommand.ExecuteReader(CommandBehavior.CloseConnection)
        'oSQLConn.Close()

        ' Return the datareader result
        Return result
    End Function

    '*******************************************************
    '
    ' UpdateSuppliers () Method 
    '
    '*******************************************************
    Public Function UpdateSuppliers(ByVal Suppliers As Suppliers, ByVal SupplierNbr As String) As String

        Dim myconnection
        Dim myCommand
        Dim ra
        Dim DBReturnMessage As String = ""

        myconnection = New SqlConnection(ConnStr)
        myconnection.Open()
        Dim sql = "UPDATE Suppliers set " & _
        "Name = '" & Suppliers.Name & "'" & ",Address1 = '" & Suppliers.Address1 & "', " & _
        "Address2 = '" & Suppliers.Address2 & "'" & ",City = '" & Suppliers.City & "', " & _
        "State = '" & Suppliers.State & "'" & ",ZipCode  = '" & Suppliers.ZipCode & "', " & _
        "ContactName = '" & Suppliers.ContactName & "',Phone1= '" & Suppliers.Phone1 & "', " & _
        "FaxPhone = '" & Suppliers.FaxPhone & "' " & _
        "Where SupplierNbr = '" & SupplierNbr & "'"
        myCommand = New SqlCommand(sql, myconnection)



        ra = myCommand.ExecuteNonQuery()
        myconnection.Close()

        Return DBReturnMessage

    End Function

    '*******************************************************
    '
    ' Addsuppliers () Method 
    '
    '*******************************************************
    Public Function Addsuppliers(ByVal suppliers As Suppliers) As String
        Dim myconnection2
        Dim myCommand2
        Dim ra
        Dim DBReturnMessage As String = ""

        myconnection2 = New SqlConnection(ConnStr)
        myconnection2.Open()

        myCommand2 = New SqlCommand("Insert into suppliers (SupplierNbr,Name,Address1,Address2,City,State,ZipCode ,ContactName,Phone1,FaxPhone) " & _
        "Values ('" & suppliers.SupplierNbr & "', '" & suppliers.Name & "', " & _
        " '" & suppliers.Address1 & "','" & suppliers.Address2 & "','" & suppliers.City & "'," & _
        " '" & suppliers.State & "','" & suppliers.ZipCode & "','" & suppliers.ContactName & "', " & _
        " ' " & suppliers.Phone1 & "','" & suppliers.FaxPhone & "')", myconnection2)

        Try
            ra = myCommand2.ExecuteNonQuery()
        Catch ex As Exception
            DBReturnMessage = ex.Message
        End Try

        myconnection2.Close()

        Return DBReturnMessage
    End Function

End Class

