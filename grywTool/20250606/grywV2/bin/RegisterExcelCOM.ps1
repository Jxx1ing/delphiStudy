param($ExcelPath)
Start-Process -FilePath $ExcelPath -ArgumentList "/regserver" -Verb RunAs -Wait
exit $LASTEXITCODE