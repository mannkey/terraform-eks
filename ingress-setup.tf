# Ingress controller and cert-manager setup
# Note: Using existing ingress-nginx and cert-manager installations

# Wait for existing cert-manager to be ready
resource "time_sleep" "wait_for_cert_manager" {
  depends_on      = [time_sleep.wait_for_cluster]
  create_duration = "30s"
}

# ClusterIssuer for Let's Encrypt
resource "kubernetes_manifest" "letsencrypt_issuer" {
  depends_on = [time_sleep.wait_for_cert_manager]

  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-prod"
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email  = "admin@pharmaetrade.com" # Change this to your email
        privateKeySecretRef = {
          name = "letsencrypt-prod"
        }
        solvers = [{
          http01 = {
            ingress = {
              class = "nginx"
            }
          }
        }]
      }
    }
  }
}
