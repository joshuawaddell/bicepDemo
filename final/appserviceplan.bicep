// Parmaters
@description('Parameter for location of the resource.')
param location string

@description('The name of the App Service Plan')
param appServicePlanName string

@description('The tags for the resource.')
param tags object

@description('The Sku of the App Service Plan.')
param appServicePlanSku string

@description('The capacity value of the App Service Plan.')
param appServicePlanInstanceCount int

// Resource - App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: appServicePlanName
  location: location
  tags: tags
  sku: {
    name: appServicePlanSku
    capacity: appServicePlanInstanceCount
  }
}

// Outputs
output appServicePlanId string = appServicePlan.id
