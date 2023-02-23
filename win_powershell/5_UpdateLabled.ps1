

#####NOT DONE YET!!!!!!!!!!!!!!!!!!!!!!! DO NOT USE!!!!!!!!!!!!!!!!!!!!!!!!!!!!



##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############
############## Name: Update Labled Folder
############## Programmer: Jordon Muzzillo
############## Date: 2/16/2020
############## Description: Script to look up folder names in excel sheet and rename the folder
##############
##############NOTE:
##############
##############   
##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############


#################Declare Variables#################

$Debug = 1 #Flag for tests, 0 = not test, 1 = test

#Excel file containing all drawing folder name text (ie. KEY LOOKUP)
$ExcelFile = "H:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\_AllDrawingNumbers-Split_V4.xlsx"


if($Debug -eq 1)
    {
        #Declare Test Directories to drawing to be renamed
        $PathToSearch = "H:\Prints\NpLabled"
        $PathToLabledFolder = "H:\Prints\Labled"

    }
    else
    {

    }

#################Code Start#################


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

        $FolderPath = $TempFold -replace [regex]::Escape($PathToSearch), $PathToLabledFolder

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


     }