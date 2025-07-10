rem …or create a new repository on the command line
rem run in ps> .\git_scr.bat

echo "# PS_A01" >> README.md

REM *** 時間 產生 ******************************************************************************
REM **********   GET DATE TIME   ****************
FOR /F "tokens=1-3 delims=/ " %%a IN ("%date%") DO (SET _today=%%a_%%b_%%c)
SET _nowtime=%time%
SET _nowtime=%_nowtime:.=:%
SET _nowtime=%_nowtime: =0%
SET _nowtime=%_nowtime::=%
SET _DT_=%_today%-%_nowtime%
REM ********************************************************************************************


SET  FORMAT_TEXTOUT=[**LASTEST UPDATED**]: %_DT_%  ***test***
echo %format_textout%

pause 
echo %FORMAT_TEXTOUT% >> README.md

git config --global user.name "ddstw" 

REM *** EDIT ***
git config --global user.email"tehsiung.ding@gmail.com"  
git status

pause 
git init
git add .
git add README.md


git commit -m "latest updated %_DT_%  ***test*** "
git branch -M main

git push -u origin main


pause
rem or push an existing repository from the command line
rem *** EDIT ********
git remote add origin https://github.com/ddstw/PS_A01.git


git branch -M main

rem if there is any change on the target(web), the command shou be executed before git push command

git pull
git push -u origin main

git log