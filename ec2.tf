# resource "aws_instance" "bastion_host" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t2.micro"

#   vpc_security_group_ids = []

#   key_name                    = "ta-mumbai"
#   subnet_id                   = aws_subnet.web_public["a"].id
#   associate_public_ip_address = true

#   tags = {
#     Name = "Bastion"
#   }
# }