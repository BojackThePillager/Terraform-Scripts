terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}


resource "docker_image" "gcphound" {
  name = "desijarvis/gcphound:v2.0"
  keep_locally = false
}

resource "docker_container" "gcphound" {
  image = docker_image.gcphound.image_id
  name = "gcphound"

  ports {
    internal = 443
    external = 443
  }
}
