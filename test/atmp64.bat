REM Copyright James Cook
@echo off
set eudir=%ONEDRIVE%\euphoria-4.1.0-Windows-x64
set euinc=..\include;%euinc%
set path=%eudir%\bin;%path%
eui atmp.ex
pause
