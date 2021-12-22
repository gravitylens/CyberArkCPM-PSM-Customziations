$url = Read-Host -Prompt "PVWA URL (e.g.  https://pvwa.mycompany.org)"
$TargetUser = Read-Host -Prompt "TargetUser"
$NewPass = Read-Host -Prompt "CurrentPassword" -AsSecureString
$ReconcileUser = Read-Host -Prompt "Reconcile User"
$ReconcilePass = Read-Host -Prompt "Reconcile Pass" - -AsSecureString

$uri = "$url/PasswordVault/api/Auth/cyberark/Logon"

$headers = @{
    Content-Type = "application/json"
}
$body = @{
    username = $Targetuser
    password = ConvertFrom-SecureString -SecureString $ReconcilePass -AsPlainText
} | ConvertTo-Json

try{
    $response = Invoke-RestMethod -uri $uri -Method "POST" -Headers $headers -Body $body
    $headers += @{"Authorization" = $response}
    try{
        #Get UserID
        $uri = "$url/PasswordVault/api/Users/$TargetUser"
        $response = Invoke-RestMethod -uri $uri -Method "GET" -Headers $headers
        
        #Reset Password
        $uri = "$uri/ResetPassword"
        $body = @{
            "id" = $response.id
            newPassword = $NewPass
        } catch {
            Write-Host "Change Failed"
        }
    }
} catch {
    write-host "Reconcile Login Failed"
}

