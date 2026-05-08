# RBAC for the application in the staging namespace
resource "kubernetes_service_account_v1" "app_sa" {
  metadata {
    name      = "demo-app-sa"
    namespace = kubernetes_namespace_v1.staging.metadata[0].name
  }
}

resource "kubernetes_role_v1" "app_role" {
  metadata {
    name      = "demo-app-role"
    namespace = kubernetes_namespace_v1.staging.metadata[0].name
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "configmaps", "services"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding_v1" "app_role_binding" {
  metadata {
    name      = "demo-app-rb"
    namespace = kubernetes_namespace_v1.staging.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.app_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.app_sa.metadata[0].name
    namespace = kubernetes_namespace_v1.staging.metadata[0].name
  }
}
