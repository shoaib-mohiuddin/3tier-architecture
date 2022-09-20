data "aws_ami" "ubuntu" { # for bastion host
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

data "aws_secretsmanager_secret" "mysql_passwd" {
  name = "rds_mysql_passwd"
}

data "aws_secretsmanager_secret_version" "mysql_passwd_version" {
  secret_id = data.aws_secretsmanager_secret.mysql_passwd.id
}