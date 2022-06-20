This section provides an overview of the principles the static validation is built upon, how it is set up, and how you can interact with it.

- [Static code validation](#static-code-validation)
- [API version validation](#api-version-validation)
- [Verify the static validation of your module locally](#verify-the-static-validation-of-your-module-locally)

<img src="./media/CIEnvironment/staticValidationStep.png" alt="Static Validation Step" height="300">

---

# Static code validation

All module Unit tests are performed with the help of [Pester](https://github.com/pester/Pester) and ensure that our modules are configured correctly, documentation is up to date, and modules don't turn stale.

The following activities are run executing the `arm/.global/global.module.tests.ps1` script.

- **File & folder tests** validate that the module folder structure is set up in the intended way. e.g.:
  - readme.md file exists
  - template file (either deploy.json or deploy.bicep) exists
  - compliance with file naming convention
- **Deployment template tests** check the template's structure and elements for errors as well as consistency matters. e.g.
  - template file (or the built bicep template) converts from JSON and has all expected properties
  - variable names are camelCase
  - the minimum set of outputs is returned (see [module design](./The%20library%20-%20Module%20design#Outputs))
- **Module (readme.md) documentation** contains all required sections. e.g.:
  - is not empty
  - contains all the mandatory sections
  - describes all the parameters
- **Parameter Files**. e.g.:
  - at least one `*parameters.json` exists
  - files should be valid JSON
  - contains all required parameters
  - (if tokens are used) Tests that no token values (e.g. `11111111-1111-1111-1111-11111111111`) from the specified token list (i.e. `deploymentSpId`, `subscriptionId`, `managementGroupId`, `tenantId`) are used in the parameter files. Instead, the token itself should be referenced.

## Output example

<img src="./media/CIEnvironment/staticValidationOutput.png" alt="Static Validation Output" height="400">

## Additional resources

- [Pester Wiki](https://github.com/pester/Pester/wiki)
- [Pester on GitHub](https://github.com/pester/Pester)
- [Pester Installation and Update](https://pester.dev/docs/introduction/installation)

# API version validation

In this phase, Pester analyzes the API version of each resource type deployed by the module.

In particular, each resource's API version is compared with those currently available on Azure. Accepted are both the latest 5 versions (including preview versions) as well as the latest 5 non-preview versions.

This test also leverages the `arm/.global/global.module.tests.ps1` script.

# Verify the static validation of your module locally


This paragraph is intended for CARML contributors or more generally for those leveraging the CARML CI environment and having the need to update or add a new module to the library.

Refer to the below snippet to leverage the 'Test-ModuleLocally.ps1' script and verify if your module will comply to the static validation before pushing to source control.

```powershell
#########[ Function Test-ModulesLocally.ps1 ]#############
$pathToRepository = '<pathToClonedRepo>'
. "$pathToRepository\utilities\tools\Test-ModuleLocally.ps1"

# REQUIRED INPUT FOR TESTING
$TestModuleLocallyInput = @{
    templateFilePath              = "$pathToRepository\arm\Microsoft.Authorization\roleDefinitions\deploy.bicep"
    PesterTest                    = $true
    DeploymentTest                = $false
    ValidationTest                = $false
}

Test-ModuleLocally @TestModuleLocallyInput -Verbose
```

> You can use the `Get-Help` cmdlet to show more options on how you can use this script.

