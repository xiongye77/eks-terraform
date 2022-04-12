resource "kubernetes_service" "sampleapp_service" {

  metadata {
    name      = "sampleapp-service"
    namespace = "sampleapp"
  }

  spec {
    selector = {
      "app.kubernetes.io/name" = "sampleapp"
    }

    type = "NodePort"

    port {
      port        = 80
      protocol    = "TCP"
      target_port = "80"
    }
  }

}
