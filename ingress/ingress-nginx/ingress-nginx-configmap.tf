resource "kubernetes_config_map" "ingress_nginx_controller" {
  metadata {
    name      = "ingress-ingress-nginx-controller"
    namespace = "ingress"
  }
  data = {
    "http-snippet" = "client_max_body_size 1g;"
  }
}

resource "null_resource" "restart_ingress_controller" {
  depends_on = [kubernetes_config_map.ingress_nginx_controller]

  provisioner "local-exec" {
    command = "kubectl delete pod -n ingress -l app.kubernetes.io/name=ingress-nginx,app.kubernetes.io/component=controller"
  }
}
