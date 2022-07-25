// Parameters
@description('The name of the deployment environment.')
@allowed([
  'dev'
  'prod'
  'test'
])
param environment string

@description('The instance number of the resource.')
param instanceNumber string = '001'

@description('Parameter for the location of the resource.')
param location string = resourceGroup().location

@description('The name of the application workload.')
param workload string = 'bicep'

// Variables
var appServiceName = 'as-${workload}-${environment}-${uniqueString(resourceGroup().id)}'
var appServicePlanName = 'asp-${workload}-${environment}-${instanceNumber}'
var appServicePlanEnvironmentSettings = {
  dev: {
    sku: 'F1'
    instanceCount: 1
  }
  prod: {
    sku: 'P1v3'
    instanceCount: 3
  }
  test: {
    sku: 'S1'
    instanceCount: 2
  }
}
var tags = {
  environment: environment
  workload: workload
}

// Modules
// App Service Plan Module
module appServicePlanModule 'appserviceplan.bicep' = {
  name: 'appServicePlanDeployment'
  params: {
    appServicePlanInstanceCount: appServicePlanEnvironmentSettings[environment].instanceCount
    appServicePlanName: appServicePlanName
    appServicePlanSku: appServicePlanEnvironmentSettings[environment].sku
    location: location
    tags: tags
  }
}

// App Service Module
module appServiceModule 'appservice.bicep' = {
  name: 'appServiceDeployment'
  params: {
    appServiceName: appServiceName
    appServicePlanId: appServicePlanModule.outputs.appServicePlanId
    location: location
    tags: tags
  }
}
