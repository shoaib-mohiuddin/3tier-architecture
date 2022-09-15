vpc_name     = "vpc-3tier"
aws_region   = "ap-south-1"
az_a = "ap-south-2a"
az_b = "ap-south-2b"
az_c = "ap-south-2c"
cidr_vpc     = "10.0.0.0/16"
cidr_web_public = {
    a = "10.0.1.0/24"
    b = "10.0.2.0/24"
    c = "10.0.3.0/24"
}
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
# cidr_kibana_public = "10.0.1.0/24"
# cidr_monitor_private = "10.0.2.0/24"
# cidr_app_private_a = "10.0.3.0/24"
# cidr_app_private_b = "10.0.6.0/24"
# cidr_app_private_c = "10.0.9.0/24"