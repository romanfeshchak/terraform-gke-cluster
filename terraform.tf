terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.19.0"
    }
  }

  backend "gcs" {
    bucket = "terraforms-state"
    prefix = "terraform/state"
  }
}
