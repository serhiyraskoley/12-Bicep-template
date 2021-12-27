param virtualMachines_Windows_name string = 'Windows'
param disks_Windows_disk1_cef8fdad05234bca8f3584f87a6df26b_externalid string = '/subscriptions/f4004ed5-6cdb-4ddc-bb57-a852b2e2e577/resourceGroups/EleksAzureCamp-rg/providers/Microsoft.Compute/disks/Windows_disk1_cef8fdad05234bca8f3584f87a6df26b'
param networkInterfaces_windows162_externalid string = '/subscriptions/f4004ed5-6cdb-4ddc-bb57-a852b2e2e577/resourceGroups/EleksAzureCamp-rg/providers/Microsoft.Network/networkInterfaces/windows162'

resource virtualMachines_Windows_name_resource 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: virtualMachines_Windows_name
  location: 'eastus'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Microsoft${virtualMachines_Windows_name}Server'
        offer: '${virtualMachines_Windows_name}Server'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        osType: virtualMachines_Windows_name
        name: '${virtualMachines_Windows_name}_disk1_cef8fdad05234bca8f3584f87a6df26b'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: disks_Windows_disk1_cef8fdad05234bca8f3584f87a6df26b_externalid
        }
        deleteOption: 'Detach'
        diskSizeGB: 127
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_Windows_name
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
          id: networkInterfaces_windows162_externalid
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