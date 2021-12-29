targetScope = 'subscription'
param resoursePrefix string = 'EleksAzureDevOpsCamp'
@description('Location')
@allowed([
  'eastus'
  'westus'
])
param location string = 'eastus'
@description('Operation System')
@allowed([
  'Windows'
  'Linux'
])
param os string = 'Windows'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${resoursePrefix}-rg'
  location: location
}

module vn 'module/virtual-network.bicep' = {
  scope: rg
  name: 'virtualNetwork'
  params: {
    location: location
  }
}

 module vm 'module/virtual-machine.bicep' = {
   scope: rg
   name: 'virtualMachine'
   params: {
     computerName: 'Webserver'
     os: os
     subnetRef: vn.outputs.subnetRef
     adminUsername: 'serhiyadmin' 
     virtualNetworkName: vn.outputs.vnet
   }
 }

