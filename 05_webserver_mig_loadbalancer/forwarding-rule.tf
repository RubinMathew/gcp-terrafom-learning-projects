#here you have to specify the front end of load balancer
resource "google_compute_global_forwarding_rule" "forwarding-rule" {
  name        = "my-forwarding-rule"
  target      = google_compute_target_http_proxy.http-proxy.self_link
  port_range  = "80"

}