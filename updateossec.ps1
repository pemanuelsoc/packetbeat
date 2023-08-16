$confFile = "C:\Program Files (x86)\ossec-agent\ossec.conf"
$newIP = "172.174.97.227" # Replace this with your desired IP address
$newPort = "20000" # Replace this with your desired port number
$newGroup = "Windows_JCG" # Replace this with your desired group
$newManager = "172.174.97.227" # Replace this with your desired manager
$newEnrollmentPort = "20001"
$tempFile = "$env:TEMP\ossec_temp.conf"

if (!(Test-Path $confFile)) {
    Write-Host "Configuration file not found: $confFile"
    exit 1
}

$addressRegex = '(?<=<address>).*?(?=</address>)'
$portRegex = '(?<=<port>).*?(?=</port>)'
$groupRegex = '(?<=<groups>).*?(?=</groups>)'
$managerRegex = '(?<=<manager_address>).*?(?=</manager_address>)'
$enrollmentOpenTag = '<enrollment>'
$enrollmentCloseTag = '</enrollment>'

$insideEnrollment = $false

(Get-Content $confFile) | ForEach-Object {
    if ($_ -match $addressRegex) {
        $_ -replace $addressRegex, $newIP
    } elseif ($_ -match $portRegex) {
        $_ -replace $portRegex, $newPort
    } elseif ($_ -match $groupRegex) {
		$_ -replace $groupRegex, $newGroup  
	} elseif ($_ -match $managerRegex) {
		$_ -replace $managerRegex, $newManager
    } elseif ($_ -match $enrollmentOpenTag) {
        $insideEnrollment = $true
        $_ 	
    } elseif ($_ -match $enrollmentCloseTag -and $insideEnrollment) {
	  $insideEnrollment = $false
      "<port>$newEnrollmentPort</port>`r`n$_"  
	} else {
        $_
    }
} | Set-Content $tempFile

Move-Item -Path $tempFile -Destination $confFile -Force
Write-Host "IP address and port updated successfully in the configuration file."
