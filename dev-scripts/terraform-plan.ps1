param(
    [switch]$RunInit
)

$ErrorActionPreference = 'Stop'
$moduleRoot = Split-Path $PSScriptRoot -Parent
$backendResourceGroupName = 'rg-alz-sep-state-swedencentral-001'
$backendStorageAccountName = 'stoalzsepswe001aafj'
$backendContainerName = 'sep-tfstate'

foreach ($command in 'az', 'terraform') {
    if (-not (Get-Command $command -ErrorAction SilentlyContinue)) {
        throw "Required command '$command' was not found in PATH."
    }
}

#$env:ARM_USE_CLI = 'true'
#$env:ARM_USE_AZUREAD = 'true'

& az account show --output none
if ($LASTEXITCODE -ne 0) {
    throw 'Azure CLI is not authenticated. Run az login and select the intended subscription.'
}

if ($RunInit) {
    $terraformArguments = @(
        "-chdir=$moduleRoot",
        'init',
        '-input=false',
        "-backend-config=resource_group_name=$backendResourceGroupName",
        "-backend-config=storage_account_name=$backendStorageAccountName",
        "-backend-config=container_name=$backendContainerName",
        '-backend-config=key=terraform.tfstate',
        '-backend-config=use_cli=true',
        '-backend-config=use_azuread_auth=true'
    )
    & terraform @terraformArguments
    if ($LASTEXITCODE -ne 0) {
        throw 'terraform init failed.'
    }
}

& terraform "-chdir=$moduleRoot" plan -input=false
if ($LASTEXITCODE -ne 0) {
    throw 'terraform plan failed.'
}