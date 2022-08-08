& Write-Host "Clean dockers..."
& docker rm (docker ps -aq) -f
& Write-Host "Clean images..."
& docker rmi (docker images -aq) -f