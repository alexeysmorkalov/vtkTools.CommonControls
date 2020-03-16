@echo off

set prversion=%1
call Settings.bat

echo *********************************************************
echo
echo (bat file works only on NT/2000/XP):
echo
echo   %src%.zip - CommonControls sources (Source and Res)
echo
echo *********************************************************
pause

md %dpup%
rmdir %dppr% /s /q
md %dppr%

rem *********************************************
rem Формируем каталог
rem *********************************************
md %dppr%\Source

rem *********************************************
rem Sources
rem *********************************************
copy %prcat%\source\*.pas %dppr%\source
copy %prcat%\source\*.res %dppr%\source
copy %prcat%\source\*.bpk %dppr%\source
copy %prcat%\source\*.dfm %dppr%\source
copy %prcat%\source\*.inc %dppr%\source
copy %prcat%\source\*.dpk %dppr%\source
copy %prcat%\source\*.cpp %dppr%\source

rem *********************************************
rem Resources
rem *********************************************

rem *********************************************
rem Demos
rem *********************************************

rem *********************************************
rem Создаем архив
rem *********************************************

%wz% -add -max -dir=relative %dpup%\%src%.zip %dppr%\*.*

rmdir %dppr% /q /s
