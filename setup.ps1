$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$gitExe = 'C:\Users\master\AppData\Local\Microsoft\WinGet\Packages\Git.MinGit_Microsoft.Winget.Source_8wekyb3d8bbwe\cmd\git.exe'
$qrUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=500x500&data=https://water-eject.vercel.app'

Write-Host "Descargando imagen QR..."
Invoke-WebRequest -Uri $qrUrl -OutFile 'D:\WaterEject\WaterEject_QR.png'
Copy-Item 'D:\WaterEject\WaterEject_QR.png' 'D:\WaterEject\web\qr.png' -Force
Copy-Item 'D:\WaterEject\WaterEject_QR.png' 'C:\Users\master\Downloads\LimpiarParlantes\WaterEject_QR.png' -Force

Write-Host "Inicializando repositorio Git..."
Set-Location 'D:\WaterEject'
& $gitExe init
& $gitExe config user.name 'WaterEjectDev'
& $gitExe config user.email 'dev@watereject.local'
& $gitExe add .
& $gitExe commit -m "feat: Water Eject app con 2 diseños, Web Audio tester, Vercel config y GitHub Actions CI/CD"
& $gitExe branch -M main
& $gitExe log -1 --oneline

Write-Host "Setup completado con éxito."
