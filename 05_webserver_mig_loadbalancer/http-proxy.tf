resource "google_compute_target_http_proxy" "http-proxy" {
  name        = "my-http-proxy"
  url_map     = google_compute_url_map.url-map.self_link
  description = "HTTP proxy for the load balancer"
}