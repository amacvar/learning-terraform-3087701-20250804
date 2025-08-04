data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

data "aws_vpc" "example" {
  filter {
    name   = "tag:Name"
    values = ["myvpc"] # Replace with the name of your VPC
  }
}

# (Information not from sources: This block would retrieve a subnet within that VPC)
data "aws_subnet" "example" {
  vpc_id = data.aws_vpc.example.id
  filter {
    name   = "tag:Name"
    values = ["sn7d"] # Replace with the name of your desired subnet
  }
}


resource "aws_instance" "web" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type
  subnet_id = data.aws_subnet.example.id
  security_groups = ["sg-0640ce76ed6404c3a"]

  tags = {
    Name = "HelloWorld"
  }
}
