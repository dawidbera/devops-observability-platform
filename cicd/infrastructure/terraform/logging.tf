resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  namespace  = kubernetes_namespace_v1.monitoring.metadata[0].name

  set = [
    {
      name  = "grafana.enabled"
      value = "false"
    },
    {
      name  = "prometheus.enabled"
      value = "false"
    },
    {
      name  = "promtail.enabled"
      value = "true"
    }
  ]

  timeout = 900
}
