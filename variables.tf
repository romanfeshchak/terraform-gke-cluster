variable "bucket_name" {
  type = string
  default = null
}

variable "google_project" {
  type = string
}

variable "google_region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "node_pool_name" {
  type = string
}

variable "node_count" {
  type = number
}

variable "machine_type" {
  type = string
}

variable "cluster_network_cidr_block" {
  type = string
}

variable "google_credentials_file" {
  type = string
  default = ""
}
