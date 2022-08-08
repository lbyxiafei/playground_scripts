# git commit with arg[0] as title
# if there is no given title, use default: checkpoint + datetime

$title = $args[0]
$date = Get-Date -Format s

if (!$title -or $title -eq ".") {
    $title = "Check point, " + $date + "."
}

&Write-Host "Commiting..."
&git add .
&git commit -m $title
&Write-Host "Commiting...Done!"
&Write-Host `n
