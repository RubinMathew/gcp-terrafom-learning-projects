# Define an instance group manager using the instance template
resource "google_compute_instance_group_manager" "webserver-instance-group" {
  name               = "webserver-instance-group"
  base_instance_name = "webserver-mig-instance"

  version {
    name              = "my-version"
    instance_template = google_compute_instance_template.webserver-instance_template.id
  }


  target_size = 2 # Set the desired number of instances
  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
   
    health_check      = google_compute_http_health_check.webserver-health-check.self_link
    initial_delay_sec = 300
  }
}
