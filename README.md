# Poshpup
A Powerhsell module to send API Calls to Datadog

This powershell module includes the following functions:

## Set-DDAPIKeys

### Configures the API and Application Key for the other functions to run. 

#### Parameter (**Mandatory**): APIKey
* The API Key for the Datadog Org
#### Parameter (**Mandatory**): ApplicationKey
* The Application Key for the Datadog Org

## Test-DDAPIKeys

### Tests the API key to see if it is valid
* *Note: This is run when you set the API Keys*

#### Parameter (**Mandatory**): APIKey
* The API Key for the Datadog Org

##  Get-DDAPIKeys

### Retrives the currently stored API and Application Key Information

## Send-DDAPIMetric

### Send a Metric to DD Via API
* **Note: Please configure the DD API and Application Key using Set-DDAPIKeys before running this command**
#### Parameter (**Mandatory**): Hostname
* The Hostname for the metric being sent
#### Parameter (**Mandatory**): MetricName
* The name for the metric being sent
#### Parameter: Time
* The time (in EPOCH Seconds) being sent to DD
* **Note: If left blank, it will send the current time of the function being run**
#### Parameter (**Mandatory**): Metric
* The value of the metric being sent.
#### Parameter: Tags
* The tags to send alongside the metric. 
* **Note: This will send an empty string if nothing is provided**
#### Parameter: Type
* The Type of Metric being sent
* **Note: This will default to Guage if nothing is configured**

#### Sample Code
```powershell
Send-DDAPIMetric -hostname "PoshpupHost" -metricName "PoshpupMetric" -metric (Get-Random -Minimum 10 -Maximum 100) -tags "Poshpup:APITest"
```
This would send a random number 10-100 to Datadog at the current time.
