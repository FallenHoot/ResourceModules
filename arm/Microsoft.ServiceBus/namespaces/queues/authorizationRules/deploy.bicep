@description('Required. The name of the service bus namepace queue')
param name string

@description('Required. The name of the parent service bus namespace')
param namespaceName string

@description('Required. The name of the parent service bus namespace queue')
param queueName string

@description('Optional. The rights associated with the rule.')
@allowed([
  'Listen'
  'Manage'
  'Send'
])
param rights array = []

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

resource namespace 'Microsoft.ServiceBus/namespaces@2021-06-01-preview' existing = {
  name: namespaceName

  resource queue 'queues@2021-06-01-preview' existing = {
    name: queueName
  }
}

resource authorizationRule 'Microsoft.ServiceBus/namespaces/queues/authorizationRules@2017-04-01' = {
  name: name
  parent: namespace::queue
  properties: {
    rights: rights
  }
}

@description('The name of the authorization rule.')
output authorizationRuleName string = authorizationRule.name

@description('The Resource ID of the authorization rule.')
output authorizationRuleResourceId string = authorizationRule.id

@description('The name of the Resource Group the authorization rule was created in.')
output authorizationRuleResourceGroup string = resourceGroup().name
