resource "kubernetes_deployment" "dispute_worker" {
  metadata {
    name = "payments-api-dispute_worker"
    labels = {
      app       = "payments-api"
      component = "dispute_worker"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app       = "payments-api"
        component = "dispute_worker"
      }
    }

    template {
      metadata {
        labels = {
          app       = "payments-api"
          component = "dispute_worker"
        }
      }

      spec {
        container {
          name    = "dispute_worker"
          image   = "payments-api:latest"
          command = ["python", "-m", "app.workers.dispute_worker"]
        }
      }
    }
  }
}
