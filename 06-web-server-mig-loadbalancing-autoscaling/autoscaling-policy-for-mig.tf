resource "google_compute_autoscaler" "werbserver-autoscaler" {
  name               = "werbserver-autoscaler"
  target = google_compute_instance_group_manager.webserver-instance-group.id
  autoscaling_policy {
    cooldown_period = 60
    min_replicas = 1
    max_replicas = 3
    cpu_utilization {
      target = 0.6
    }
  }
}