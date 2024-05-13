
output "config_host" {
  value = "https://${module.gke_cluster.endpoint}"
  sensitive = true
}

output "config_token" {
  value     = data.google_client_config.this.access_token
  sensitive = true
}

output "config_ca" {
  value = base64decode(google_container_cluster.this.master_auth[0].cluster_ca_certificate)
}

output "name" {
  value = module.gke_cluster.name
}