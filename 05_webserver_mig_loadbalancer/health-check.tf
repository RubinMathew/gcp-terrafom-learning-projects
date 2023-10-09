# Create a health check
resource "google_compute_http_health_check" "webserver-health-check" {
  name               = "webserver-health-check"
  check_interval_sec = 5
  timeout_sec        = 5
  port               = 80
  request_path       = "/"
  healthy_threshold = 3
  unhealthy_threshold = 3
  
}




/* sucess */