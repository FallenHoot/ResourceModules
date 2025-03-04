# Activity Log Alerts `[Microsoft.Insights/activityLogAlerts]`

This module deploys an Alert based on Activity Log.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2020-10-01-preview](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-10-01-preview/roleAssignments) |
| `Microsoft.Insights/activityLogAlerts` | [2020-10-01](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-10-01/activityLogAlerts) |

## Parameters

**Required parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `conditions` | array |  | The condition that will cause this alert to activate. Array of objects. |
| `name` | string |  | The name of the alert. |
| `scopes` | array | `[[subscription().id]]` | the list of resource IDs that this metric alert is scoped to. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `actions` | array | `[]` | The list of actions to take when alert triggers. |
| `alertDescription` | string | `''` | Description of the alert. |
| `enabled` | bool | `True` | Indicates whether this alert is enabled. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `location` | string | `'global'` | Location for all resources. |
| `roleAssignments` | array | `[]` | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `tags` | object | `{object}` | Tags of the resource. |


### Parameter Usage: actions

<details>

<summary>Parameter JSON format</summary>

```json
"actions": {
    "value": [
        {
            "actionGroupId": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rgName/providers/microsoft.insights/actiongroups/actionGroupName",
            "webhookProperties": {}
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
actions: [
    {
        actionGroupId: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rgName/providers/microsoft.insights/actiongroups/actionGroupName'
        webhookProperties: {}
    }
]
```

</details>
<p>

`webhookProperties` is optional.

If you do only want to provide actionGroupIds, a shorthand use of the parameter is available.

<details>

<summary>Parameter JSON format</summary>

```json
"actions": {
    "value": [
        "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rgName/providers/microsoft.insights/actiongroups/actionGroupName"
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
actions: [
    '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rgName/providers/microsoft.insights/actiongroups/actionGroupName'
]
```

</details>
<p>

### Parameter Usage: conditions

**Conditions can also be combined with logical operators `allOf` and `anyOf`**


<details>

<summary>Parameter JSON format</summary>

```json
{
  "field": "string",
  "equals": "string",
  "containsAny": "array"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
{
    field: 'string'
    equals: 'string'
    containsAny: 'array'
}
```

</details>
</p>

Each condition can specify only one field between `equals` and `containsAny`.

| Parameter Name | Type             | Possible values                                                                                                                                                                                                   | Description                                                                                                                             |
| :------------- | :--------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------- |
| `field`        | string           | `resourceId`,<br>`category`,<br>`caller`,<br>`level`,<br>`operationName`,<br>`resourceGroup`,<br>`resourceProvider`,<br>`status`,<br>`subStatus`,<br>`resourceType`,<br> or anything beginning with `properties.` | Required. The name of the field that this condition will examine.                                                                       |
| `equals`       | string           |                                                                                                                                                                                                                   | Optional (Alternative to `containsAny`). The value to confront with.                                                                    |
| `containsAny`  | array of strings |                                                                                                                                                                                                                   | Optional (Alternative to `equals`). Condition will be satisfied if value of the field in the event is within one of the specified here. |

**Sample**

<details>

<summary>Parameter JSON format</summary>

```json
"conditions": {
    "value": [
        {
            "field": "category",
            "equals": "Administrative"
        },
        {
            "field": "resourceType",
            "equals": "microsoft.compute/virtualmachines"
        },
        {
            "field": "operationName",
            "equals": "Microsoft.Compute/virtualMachines/performMaintenance/action"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
conditions: [
    {
        field: 'category'
        equals: 'Administrative'
    }
    {
        field: 'resourceType'
        equals: 'microsoft.compute/virtualmachines'
    }
    {
        field: 'operationName'
        equals: 'Microsoft.Compute/virtualMachines/performMaintenance/action'
    }
]
```

</details>
<p>

**Sample 2**

<details>

<summary>Parameter JSON format</summary>

```json
"conditions":{
    "value": [
        {
            "field": "category",
            "equals": "ServiceHealth"
        },
        {
            "anyOf": [
                {
                    "field": "properties.incidentType",
                    "equals": "Incident"
                },
                {
                    "field": "properties.incidentType",
                    "equals": "Maintenance"
                }
            ]
        },
        {
            "field": "properties.impactedServices[*].ServiceName",
            "containsAny": [
                "Action Groups",
                "Activity Logs & Alerts"
            ]
        },
        {
            "field": "properties.impactedServices[*].ImpactedRegions[*].RegionName",
            "containsAny": [
                "West Europe",
                "Global"
            ]
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
conditions: [
    {
        field: 'category'
        equals: 'ServiceHealth'
    }
    {
        anyOf: [
            {
                field: 'properties.incidentType'
                equals: 'Incident'
            }
            {
                field: 'properties.incidentType'
                equals: 'Maintenance'
            }
        ]
    }
    {
        field: 'properties.impactedServices[*].ServiceName'
        containsAny: [
            'Action Groups'
            'Activity Logs & Alerts'
        ]
    }
    {
        field: 'properties.impactedServices[*].ImpactedRegions[*].RegionName'
        containsAny: [
            'West Europe'
            'Global'
        ]
    }
]
```

</details>
<p>

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

<details>

<summary>Parameter JSON format</summary>

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
roleAssignments: [
    {
        roleDefinitionIdOrName: 'Reader'
        description: 'Reader Role Assignment'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
            '78945612-1234-1234-1234-123456789012' // object 2
        ]
    }
    {
        roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
        ]
        principalType: 'ServicePrincipal'
    }
]
```

</details>
<p>

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the activity log alert. |
| `resourceGroupName` | string | The resource group the activity log alert was deployed into. |
| `resourceId` | string | The resource ID of the activity log alert. |

## Deployment examples

<h3>Example 1</h3>

<details>

<summary>via JSON Parameter file</summary>

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "value": "<<namePrefix>>-az-ala-x-001"
        },
        "scopes": {
            "value": [
                "/subscriptions/<<subscriptionId>>"
            ]
        },
        "conditions": {
            "value": [
                {
                    "field": "category",
                    "equals": "Administrative"
                },
                {
                    "field": "resourceType",
                    "equals": "microsoft.compute/virtualmachines"
                },
                {
                    "field": "operationName",
                    "equals": "Microsoft.Compute/virtualMachines/performMaintenance/action"
                }
            ]
        },
        "actions": {
            "value": [
                {
                    "actionGroupId": "/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/microsoft.insights/actiongroups/adp-<<namePrefix>>-az-ag-x-001"
                }
            ]
        },
        "roleAssignments": {
            "value": [
                {
                    "roleDefinitionIdOrName": "Reader",
                    "principalIds": [
                        "<<deploymentSpId>>"
                    ]
                }
            ]
        }
    }
}

```

</details>

<details>

<summary>via Bicep module</summary>

```bicep
module activityLogAlerts './Microsoft.Insights/activityLogAlerts/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-activityLogAlerts'
  params: {
    name: '<<namePrefix>>-az-ala-x-001'
    scopes: [
      '/subscriptions/<<subscriptionId>>'
    ]
    conditions: [
      {
        field: 'category'
        equals: 'Administrative'
      }
      {
        field: 'resourceType'
        equals: 'microsoft.compute/virtualmachines'
      }
      {
        field: 'operationName'
        equals: 'Microsoft.Compute/virtualMachines/performMaintenance/action'
      }
    ]
    actions: [
      {
        actionGroupId: '/subscriptions/<<subscriptionId>>/resourceGroups/validation-rg/providers/microsoft.insights/actiongroups/adp-<<namePrefix>>-az-ag-x-001'
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '<<deploymentSpId>>'
        ]
      }
    ]
  }
```

</details>
<p>
