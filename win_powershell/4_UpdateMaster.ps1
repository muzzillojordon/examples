##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############
############## Name: Update Master
############## Programmer: Jordon Muzzillo
############## Date: 2/16/2020
############## Description: Script to automate updateing master file with current prints that have been processed
##############              
############## #NOTE:
##############        Must run other programs first, Pulls from NP folder. Make sure only files to be added to master
##############        are in the NP folder at time of running
##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############
##############*****************************************************************************************##############


#################Declare Variables#################

$Debug = 1 #Flag for tests, 0 = not test, 1 = test

$TramitFoldFilt = ''

if($Debug -eq 1) 
    {
        #path to master folder
        $PathToMaster = "H:\Prints\Master"                     
                       
        #Prints not printed Location
        $PathToSearch = "H:\Prints\NP"
    }
    else
        {
        #path to master folder
        $PathToMaster = "H:\Prints\Master"                     
                       
        #Prints not printed Location
        $PathToSearch = "H:\Prints\NP"

         }

    #Declare directory to log files
    #home location
    $PathToShearchByTxt = "H:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\Logs\SearchBy.txt" #Log of drawings that were searched for and may or may not have been printed
    $PathToAlreadyPrintedTxt = "H:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\Logs\AlreadyPrinted.txt" #log of drawings that were already printed
    $PathToNotPrintedTxt = "H:\OneDrive\Work\SDI_Texas\NewConstruction\Projects\Prints\TestFiles\Logs\NotPrinted.txt" #log of drawings that have not been printed


#################Code Start#################

#Clear log text file
Clear-Content $PathToShearchByTxt
Clear-Content $PathToAlreadyPrintedTxt
Clear-Content $PathToNotPrintedTxt


#Get directory of all transmittle folders
$DrawingFoldersToSearch = Get-ChildItem -Path $PathToSearch -Filter $TramitFoldFilt -Recurse -Directory |
Foreach-Object {
        #Get all files for current transmittle directory   
        $DrawingsToAdd = Get-ChildItem $PathToSearch\$_\$FileFormat -Recurse
            #NOTE: This will error on last folder in directory, ignore error!!!

        #loop through path to files not added to master and add them, if no folder exists for file create it
            for ($i=0; $i -lt $DrawingsToAdd.Count; $i++) 
            {
                #Get drawing to be checked
                $DrawingName = $DrawingsToAdd[$i].BaseName + $DrawingsToAdd[$i].Extension
                Write-Output $DrawingName

                #Parse drawing name
                $Parts = ($DrawingsToAdd[$i].BaseName).Split(".")
                            
                $path = $PathToMaster

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
                                    copy-item $DrawingsToAdd[$i] $path
                            }
                        }
                    }
                }
         }