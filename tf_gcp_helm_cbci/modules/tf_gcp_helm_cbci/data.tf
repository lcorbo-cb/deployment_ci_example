data google_secret_manager_secret_version cbci_modern {
  secret = "cbci_modern"
}

data google_secret_manager_secret_version cbci_modern_key {
  secret = "cbci_modern_key"
}

data kubernetes_service ingress {
  metadata {
    name = "cloudbees-core-ingress-nginx-controller"
    namespace = "cloudbees-core"
  }
  depends_on = [
    helm_release.cbci,
  ]
}
