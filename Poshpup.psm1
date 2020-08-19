
function Test-DDAPIKeys{
    param(
    [Parameter(Mandatory)]   
    [string]$APIKey
    )

    $header = @{
        'Content-Type' = 'application/json'
        'DD-API-KEY' = $APIKey 
    }
    try{if((Invoke-RestMethod -Method Get -URI "https://api.datadoghq.com/api/v1/validate" -Headers $header).valid -eq "True") {Write-Output "The API Key is Valid"}}
    catch{Write-Output "The API Key provided is invalid." -ErrorAction Stop}
    
}

function Set-DDAPIKeys{
    param(
    [Parameter(Mandatory,HelpMessage="Enter the API key")]   
    [string]$APIKey,
    
    [Parameter(Mandatory,HelpMessage="Enter the Application Key")]   
    [string]$ApplicationKey
    )

    #Tests the API Key before continuing
    Test-DDAPIKeys $APIKey

    #Sets up headers
    $global:keys = @{
        'DD-API-KEY' = $APIKey
        'DD-APPLICATION-KEY' = $ApplicationKey
        }    
}

function Get-DDAPIKeys{
    if($global:keys){$global:keys}
    else{"No Keys have been configured"}
}

function Send-DDAPIMetric{
    param(
    [Parameter(Mandatory,HelpMessage="Enter the hostname for the Metric")]
    [string]$Hostname,

    [Parameter(Mandatory,HelpMessage="Enter the name of the Metric")]
    [string]$MetricName,

    [Parameter()]
    [int]$Time,

    [Parameter(Mandatory,HelpMessage="Enter the value of Metric")]
    [string]$Metric,

    [Parameter()]
    [string]$Tags,

    [Parameter()]
    [string]$Type

    )

    if(-not($keys)){
        Write-Output "Please use Set-DDAPIKeys to configure the API and APP Keys" -ErrorAction Stop}
    
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

    $json.series[0].host = $hostname
    $json.series[0].metric = $metricName
    if($time){$json.series.points[0] = $time}
    else{$json.series.points[0] = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))}
    $json.series.points[1] = $metric
    if($tags){$json.series[0].tags = $tags}
    else{$tags = ""}
    
    #Splatts the Web Request
    $params = @{
		Uri = 'https://api.datadoghq.com/api/v1/series'
		Method = 'Post'
		Headers = $global:keys
		Body = $json | ConvertTo-Json -Depth 4
		ContentType = 'application/json'
		}

	try{Invoke-RestMethod @params}
	catch{Write-Output -ErrorAction Stop "Failed to Invoke-Rest Method with $Params, investigate."}
    Write-Output "The following metric was submitted to DD via API:"
    Write-Output $json | ConvertTo-Json -Depth 4
    
}

Export-ModuleMember -Function Test-DDAPIKeys
Export-ModuleMember -Function Set-DDAPIKeys
Export-ModuleMember -Function Get-DDAPIKeys
Export-ModuleMember -Function Send-DDAPIMetric