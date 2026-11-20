@echo off
chcp 65001 >nul
title Subir Water Eject a GitHub
set "GIT_CMD=C:\Users\master\AppData\Local\Microsoft\WinGet\Packages\Git.MinGit_Microsoft.Winget.Source_8wekyb3d8bbwe\cmd\git.exe"

if not exist "%GIT_CMD%" (
    set "GIT_CMD=git"
)

cd /d "D:\WaterEject"

echo ========================================================
echo       SUBIR PROYECTO WATER EJECT A GITHUB
echo ========================================================
echo.
echo Recuerda haber creado primero el repositorio vacio en GitHub:
echo https://github.com/new
echo.
set /p REPO_URL="Pega aqui la URL de tu repositorio (ejemplo: https://github.com/tu-usuario/WaterEject.git): "

if "%REPO_URL%"=="" (
    echo [ERROR] No ingresaste ninguna URL.
    pause
    exit /b
)

echo.
echo [1/3] Configurando enlace remoto...
"%GIT_CMD%" remote remove origin >nul 2>&1
"%GIT_CMD%" remote add origin %REPO_URL%

echo [2/3] Verificando rama principal...
"%GIT_CMD%" branch -M main

echo [3/3] Subiendo archivos a GitHub...
"%GIT_CMD%" push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ========================================================
    echo  ¡SUBIDA EXITOSA A GITHUB!
    echo ========================================================
    echo GitHub Actions comenzara a compilar tu APK de inmediato.
    echo Ahora puedes ir a Vercel para conectar el repositorio.
) else (
    echo.
    echo [AVISO] Si te pidio credenciales o fallo el inicio de sesion,
    echo verifica que tu usuario y contrasena/token sean correctos.
)

echo.
pause
