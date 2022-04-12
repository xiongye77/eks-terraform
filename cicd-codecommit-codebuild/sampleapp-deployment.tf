data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "kubernetes_deployment" "sampleapp_deployment" {

  metadata {
    name      = "sampleapp"
    namespace = "sampleapp"
  }

  spec {
    replicas = 4
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "sampleapp"
      }
    }
    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge       = "25%"
        max_unavailable = "25%"
      }
    }

    template {
      metadata {
        annotations = {}
        labels      = { "app.kubernetes.io/name" = "sampleapp" }
      }

      spec {

        restart_policy                   = "Always"
        share_process_namespace          = false
        termination_grace_period_seconds = 30

        container {
          image             = format("%s.dkr.ecr.%s.amazonaws.com/sample-app", data.aws_caller_identity.current.account_id, data.aws_region.current.name)
          image_pull_policy = "Always"
          name              = "sampleapp"
          port {
            container_port = 80
            protocol       = "TCP"
          }

          resources {
          }
        }
      }
    }
  }


}
