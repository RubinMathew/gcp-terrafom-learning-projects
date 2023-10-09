# Configure the Google Cloud provider- for project my-first-project
provider "google" {
  project     = var.project
  region      = var.compute_region
  zone =var.compute_zone
  # credentials = file("<path-to-key-file>.json") or provide your key as environment variable with name GOOGLE_APPLICATION_CREDENTIALS
}
