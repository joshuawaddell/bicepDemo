// Parmaters
@description('Parameter for location of the resource.')
param location string = resourceGroup().location

@description('The name of the environment.')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string = 'prod'

@description('The instance number of the resource.')
param instanceNumber string = '001'

@description('The name of the workload.')
param workload string = 'bicep'

// Variables
var appServiceName = 'as-${workload}-${environmentName}-${uniqueString(resourceGroup().id)}'
var appServicePlanName = 'asp-${workload}-${environmentName}-${instanceNumber}'
var appServiceEnvironmentSettings = {
  dev: {
    sku: 'F1'
    instanceCount: 1
  }
  prod: {
    sku: 'P1v3'
    instanceCount: 10
  }
  test: {
    sku: 'S1'
    instanceCount: 5
  }
}
var resourceTags = {
  costCenter: 'it'
  environment: 'production'
  workload: 'bicep'
}

module appServicePlanModule 'appserviceplan.bicep' = {
  name: 'appServicePlanModule'
  params: {
    appServicePlanInstanceCount: appServiceEnvironmentSettings[environmentName].instanceCount
    appServicePlanName: appServicePlanName
    appServicePlanSku: appServiceEnvironmentSettings[environmentName].sku
    location: location
    resourceTags: resourceTags
  }
}

module appServiceModule 'appservice.bicep' = {
  name: 'appServiceModule'
  params: {
    appServiceName: appServiceName
    appServicePlanId: appServicePlanModule.outputs.appServicePlanId
    location: location
    resourceTags: resourceTags
  }
}
