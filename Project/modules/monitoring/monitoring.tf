resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = var.namespace
  }
}

# ─────────────────────────────────────────────
# Prometheus + Grafana via kube-prometheus-stack
# ─────────────────────────────────────────────
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version
  namespace  = kubernetes_namespace_v1.monitoring.metadata[0].name

  values = [file("${path.module}/values.yaml")]

  timeout = 600

  depends_on = [kubernetes_namespace_v1.monitoring]
}
