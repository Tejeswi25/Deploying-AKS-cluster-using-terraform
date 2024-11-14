provider "azurerm" {
    features {
    }
    subscription_id = "8102abc5-f086-4982-8783-b54fb29dd904"
}

provider "kubernetes" {
  host                   = module.aks.kubeconfig.host
  cluster_ca_certificate = base64decode(module.aks.kubeconfig.cluster_ca_certificate)
  client_certificate     = base64decode(module.aks.kubeconfig.client_certificate)
  client_key             = base64decode(module.aks.kubeconfig.client_key)
}

resource "azurerm_resource_group" "rg1" {
    name = var.rgname
    location = var.location
}

module "ServicePrincipal" {
  source = "C:/Users/pteju/saikiranterraform/AKSDeployment/modules/ServicePrincipal"
  azuread_service_principal_name = var.service_principal_name
  depends_on = [ 
    azurerm_resource_group.rg1 
    ]
}

resource "azurerm_role_assignment" "rolespn" {

  scope                = "/subscriptions/8102abc5-f086-4982-8783-b54fb29dd904"
  role_definition_name = "Contributor"
  principal_id         = module.ServicePrincipal.service_principal_object_id

  depends_on = [
    module.ServicePrincipal
  ]
}



module "keyvault" {
    source = "./modules/keyvault"
    keyvault_name = var.keyvault_name
    location = var.location
    resource_group_name = var.rgname
    service_principal_name = var.service_principal_name
    service_principal_object_id = module.ServicePrincipal.service_principal_object_id
    service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id
    depends_on = [ 
        module.ServicePrincipal
     ]
}

resource "azurerm_key_vault_access_policy" "example"{
    key_vault_id = module.keyvault.keyvault_id
    tenant_id = module.keyvault.tenant_id
    object_id = module.ServicePrincipal.service_principal_object_id
    secret_permissions = [
        "Get",
        "List",
        "Set",
        "Delete"
    ]
    depends_on = [ 
        module.keyvault
     ]
}


resource "azurerm_key_vault_secret" "example" {
    name = module.ServicePrincipal.client_id
    value = module.ServicePrincipal.client_secret
    key_vault_id = module.keyvault.keyvault_id
    depends_on = [ 
        module.keyvault
     ]
}

# Creation of Azure container Registry to store images.
  

resource "azurerm_container_registry" "example" {
    name = "myacr18"
    location = var.location
    resource_group_name = var.rgname
    sku = "Basic"
}

module  "aks" {
    source =  "./modules/aks"
    
    client_id = module.ServicePrincipal.client_id
    client_secret = module.ServicePrincipal.client_secret
    location = var.location
    resource_group_name = var.rgname
    depends_on = [ 
        module.ServicePrincipal
     ]
}

# Assigning "ACRPull" role for service principal id for AKS to pull images from ACR.

resource "azurerm_role_assignment" "example" {
    principal_id = module.ServicePrincipal.service_principal_object_id
    role_definition_name = "AcrPull"
    scope = azurerm_container_registry.example.id
  
}

# kubernetes deployment manifest

resource "kubernetes_deployment" "example" {
  metadata {
    name = "myapp"
    labels = {
      app = "myapp"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "myapp"
      }
    }
    template {
      metadata {
        labels = {
          app = "myapp"
        }
      }
      spec {
        container {
          name = "myapp"
          image = "${azurerm_container_registry.example.login_server}/myhttpd:latest"
          port {
            container_port = 80 
          }
        }
      }
    }

  }
}

resource "local_file" "kubeconfig" {
    depends_on = [ module.aks ]
    filename = "./kubeconfig"
    content = module.aks.config  
}


