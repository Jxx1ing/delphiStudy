# RunSFC.ps1
Start-Process -FilePath "cmd.exe" -ArgumentList "/k sfc /scannow" -Verb RunAs -WindowStyle Normal
