param virtualMachines_VM_1_name string = 'VM-1'
param virtualMachines_VM_2_name string = 'VM-2'
param sshPublicKeys_test1234_name string = 'test1234'
param networkInterfaces_vm_1694_name string = 'vm-1694'
param networkInterfaces_vm_2883_name string = 'vm-2883'
param publicIPAddresses_VM_1_ip_name string = 'VM-1-ip'
param publicIPAddresses_VM_2_ip_name string = 'VM-2-ip'
param virtualNetworks_TEST_vnet_name string = 'TEST-vnet'
param networkSecurityGroups_VM_1_nsg_name string = 'VM-1-nsg'
param networkSecurityGroups_VM_2_nsg_name string = 'VM-2-nsg'
param disks_VM_1_disk1_fb0367b3d7ba451aa45f068e9685f3a3_externalid string = '/subscriptions/f4004ed5-6cdb-4ddc-bb57-a852b2e2e577/resourceGroups/TEST/providers/Microsoft.Compute/disks/VM-1_disk1_fb0367b3d7ba451aa45f068e9685f3a3'
param disks_VM_2_OsDisk_1_78caa2e3da2e47bfaf662c68795da786_externalid string = '/subscriptions/f4004ed5-6cdb-4ddc-bb57-a852b2e2e577/resourceGroups/TEST/providers/Microsoft.Compute/disks/VM-2_OsDisk_1_78caa2e3da2e47bfaf662c68795da786'

resource sshPublicKeys_test1234_name_resource 'Microsoft.Compute/sshPublicKeys@2021-07-01' = {
  name: sshPublicKeys_test1234_name
  location: 'westeurope'
  properties: {
    publicKey: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDO0lMj/PrM4BQMnTjQ9syi3koS\r\nY+e6KUNvQYf9Pl7K5fmfxc7R8dxQpTuce7EG6iU6NLtlXEYXTrqIq0jwuwBOLe0O\r\nwG0M72F/BV3f7VhZdSg0a/qJTg7Z/yei5R0vtNFHry31d1cWynul965KdfuUl2QQ\r\n4GfIZMOPsb2THsWu0zbyvWyllgGWcjrmtiPfA9QlaYeKlXzg6GMKTBmRAVBjvlds\r\n6StBz4FpriWMuTdtyS7iEpQNPlebH6MYiYLAD98bPvRNdanlXndNFmiNBEM61sDb\r\nUE45JW6ndj4OCY3ae6qAIFgUdG8nyrhHHFAH++0YMJO3LZ0CmVzm32LvtzGQieTo\r\nbmEHhANLc4j71NIvTuRYA/q9F7T9VViofWiSUp4u7wlpwZDGQxMOVTw0xzvj6ZL8\r\nH7hJOr6BiKh4stxkpwmEmEkKll2Pue6jHjx00qJ3xgazPKznCuP7SpMVKvkpFahR\r\nc01PqAuGRYNTAQs7gjQnSKF6CPJxzeNl+fnLZOU= generated-by-azure\r\n'
  }
}

resource networkSecurityGroups_VM_1_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: networkSecurityGroups_VM_1_nsg_name
  location: 'westeurope'
  properties: {
    securityRules: [
      {
        name: 'RDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
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

resource networkSecurityGroups_VM_2_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: networkSecurityGroups_VM_2_nsg_name
  location: 'westeurope'
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

resource publicIPAddresses_VM_1_ip_name_resource 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: publicIPAddresses_VM_1_ip_name
  location: 'westeurope'
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '51.124.202.198'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource publicIPAddresses_VM_2_ip_name_resource 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: publicIPAddresses_VM_2_ip_name
  location: 'westeurope'
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '51.124.233.58'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource virtualNetworks_TEST_vnet_name_resource 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworks_TEST_vnet_name
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
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

resource virtualMachines_VM_1_name_resource 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: virtualMachines_VM_1_name
  location: 'westeurope'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_VM_1_name}_disk1_fb0367b3d7ba451aa45f068e9685f3a3'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: disks_VM_1_disk1_fb0367b3d7ba451aa45f068e9685f3a3_externalid
        }
        deleteOption: 'Detach'
        diskSizeGB: 127
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_VM_1_name
      adminUsername: 'serhiyadmin'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_vm_1694_name_resource.id
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

resource virtualMachines_VM_2_name_resource 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: virtualMachines_VM_2_name
  location: 'westeurope'
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
        osType: 'Linux'
        name: '${virtualMachines_VM_2_name}_OsDisk_1_78caa2e3da2e47bfaf662c68795da786'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: disks_VM_2_OsDisk_1_78caa2e3da2e47bfaf662c68795da786_externalid
        }
        deleteOption: 'Detach'
        diskSizeGB: 30
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_VM_2_name
      adminUsername: 'azureuser'
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/azureuser/.ssh/authorized_keys'
              keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDO0lMj/PrM4BQMnTjQ9syi3koS\r\nY+e6KUNvQYf9Pl7K5fmfxc7R8dxQpTuce7EG6iU6NLtlXEYXTrqIq0jwuwBOLe0O\r\nwG0M72F/BV3f7VhZdSg0a/qJTg7Z/yei5R0vtNFHry31d1cWynul965KdfuUl2QQ\r\n4GfIZMOPsb2THsWu0zbyvWyllgGWcjrmtiPfA9QlaYeKlXzg6GMKTBmRAVBjvlds\r\n6StBz4FpriWMuTdtyS7iEpQNPlebH6MYiYLAD98bPvRNdanlXndNFmiNBEM61sDb\r\nUE45JW6ndj4OCY3ae6qAIFgUdG8nyrhHHFAH++0YMJO3LZ0CmVzm32LvtzGQieTo\r\nbmEHhANLc4j71NIvTuRYA/q9F7T9VViofWiSUp4u7wlpwZDGQxMOVTw0xzvj6ZL8\r\nH7hJOr6BiKh4stxkpwmEmEkKll2Pue6jHjx00qJ3xgazPKznCuP7SpMVKvkpFahR\r\nc01PqAuGRYNTAQs7gjQnSKF6CPJxzeNl+fnLZOU= generated-by-azure\r\n'
            }
          ]
        }
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
          id: networkInterfaces_vm_2883_name_resource.id
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

resource networkSecurityGroups_VM_1_nsg_name_RDP 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  parent: networkSecurityGroups_VM_1_nsg_name_resource
  name: 'RDP'
  properties: {
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '3389'
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

resource networkSecurityGroups_VM_2_nsg_name_SSH 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  parent: networkSecurityGroups_VM_2_nsg_name_resource
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
    addressPrefix: '10.0.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource networkInterfaces_vm_1694_name_resource 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: networkInterfaces_vm_1694_name
  location: 'westeurope'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '10.0.0.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_VM_1_ip_name_resource.id
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
      id: networkSecurityGroups_VM_1_nsg_name_resource.id
    }
  }
}

resource networkInterfaces_vm_2883_name_resource 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: networkInterfaces_vm_2883_name
  location: 'westeurope'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '10.0.0.5'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_VM_2_ip_name_resource.id
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
      id: networkSecurityGroups_VM_2_nsg_name_resource.id
    }
  }
}