output "ip" {
  value = google_compute_instance.default.network_interface.0.network_ip
}

output "ex-ip" {
 value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}

output "connection_name" {
  value = google_sql_database_instance.postgres.connection_name
}

