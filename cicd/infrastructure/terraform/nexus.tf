resource "helm_release" "nexus" {
  name       = "nexus"
  repository = "https://oteemo.github.io/charts"
  chart      = "sonatype-nexus"
  namespace  = kubernetes_namespace.nexus.metadata[0].name

  values = [
    file("${path.module}/../helm/nexus-values.yaml")
  ]

  timeout = 900
}
