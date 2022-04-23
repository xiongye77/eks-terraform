provider "kubernetes" {
  config_path = "~/.kube/config"
}
resource "kubernetes_deployment" "app1-nginx-deployment" {
  metadata {
    name = "app1-nginx"
    labels = {
      app = "app1-nginx"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "app1-nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "app1-nginx"
        }
      }
      spec {
        container {
          image = "dbaxy770928/carsales1"
          name  = "app1-nginx"
          port {
            container_port = 80
          }
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "app1-nginx-service" {
  depends_on = [kubernetes_deployment.app1-nginx-deployment]

  metadata {
    labels = {
      app = "app1-nginx"
    }
    name = "app1-nginx"
  }

  spec {
    port {
      port = 80
      target_port = 80
    }
    selector = {
      app = "app1-nginx"
    }
    type = "NodePort"
  }
}
