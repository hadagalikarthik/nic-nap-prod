locals {
  project_prefix         = data.terraform_remote_state.infra.outputs.project_prefix
  build_suffix            = data.terraform_remote_state.infra.outputs.build_suffix
  host                   = data.terraform_remote_state.gke.outputs.kubernetes_api_server_url
  region                 = data.terraform_remote_state.infra.outputs.gcp_region
  cluster_ca_certificate = data.terraform_remote_state.gke.outputs.kubernetes_cluster_ca_certificate
  cluster_name           = data.terraform_remote_state.gke.outputs.kubernetes_cluster_name
  cluster_token          = data.terraform_remote_state.gke.outputs.kubernetes_cluster_access_token
  cidr                   = data.terraform_remote_state.infra.outputs.cidr
}