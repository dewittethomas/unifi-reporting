# Start Configuration
$username = ""
$password = ""
$hostname = ""
$port = ""
$apiurl = "https://${hostname}:${port}/api/login"
$apistatuscsv = "YourLocation/api-status.csv"
$statusname = "Unifi Reporting"
# End Configuration

# Start API URL's
$generalurl = "https://${hostname}:${port}/api/s"
$sitesurl = "https://${hostname}:${port}/api/self/sites"
# End API URL's

# Start JSON Files
$sitesjson = "YourLocation/unifi-sites.json"
$devicesjson = "YourLocation/unifi-devices.json"
# End JSON Files

Try {
    # Generate session cookie
    $headers = @{
        "Accept" = "application/json"
        "Content-Type" = "application/json"
    }

    $params = @{
        "username" = $username
        "password" = $password
        "remember" = $true
    }

    $body = $params | ConvertTo-Json

    $options = @{
        Method = "POST"
        Uri = $apiurl
        Headers = $headers
        Body = $body
    }

    # Login and save session variable
    $response = Invoke-RestMethod @options -SessionVariable sessionvariable



    <# Start API Scripts #>

    ###############
    ###Get Sites###
    ###############

    $sitesResponse = Invoke-RestMethod -Uri $sitesurl -Headers $headers -WebSession $sessionvariable -Method Get

    # Insert data in JSON file
    $sitesResponse.data | ConvertTo-Json -Depth 100 | Out-File -FilePath $sitesjson

    #################
    ###Get Devices###
    #################

    # Create an empty array to store the data
    $devicesData = @()

    # Looping through all sites
    foreach ($name in $sitesResponse.data.name) {
        $devicesResponse = Invoke-RestMethod -Uri "$generalurl/$name/stat/device" -Headers $headers -WebSession $sessionvariable -Method Get

        foreach ($deviceData in $devicesResponse.data) {
            $offline = $null
            $disconnectedAt = $null
            

            # Check if device is offline
            if ($deviceData.state -eq 0) {
                $offline = $true
                $disconnectedAt = $deviceData.disconnected_at
            } elseif ($deviceData.state -eq 1) {
                $offline = $false
            }

            $fetchedData = @{
                "siteName" = $name
                "deviceName" = $deviceData.name
                "offline" = $offline
                "disconnectedAt" = $disconnectedAt
                "upgradable" = $deviceData.upgradable
                "model" = $deviceData.model
                "type" = $deviceData.type
            }

            # Append the object to the array
            $devicesData += $fetchedData
        }
    }

    # Insert data in JSON file
    $devicesData | ConvertTo-Json -Depth 100 | Out-File -FilePath $devicesjson

    <# End API Scripts #>



    # Add status row to csv file 
    $data = Import-Csv -Path $apistatuscsv
    $date = (Get-Date).Date.ToString("dd/MM/yyyy")
    $time = (Get-Date).ToString("HH:mm:ss")
    $newrow = [pscustomobject]@{
        date = $date
        time = $time
        name = $statusname
        status = "OK"
    }

    $data = @($data) + $newrow
    $data | Export-Csv -Path $apistatuscsv -NoTypeInformation
    $data = $null
}
Catch {
    # Add status row to csv file
    $data = Import-Csv -Path $apistatuscsv
    $date = (Get-Date).Date.ToString("dd/MM/yyyy")
    $time = (Get-Date).ToString("HH:mm:ss")
    $newrow = [pscustomobject]@{
        date = $date
        time = $time
        name = $statusname
        status = "NOK"
    }

    $data = @($data) + $newrow
    $data | Export-Csv -Path $apistatuscsv -NoTypeInformation
    $data = $null
    Write-Host $_.Exception.Message
}
