param location string = resourceGroup().location

resource kubernetesVNet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: 'kubernetes-the-hard-way'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/26'
      ]
    }
  }
}
