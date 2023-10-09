# Configure the Google Cloud provider- for projetc my-first-project using default-compute-service-account
# This is a terraform configuration file for creating s simple webserver-mig with apache in gcp
provider "google" {
  project     = "<project-name>"  #specify your project id
  region      = "us-central1"
  zone ="us-central1-a"
   # credentials = file("<path-to-key-file>.json") or provide your key as environment variable with name GOOGLE_APPLICATION_CREDENTIALS
}