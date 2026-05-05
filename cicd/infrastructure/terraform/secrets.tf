resource "kubernetes_secret" "sonarqube_credentials" {
  metadata {
    name      = "sonarqube-creds"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }

  data = {
    username = "admin"
    password = "admin"
  }

  type = "Opaque"
}

resource "kubernetes_secret" "nexus_credentials" {
  metadata {
    name      = "nexus-creds"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }

  data = {
    username = "admin"
    password = "admin123"
  }

  type = "Opaque"
}
