Quick and dirty repro to deploy a .NET web app to Azure App Service. Uses .NET Core 7.x

- [Infrastructure as Code (Terraform)](#infrastructure-as-code-terraform)
- [Pipelines](#pipelines)
  - [deploy\_iac.yml](#deploy_iacyml)
  - [deploy\_dotnet.yml](#deploy_dotnetyml)
- [App content](#app-content)


```bash
├── app                 # .NET Web App Content
├── infra               # Terraform IAC
│   ├── dev             # Dev environment configuration
│   ├── modules         # Modules
│   └── prod            # Production environment configuration
└── .pipelines          # Azure DevOps Pipelines
```

## Infrastructure as Code (Terraform)

Using Terraform, there is one module, app_service_module, for deploying the App Service Plan and Web App. The SKU is restricted to F1 or B1.

There are separate directories for each environment. This facilitates separate configurations and states for each environment.

***Module Variables***

```yaml
  APPNAME: 'Name of app'
  ENV: 'Environment, will be prefixed in naming scheme'
  LOCATION: 'Location to deploy resources to'
  SKU: 'App Service Plan SKU. Must be F1 or B1'
```

## Pipelines

Two pipelines - I'm not doing any testing so there wasn't much need to have separate CI/CD pipelines but should be simple enough to break up if the need arises.

Note: These were run on a Raspberry Pi as a self-hosted agent.

### deploy_iac.yml

Simple Terraform deployment using the [Terraform ADO extension.](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.custom-terraform-tasks) Creates Azure Infrastructure including:

- Resource Group
- App Service Plan (Windows)
- Web App (.NET v7.0)

***Pipeline Parameters***

When deploying, you must provide these parameters. The working directory will be set based on which environment you pick.

```yaml
  APPNAME: 'Name of app'
  ENV: 'Environment, will be prefixed in naming scheme'
    Choices: ['DEV', 'PROD']
  LOCATION: 'Location to deploy resources to'
    Choices: ['East US', 'Central US']
  SKU: 'App Service Plan SKU'
    Choices: ['F1','B1']
```

These will then be assigned to TF_VAR_VARNAME variables to be used when the Terraform configurations are applied.

### deploy_dotnet.yml

Very minimal .NET deployment to Azure App Service per the following documentation:

- [Build, test, and deploy .NET Core apps](https://learn.microsoft.com/en-us/azure/devops/pipelines/ecosystems/dotnet-core?view=azure-devops&tabs=dotnetfive)
- [Deploy to App Service using Azure Pipelines](https://learn.microsoft.com/en-us/azure/app-service/deploy-azure-pipelines?tabs=yaml)

I did have to add an additional UseDotNet@2 task to manually install .NET during the run, as my self-hosted agent seemed to have issues otherwise.

## App content

Barebones .NET web app created with:

```bash
dotnet new webapp -f net6.0
```