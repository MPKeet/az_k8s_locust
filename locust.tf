#############################
# Providers
#############################

provider "azurerm" {
  version         = "=2.35.0"

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  features {}
}

provider "azuread" {
  version = "=1.0.0"
}

provider "random" {
  version = "=3.0.0"
}

provider "kubernetes" {
  host                   = data.azurerm_key_vault_secret.core_itter["aks-host"].value
  username               = data.azurerm_key_vault_secret.core_itter["aks-admin-username"].value
  password               = data.azurerm_key_vault_secret.core_itter["aks-admin-password"].value
  client_certificate     = data.azurerm_key_vault_secret.core_itter["aks-client-cert"].value
  client_key             = data.azurerm_key_vault_secret.core_itter["aks-client-key"].value
  cluster_ca_certificate = data.azurerm_key_vault_secret.core_itter["aks-ca-certificate"].value
}

locals {
  acr_name = var.acr_name
  loku_repository_name = "loku"
  image_repository = "${local.acr_name}.azurecr.io/${local.loku_repository_name}:latest"
  namespace = "locust-namespace"
  jsonpath = "{.items[0].metadata.name}"
  backend_container_name = var.backend_container_name != "" ? var.backend_container_name : "sandbox-${var.name}"
  keyvault_name = data.terraform_remote_state.create_core_infrastructure.outputs.akv_name

  #list of secret names in core-secrets keyvault
  core_key_list = [
    for i in data.azurerm_key_vault_secrets.core-secrets.names : format("%s", i)
  ]
}

#############################
# Data Sources
#############################


data "terraform_remote_state" "create_core_infrastructure" {
  backend = "azurerm"
  config = {
    storage_account_name = "bkcterraform"
    container_name = local.backend_container_name
    key = "create_core_infrastructure.terraform.tfstate"
  }
}

data "azurerm_key_vault" "core-info" {
  name = local.keyvault_name
  resource_group_name = local.core_rg
}

#gets all names from core-info key vault
data "azurerm_key_vault_secrets" "core-secrets" {
  key_vault_id = data.azurerm_key_vault.core-info.id
}

#iterates through above list and sets a data source for each secret
data "azurerm_key_vault_secret" "core_itter" {
  for_each = {
    for i in local.core_key_list:
      i => {"type" = "string"}
  }
  name     = each.key
  key_vault_id = data.azurerm_key_vault.core-info.id
}

data "azurerm_kubernetes_cluster" "airflow_aks" {
  name = var.aks_cluster_name
  resource_group_name = "container-services-rg"
}


resource "kubernetes_namespace" "locust" {

  metadata {
    annotations = {
      name = "example-annotation"
      }
    name = local.namespace
  }
}

resource "helm_release" "locust" {
  name = "locust"
  chart = var.loku_helm_path
  namespace = "locust-namespace"
  depends_on = [
    kubernetes_namespace.locust
  ]

  values = [
    file("${var.loku_helm_path}/values.yaml")
  ]
  
  set {
    name = "master.image.repository"
    value = local.image_repository
  }

  set {
    name = "worker.image.repository"
    value = local.image_repository
  }

  set {
    name = "worker.replicaCount"
    value = 15
  }  
}

resource "null_resource" "k8" {
  provisioner "local-exec" {
    command = "mastpod=`kubectl get pods -l app=locust-master -o jsonpath=${local.jsonpath} --namespace ${local.namespace}` && kubectl port-forward $mastpod 8089:8089 --namespace ${local.namespace}"
  }
  depends_on = [ helm_release.locust ]
}
output "airflow_url" {
  value = "Your Locust deployment is now reachable at https://localhost:8089"
}
