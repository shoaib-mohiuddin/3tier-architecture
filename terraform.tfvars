vpc_name   = "vpc-3tier"
aws_region = "ap-south-1"

availability_zones = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
cidr_vpc           = "10.0.0.0/16"
cidr_web_public = {
  a = "10.0.1.0/24"
  b = "10.0.2.0/24"
  c = "10.0.3.0/24"
}
#cidr_web_public = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
cidr_app_private = {
  a = "10.0.4.0/24"
  b = "10.0.5.0/24"
  c = "10.0.6.0/24"
}
cidr_data_private = {
  a = "10.0.7.0/24"
  b = "10.0.8.0/24"
  c = "10.0.9.0/24"
}