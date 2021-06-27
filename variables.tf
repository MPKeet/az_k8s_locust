variable "name" {
  type = string
  description = "The name used to differentiate Azure resources & Airflow deployments in the Sandbox evironments."
}

variable "sandbox" {
  type = bool
  description = "Flag indicating whether this is a sandbox subscription deployment or not.  If not, the 'name' variable will not be used."
  default = true
}

variable "subscription_id" {
  type = string
  description = "The Azure subscription ID to be deployed to."
  default = "200cdc10-c664-4977-adb3-edf02fb85d6c"
}

variable "tenant_id" {
  type = string
  description = "The Azure tenant ID to be deployed to."
  default = "6bf1a438-ef3a-475a-9e51-6ff6e79af305"
}

variable "location" {
  type = string
  description = "The default location to which all Airflow resources will be deployed."
  default = "Central US"
}

variable "ad_app_name" {
  type = string
  description = "The name of the Azure Active Directory Application for connecting AKS to ACR and KeyVault."
  default = "airflow"
}

variable "azuread_sp_pwd_end_date_relative" {
  type = string
  description = "The amount of time between password expirations for the Service Principal connecting AKS to ACR and KeyVault, in hours.  E.g. '239976h' for 9999 days.  Note the string ends with 'h'."
  default = "239976h"
}

variable "storage_account_name" {
  type = string
  description = "The name of the storage account to be created for Airflow logs and other persistent storage needs by Airflow."
  default = "dapairflowpersistentstorage"
}

variable "storage_account_tier" {
  type = string
  description = "The level/tier of the storage account to use."
  default = "Standard"
}

variable "storage_account_replication_type" {
  type = string
  description = "The type of replication to use for the Storage Account: https://docs.microsoft.com/en-us/azure/storage/common/redundancy-migration?tabs=portal"
  default = "LRS" # Locally redundant storage

  validation {
    condition = can(regex("^(LRS|ZRS|GRS|RA-GRS|GZRS|RA-GZRS)$", var.storage_account_replication_type))
    error_message = "The specified storage_account_replication_type is not recognized."
  }
}

variable "airflow_logging_storage_container_name" {
  type = string
  description = "The name of the storage container to use for storing the Airflow logs."
  default = "airflow-logs"
}

variable "airflow_logging_directory_name" {
  type = string
  description = "The name of the directory within the storage container to use for storing the Airflow logs."
  default = "wasb-airflow-logs"
}

variable "airflow_dags_file_share_name" {
  type = string
  description = "The name of the Azure file share to be created in the storage account."
  default = "airflow-dags-file-share"

  validation {
    condition = length(var.airflow_dags_file_share_name) >= 3 && length(var.airflow_dags_file_share_name) <= 63
    error_message = "Validation for variable 'airflow_dags_file_share_name' failed - variable must be between 3 and 63 characters in length."
  }
}

variable "airflow_dags_file_share_quota" {
  type = number
  description = "The maximum size of the Azure file share (in GB)."
  default = 3
}

variable "keyvault_name" {
  type = string
  description = "The name of the Azure KeyVault that will be used by Airflow."
  default = "DapAirflowKeyVault"
}

variable "akv_enable_purge_protection" {
  type = bool
  description = "Property - enablePurgeProtection"
}

variable "akv_enable_soft_delete" {
  type = bool
  description = "Property - enableSoftDelete"
}

variable "akv_soft_delete_retention_in_days" {
  type = number
  description = "Property - softDeleteRetentionInDays"

  validation {
    condition = var.akv_soft_delete_retention_in_days >= 7 && var.akv_soft_delete_retention_in_days <= 90
    error_message = "Validation for variable 'akv_soft_delete_retention_in_days' failed - variable must be an integer between 7 and 90."
  }
}

variable "akv_sku" {
  type = string
  description = "The tier/sku to use for Airflow's Azure KeyVault."
  default = "standard"
}

variable "akv_key_access_policy" {
  type = list(string)
  description = "The list of permissions to grant the Service Principal for AKS to the KeyVault Keys."
}

variable "akv_secret_access_policy" {
  type = list(string)
  description = "The list of permissions to grant the Service Principal for AKS to the KeyVault Secret."
}

variable "akv_certificate_access_policy" {
  type = list(string)
  description = "The list of permissions to grant the Service Principal for AKS to the KeyVault Certificate."
}

variable "akv_storage_access_policy" {
  type = list(string)
  description = "The list of permissions to grant the Service Principal for AKS to the KeyVault Storage."
}

variable "kubernetes_version" {
  type = string
  description = "The kubernetes version to use for the AKS deployment in the form 'Major.Minor.Patch' e.g. '1.17.9'"
}

variable "aks_cluster_name" {
  type = string
  description = "The name to give the AKS instance being deployed."
  default = "DapAks"
}

variable "aks_vm_size" {
  type = string
  description = "The VM size to be used for AKS nodes"
  default = "Standard_A2m_v2"

  validation {
    condition = var.aks_vm_size == "Standard_A1" || var.aks_vm_size == "Standard_A10" || var.aks_vm_size == "Standard_A11" || var.aks_vm_size == "Standard_A1_v2" || var.aks_vm_size == "Standard_A2" || var.aks_vm_size == "Standard_A2_v2" || var.aks_vm_size == "Standard_A2m_v2" || var.aks_vm_size == "Standard_A3" || var.aks_vm_size == "Standard_A4" || var.aks_vm_size == "Standard_A4_v2" || var.aks_vm_size == "Standard_A4m_v2" || var.aks_vm_size == "Standard_A5" || var.aks_vm_size == "Standard_A6" || var.aks_vm_size == "Standard_A7" || var.aks_vm_size == "Standard_A8" || var.aks_vm_size == "Standard_A8_v2" || var.aks_vm_size == "Standard_A8m_v2" || var.aks_vm_size == "Standard_A9" || var.aks_vm_size == "Standard_B2ms" || var.aks_vm_size == "Standard_B2s" || var.aks_vm_size == "Standard_B4ms" || var.aks_vm_size == "Standard_B8ms" || var.aks_vm_size == "Standard_D1" || var.aks_vm_size == "Standard_D11" || var.aks_vm_size == "Standard_D11_v2" || var.aks_vm_size == "Standard_D11_v2_Promo" || var.aks_vm_size == "Standard_D12" || var.aks_vm_size == "Standard_D12_v2" || var.aks_vm_size == "Standard_D12_v2_Promo" || var.aks_vm_size == "Standard_D13" || var.aks_vm_size == "Standard_D13_v2" || var.aks_vm_size == "Standard_D13_v2_Promo" || var.aks_vm_size == "Standard_D14" || var.aks_vm_size == "Standard_D14_v2" || var.aks_vm_size == "Standard_D14_v2_Promo" || var.aks_vm_size == "Standard_D15_v2" || var.aks_vm_size == "Standard_D16_v3" || var.aks_vm_size == "Standard_D16s_v3" || var.aks_vm_size == "Standard_D1_v2" || var.aks_vm_size == "Standard_D2" || var.aks_vm_size == "Standard_D2_v2" || var.aks_vm_size == "Standard_D2_v2_Promo" || var.aks_vm_size == "Standard_D2_v3" || var.aks_vm_size == "Standard_D2s_v3" || var.aks_vm_size == "Standard_D3" || var.aks_vm_size == "Standard_D32_v3" || var.aks_vm_size == "Standard_D32s_v3" || var.aks_vm_size == "Standard_D3_v2" || var.aks_vm_size == "Standard_D3_v2_Promo" || var.aks_vm_size == "Standard_D4" || var.aks_vm_size == "Standard_D4_v2" || var.aks_vm_size == "Standard_D4_v2_Promo" || var.aks_vm_size == "Standard_D4_v3" || var.aks_vm_size == "Standard_D4s_v3" || var.aks_vm_size == "Standard_D5_v2" || var.aks_vm_size == "Standard_D5_v2_Promo" || var.aks_vm_size == "Standard_D64_v3" || var.aks_vm_size == "Standard_D64s_v3" || var.aks_vm_size == "Standard_D8_v3" || var.aks_vm_size == "Standard_D8s_v3" || var.aks_vm_size == "Standard_DS1" || var.aks_vm_size == "Standard_DS11" || var.aks_vm_size == "Standard_DS11_v2" || var.aks_vm_size == "Standard_DS11_v2_Promo" || var.aks_vm_size == "Standard_DS12" || var.aks_vm_size == "Standard_DS12_v2" || var.aks_vm_size == "Standard_DS12_v2_Promo" || var.aks_vm_size == "Standard_DS13" || var.aks_vm_size == "Standard_DS13-2_v2" || var.aks_vm_size == "Standard_DS13-4_v2" || var.aks_vm_size == "Standard_DS13_v2" || var.aks_vm_size == "Standard_DS13_v2_Promo" || var.aks_vm_size == "Standard_DS14" || var.aks_vm_size == "Standard_DS14-4_v2" || var.aks_vm_size == "Standard_DS14-8_v2" || var.aks_vm_size == "Standard_DS14_v2" || var.aks_vm_size == "Standard_DS14_v2_Promo" || var.aks_vm_size == "Standard_DS15_v2" || var.aks_vm_size == "Standard_DS1_v2" || var.aks_vm_size == "Standard_DS2" || var.aks_vm_size == "Standard_DS2_v2" || var.aks_vm_size == "Standard_DS2_v2_Promo" || var.aks_vm_size == "Standard_DS3" || var.aks_vm_size == "Standard_DS3_v2" || var.aks_vm_size == "Standard_DS3_v2_Promo" || var.aks_vm_size == "Standard_DS4" || var.aks_vm_size == "Standard_DS4_v2" || var.aks_vm_size == "Standard_DS4_v2_Promo" || var.aks_vm_size == "Standard_DS5_v2" || var.aks_vm_size == "Standard_DS5_v2_Promo" || var.aks_vm_size == "Standard_E16_v3" || var.aks_vm_size == "Standard_E16s_v3" || var.aks_vm_size == "Standard_E2_v3" || var.aks_vm_size == "Standard_E2s_v3" || var.aks_vm_size == "Standard_E32-16s_v3" || var.aks_vm_size == "Standard_E32-8s_v3" || var.aks_vm_size == "Standard_E32_v3" || var.aks_vm_size == "Standard_E32s_v3" || var.aks_vm_size == "Standard_E4_v3" || var.aks_vm_size == "Standard_E4s_v3" || var.aks_vm_size == "Standard_E64-16s_v3" || var.aks_vm_size == "Standard_E64-32s_v3" || var.aks_vm_size == "Standard_E64_v3" || var.aks_vm_size == "Standard_E64s_v3" || var.aks_vm_size == "Standard_E8_v3" || var.aks_vm_size == "Standard_E8s_v3" || var.aks_vm_size == "Standard_F1" || var.aks_vm_size == "Standard_F16" || var.aks_vm_size == "Standard_F16s" || var.aks_vm_size == "Standard_F16s_v2" || var.aks_vm_size == "Standard_F1s" || var.aks_vm_size == "Standard_F2" || var.aks_vm_size == "Standard_F2s" || var.aks_vm_size == "Standard_F2s_v2" || var.aks_vm_size == "Standard_F32s_v2" || var.aks_vm_size == "Standard_F4" || var.aks_vm_size == "Standard_F4s" || var.aks_vm_size == "Standard_F4s_v2" || var.aks_vm_size == "Standard_F64s_v2" || var.aks_vm_size == "Standard_F72s_v2" || var.aks_vm_size == "Standard_F8" || var.aks_vm_size == "Standard_F8s" || var.aks_vm_size == "Standard_F8s_v2" || var.aks_vm_size == "Standard_G1" || var.aks_vm_size == "Standard_G2" || var.aks_vm_size == "Standard_G3" || var.aks_vm_size == "Standard_G4" || var.aks_vm_size == "Standard_G5" || var.aks_vm_size == "Standard_GS1" || var.aks_vm_size == "Standard_GS2" || var.aks_vm_size == "Standard_GS3" || var.aks_vm_size == "Standard_GS4" || var.aks_vm_size == "Standard_GS4-4" || var.aks_vm_size == "Standard_GS4-8" || var.aks_vm_size == "Standard_GS5" || var.aks_vm_size == "Standard_GS5-16" || var.aks_vm_size == "Standard_GS5-8" || var.aks_vm_size == "Standard_H16" || var.aks_vm_size == "Standard_H16m" || var.aks_vm_size == "Standard_H16mr" || var.aks_vm_size == "Standard_H16r" || var.aks_vm_size == "Standard_H8" || var.aks_vm_size == "Standard_H8m" || var.aks_vm_size == "Standard_L16s" || var.aks_vm_size == "Standard_L32s" || var.aks_vm_size == "Standard_L4s" || var.aks_vm_size == "Standard_L8s" || var.aks_vm_size == "Standard_M128-32ms" || var.aks_vm_size == "Standard_M128-64ms" || var.aks_vm_size == "Standard_M128ms" || var.aks_vm_size == "Standard_M128s" || var.aks_vm_size == "Standard_M64-16ms" || var.aks_vm_size == "Standard_M64-32ms" || var.aks_vm_size == "Standard_M64ms" || var.aks_vm_size == "Standard_M64s" || var.aks_vm_size == "Standard_NC12" || var.aks_vm_size == "Standard_NC12s_v2" || var.aks_vm_size == "Standard_NC12s_v3" || var.aks_vm_size == "Standard_NC24" || var.aks_vm_size == "Standard_NC24r" || var.aks_vm_size == "Standard_NC24rs_v2" || var.aks_vm_size == "Standard_NC24rs_v3" || var.aks_vm_size == "Standard_NC24s_v2" || var.aks_vm_size == "Standard_NC24s_v3" || var.aks_vm_size == "Standard_NC6" || var.aks_vm_size == "Standard_NC6s_v2" || var.aks_vm_size == "Standard_NC6s_v3" || var.aks_vm_size == "Standard_ND12s" || var.aks_vm_size == "Standard_ND24rs" || var.aks_vm_size == "Standard_ND24s" || var.aks_vm_size == "Standard_ND6s" || var.aks_vm_size == "Standard_NV12" || var.aks_vm_size == "Standard_NV24" || var.aks_vm_size == "Standard_NV6"
    error_message = "Validation for variable 'aks_vm_size' failed - valid values are 'Standard_A1', 'Standard_A10', 'Standard_A11', 'Standard_A1_v2', 'Standard_A2', 'Standard_A2_v2', 'Standard_A2m_v2', 'Standard_A3', 'Standard_A4', 'Standard_A4_v2', 'Standard_A4m_v2', 'Standard_A5', 'Standard_A6', 'Standard_A7', 'Standard_A8', 'Standard_A8_v2', 'Standard_A8m_v2', 'Standard_A9', 'Standard_B2ms', 'Standard_B2s', 'Standard_B4ms', 'Standard_B8ms', 'Standard_D1', 'Standard_D11', 'Standard_D11_v2', 'Standard_D11_v2_Promo', 'Standard_D12', 'Standard_D12_v2', 'Standard_D12_v2_Promo', 'Standard_D13', 'Standard_D13_v2', 'Standard_D13_v2_Promo', 'Standard_D14', 'Standard_D14_v2', 'Standard_D14_v2_Promo', 'Standard_D15_v2', 'Standard_D16_v3', 'Standard_D16s_v3', 'Standard_D1_v2', 'Standard_D2', 'Standard_D2_v2', 'Standard_D2_v2_Promo', 'Standard_D2_v3', 'Standard_D2s_v3', 'Standard_D3', 'Standard_D32_v3', 'Standard_D32s_v3', 'Standard_D3_v2', 'Standard_D3_v2_Promo', 'Standard_D4', 'Standard_D4_v2', 'Standard_D4_v2_Promo', 'Standard_D4_v3', 'Standard_D4s_v3', 'Standard_D5_v2', 'Standard_D5_v2_Promo', 'Standard_D64_v3', 'Standard_D64s_v3', 'Standard_D8_v3', 'Standard_D8s_v3', 'Standard_DS1', 'Standard_DS11', 'Standard_DS11_v2', 'Standard_DS11_v2_Promo', 'Standard_DS12', 'Standard_DS12_v2', 'Standard_DS12_v2_Promo', 'Standard_DS13', 'Standard_DS13-2_v2', 'Standard_DS13-4_v2', 'Standard_DS13_v2', 'Standard_DS13_v2_Promo', 'Standard_DS14', 'Standard_DS14-4_v2', 'Standard_DS14-8_v2', 'Standard_DS14_v2', 'Standard_DS14_v2_Promo', 'Standard_DS15_v2', 'Standard_DS1_v2', 'Standard_DS2', 'Standard_DS2_v2', 'Standard_DS2_v2_Promo', 'Standard_DS3', 'Standard_DS3_v2', 'Standard_DS3_v2_Promo', 'Standard_DS4', 'Standard_DS4_v2', 'Standard_DS4_v2_Promo', 'Standard_DS5_v2', 'Standard_DS5_v2_Promo', 'Standard_E16_v3', 'Standard_E16s_v3', 'Standard_E2_v3', 'Standard_E2s_v3', 'Standard_E32-16s_v3', 'Standard_E32-8s_v3', 'Standard_E32_v3', 'Standard_E32s_v3', 'Standard_E4_v3', 'Standard_E4s_v3', 'Standard_E64-16s_v3', 'Standard_E64-32s_v3', 'Standard_E64_v3', 'Standard_E64s_v3', 'Standard_E8_v3', 'Standard_E8s_v3', 'Standard_F1', 'Standard_F16', 'Standard_F16s', 'Standard_F16s_v2', 'Standard_F1s', 'Standard_F2', 'Standard_F2s', 'Standard_F2s_v2', 'Standard_F32s_v2', 'Standard_F4', 'Standard_F4s', 'Standard_F4s_v2', 'Standard_F64s_v2', 'Standard_F72s_v2', 'Standard_F8', 'Standard_F8s', 'Standard_F8s_v2', 'Standard_G1', 'Standard_G2', 'Standard_G3', 'Standard_G4', 'Standard_G5', 'Standard_GS1', 'Standard_GS2', 'Standard_GS3', 'Standard_GS4', 'Standard_GS4-4', 'Standard_GS4-8', 'Standard_GS5', 'Standard_GS5-16', 'Standard_GS5-8', 'Standard_H16', 'Standard_H16m', 'Standard_H16mr', 'Standard_H16r', 'Standard_H8', 'Standard_H8m', 'Standard_L16s', 'Standard_L32s', 'Standard_L4s', 'Standard_L8s', 'Standard_M128-32ms', 'Standard_M128-64ms', 'Standard_M128ms', 'Standard_M128s', 'Standard_M64-16ms', 'Standard_M64-32ms', 'Standard_M64ms', 'Standard_M64s', 'Standard_NC12', 'Standard_NC12s_v2', 'Standard_NC12s_v3', 'Standard_NC24', 'Standard_NC24r', 'Standard_NC24rs_v2', 'Standard_NC24rs_v3', 'Standard_NC24s_v2', 'Standard_NC24s_v3', 'Standard_NC6', 'Standard_NC6s_v2', 'Standard_NC6s_v3', 'Standard_ND12s', 'Standard_ND24rs', 'Standard_ND24s', 'Standard_ND6s', 'Standard_NV12', 'Standard_NV24', or 'Standard_NV6'."
  }
}

variable "aks_nodepool_1_count" {
  type = number
  description = "The initial number of nodes to allocate to the default/master AKS nodepool.  It is recommended to have more than 1 for resiliency against hardware failures."
  default = 2
}

variable "aks_worker_node_count" {
  type = number
  description = "The initial number of nodes to allocate to the AKS worker nodepool.  It is recommended to have more than 1 for resiliency against hardware failures."
  default = 2
}

variable "aks_min_worker_node_count" {
  type = number
  description = "The minimum number of nodes permitted for the AKS worker nodepool. It is recommended to have more than 1 for resiliency against hardware failures."
  default = 2
}

variable "aks_max_worker_node_count" {
  type = number
  description = "The maximum number of nodes permitted for the AKS worker nodepool.  This is mostly for cost savings purposes."
  default = 20
}

variable "acr_name" {
  type = string
  description = "The name to give the Azure Container Registry instance being deployed."
  default = "DapAcr"
}

variable "acr_sku" {
  type = string
  description = "The SKU/tier to use for the Azure Container Registry."
  default = "Basic"
}

variable "pg_server_name" {
  type = string
  description = "The name of the PostgreSQL server instance."
  default = "dap-postgres-dev"
}

variable "pg_administrator_login" {
  type = string
  description = "The name of the PostgreSQL administrator."

  validation {
    condition = length(var.pg_administrator_login) >= 1
    error_message = "Validation for variable 'postgresql_administrator_login' failed - variable must be at least 1 character in length."
  }
}

variable "pg_version" {
  type = string
  description = "The version of the PostgreSQL server."
  default = "10"

  validation {
    condition = var.pg_version == "9.5" || var.pg_version == "9.6" || var.pg_version == "10" || var.pg_version == "11"
    error_message = "Validation for variable 'postgresql_version' failed - valid values are 9.5, 9.6, 10, or 11."
  }
}

variable "pg_sku_name" {
  type = string
  description = "The SKU of the Azure Database for PostgreSQL server to be used."
  default = "B_Gen5_2"
}

variable "pg_port" {
  type = number
  description = "The port on which the PostgreSQL instance is accepting connections."
  default = 5432
}

variable "pg_airflow_db" {
  type = string
  description = "The name of the database to be created for use by Airflow."
  default = "airflow"
}

variable "pg_celery_db" {
  type = string
  description = "The name of the database to be created for use by Celery."
  default = "celery"
}

variable "pg_storage_mb" {
  type = number
  description = "The amount of DB storage to allocate to Postgres in MB"
  default = 5120 # 5G
}

variable "pg_backup_retention_days" {
  type = number
  description = "The number of days to retain data backups of the Postgres databases"
  default = 7
}

variable "pg_db_charset" {
  type = string
  description = "A valid PostgreSQL charset for created databases. More info @ https://www.postgresql.org/docs/current/multibyte.html"
  default = "UTF8"
}

variable "pg_db_collation" {
  type = string
  description = "A valid PostgreSQL collation for created databases. More info @ https://www.postgresql.org/docs/current/collation.html"
  default = "English_United States.1252"
}

variable pg_min_tls_version {
  type = string
  description = "Specify the minimum TLS version permitted for connecting to Postgres behind SSL."
  default = "TLS1_2"

  validation {
    condition = can(regex("^(TLSEnforcementDisabled|TLS1_0|TLS1_1|TLS1_2)$", var.pg_min_tls_version))
    error_message = "Variable pg_min_tls_version valid values are TLSEnforcementDisabled, TLS1_0, TLS1_1, or TLS1_2."
  }
}

variable "geo_redundant_backup" {
  type = bool
  description = "Whether to use georedundancy when backing up Postgres databases."
  default = false
}

variable "redis_server_name" {
  type = string
  description = "The name to assign the Redis server instance in Azure."
  default = "DapRedis"
}

variable "redis_sku_name" {
  type = string
  description = "The type of Redis cache to deploy. Valid values: (Basic, Standard, Premium). - Basic, Standard, Premium."
  default = "Basic"
  
  validation {
    condition = var.redis_sku_name == "Basic" || var.redis_sku_name == "Standard" || var.redis_sku_name == "Premium"
    error_message = "Validation for variable 'redis_sku_name' failed - valid values are Basic, Standard, or Premium."
  }
}

variable "redis_sku_family" {
  type = string
  description = "The SKU family to use. Valid values: (C, P). (C = Basic/Standard, P = Premium). - C or P."
  default = "C"
  
  validation {
    condition = var.redis_sku_family == "C" || var.redis_sku_family == "P"
    error_message = "Validation for variable 'redis_sku_family' failed - valid values are C or P."
  }
}

variable "redis_sku_capacity" {
  type = number
  description = "The size of the Azure Redis Cache. Valid values: for C (Basic/Standard) family (0, 1, 2, 3, 4, 5, 6), for P (Premium) family (1, 2, 3, 4, 5). "
  default = 0
  
  validation {
    condition = var.redis_sku_capacity >= 0 && var.redis_sku_capacity <= 6
    error_message = "Validation for variable 'redis_sku_capacity' failed - valid values are 0, 1, 2, 3, 4, 5, or 6."
  }
}

variable "redis_local_port" {
  type = number
  description = "The port on which the Airflow Flower node is accepting connections."
  default = 6379
}

variable "redis_local_host" {
  type = string
  description = "The AKS cluster DNS name of the Airflow Flower host."
  default = "airflow-flower"
}

variable "redis_port" {
  type = number
  description = "The port on which the Redis Cache is accepting connections."
  default = 6380
}

variable "remote_logging_conn_type" {
  type = string
  description = "The connection type used by Airflow to connect to the storage account."
  default = "Azure Blob Storage"
}

variable "redis_min_tls_version" {
  type = string
  description = "The minimum TLS version to permit for connecting to the Redis SSL port."
  default = "1.2"
}

variable is_sensitive_environment {
  type = bool
  description = "aks only"
  default = false
}

variable gp_ip_start {
  type = string
  default = "192.81.9.0"
}

variable gp_ip_end {
  type = string
  default = "192.81.9.255"
}

variable vdi_ip_start {
  type = string
  default = "4.7.69.65"
}

variable vdi_ip_end {
  type = string
  default = "4.7.69.127"
}

variable gp_ip_cidr {
  type = string
  description = "IP range for Global Protect"
  default = "192.81.9.0/24"
}

variable vdi_ip_cidr {
  type = string
  description = "IP range for VDI"
  default = "4.7.69.64/26"
}

/******************************************************************************
 * AKS Auto-scaling profile
 ******************************************************************************/

variable balance_similar_node_groups {
  type = string
  default = "false"

  validation {
    condition = can(regex("^(false|true)$", var.balance_similar_node_groups))
    error_message = "Balance_similar_node_groups only valid values are the strings 'true' or 'false'."
  }
}

variable max_graceful_termination_sec {
  type = string
  default = "600"  // 600 seconds := 10 minutes

  validation {
    condition = can(regex("^[0-9]+$", var.max_graceful_termination_sec))
    error_message = "Variable max_graceful_termination_sec must be a number string."
  }
}

variable scale_down_delay_after_add {
  type = string
  default = "10m"
}

variable scale_down_delay_after_delete {
  type = string
  default = "10s"
}

variable scale_down_delay_after_failure {
  type = string
  default = "3m"
}

variable scan_interval {
  type = string
  default = "10s"
}

variable scale_down_unneeded {
  type = string
  default = "10m"
}

variable scale_down_unready {
  type = string
  default = "20m"
}

variable scale_down_utilization_threshold {
  type = string
  default = "0.5"

  validation {
    condition = can(regex("^0.[0-9]{1,2}$", var.scale_down_utilization_threshold))
    error_message = "Scale_down_utilization_threshold must be a string representing a decimal number with 0 left of the decimal and 1 or 2 digits right of the decimal which is >= 0.0 and < 1.0."
  }
}

# Service principal name
variable sp_akv {
  type = string
  default = "airflow-sp-auth"
}

# Service principal rg name
variable sp_akv_rg {
  type = string
  default = "Datalake-RG"
}

# Service principal secret name 
variable aks_sp_akv_secret_name {
  type = string
  default = "airflow-admin"
}

variable perm_sp_akv_secret_name {
  type = string
  default = "airflow-perm-secret"
}

# Secret flag
variable akv_secret_tag {
  sensitive = true
  type = string
  default = "admin"
}

variable loku_helm_path {
  type = string
  description = "The relative path to the bluekc-airflow helm chart directory."
  default = "./loku-deploy"
}