provider "aws" {
  region = "eu-north-1"
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
  ami                    = "ami-0c1ac8a41498c1a9c"  # Ubuntu 24.04 LTS in eu‑north‑1
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.todo_sg.id]
  key_name               = "todo-key"               # ← updated here

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io
              docker run -d --name todo-app -p 5000:5000 \
                ${var.dockerhub_user}/todo-app:latest
              EOF

  tags = {
    Name = "todo-server"
  }
}
output "public_ip" {
  description = "The public IP of the ToDo VM"
  value       = aws_instance.todo_vm.public_ip
}

