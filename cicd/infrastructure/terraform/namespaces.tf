resource "kubernetes_namespace_v1" "jenkins" {
  metadata {
    name = "jenkins"
  }
}

resource "kubernetes_namespace_v1" "sonarqube" {
  metadata {
    name = "sonarqube"
  }
}

resource "kubernetes_namespace_v1" "nexus" {
  metadata {
    name = "nexus"
  }
}

resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace_v1" "staging" {
  metadata {
    name = "staging"
  }
}

resource "kubernetes_namespace_v1" "prod_sim" {
  metadata {
    name = "prod-sim"
  }
}
