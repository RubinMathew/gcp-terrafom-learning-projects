
resource "google_compute_url_map" "url-map" {
  name            = "my-url-map"
  default_service = google_compute_backend_service.webserver-backend-service.self_link
}
