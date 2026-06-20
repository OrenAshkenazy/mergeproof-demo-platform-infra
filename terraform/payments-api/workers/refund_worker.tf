resource "kubernetes_deployment" "refund_worker" {
  metadata {
    name = "payments-api-refund_worker"
    labels = {
      app       = "payments-api"
      component = "refund_worker"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app       = "payments-api"
        component = "refund_worker"
      }
    }

    template {
      metadata {
        labels = {
          app       = "payments-api"
          component = "refund_worker"
        }
      }

      spec {
        container {
          name    = "refund_worker"
          image   = "payments-api:latest"
          command = ["python", "-m", "app.workers.refund_worker"]
        }
      }
    }
  }
}
