# Create a backend service with your MIG as a backend
resource "google_compute_backend_service" "webserver-backend-service" {
  name                  = "webserver-backend-service"
  protocol              = "HTTP"
  timeout_sec           = 10
  health_checks = [google_compute_http_health_check.webserver-health-check.self_link]
  port_name   = "http"
  backend {
    group          = google_compute_instance_group_manager.webserver-instance-group.instance_group
  }
  
}
