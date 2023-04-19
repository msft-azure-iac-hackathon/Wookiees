targetScope='resourceGroup'
// param subscriptionId string
param name string
param location string = resourceGroup().location
param hostingPlanName string
// param serverFarmResourceGroup string
// param use32BitWorkerProcess bool
// param ftpsState string
param storageAccountName string
param storageAccountId string
// param linuxFxVersion string
// param sku string
// param skuCode string
// param workerSize string
// param workerSizeId string
// param numberOfWorkers string
// param repoUrl string
// param branch string

resource name_resource 'Microsoft.Web/sites@2022-09-01' = {
  name: name
  kind: 'functionapp,linux'
  location: location
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listKeys(storageAccountId, '2019-06-01').keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listKeys(storageAccountId, '2019-06-01').keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: 'wookie-webgetter8c42'
        }
      ]
      cors: {
        allowedOrigins: [
          'https://portal.azure.com'
        ]
      }
      // use32BitWorkerProcess: false
      // ftpsState: ftpsState
      // linuxFxVersion: linuxFxVersion
    }
    // serverFarmId: '/subscriptions/${subscriptionId}/resourcegroups/${serverFarmResourceGroup}/providers/Microsoft.Web/serverfarms/${hostingPlanName}'
    clientAffinityEnabled: false
    virtualNetworkSubnetId: null
    httpsOnly: true
    publicNetworkAccess: 'Enabled'
  }
  dependsOn: [
    hostingPlan
  ]
}

// resource name_web 'Microsoft.Web/sites/sourcecontrols@2022-09-01' = {
//   parent: name_resource
//   name: 'web'
//   properties: {
//     repoUrl: repoUrl
//     branch: branch
//     isManualIntegration: false
//     deploymentRollbackEnabled: false
//     isMercurial: false
//     isGitHubAction: true
//     gitHubActionConfiguration: {
//       generateWorkflowFile: true
//       workflowSettings: {
//         appType: 'functionapp'
//         publishType: 'code'
//         os: 'linux'
//         runtimeStack: 'dotnet'
//         workflowApiVersion: '2020-12-01'
//         slotName: 'production'
//         variables: {
//           runtimeVersion: '6.0.x'
//         }
//       }
//     }
//   }
// }

resource hostingPlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: hostingPlanName
  location: location
  kind: 'linux'
  tags: {}
  properties: {
    // workerSize: workerSize
    // workerSizeId: workerSizeId
    // numberOfWorkers: numberOfWorkers
    reserved: true
  }
  sku: {
    tier: 'Dynamic'
    name: 'Y1'
  }
  dependsOn: []
}
