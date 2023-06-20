@ECHO OFF

set "Title=RMM [ RMM HOSTLP ]" & set "Author=Thiago Castro"
title %Title% - Written by %Author%. & mode con: cols=86 lines=20 & color 17

setlocal EnableDelayedExpansion
set "params=%*"
cd /d "%~dp0" && ( if exist "%Temp%\getadmin.vbs" del "%Temp%\getadmin.vbs") && fsutil dirty query %systemdrive% 1>nul 2>nul || ( echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%Temp%\getadmin.vbs" && "%Temp%\getadmin.vbs" && Exit /b)
%windir%\system32\reg.exe query "HKU\S-1-5-19" 1>nul 2>nul || ( echo. & echo  ERROR: This Batch file MUST be run in an ELEVATED cmd prompt [ Administrator ] & echo. & echo         Right-click the Batch file and click ^<Run as Administrator^>. & echo. & echo ^>Press ANY key to EXIT . . . & pause >nul & Exit )


:INICIO
CLS
@ECHO OFF
ECHO --------------------------------------------------------------
ECHO .:: RMM v1.1.0::.
ECHO --------------------------------------------------------------
ECHO Digite "1" para parar RMM
ECHO Digite "2" para iniciar RMM
ECHO Digite "3" para reiniciar RMM
ECHO Digite "4" para versao RMM
ECHO Digite "5" para cancelar e sair
ECHO --------------------------------------------------------------
:LOOP
SET /P choice1= Escolha 1,2,3,4 ou 5, e pressione ENTER:    
IF /I "%choice1%"=="1" GOTO PARAR
IF /I "%choice1%"=="2" GOTO INICIAR
IF /I "%choice1%"=="3" GOTO REINICIAR
IF /I "%choice1%"=="4" GOTO VERSAO
IF /I "%choice1%"=="5" GOTO CANCEL
:: ELSE
GOTO LOOP

:PARAR
@ECHO OFF
CLS
net stop "Mesh Agent"
net stop "SplashtopRemoteService"
sc config "Mesh Agent" start= demand
sc config "SplashtopRemoteService" start= demand
@ECHO OFF
ECHO * RMM parado com sucesso - Aperte qualquer tecla para sair *
ECHO.
GOTO SUCCESS

:INICIAR
@ECHO OFF
CLS
net start "Mesh Agent"
net start "SplashtopRemoteService"
ECHO * RMM iniciado com sucesso - Aperte qualquer tecla para sair *
ECHO.
GOTO SUCCESS

:REINICIAR
@ECHO OFF
CLS
net stop "Mesh Agent"
net stop "SplashtopRemoteService"
net start "Mesh Agent"
net start "SplashtopRemoteService"
@ECHO OFF
ECHO * RMM reiniciado com sucesso - Aperte qualquer tecla para sair *
ECHO.
GOTO SUCCESS

:VERSAO
@ECHO OFF
CLS
;@ECHO * .::v2.4.9::.  - Aperte qualquer tecla para sair *
ECHO.
@PAUSE > NUL
GOTO INICIO

:SUCCESS
@ECHO .::TUDO OK::.
ECHO.
@PAUSE > NUL
GOTO INICIO

:CANCEL
CLS
ECHO * Cancelado pelo usuario - Aperte qualquer tecla para sair *
ECHO.
@PAUSE > NUL > NUL
EXIT
