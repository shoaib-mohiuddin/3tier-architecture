variable "vpc_name" {
  description = "This is the VPC name"
  type        = string
}

variable "aws_region" {
  description = "The region to deploy the resources"
  type        = string
}

variable "availability_zones" {
  description = "The AZs to deploy the resources"
}


variable "cidr_vpc" {
  description = "This is the CIDR of the VPC"
}

variable "cidr_web_public" {
  description = "This is the CIDR of the Web Public Subnet"
}

variable "cidr_app_private" {
  description = "This is the CIDR of the App Subnet Private"
}

variable "cidr_data_private" {
  description = "This is the CIDR of the Data Subnet Private-a"
}