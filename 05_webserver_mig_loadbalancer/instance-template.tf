# Define an instance template with a startup script
resource "google_compute_instance_template" "webserver-instance_template" {

  name= "webserver-template"
  # Set machine type, image, and other instance details
  machine_type = "e2-micro"

  disk {
    source_image = "debian-cloud/debian-11"
    disk_size_gb = 10
  }

  network_interface {
    access_config {    #external ip addresss is required in order to execute your start up script. 
      network_tier = "PREMIUM"
    }
    subnetwork = google_compute_subnetwork.subnets-vpc[0].name
  }

  # Add a startup script to install Apache2
  metadata = {
    startup-script = "#!/bin/bash\napt update\napt -y install apache2\necho \"<html><body><p> Welcome to the Linux System Server </p><p>Host Machine info :  $(hostname)</p><p>Internal IP: $(hostname -I)</p></body></html>\" > /var/www/html/index.html"
  }
  tags = ["http-server", "https-server"]
}

