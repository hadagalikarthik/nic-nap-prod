output "kubernetes_cluster_name" {
  value       = nonsensitive(google_container_cluster.primary.name)
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

output "kubernetes_cluster_client_certificate" {
  value       = google_container_cluster.primary.master_auth.0.client_certificate
  description = "GKE Cluster Client Certificate"
}

output "kubernetes_cluster_client_key" {
  value       = nonsensitive(google_container_cluster.primary.master_auth.0.client_key)
  description = "GKE Cluster Client Key"
}

output "kubernetes_cluster_ca_certificate" {
  value       = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
  description = "GKE Cluster CA Certificate"
}

output "kubernetes_cluster_access_token" {
  value       = nonsensitive(data.google_client_config.provider.access_token)
  description = "GKE Cluster Access Token"
}

output "instance_group_urls" {
  value = google_container_node_pool.primary_nodes.instance_group_urls
}

output "kubernetes_api_server_url" {
  value = "https://${google_container_cluster.primary.endpoint}"
}