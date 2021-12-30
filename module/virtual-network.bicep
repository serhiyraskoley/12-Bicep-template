param virtualNetworkName string = '${resourceGroup().name}-vnet'
param location string 
param addressPrefixes array = [
  '10.0.0.0/24'
]
param subnetName string = 'default'
param addressPrefix string = '10.0.0.0/24'

resource virtualNetworkName_resource 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: addressPrefix
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
  tags: {
    resoursegroup: '${resourceGroup().name}'
  }
}

var vnetId = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks', virtualNetworkName)
output subnetRef string = '${vnetId}/subnets/${subnetName}'
output vnet string = virtualNetworkName_resource.name
