resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version
  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name

  values = [file("${path.module}/values.yaml")]

  timeout = 600

  depends_on = [kubernetes_namespace_v1.argocd]
}

resource "helm_release" "argocd_apps" {
  name      = "argocd-apps"
  chart     = "${path.module}/charts"
  namespace = kubernetes_namespace_v1.argocd.metadata[0].name

  values = [
    <<-EOT
applications:
  - name: django-app
    repoURL: ${var.git_repo_url}
    targetRevision: ${var.git_repo_branch}
    destination:
      namespace: ${var.app_namespace}
repositories:
  - url: ${var.git_repo_url}
    password: ${var.git_token}
EOT
  ]

  depends_on = [helm_release.argocd]
}