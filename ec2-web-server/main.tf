# 1. Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "Server01-VPC" }
}

# 2. Create a Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  tags = { Name = "task2-public-subnet" }
}

# 3. Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags   = { Name = "Server01-igw" }
}

# 4. Create a Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# 5. Associate Route Table with Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# 6. Security Group
resource "aws_security_group" "web_access" {
  name   = "allow_ssh_http"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 7. EC2 Instance
resource "aws_instance" "ubuntu_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_access.id]
  key_name               =  ""  

  tags = { Name = "Ubuntu-DevOps-Server" }

  user_data = <<-EOF
              #!/bin/bash
              # 1. Update and install Docker
              dnf update -y
              dnf install docker git -y
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ec2-user

              # 2. Install Terraform
              dnf install -y yum-utils
              yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
              dnf install terraform -y

              # 3. Install kubectl
              curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
              install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

              # 4. Install Minikube
              curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
              dnf install -y ./minikube-latest.x86_64.rpm

              # 5. CLI Optimizations
              echo 'alias k=kubectl' >> /home/ec2-user/.bashrc
              echo 'complete -F __start_kubectl k' >> /home/ec2-user/.bashrc
              EOF
}
