Imports System
Imports System.Web
Imports System.Web.UI

<Assembly: WebResource("JavaScriptLibrary.DummyFile.js", "application/x-javascript")> 

<Assembly: WebResource("JavaScriptLibrary.app.js", "application/x-javascript")> 
<Assembly: WebResource("JavaScriptLibrary.modernizr.js", "application/x-javascript")> 
<Assembly: WebResource("JavaScriptLibrary.jquery-2.1.3.min.js", "application/x-javascript")> 
<Assembly: WebResource("JavaScriptLibrary.jquery-ui-darkness.min.js", "application/x-javascript")> 
<Assembly: WebResource("JavaScriptLibrary.foundation.min.js", "application/x-javascript")> 

<Assembly: WebResource("JavaScriptLibrary.json2.min.js", "application/x-javascript")> 
<Assembly: WebResource("JavaScriptLibrary.jquery.jtable.js", "application/x-javascript")> 
<Assembly: WebResource("JavaScriptLibrary.jquery.jtable.aspnetpagemethods.min.js", "application/x-javascript")> 
<Assembly: WebResource("JavaScriptLibrary.jquery.validationEngine.js", "application/x-javascript")> 
<Assembly: WebResource("JavaScriptLibrary.jquery.validationEngine-en.js", "application/x-javascript")> 


''' <summary>
''' Helps include JavaScript files in pages.
''' </summary>
Public Class JavaScriptHelper

#Region "Constants"

    Private Const TEMPLATE_SCRIPT As String = "<script type=""text/javascript"" src=""{0}""></script>"

    Private Const NAME_DUMMY_FILE As String = "JavaScriptLibrary.DummyFile.js"

    Private Const NAME_APP_FILE As String = "JavaScriptLibrary.app.js"
    Private Const NAME_modernizr_FILE As String = "JavaScriptLibrary.modernizr.js"
    Private Const NAME_JQUERY_FILE As String = "JavaScriptLibrary.jquery-2.1.3.min.js"
    Private Const NAME_JQUERY_UI_FILE As String = "JavaScriptLibrary.jquery-ui-darkness.min.js"
    Private Const NAME_Foundation_FILE As String = "JavaScriptLibrary.foundation.min.js"

    Private Const NAME_JSON2_FILE As String = "JavaScriptLibrary.json2.min.js"
    Private Const NAME_JTABLE_FILE As String = "JavaScriptLibrary.jquery.jtable.js"
    Private Const NAME_ASPNETPAGMETHODS_FILE As String = "JavaScriptLibrary.jquery.jtable.aspnetpagemethods.min.js"
    Private Const NAME_validationEngine_FILE As String = "JavaScriptLibrary.jquery.validationEngine.js"
    Private Const NAME_validationEngineEN_FILE As String = "JavaScriptLibrary.jquery.validationEngine-en.js"

#End Region

#Region "Public Methods"

    'MasterPAGE SCRIPS SCRIPTS (app, jquery,jquery-UI,Foundation(more than one) Scripts START
    ''' <summary>
    ''' Includes Include_app in page
    ''' </summary>
    ''' <param name="manager"></param>
    ''' <param name="late"></param>
    ''' <remarks></remarks>
    Public Shared Sub Include_App(ByVal manager As ClientScriptManager, Optional ByVal late As Boolean = False)
        Include_Modernizr(manager, late)
        Include_jQuery(manager, late)
        Include_jQuery_UI(manager, late)
        Include_Foundation(manager, late)

        IncludeJavaScript(manager, NAME_APP_FILE, late)

    End Sub
    ''' <summary>
    ''' Includes Include_Modernizr in the page.
    ''' </summary>
    ''' <param name="manager">Accessible via Page.ClientScript.</param>
    ''' <param name="late">Include the JavaScript at the bottom of the HTML?</param>
    Public Shared Sub Include_Modernizr(ByVal manager As ClientScriptManager, Optional ByVal late As Boolean = False)
        IncludeJavaScript(manager, NAME_modernizr_FILE, late)
    End Sub
    ''' <summary>
    ''' Includes jQuery.js (and all dependencies) in the page.
    ''' </summary>
    ''' <param name="manager">Accessible via Page.ClientScript.</param>
    ''' <param name="late">Include the JavaScript at the bottom of the HTML?</param>
    Public Shared Sub Include_jQuery(ByVal manager As ClientScriptManager, Optional ByVal late As Boolean = False)
        ' Include jQuery.js.
        IncludeJavaScript(manager, NAME_JQUERY_FILE, late)

    End Sub
    ''' <summary>
    ''' Includes jQuery-UI in the page.
    ''' </summary>
    ''' <param name="manager">Accessible via Page.ClientScript.</param>
    ''' <param name="late">Include the JavaScript at the bottom of the HTML?</param>
    Public Shared Sub Include_jQuery_UI(ByVal manager As ClientScriptManager, Optional ByVal late As Boolean = False)
        IncludeJavaScript(manager, NAME_JQUERY_UI_FILE, late)
    End Sub
    ''' <summary>
    ''' Includes Foundation in the page.
    ''' </summary>
    ''' <param name="manager">Accessible via Page.ClientScript.</param>
    ''' <param name="late">Include the JavaScript at the bottom of the HTML?</param>
    Public Shared Sub Include_Foundation(ByVal manager As ClientScriptManager, Optional ByVal late As Boolean = False)

        IncludeJavaScript(manager, NAME_Foundation_FILE, late)
    End Sub


    'MasterPAGE SCRIPS SCRIPTS (app, jquery,jquery-UI,Foundation(more than one) Scripts END

    'JTABLE SCRIPTS START
    ''' <summary>
    ''' Include Json2 java script. apart of JTABLE
    ''' </summary>
    ''' <param name="manager"></param>
    ''' <param name="late"></param>
    ''' <remarks></remarks>
    Public Shared Sub Include_JSON2(ByVal manager As ClientScriptManager, Optional ByVal late As Boolean = False)
        IncludeJavaScript(manager, NAME_JSON2_FILE, late)

    End Sub
    ''' <summary>
    ''' Include jTABLE script. apart of JTABLE. Calls other methods to load rest of jtable scripts, order matters
    ''' </summary>
    ''' <param name="manager"></param>
    ''' <param name="late"></param>
    ''' <remarks></remarks>
    Public Shared Sub Include_JTable(ByVal manager As ClientScriptManager, Optional ByVal late As Boolean = False)

        Include_JSON2(manager, late)
        IncludeJavaScript(manager, NAME_JTABLE_FILE, late)
        Include_validationEngine(manager, late)      
        Include_aspnetpagemethods(manager, late)

    End Sub
    ''' <summary>
    ''' Include ASPNETPAGMETHODS script. apart of JTABLE.
    ''' </summary>
    ''' <param name="manager"></param>
    ''' <param name="late"></param>
    ''' <remarks></remarks>
    Public Shared Sub Include_aspnetpagemethods(ByVal manager As ClientScriptManager, Optional ByVal late As Boolean = False)
        IncludeJavaScript(manager, NAME_ASPNETPAGMETHODS_FILE, late)
    End Sub
    ''' <summary>
    ''' Include validationEngine script. 
    ''' </summary>
    ''' <param name="manager"></param>
    ''' <param name="late"></param>
    ''' <remarks></remarks>
    Public Shared Sub Include_validationEngine(ByVal manager As ClientScriptManager, Optional ByVal late As Boolean = False)
        IncludeJavaScript(manager, NAME_validationEngine_FILE, late)
        Include_validationEngineEN(manager, late)
    End Sub
    ''' <summary>
    ''' Include validationEngine script. 
    ''' </summary>
    ''' <param name="manager"></param>
    ''' <param name="late"></param>
    ''' <remarks></remarks>
    Public Shared Sub Include_validationEngineEN(ByVal manager As ClientScriptManager, Optional ByVal late As Boolean = False)
        IncludeJavaScript(manager, NAME_validationEngineEN_FILE, late)
    End Sub
    'JTABLE SCRIPTS END

#End Region

#Region "Private Methods"

    ''' <summary>
    ''' Includes the specified embedded JavaScript file in the page.
    ''' </summary>
    ''' <param name="manager">Accessible via Page.ClientScript.</param>
    ''' <param name="resourceName">The name used to identify the embedded JavaScript file.</param>
    ''' <param name="late">Include the JavaScript at the bottom of the HTML?</param>
    Private Shared Sub IncludeJavaScript(ByVal manager As ClientScriptManager, ByVal resourceName As String, ByVal late As Boolean)
        Dim type = GetType(JavaScriptLibrary.JavaScriptHelper)
        If Not manager.IsStartupScriptRegistered(type, resourceName) Then
            If late Then
                Dim url As String = manager.GetWebResourceUrl(type, resourceName)
                Dim scriptBlock As String = String.Format(TEMPLATE_SCRIPT, HttpUtility.HtmlEncode(url))
                manager.RegisterStartupScript(type, resourceName, scriptBlock)
            Else
                manager.RegisterClientScriptResource(type, resourceName)
                manager.RegisterStartupScript(type, resourceName, String.Empty)
            End If
        End If
    End Sub

    ''' <summary>
    ''' Registers a dummy script to prevent the inclusion of the real JavaScript.
    ''' </summary>
    ''' <param name="manager">Accessible via Page.ClientScript.</param>
    ''' <param name="key">The name used to uniquely identify the JavaScript file.</param>
    ''' 
    Private Shared Sub ExcludeJavaScript(ByVal manager As ClientScriptManager, ByVal key As String)
        Dim type = GetType(JavaScriptLibrary.JavaScriptHelper)
        Dim url As String = manager.GetWebResourceUrl(type, NAME_DUMMY_FILE)
        manager.RegisterStartupScript(type, key, String.Empty)
        manager.RegisterClientScriptInclude(type, key, url)
    End Sub

#End Region

End Class