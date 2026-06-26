resource "kubernetes_deployment" "payout_worker" {
  metadata {
    name = "payments-api-payout_worker"
    labels = {
      app       = "payments-api"
      component = "payout_worker"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app       = "payments-api"
        component = "payout_worker"
      }
    }

    template {
      metadata {
        labels = {
          app       = "payments-api"
          component = "payout_worker"
        }
      }

      spec {
        container {
          name    = "payout_worker"
          image   = "payments-api:latest"
          command = ["python", "-m", "app.workers.payout_worker"]
        }
      }
    }
  }
}
