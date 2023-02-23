##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############
############## Name: Drawing Print Adder
############## Programmer: Jordon Muzzillo
############## Date: 11/16/2019
############## Description: Script to search if drawings have been printed or not
##############              If drawings have not been printed copy drawing in to new
##############              directory to be printed
##############              
############## #NOTE: Any files not following standard name format will not be found in checkFolder and therefor be added to the "PathToNotPrinted" folder
##############        but becasue the name does not following a standard format, a new folder will be created with the nonstandard name and needs to be identified manually
##############        1)If non standard names have been identified, delete all drawings added to "PathToNotPrinted" folder
##############        2)Run "NameStandardizer.ps1" for the production line
##############        2-1)"NameStandardizer.ps1" will add rename the file (either in place, or will copy to the "PathToNotPrinted" folder and rename file)
##############        3)run "PrintChecker.ps1" again for production line
##############        3-1) if "NameStandardizer.ps1" was set to rename in place, files should be added correctly,
##############        3-2) if "NameStandardizer.ps1" was set to copy and rename, files of non standared names would already have be added to "PathToNotPrinted" correctly,
##############            but the non standard names from re-running "PrintChecker.ps1" will need to be removed from "PathToNotPrinted", because they will be added again
##############        4) MANUALLY ADD TO MASTER FOLDER ON SHARED DRIVE
##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############


#################Declare Variables#################

$Debug = 0 #Flag for tests, 0 = not test, 1 = test

#$ProductionArea = 'SMP'
#$ProductionArea = 'CSP'
$ProductionArea = 'PLTCM'
#$ProductionArea = 'CGL'
#$ProductionArea = 'oSPM'

#Set file format to search for:
#$FileFormat = "*.tif"
$FileFormat = "*.pdf"
#$FileFormat = "*.dwg"


$TramitFoldFilt = ''

if($Debug -eq 1) 
    {
            #Declare Path to search is directory of files to be looked if printed
            $PathToSearch = "D:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\TestSearch"
        
            #Declare path to check: directory of files that are already printed, to check searched files against
            $PathToCheck = "D:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\Master"
        
            #Declare path to copy shearched path files that not match was found in checked file path
            $PathToNotPrinted = "D:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\NotPrinted" 


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
                            #$PathToSearch = "H:\Steel Dynamics Inc\Buffalo - Documents\Buffalo\Equipment Suppliers\SMS\01 SMP" ; Break
                            #$PathToSearch = "H:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\TestSearch" ; Break
                            #$PathToSearch = "C:\Users\Jordon\Desktop\TestSearch" ; Break

                            $PathToSearch = "D:\Prints\Search\SMP-2"                       
  
                            #Set filter string to get directory of transmittle folders
                            $TramitFoldFilt = "*SDI-BUFFALO TD*" 
                            ; Break
                            }
                    'CSP' {
                            #$PathToSearch = "C:\Users\Jordon\Steel Dynamics Inc\Buffalo - Buffalo\Equipment Suppliers\SMS\02 CSP" ; Break
                            #$PathToSearch = "H:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\TestSearch" ; Break
                            #$PathToSearch = "C:\Users\Jordon\Desktop\TestSearch" ; Break

                            $PathToSearch = "D:\Prints\Search\CSP-2"
 
                            #Set filter string to get directory of transmittle folders
                            $TramitFoldFilt = "*TD-SDE-CSP*" 
                            ; Break
                            }
                   'PLTCM' {
                            #$PathToSearch = "C:\Users\Jordon\Steel Dynamics Inc\Buffalo - Buffalo\Equipment Suppliers\SMS\03 PLTCM" ; Break
                            #$PathToSearch = "H:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\TestSearch" ; Break
                            #$PathToSearch = "C:\Users\Jordon\Desktop\TestSearch" ; Break

                            $PathToSearch = "D:\Prints\Search\PLTCM"
  
                            #Set filter string to get directory of transmittle folders
                            $TramitFoldFilt = "*TD-SDE-*" 
                            ; Break
                            }
                   'CGL' {
                            #$PathToSearch = "C:\Users\Jordon\Steel Dynamics Inc\Buffalo - Buffalo\Equipment Suppliers\SMS\04 CGL" ; Break
                            #$PathToSearch = "H:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\TestSearch" ; Break
                            #$PathToSearch = "C:\Users\Jordon\Desktop\TestSearch" ; Break

                            $PathToSearch = "D:\Prints\Search\CGL"

                            #Set filter string to get directory of transmittle folders
                            $TramitFoldFilt = "*SDI-BUFFALO TD*" 
                            ; Break
                          }
                   'oSPM' {
                            #$PathToSearch = "C:\Users\Jordon\Steel Dynamics Inc\Buffalo - Buffalo\Equipment Suppliers\SMS\05 oSPM" ; Break
                            #$PathToSearch = "H:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\TestSearch" ; Break
                            #$PathToSearch = "C:\Users\Jordon\Desktop\TestSearch" ; Break

                            $PathToSearch = "D:\Prints\Search\oSPM"

                            #Set filter string to get directory of transmittle folders
                            $TramitFoldFilt = "*SDI-BUFFALO TD*" 
                            ; Break 
                          }
                }
                
                #Declare path to check: directory of files that are already printed, to check searched files against
                $PathToCheck = "D:\Prints\Master-PDF"
                #$PathToCheck = "D:\Prints\Master-Tif"

                #Actual Print not printed Location
                $PathToNotPrinted = "D:\Prints\NP"
         }

            #Declare directory to log files
            #home location
            $PathToShearchByTxt = "D:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\Logs\SearchBy.txt" #Log of drawings that were searched for and may or may not have been printed
            $PathToAlreadyPrintedTxt = "D:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\Logs\AlreadyPrinted.txt" #log of drawings that were already printed
            $PathToNotPrintedTxt = "D:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\Logs\NotPrinted.txt" #log of drawings that have not been printed


#################Code Start#################

#Clear log text file
Clear-Content $PathToShearchByTxt
Clear-Content $PathToAlreadyPrintedTxt
Clear-Content $PathToNotPrintedTxt


#Get directory of all transmittle folders
$DrawingFoldersToSearch = Get-ChildItem -Path $PathToSearch -Filter $TramitFoldFilt -Recurse -Directory |
Foreach-Object {
        #Get all files for current transmittle directory
        #$DrawingsToSearch = Get-ChildItem $PathToSearch\$_\*.pdf -Recurse    
        $DrawingsToSearch = Get-ChildItem $PathToSearch\$_\$FileFormat -Recurse

        #Get all drawings from already printed directory
        #$DrawingsPrinted = Get-ChildItem -Path $PathToCheck\*.pdf -Recurse
        $DrawingsPrinted = Get-ChildItem -Path $PathToCheck\$FileFormat -Recurse
        

        #loop through path to search and check that file is in path to check
            for ($i=0; $i -lt $DrawingsToSearch.Count; $i++) 
            {

                #Get drawing to be checked
                $DrawingName = $DrawingsToSearch[$i].BaseName + $DrawingsToSearch[$i].Extension

                #Add drawing name to shearched log
                Add-Content -Path $PathToShearchByTxt -Value $DrawingName
                Write-Output $DrawingName

                #Search printed files to check if drawing has been printed
                if(!($DrawingsPrinted.Name -contains $DrawingName))
                    {
                        #Drawing not found in foler, it is not printed yet, 
          
                        #Add to log
                        Add-Content -Path $PathToNotPrintedTxt -Value $DrawingName
                        Write-Output $DrawingName

                        #Parse drawing name
                        $Parts = ($DrawingsToSearch[$i].BaseName).Split(".")
                            
                        $path = $PathToNotPrinted

                        $PartBuilder = ""

                        #For each part of file name build folder structure
                        foreach ($Part in $Parts) {
                                
                            #Check if parsing is SMS project number (SMP has 2460 were others have 2542)  
                            If(($Part -like '*2460*'))
                               { 
                                  #SMP has project name seperated by "." were others do not, so must get project name separated
                                  #SMP = "A02542.210.30.70.10.1005_14767918_0004_1009233444_A_002"
                                  #others = A02460M320.70.30.0100_14736399_0010_1009332207_B_001

                                  $numcar = $Part.length
                                  $LastThree = $Part.Substring($numcar-3)
                                  $Part = $LastThree
                                }
                             
                             If(!($Part -like '*2542*'))
                                {
                                    #Check if parse is at the end of drawing name, ie "A02542.210.30.70.10.1005_14767918_0004_1009233444_A_002"
                                    If(!($Part -like '*_*'))
                                    {
                                        $PartBuilder += $Part + "."
                                        $Path += "\" + $PartBuilder

                                        #check if folder already exists
                                        If(!(test-path $Path))
                                        {#If foler does not exist create it
                                                New-Item -ItemType Directory -Force -Path $path
                                        }
                                    }
                                    else 
                                    {
                                        #Coppy drawing to new directory
                                            copy-item $DrawingsToSearch[$i] $path
                                    }

                                }
                        }
                    }
                    else
                    {
                        #Drawing found in folder, it is already printed
                        #Add drawing name to log
                        Add-Content -Path $PathToAlreadyPrintedTxt -Value $DrawingName
                        Write-Output $DrawingName
                    }
                }
         }