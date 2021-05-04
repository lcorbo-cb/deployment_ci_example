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
      mylabel              = "cloudbees-core"
      "cloudbees.com/role" = "agents"
    }

    name = "cloudbees-core"
  }
}

resource "kubernetes_namespace" "nginx_ingress" {
  metadata {
    annotations = {
      name = "nginx-ingress"
    }

    labels = {
      mylabel = "nginx-ingress"
    }

    name = "nginx-ingress"
  }
}

resource "google_dns_record_set" "node" {
  name         = "cbci.${var.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = var.name

  rrdatas = [data.kubernetes_service.ingress.status[0].load_balancer[0].ingress[0].ip]
}

resource "helm_release" "cbci" {
  name       = "cloudbees-core"
  repository = "https://charts.cloudbees.com/public/cloudbees"
  chart      = "cloudbees-core"
  # version    = "3.25.3+73c21ed5fcda"

  values = [
    file("${path.module}/values/cloudbees.yaml")
  ]

  set {
    name  = "OperationsCenter.HostName"
    value = "cbci.cloudbees.demo"
  }

  namespace = kubernetes_namespace.cloudbees_core.id

  depends_on = [
    kubernetes_namespace.cloudbees_core
  ]
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "2.15.0"

  values = [
    file("${path.module}/values/nginx.yaml")
  ]

  set {
    name  = "OperationsCenter.HostName"
    value = "cbci.cloudbees.demo"
  }

  namespace = kubernetes_namespace.nginx_ingress.id

  depends_on = [
    helm_release.cbci,
    kubernetes_namespace.nginx_ingress
  ]
}
