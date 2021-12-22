$url = Read-Host -Prompt "PVWA URL (e.g.  https://pvwa.mycompany.org)"
$TargetUser = Read-Host -Prompt "TargetUser"
$NewPass = Read-Host -Prompt "NewPassword" -AsSecureString
$ReconcileUser = Read-Host -Prompt "Reconcile User"
$ReconcilePass = Read-Host -Prompt "Reconcile Pass" -AsSecureString

$uri = "$url/PasswordVault/api/Auth/cyberark/Logon"

$headers = @{
    "Content-Type" = "application/json"
}
$body = @{
    "username" = $ReconcileUser
    "password" = ConvertFrom-SecureString -SecureString $ReconcilePass -AsPlainText
} | ConvertTo-Json

try{
    $response = Invoke-RestMethod -uri $uri -Method "POST" -Headers $headers -Body $body
    $headers += @{"Authorization" = $response}
    try{
        #Get UserID
        $uri = "$url/PasswordVault/api/Users/$TargetUser"
		write-host $uri
        $response = Invoke-RestMethod -uri $uri -Method "GET" -Headers $headers
        write-host $response
        #Reset Password
        $uri = "$uri/ResetPassword"
        $body = @{
            "id" = $response.id
            "newPassword" = $NewPass
        } 
		$response = Invoke-RestMethod -uri $uri -Method "POST" -Headers $headers -Body $body
		write-host $response
		write-host = "Password Change Successful"
    } catch {
		write-host "Password Change Failed"
	}
} catch {
    write-host "Reconcile Login Failed"
}

