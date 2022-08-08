# git push with arg[0] as title name
# git push to current origin branch

# commit first
$title = $args[0]
&gcommit $title

# figure out the branch
$branch = &git rev-parse --abbrev-ref HEAD
$branch = "origin "+$branch

# then, push
Write-Host "Pushing..."
$push_cmd="git push "+$branch+" --no-verify"
Invoke-Expression $push_cmd
Write-Host "Pushing...Done!"

