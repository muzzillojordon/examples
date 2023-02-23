##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############
############## Name: Drawing Folder Namer
############## Programmer: Jordon Muzzillo
############## Date: 11/16/2019
############## Description: Script to look up folder names in excel sheet and rename the folder
##############
##############NOTE:
##############    1) make sure "PrintChecker.ps1" has been run and files were added to "master" folder on shared drive
##############       Program shearches "PathToSearch" folder, this is the master folder
##############    2) FUTURE: For auto Add Program will rename in place or copy and rename
##############    3) Program will rename folder in place, point to upnextprintfolder
##############    4) After labled Manually add to printLabled Folder on shared drive
##############
##############   
##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############


#################Declare Variables#################

$Debug = 1 #Flag for tests, 0 = not test, 1 = test


#Flag renaming files inplace
#    0 = Do not rename file in place (copy to "PathToLabledFolder" folder then rename)
#    1 = Rename file in place
#$RenameFileInPlaceFlag = 0


#Excel file containing all drawing folder name text (ie. KEY LOOKUP)
$ExcelFile = "D:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\_AllDrawingNumbers-Split_V4.xlsx"


if($Debug -eq 1)
    {
        #Declare Test Directories to drawing to be renamed
        $PathToSearch = "D:\Prints\NpLabled"
        #$PathToLabledFolder = "H:\Prints\NpLabled"

    }
    else
    {
        #Declare Real Directories to drawing to be renamed
        $PathToSearch = "D:\Prints\NpLabled"
        #$PathToLabledFolder = "H:\Prints\NpLabled"
    }


#Declare directory to log files
$PathToFolderRenameTxt = "D:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\Logs\FolderRename.txt" #Log of drawings that were searched for and may or may not have been printed

#################Code Start#################


#Clear log text file
Clear-Content $PathToFolderRenameTxt


#Open Workbook
$xl = New-Object -COM "Excel.Application"
$xl.Visible = $true
$wb = $xl.Workbooks.Open($ExcelFile)
$ws = $wb.Sheets.Item(1)


#Declare Filter Variable
$TramitFoldFilt = ''

#Get directory of all folder names
$DrawingFoldersToSearch = Get-ChildItem -Path $PathToSearch -Filter $TramitFoldFilt -Recurse -Directory

#Must reverse array bc when folder name gets change the path gets lost to sub folders
[array]::reverse($DrawingFoldersToSearch)
$DrawingFoldersToSearch

Foreach ($Folder in $DrawingFoldersToSearch) {     

        #clear variables
        $FolderName = ""
        $OrigFolderName = ""
        $FolderNameBuilder = ""
        $NoZeroFolderName = ""
        $Parts = @()


        #Build Folder Path
        $FolderName = $Folder.BaseName
        $OrigFolderName = $Folder.BaseName
        
        $TempFold = $Folder.PSPath
        
        #Comment off for future non rename in place
        $FolderPath = $Folder.PSPath


        ###################################For Future Non Rename in Place#######################################
        #Select where to put Labled Folder (rename in place vs different directory)
        #if($RenameFileInPlaceFlag -eq 1)
         #   {
          #      $FolderPath = $Folder.PSPath
           # }
        #else
         #   {
          #      $FolderPath = $TempFold -replace [regex]::Escape($PathToSearch), $PathToLabledFolder
           # }
        ###################################For Future Non Rename in Place#######################################


        #Excel file does not have any zeros as first diget of number string
        #need to loop through and remove any starting zeros and rebuild string
        #Parse Folder name
        $Parts = ($FolderName).Split(".")

        if($Parts.Count -gt 1)
        {
            #setup new folder name to build off of
            $NoZeroFolderName = $Parts[0]

            #loop through each number set in folder name
            for ($i = 1; $i -le ($Parts.Count-1); $i++) 
            {
                #if a number set starts with zero, remove it and rebuild string
                if ($Parts[$i].StartsWith(0))
                {
                    $NoZeroFolderName += '.' + $Parts[$i].Substring(1)
                }
                else
                {
                    $NoZeroFolderName += '.' + $Parts[$i]
                }
            }

            $FolderName = $NoZeroFolderName
        }


        #Loop through each cell of excel sheet
        for ($ii = 2; $ii -le 1886; $ii++) 
        {

            if ( $ws.Cells.Item($ii, 3).text -eq $FolderName)
            {
                #check value of cell
                $ValTemp = $ws.Cells.Item($ii, 3).text
                Write-Host = $ValTemp

                #Rename Folder
                $FolderNameBuilder += $OrigFolderName + " "
                $FolderNameBuilder += $ws.Cells.Item($ii, 9).text
                 
                ###################################For Future adding auto#######################################
                #$Path += "\" + $FolderNameBuilder
                #check if folder already exists
                #If(!(test-path $Path))
                #{#If foler does not exist create it
                #        New-Item -ItemType Directory -Force -Path $path
                #}
                #else
                #{
                #   Rename-Item -Path $FolderPath -NewName $FolderNameBuilder
                #}
                ###################################For Future adding auto#######################################
                
                Rename-Item -Path $FolderPath -NewName $FolderNameBuilder        
                break
            }
        }
     }

#Close workbook
$wb.Close()
$xl.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($xl)