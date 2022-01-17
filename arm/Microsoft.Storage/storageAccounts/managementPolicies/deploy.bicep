@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('Optional. The name of the storage container to deploy')
param name string = 'default'

@description('Required. The Storage Account ManagementPolicies Rules')
param rules array

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param telemetryCuaId string = ''

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

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: storageAccountName
}

// lifecycle policy
resource managementPolicy 'Microsoft.Storage/storageAccounts/managementPolicies@2019-06-01' = if (!empty(rules)) {
  name: name
  parent: storageAccount
  properties: {
    policy: {
      rules: rules
    }
  }
}

@description('The resource ID of the deployed management policy')
output managementPoliciesResourceId string = managementPolicy.name

@description('The name of the deployed management policy')
output managementPoliciesName string = managementPolicy.name

@description('The resource group of the deployed management policy')
output managementPoliciesResourceGroup string = resourceGroup().name
