resource "kubernetes_deployment" "notification_worker" {
  metadata {
    name = "payments-api-notification_worker"
    labels = {
      app       = "payments-api"
      component = "notification_worker"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app       = "payments-api"
        component = "notification_worker"
      }
    }

    template {
      metadata {
        labels = {
          app       = "payments-api"
          component = "notification_worker"
        }
      }

      spec {
        container {
          name    = "notification_worker"
          image   = "payments-api:latest"
          command = ["python", "-m", "app.workers.notification_worker"]
        }
      }
    }
  }
}
