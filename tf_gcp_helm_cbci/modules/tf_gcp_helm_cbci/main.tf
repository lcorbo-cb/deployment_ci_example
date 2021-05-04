resource "kubernetes_secret" "ingress_cert_secret" {
  metadata {
    name      = "ingress-cert-secret"
    namespace = kubernetes_namespace.cloudbees_core.id
  }

  data = {
    "tls.crt" = data.google_secret_manager_secret_version.cbci_modern.secret_data
    "tls.key" = data.google_secret_manager_secret_version.cbci_modern_key.secret_data
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_namespace" "cloudbees_core" {
  metadata {
    annotations = {
      name = "cloudbees-core"
    }

    labels = {
      mylabel = "cloudbees-core"
    }

    name = "cloudbees-core"
  }
}

resource "google_dns_record_set" "node" {
  name         = "cbci.${var.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = var.name

  rrdatas = [data.kubernetes_service.ingress.load_balancer_ingress.0.ip]
}

resource "helm_release" "cbci" {
  name       = "cloudbees-core"
  repository = "https://charts.cloudbees.com/public/cloudbees"
  chart      = "cloudbees-core"
  # version    = "6.0.1"

  # values = [
  #   file("${path.module}/values/cloudbees_ingress.yaml")
  # ]

  set {
    name  = "OperationsCenter.HostName"
    value = "cbci.cloudbees.demo"
  }

  set {
    name  = "OperationsCenter.Ingress.tls.Enable"
    value = true
  }

  set {
    name  = "OperationsCenter.Ingress.tls.SecretName"
    value = "ingress-cert-secret"
  }

  set {
    name = "ingress-nginx.Enabled"
    value = true
  }

  namespace = kubernetes_namespace.cloudbees_core.id
}
