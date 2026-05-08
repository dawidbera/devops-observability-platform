resource "kubernetes_secret_v1" "sonarqube_credentials" {
  metadata {
    name      = "sonarqube-creds"
    namespace = kubernetes_namespace_v1.jenkins.metadata[0].name
  }

  data = {
    username = "admin"
    password = "admin"
  }

  type = "Opaque"
}

resource "kubernetes_secret_v1" "nexus_credentials" {
  metadata {
    name      = "nexus-creds"
    namespace = kubernetes_namespace_v1.jenkins.metadata[0].name
  }

  data = {
    username = "admin"
    password = "admin123"
  }

  type = "Opaque"
}
