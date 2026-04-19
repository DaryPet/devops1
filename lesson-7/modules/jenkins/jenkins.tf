resource "kubernetes_namespace_v1" "jenkins" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = var.chart_version
  namespace  = kubernetes_namespace_v1.jenkins.metadata[0].name

  values = [
    file("${path.module}/values.yaml"),
    <<-EOT
controller:
  admin:
    password: ${var.admin_password}
  jenkinsUrl: http://jenkins.${var.namespace}.svc.cluster.local:8080
EOT
  ]

  timeout = 600

  depends_on = [kubernetes_namespace_v1.jenkins]
}