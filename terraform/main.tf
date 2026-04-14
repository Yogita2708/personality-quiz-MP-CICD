# 1. Define the Cloud Provider (AWS)
provider "aws" {
  region = "ap-south-1" # Targeting Mumbai to resolve previous manual connection issues
}

# 2. Create a Security Group
resource "aws_security_group" "quiz_sg" {
  name        = "personality-quiz-sg"
  description = "Allow port 7000 for the quiz app"

  # Allow incoming traffic on Port 7000 (where your browser hits)
  ingress {
    from_port   = 7000
    to_port     = 7000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Allow all outgoing traffic so the server can download Docker
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Define the EC2 Instance (The Cloud Server)
resource "aws_instance" "quiz_server" {
  ami           = "ami-0dee22c13ea7a9a67" # Ubuntu 24.04 LTS AMI for ap-south-1
  instance_type = "t3.micro"             # Free-tier eligible instance

  # Attach the Security Group defined above
  vpc_security_group_ids = [aws_security_group.quiz_sg.id]

  tags = {
    Name = "PersonalityQuizServer"
  }

  # Automatic setup script: Installs Docker on the new server
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              EOF
}

# 4. Output the Public IP
output "instance_public_ip" {
  description = "The public IP address of the quiz server"
  value       = aws_instance.quiz_server.public_ip
}