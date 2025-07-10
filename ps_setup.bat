@echo off
ECHO  1 --- The restriction of using POWERSHELL must be reset by the following steps, must be in the dos ADDMINTRACTION mode.
pause

ECHO Enter into Powershell Execution mode ...... by keyin in DOS command line  "Powershell"
powershell 
pause

ECHO 2 --- get the Execution Policy/Rure
Get-ExecutionPolicy


ECHO 3 --- then set the new policy. 
Set-ExecutionPolicy -ExecutionPolicy Unrestricted



ECHO 4 --- get the Execution Policy/Rure
Get-ExecutionPolicy


pause
echo key Exit to exit powershell mode. 