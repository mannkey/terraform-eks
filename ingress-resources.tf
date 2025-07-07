# Ingress for Pharmetrade Frontend - https://www.pharmetrade.com
resource "kubernetes_ingress_v1" "pharmetrade_ingress" {
  depends_on = [time_sleep.wait_for_cert_manager]

  metadata {
    name      = "pharmetrade-ingress"
    namespace = "default"
    annotations = {
      "cert-manager.io/cluster-issuer"                 = "letsencrypt-prod"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"

    tls {
      hosts       = ["www.pharmetrade.com", "pharmetrade.com"]
      secret_name = "pharmetrade-tls"
    }

    # www.pharmetrade.com
    rule {
      host = "www.pharmetrade.com"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.pharmetrade.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    # pharmetrade.com
    rule {
      host = "pharmetrade.com"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.pharmetrade.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

# Ingress for API Gateway/Server - https://server.pharmetrade.com
resource "kubernetes_ingress_v1" "api_gateway_ingress" {
  depends_on = [time_sleep.wait_for_cert_manager]

  metadata {
    name      = "api-gateway-ingress"
    namespace = "default"
    annotations = {
      "cert-manager.io/cluster-issuer"                 = "letsencrypt-prod"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"

    tls {
      hosts       = ["server.pharmetrade.com"]
      secret_name = "api-gateway-tls"
    }

    rule {
      host = "server.pharmetrade.com"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.api_gateway.metadata[0].name
              port {
                number = 5000
              }
            }
          }
        }
      }
    }
  }
}

# Ingress for Adminer - https://adminer.pharmetrade.com
resource "kubernetes_ingress_v1" "adminer_ingress" {
  depends_on = [time_sleep.wait_for_cert_manager]

  metadata {
    name      = "adminer-ingress"
    namespace = "default"
    annotations = {
      "cert-manager.io/cluster-issuer"                 = "letsencrypt-prod"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    }
  }

  spec {
    ingress_class_name = "nginx"

    tls {
      hosts       = ["adminer.pharmetrade.com"]
      secret_name = "adminer-tls"
    }

    rule {
      host = "adminer.pharmetrade.com"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.adminer.metadata[0].name
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}
