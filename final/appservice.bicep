// Parmaters
@description('Parameter for location of the resource.')
param location string

@description('The name of the App Service Plan')
param appServiceName string

@description('The App Service Plan Id. This value is passed in through the main.bicep file from an output.')
param appServicePlanId string

@description('The tags for the resource.')
param resourceTags object

// Resource - App Service
resource webApplication 'Microsoft.Web/sites@2018-11-01' = {
  name: appServiceName
  location: location
  tags: resourceTags
  properties: {
    serverFarmId: appServicePlanId
  }
}
