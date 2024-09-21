variable "imagename" {
    description = "The name of the image to build"
    type = string
    default = "micronaut-apprunner"
}

variable "vpc_id" {
    description = "The VPC ID"
    type = string
}
