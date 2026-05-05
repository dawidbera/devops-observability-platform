resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"
  }
}

resource "kubernetes_namespace" "sonarqube" {
  metadata {
    name = "sonarqube"
  }
}

resource "kubernetes_namespace" "nexus" {
  metadata {
    name = "nexus"
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "staging" {
  metadata {
    name = "staging"
  }
}

resource "kubernetes_namespace" "prod_sim" {
  metadata {
    name = "prod-sim"
  }
}
