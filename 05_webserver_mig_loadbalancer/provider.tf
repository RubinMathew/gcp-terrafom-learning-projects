# Configure the Google Cloud provider- for projetc my-first-project using default-compute-service-account

provider "google" {
  project     = "<your project name>" #specify your project name
  region      = "us-central1"
  zone ="us-central1-a"
  # credentials = file("<path-to-key-file>.json") or provide your key as environment variable with name GOOGLE_APPLICATION_CREDENTIALS
}
