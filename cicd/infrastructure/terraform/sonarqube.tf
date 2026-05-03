resource "helm_release" "sonarqube" {
  name       = "sonarqube"
  repository = "https://SonarSource.github.io/helm-chart-sonarqube"
  chart      = "sonarqube"
  namespace  = kubernetes_namespace.sonarqube.metadata[0].name

  values = [
    file("${path.module}/../helm/sonarqube-values.yaml")
  ]

  timeout = 900
}
