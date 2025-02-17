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

variable "project_id" {
  type        = string
  description = "GCP project id"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace where resources are deployed"
  default     = "ray-system"
}

variable "create_namespace" {
  type        = bool
}

variable "enable_tpu" {
  type        = bool
  description = "Set to true to request TPUs in Ray cluster"
  default     = false
}

variable "enable_gpu" {
  type        = bool
  description = "Set to true to request GPUs in Ray cluster"
  default     = false
}

variable "enable_autopilot" {
  type        = bool
  description = "Set to true to enable GKE Autopilot clusters"
}

variable "google_service_account" {
  type        = string
  description = "Google service account name"
  default     = "kuberay-gcp-sa"
}

variable "gcs_bucket" {
  type        = string
  description = "GCS Bucket name"
}

variable "grafana_host" {
  type        = string
}
