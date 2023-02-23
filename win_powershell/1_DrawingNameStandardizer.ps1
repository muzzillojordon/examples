##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############
############## Name: Drawing Name Standardizer
############## Programmer: Jordon Muzzillo
############## Date: 11/16/2019
############## Description: Script to add drawing name convention to drawings that do not have it
##############   SMS has excel sheet in each transmittle giving conversions           
##############   Example: 14770035B2.pdf TO A02460M320.10.10.0100_14770035B2.pdf
##############   The A02460M320.10.10.0100 comes from excell sheet by search key 14770035
##############
############## NOTE:
##############     1)"NameStandardizer.ps1" will add rename the file (either in place, or will copy to the "PathToNotPrinted" folder and rename file)
##############     2)If non standard name is not found in transmittle Excel sheet (KEY) an entry to "PathToNoMatchTxt" will be added
##############     3)If name is correct, nothing will happen, program will go to next file
##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############


#################Declare Variables#################

$Debug = 0 #Flag for tests, 0 = not test, 1 = test
#Flag re-naming files inplace, 
#    0 = Do not rename file in place (copy to "NotPrinted" folder then rename)
#    1 = Rename file in place
$RenameFileInPlaceFlag = 1

#Set file format to search for:
#$FileFormat = "*.tif"
$FileFormat = "*.pdf"
#$FileFormat = "*.dwg"


#$ProductionArea = 'SMP'
#$ProductionArea = 'CSP'
$ProductionArea = 'PLTCM'
#$ProductionArea = 'CGL'
#$ProductionArea = 'oSPM'

if($Debug -eq 1)
    {
        #Declare Test Directories to drawing to be checked, drawings that are printed and drawings that are not printed files
        $PathToSearch = "D:\Prints\Search\SMP" ; Break
        

        #Actual Print not printed Location
        $NotPrinted = "D:\Users\Jordon\Desktop\NotPrinted" #Directory of copy of files that were found needed to be printed

        #Set filter string to get directory of transmittle folders
        switch ($ProductionArea)
            {
                'SMP' {
                    $TramitFoldFilt = "*SDI-BUFFALO TD*" ; Break 
                        }
                'CSP' {
                    $TramitFoldFilt = "*TD-SDE-CSP*" ; Break
                        }
                'PLTCM' {
                    $TramitFoldFilt = "*TD-SDE-*" ; Break
                        }
                'CGL' {
                    $TramitFoldFilt = "*SDI-BUFFALO TD*" ; Break
                        }
                'oSPM' {
                    $TramitFoldFilt = "*SDI-BUFFALO TD*" ; Break
                        }
            }
    }
    else
        {
            #Declare Real Directories to drawing to be checked, drawings that are printed and drawings that are not printed files
            switch ($ProductionArea)
                {
                    'SMP' {
                        #$PathToSearch = "C:\Users\Jordon\Desktop\TestSearch"
                        $PathToSearch = "D:\Prints\Search\SMP-2"
                        
                        #Set filter string to get directory of transmittle folders
                        $TramitFoldFilt = "*SDI-BUFFALO TD*" ; Break
                            }
                    'CSP' {
                        #$PathToSearch = "C:\Users\Jordon\Desktop\TestSearch" ; Break
                        $PathToSearch = "D:\Prints\Search\CSP-2"
                        
                        #Set filter string to get directory of transmittle folders
                        $TramitFoldFilt = "*TD-SDE-CSP*" ; Break
                            }
                   'PLTCM' {
                        #$PathToSearch = "C:\Users\Jordon\Desktop\TestSearch" ; Break
                        $PathToSearch = "D:\Prints\Search\PLTCM"
                        
                        #Set filter string to get directory of transmittle folders
                        $TramitFoldFilt = "*TD-SDE-*" ; Break
                            }
                   'CGL' {
                        #$PathToSearch = "C:\Users\Jordon\Desktop\TestSearch" ; Break
                        $PathToSearch = "D:\Prints\Search\CGL-2"
     
                        #Set filter string to get directory of transmittle folders
                        $TramitFoldFilt = "*SDI-BUFFALO TD*" ; Break
                          }
                   'oSPM' {
                        #$PathToSearch = "C:\Users\Jordon\Desktop\TestSearch" ; Break
                        $PathToSearch = "D:\Prints\Search\oSPM-2"

                        #Set filter string to get directory of transmittle folders
                        $TramitFoldFilt = "*SDI-BUFFALO TD*" ; Break       
                          }
                }
                
                #Actual Print not printed Location
                $NotPrinted = "D:\Prints\NP"
         }


#Declare directory to log files (Home)
$PathToShearchByTxt = "D:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\Logs\SearchBy.txt" #Log of drawings that were searched for and may or may not have been printed
$PathToNoMatchTxt = "D:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\Logs\NoMatchFound.txt" #Log of drawings that were searched for and may or may not have been printed
$PathToYesMatchTxt = "D:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\Logs\YesMatchFound.txt" #Log of drawings that were searched for and may or may not have been printed


#Declare Filter Variable
$TramitFoldFilt = ''

#################Code Start#################

#Clear log text file
Clear-Content $PathToShearchByTxt
Clear-Content $PathToNoMatchTxt
Clear-Content $PathToYesMatchTxt

#Get directory of all transmittle folders
$DrawingFoldersToSearch = Get-ChildItem -Path $PathToSearch -Filter $TramitFoldFilt -Recurse -Directory |
Foreach-Object {

        $ExcelFile = Get-ChildItem $PathToSearch\$_\*.xlsx -Recurse 

        #Get all files for current transmittle directory
        $DrawingsToSearch = Get-ChildItem $PathToSearch\$_\$FileFormat -Recurse    

        #Open Workbook
        $xl = New-Object -COM "Excel.Application"
        $xl.Visible = $true
        $wb = $xl.Workbooks.Open($ExcelFile)
        $ws = $wb.Sheets.Item(1)

       

        #loop through path to search and check that file is in path to check
            for ($i=0; $i -lt $DrawingsToSearch.Count; $i++) 
            {

                Write-Output $ExcelFile.FullName  + " is being used"

                #Get drawing to be checked
                $DrawingName = $DrawingsToSearch[$i].BaseName + $DrawingsToSearch[$i].Extension

                #Add drawing name to shearched log
                Add-Content -Path $PathToShearchByTxt -Value $DrawingName

                #clear variables
                $StandardName = ""
                $MatNumber = ""
                $StandFormFullName = ""
                $NewPathTemp = ""
                $MatchFlag = 0

                #Check if drawing name needs to be Standardized (check both project numbers used
                If(($DrawingName -like '*2460*') -OR ($DrawingName -like '*2542*'))
                {
                    #correct format do nothing
                     Write-Output $DrawingName + "is good"

                }
                else
                {
                    Write-Output $DrawingName + "is being looked up"
                   #Drawing name not in correct format, add correct format
                   #Find the 8 digit long "Material Number" to use as key matching value
                   if ($DrawingsToSearch[$i].BaseName -match '\d{8}')
                   {
                        $MatNumber = $matches[0]

                        #Search for match
                        for ($ii = 69; $ii -le 500; $ii++) 
                        {
                            $ValTemp = $ws.Cells.Item($ii, 4).text
                     
                      
                          if ( $ws.Cells.Item($ii, 4).text -eq $MatNumber ) 
                          {
                            $StandardName = $ws.Cells.Item($ii, 3).text
                            $MatchFlag = 1
                            break
                          }
                        }

                        if($MatchFlag -eq 0)
                        {
                          #Log no standard format found
                          Add-Content -Path $PathToNoMatchTxt -Value $DrawingName
                          Write-Output $DrawingName
                        }
                        else
                        {
                            #Create standard format name
                            $StandFormFullName = $StandardName + '_' + $DrawingName

                            #Log Standard format found
                            Add-Content -Path $PathToYesMatchTxt -Value $DrawingName
                            Write-Output $DrawingName

                            #Coppy drawing to new directory (1= Rename in place, 0 = do not rename in place
                            if($RenameFileInPlaceFlag -eq 1)
                            {
                              #Rename drawing with standard format
                              Rename-Item -Path $DrawingsToSearch[$i] -NewName $StandFormFullName
                            }
                            else
                            {
                              copy-item $DrawingsToSearch[$i] $NotPrinted
                              #Rename drawing with standard format
                              $NewPathTemp = $NotPrinted +'\' + $DrawingName
                              Rename-Item -Path $NewPathTemp -NewName $StandFormFullName
                            }
                        }
                   }
                   else
                   {
                     #no material number found
                     #Log Standard format found
                     Add-Content -Path $PathToNoMatchTxt -Value $DrawingName
                     Write-Output $DrawingName + "was not found"
                   }
                }

            }

            #Close workbook
            $wb.Close()
            $xl.Quit()
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($xl)
         }
