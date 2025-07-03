output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

# Kubernetes Deployments Outputs
output "pharmetrade_service_url" {
  description = "URL for the Pharmetrade frontend service"
  value       = try("http://${kubernetes_service.pharmetrade.status[0].load_balancer[0].ingress[0].hostname}", "LoadBalancer provisioning...")
}

output "adminer_service_url" {
  description = "URL for the Adminer database management service"
  value       = try("http://${kubernetes_service.adminer.status[0].load_balancer[0].ingress[0].hostname}:8080", "LoadBalancer provisioning...")
}

output "api_gateway_service_endpoint" {
  description = "Internal endpoint for the API Gateway service"
  value       = "${kubernetes_service.api_gateway.metadata[0].name}.${kubernetes_service.api_gateway.metadata[0].namespace}.svc.cluster.local:8080"
}

output "api_gateway_service_url" {
  description = "External URL for the API Gateway service (Swagger UI)"
  value       = try("http://${kubernetes_service.api_gateway.status[0].load_balancer[0].ingress[0].hostname}:8080", "LoadBalancer provisioning...")
}

output "kubeconfig_update_command" {
  description = "Command to update kubeconfig for kubectl access"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
}

# Domain URLs (after DNS configuration)
output "pharmetrade_frontend_url" {
  description = "Pharmetrade Frontend URL"
  value       = "https://www.pharmaetrade.com"
}

output "api_gateway_url" {
  description = "API Gateway/Server URL"
  value       = "https://www.server.pharmaetrade.com"
}

output "adminer_url" {
  description = "Adminer Database Admin URL"
  value       = "https://adminer.pharmaetrade.com"
}

# Ingress Controller LoadBalancer (for DNS configuration)
output "ingress_controller_loadbalancer" {
  description = "Ingress Controller LoadBalancer hostname - Point your domains to this"
  value       = try(data.kubernetes_service.ingress_nginx.status[0].load_balancer[0].ingress[0].hostname, "Not yet available")
}

# Data source to get ingress controller service details
data "kubernetes_service" "ingress_nginx" {
  depends_on = [time_sleep.wait_for_cert_manager]
  metadata {
    name      = "ingress-ingress-nginx-controller"
    namespace = "ingress"
  }
}

