param location string = resourceGroup().location
param workload string = 'bicep'
param environment string = 'production'
param instanceNumber string = '001'

var appServicePlanName = 'asp-${workload}-${environment}-${instanceNumber}'
var appServiceName = 'as-${workload}-${environment}-${uniqueString(resourceGroup().id)}'
var tags = {
  environment: environment
  workload: workload
}

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: appServicePlanName
  location: location
  tags: tags
  sku: {
    name: 'F1'
    tier: 'Free'
    capacity: 1
  }
}

resource appService 'Microsoft.Web/sites@2018-11-01' = {
  name: appServiceName
  location: location
  tags: tags
  properties: {
    serverFarmId: appServicePlan.id
  }
}

output appServicePlanId string = appServicePlan.id
