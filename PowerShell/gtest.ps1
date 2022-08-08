$branch=&git rev-parse --abbrev-ref HEAD
$branch = "origin "+$branch
$date=&get-date

echo $branch
echo $date

Write-Host "Test...Done"
