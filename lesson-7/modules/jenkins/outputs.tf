output "jenkins_namespace" {
  description = "Namespace where Jenkins is deployed"
  value       = kubernetes_namespace_v1.jenkins.metadata[0].name
}

output "jenkins_release_name" {
  description = "Helm release name"
  value       = helm_release.jenkins.name
}

output "jenkins_admin_password_note" {
  description = "How to get Jenkins admin password"
  value       = "kubectl get secret --namespace jenkins jenkins -o jsonpath='{.data.jenkins-admin-password}' | base64 --decode"
}
