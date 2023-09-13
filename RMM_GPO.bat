chcp 65001
@ECHO OFF
CLS

title Instalação RMM HOSTLP. & mode con: cols=100 lines=50 & color 17
setlocal EnableDelayedExpansion
set "params=%*"
cd /d "%~dp0" && ( if exist "%Temp%\getadmin.vbs" del "%Temp%\getadmin.vbs") && fsutil dirty query %systemdrive% 1>nul 2>nul || ( echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%Temp%\getadmin.vbs" && "%Temp%\getadmin.vbs" && Exit /b)
%windir%\system32\reg.exe query "HKU\S-1-5-19" 1>nul 2>nul || ( echo. & echo  ERRO: Este arquivo em lote DEVE ser executado em um prompt de cmd ELEVADO [Administrador] & echo. & echo         Clique com o botão direito do mouse no arquivo Batch e clique em ^<Executar como Administrador^>. & echo. & echo ^>Aperte qualquer tecla para sair . . . & pause >nul & Exit )
ECHO --------------------------------------------------------------

@echo off

REM Setup deployment URL
set "DeploymentURL=https://api.hostlp.cloud/clients/3dc6c1fa-abb2-4458-a914-eecb9646b3df/deploy/"

set "Name="
for /f "usebackq tokens=* delims=" %%# in (
    `wmic service where "name like 'tacticalrmm'" get Name /Format:Value`
) do (
    for /f "tokens=* delims=" %%g in ("%%#") do set "%%g"
)

if not defined Name (
    echo RMM não encontrado, instalando agora.
    if not exist c:\ProgramData\TacticalRMM\temp md c:\ProgramData\TacticalRMM\temp
    powershell -Command Set-ExecutionPolicy -ExecutionPolicy Unrestricted
    powershell -Command Add-MpPreference -ExclusionPath "'C:\Program Files\TacticalAgent\*'"
    powershell -Command Add-MpPreference -ExclusionPath "'C:\Program Files\Mesh Agent\*'"
    powershell -Command Add-MpPreference -ExclusionPath "'C:\ProgramData\TacticalRMM\*'"
    cd c:\ProgramData\TacticalRMM\temp
    powershell Invoke-WebRequest "%DeploymentURL%" -Outfile tactical.exe
    REM"C:\Program Files\TacticalAgent\unins000.exe" /VERYSILENT
    tactical.exe
    rem exit /b 1
) else (
    echo RMM já instalado, Saindo
Exit 0
)
