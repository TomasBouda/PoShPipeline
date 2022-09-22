# PoShPipeline [![psgallery](https://img.shields.io/powershellgallery/v/PoShPipeline.svg)](https://www.powershellgallery.com/packages/PoShPipeline/) [![psgallery](https://img.shields.io/powershellgallery/dt/PoShPipeline.svg)](https://www.powershellgallery.com/packages/PoShPipeline/)

Collection of scripts I use in Azure Pipelines

## Usage

azure-pipelines.yml
```yml
...

- task: PowerShell@2
  inputs:
    targetType: 'inline'
    script: |
      Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
      Install-Module -Name PoShPipeline -Force -Verbose -Scope CurrentUser
      Import-Module -Name PoShPipeline
      
...
```
