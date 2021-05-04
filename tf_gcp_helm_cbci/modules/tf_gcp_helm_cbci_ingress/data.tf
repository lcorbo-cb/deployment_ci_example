data google_secret_manager_secret_version cbci_modern {
  secret = "cbci_modern"
}

data google_secret_manager_secret_version cbci_modern_key {
  secret = "cbci_modern_key"
}

data kubernetes_service ingress {
  metadata {
    name = "${kubernetes_namespace.nginx_ingress.id}-ingress-nginx-controller"
    namespace = kubernetes_namespace.nginx_ingress.id
  }
  depends_on = [
    helm_release.nginx_ingress,
  ]
}
