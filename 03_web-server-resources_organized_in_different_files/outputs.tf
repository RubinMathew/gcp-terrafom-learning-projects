# Output the instance status,name,internal & external IP address of the created VM
output "Instance_Name" {
  value = google_compute_instance.instance-tf-rbn-pc.name
}

output "Instance_Status" {
  value = google_compute_instance.instance-tf-rbn-pc.current_status
}
output "Internal_ip" {
  value = google_compute_instance.instance-tf-rbn-pc.network_interface.0.network_ip
}
output "External_ip" {
  value = google_compute_instance.instance-tf-rbn-pc.network_interface[0].access_config[0].nat_ip
}