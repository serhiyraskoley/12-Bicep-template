targetScope = 'subscription'
param resoursePrefix string = 'EleksAzureDevOpsCamp'
@description('Location')
@allowed([
  'eastus'
  'westus'
])
param location string = 'eastus'


resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${resoursePrefix}-rg'
  location: location
}

module vn 'module/vn.bicep' = {
  scope: rg
  name: 'virtualNetowrks'
  params: {
    location: location
  }
}


