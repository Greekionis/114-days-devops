variable "container_name" {
  description = "Name of the Docker container"
  type        = string
  default     = "my-app"
}

variable "external_port" {
  description = "External port to expose"
  type        = number
  default     = 8088
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "nginx:1.25"
}
