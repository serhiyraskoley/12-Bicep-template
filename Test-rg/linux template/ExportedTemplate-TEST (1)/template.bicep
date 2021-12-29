param virtualMachines_Linux_name string = 'Linux'
param virtualNetworks_TEST_vnet_name string = 'TEST-vnet'
param networkInterfaces_linux422_name string = 'linux422'
param publicIPAddresses_Linux_ip_name string = 'Linux-ip'
param networkSecurityGroups_Linux_nsg_name string = 'Linux-nsg'

resource networkSecurityGroups_Linux_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: networkSecurityGroups_Linux_nsg_name
  location: 'eastus'
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource publicIPAddresses_Linux_ip_name_resource 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: publicIPAddresses_Linux_ip_name
  location: 'eastus'
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.121.25.44'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource virtualNetworks_TEST_vnet_name_resource 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworks_TEST_vnet_name
  location: 'eastus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.1.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualMachines_Linux_name_resource 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: virtualMachines_Linux_name
  location: 'eastus'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts'
        version: 'latest'
      }
      osDisk: {
        osType: virtualMachines_Linux_name
        name: '${virtualMachines_Linux_name}_disk1_aa4a3d97a9aa4ab6b7339553dd04ce9a'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: resourceId('Microsoft.Compute/disks', '${virtualMachines_Linux_name}_disk1_aa4a3d97a9aa4ab6b7339553dd04ce9a')
        }
        deleteOption: 'Detach'
        diskSizeGB: 30
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_Linux_name
      adminUsername: 'serhiyadmin'
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_linux422_name_resource.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource networkSecurityGroups_Linux_nsg_name_SSH 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  parent: networkSecurityGroups_Linux_nsg_name_resource
  name: 'SSH'
  properties: {
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 300
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
}

resource virtualNetworks_TEST_vnet_name_default 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: virtualNetworks_TEST_vnet_name_resource
  name: 'default'
  properties: {
    addressPrefix: '10.1.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource networkInterfaces_linux422_name_resource 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: networkInterfaces_linux422_name
  location: 'eastus'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '10.1.0.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_Linux_ip_name_resource.id
          }
          subnet: {
            id: virtualNetworks_TEST_vnet_name_default.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    networkSecurityGroup: {
      id: networkSecurityGroups_Linux_nsg_name_resource.id
    }
  }
}