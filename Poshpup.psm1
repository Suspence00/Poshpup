
function Test-APIKey{
    param(
    [Parameter(Mandatory)]   
    [string]$APIKey
    )

    $header = @{
        'Content-Type' = 'application/json'
        'DD-API-KEY' = $APIKey 
    }
    try{if((Invoke-RestMethod -Method Get -URI "https://api.datadoghq.com/api/v1/validate" -Headers $header).valid -eq "True") {Write-Output "The API Key is Valid"}}
    catch{Write-Output "The API Key provided is invalid."}
    
}

function Set-DDAPIKeys{
    param(
    [Parameter(Mandatory)]   
    [string]$APIKey,
    
    [Parameter(Mandatory)]   
    [string]$ApplicationKey
    )

    #Tests the API Key before continuing
    Test-APIKey $APIKey

    #Sets up headers
    $keys = @{
        'DD-API-KEY' = $APIKey
        'DD-APPLICATION-KEY' = $ApplicationKey
        }    
}

function Set-DDAIJSON{
    param(
    [Parameter()]
    [string]$hostname,

    [Parameter()]
    [string]$metric,

    [Parameter()]
    [string]$host,

    [Parameter()]
    [string]$host,
    )
    $json = '{"series": [ {
        "host": "",
        "metric": "",
        "points": [
            [
                "timestamp",
                "metric"]],
        "tags": "",
        "type": "gauge"
            }]}' | ConvertFrom-Json
}
Export-ModuleMember -Function Test-APIKey
Export-ModuleMember -Function Set-DDAPIKeys
Export-ModuleMember -Function Set-DDAIJSON