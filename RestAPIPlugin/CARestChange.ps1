$url = Read-Host -Prompt "PVWA URL (e.g.  https://pvwa.mycompany.org)"
$TargetUser = Read-Host -Prompt "TargetUser"
$CurPass = Read-Host -Prompt "CurrentPassword" -AsSecureString
$NewPass = Read-Host -Prompt

$uri = "$url/PasswordVault/api/Auth/cyberark/Logon"

$headers = @{
    Content-Type = "application/json"
}
$body = @{
    username = $Targetuser
    password = ConvertFrom-SecureString -SecureString $CurPass -AsPlainText
    newPassword = ConvertFrom-SecureString -SecureString $NewPass -AsPlainText
} | ConvertTo-Json

try{
    $response = Invoke-RestMethod -uri $uri -Method "POST" -Headers $headers -Body $body
    write-host "Change Successful"
} catch {
    write-host "Change Failed"
}
