Write-Host "Address:"
$url = [Console]::ReadLine()
Write-Host "TargetUser:"
$TargetUser = [Console]::ReadLine()
Write-Host "CurrentPassword:"
$CurPass = [Console]::ReadLine()
Write-Host "NewPassword:"
$NewPass = [Console]::ReadLine()

$uri = "$url/PasswordVault/api/Auth/cyberark/Logon"

$headers = @{
    "Content-Type" = "application/json"
}
$body = @{
    "username" = $Targetuser
    "password" = $CurPass
    "newPassword" = $NewPass
} | ConvertTo-Json

try{
    $response = Invoke-RestMethod -uri $uri -Method "POST" -Headers $headers -Body $body
    write-host "Change Successful"
} catch {
    write-host "Change Failed"
}
