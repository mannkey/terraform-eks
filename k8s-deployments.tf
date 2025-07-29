# Note: Kubernetes provider is configured in providers.tf

# Wait for the EKS cluster to be ready
resource "time_sleep" "wait_for_cluster" {
  depends_on      = [module.eks]
  create_duration = "30s"
}

# API Gateway Deployment
resource "kubernetes_deployment" "api_gateway" {
  depends_on = [time_sleep.wait_for_cluster]

  metadata {
    name      = "api-gateway-deployment"
    namespace = "default"
    labels = {
      app = "api-gateway"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "api-gateway"
      }
    }

    template {
      metadata {
        labels = {
          app = "api-gateway"
        }
      }

      spec {
        image_pull_secrets {
          name = "regcred"
        }
        container {
          name  = "api-gateway"
          image = "headway630/pharmetrade_apigateway-server:latest"

          # Your actual API Gateway/Server image
          port {
            container_port = 5000
            name           = "api-gateway"
          }
        }
      }
    }
  }
}

# API Gateway Service
resource "kubernetes_service" "api_gateway" {
  depends_on = [kubernetes_deployment.api_gateway]

  metadata {
    name      = "api-gateway-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "api-gateway"
    }

    port {
      port        = 5000
      target_port = 5000
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

# Pharmetrade Frontend Deployment
resource "kubernetes_deployment" "pharmetrade" {
  depends_on = [kubernetes_service.api_gateway]

  metadata {
    name      = "pharmetrade-deployment"
    namespace = "default"
    labels = {
      app = "pharmetrade"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "pharmetrade"
      }
    }

    template {
      metadata {
        labels = {
          app = "pharmetrade"
        }
      }

      spec {
        image_pull_secrets {
          name = "regcred"
        }

        container {
          name  = "pharmetrade"
          image = "headway630/pharmaetrade:latest"

          env {
            name  = "VITE_API_BASE_URL"
            value = "https://www.server.pharmetrade.com"
          }

          port {
            container_port = 5173
            name           = "pharmetrade"
          }
        }
      }
    }
  }
}

# Pharmetrade Service
resource "kubernetes_service" "pharmetrade" {
  depends_on = [kubernetes_deployment.pharmetrade]

  metadata {
    name      = "pharmetrade-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "pharmetrade"
    }

    port {
      port        = 80
      target_port = 5173
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

# Adminer Deployment (standalone, no MySQL dependency)
resource "kubernetes_deployment" "adminer" {
  depends_on = [time_sleep.wait_for_cluster]

  metadata {
    name      = "adminer-deployment"
    namespace = "default"
    labels = {
      app = "adminer"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "adminer"
      }
    }

    template {
      metadata {
        labels = {
          app = "adminer"
        }
      }

      spec {
        container {
          name  = "adminer"
          image = "adminer:latest"

          port {
            container_port = 8080
            name           = "adminer"
          }
        }
      }
    }
  }
}

# Adminer Service
resource "kubernetes_service" "adminer" {
  depends_on = [kubernetes_deployment.adminer]

  metadata {
    name      = "adminer-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "adminer"
    }

    port {
      port        = 8080
      target_port = 8080
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}
