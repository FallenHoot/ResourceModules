@description('Required. The name of the of the API Management service.')
param apiManagementServiceName string

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param telemetryCuaId string = ''

@description('Required. Portal setting name')
@allowed([
  'delegation'
  'signin'
  'signup'
])
param name string

@description('Optional. Portal setting properties.')
param properties object = {}

resource pid_cuaId 'Microsoft.Resources/deployments@2021-04-01' = if (!empty(telemetryCuaId)) {
  name: 'pid-${telemetryCuaId}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource portalSetting 'Microsoft.ApiManagement/service/portalsettings@2021-08-01' = if (!empty(properties)) {
  name: any(name)
  parent: service
  properties: properties
}

@description('The resource ID of the API management service portal setting')
output portalSettingsResourceId string = portalSetting.id

@description('The name of the API management service portal setting')
output portalSettingsName string = portalSetting.name

@description('The resource group the API management service portal setting was deployed into')
output portalSettingsResourceGroup string = resourceGroup().name
