provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "todo_sg" {
  name        = "todo-sg"
  description = "Allow SSH & Flask port"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "dockerhub_user" {
  description = "DockerHub username for pulling image"
  type        = string
}

resource "aws_instance" "todo_vm" {
  ami                    = "ami-0abcdef1234567890"  # replace with Ubuntu 20.04 LTS AMI in your region
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.todo_sg.id]
  key_name               = "your-ssh-keypair-name"

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io
              docker run -d --name todo-app -p 5000:5000 \
                ${var.dockerhub_user}/todo-app:latest
              EOF

  tags = { Name = "todo-server" }
}
