# Create a Google Cloud VM instance with a startup script using default-compute-service-account
resource "google_compute_instance" "instance-tf-rbn-pc" {
 name = "instance-tf-rbn-pc"
    network_interface {
    access_config {
      network_tier = "PREMIUM"
    }
    subnetwork=google_compute_subnetwork.subnet1-vpc-public.name
  }

  boot_disk {
    auto_delete = true
    device_name = "instance-tf-rbn-pc"
    initialize_params {
      image = var.vm_parametes.os_image
      type  = "pd-balanced"
    }
    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = var.vm_parametes.machine_type

  metadata = {
    startup-script = "#!/bin/bash\napt update\napt -y install apache2\necho \"<html><body><p> Welcome to the Linux System Server </p><p>Host Machine info :  $(hostname)</p><p>Internal IP: $(hostname -I)</p></body></html>\" > /var/www/html/index.html"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "1234567890-compute@developer.gserviceaccount.com"  #specify your default service account name here
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = var.network_tags  # default value ["http-server", "https-server"] 
  zone = var.compute_zone
}


#End of simple web server configuration file