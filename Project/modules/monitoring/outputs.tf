output "monitoring_namespace" {
  description = "Namespace where monitoring is deployed"
  value       = kubernetes_namespace_v1.monitoring.metadata[0].name
}

output "grafana_access_note" {
  description = "Command to access Grafana"
  value       = "kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring"
}

output "prometheus_access_note" {
  description = "Command to access Prometheus"
  value       = "kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090 -n monitoring"
}

output "grafana_admin_password_note" {
  description = "Command to get Grafana admin password"
  value       = "kubectl get secret --namespace monitoring prometheus-grafana -o jsonpath='{.data.admin-password}' | base64 --decode"
}
