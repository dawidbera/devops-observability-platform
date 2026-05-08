resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  namespace  = kubernetes_namespace_v1.jenkins.metadata[0].name

  values = [
    file("${path.module}/../helm/jenkins-values.yaml")
  ]

  timeout = 1200
}
