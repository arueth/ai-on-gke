# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork_name
  project = var.project_id
}

module "gke" {
  source                  = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"
  version                 = "29.0.0"
  project_id              = var.project_id
  regional                = var.cluster_regional
  name                    = var.cluster_name
  cluster_resource_labels = var.cluster_labels
  kubernetes_version      = var.kubernetes_version
  region                  = var.cluster_region
  zones                   = var.cluster_zones
  network                 = var.network_name
  subnetwork              = var.subnetwork_name
  ip_range_pods           = var.ip_range_pods
  ip_range_services       = var.ip_range_services
  #cluster_resource_labels = { "mesh_id" : "proj-${data.google_project.project.number}" }

  horizontal_pod_autoscaling = true
  enable_private_endpoint    = true
  enable_private_nodes       = true
  master_authorized_networks = length(var.master_authorized_networks) == 0 ? [{ cidr_block = "${data.google_compute_subnetwork.subnetwork.ip_cidr_range}", display_name = "${data.google_compute_subnetwork.subnetwork.name}" }] : var.master_authorized_networks
  master_ipv4_cidr_block     = var.master_ipv4_cidr_block
  deletion_protection        = var.deletion_protection

}

# GKE cluster fleet registration
resource "google_gke_hub_membership" "gke-fleet" {
  project       = var.project_id
  membership_id = var.cluster_name
  location      = var.cluster_region

  endpoint {
    gke_cluster {
      resource_link = module.gke.cluster_id
    }
  }

  authority {
    issuer = "https://container.googleapis.com/v1/${module.gke.cluster_id}"
  }
}
