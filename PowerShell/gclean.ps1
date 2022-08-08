& Write-Host "Add to stage..."
& git add .
& Write-Host "Fetching..."
& git fetch -pP
& Write-Host "Cleaning..."
& git clean -xdf
& Write-Host "Pulling..."
& git pull
