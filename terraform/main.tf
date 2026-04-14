# 1. Define the Cloud Provider (AWS)
provider "aws" {
  region = "ap-south-1" # Mumbai
}

# 2. Create a Security Group (NAME UPDATED TO AVOID DUPLICATE ERROR)
resource "aws_security_group" "quiz_sg" {
  name        = "personality-quiz-sg-v2" # Changed from original to bypass AWS name conflict
  description = "Allow port 7000 and SSH for the quiz app"

  # Allow incoming traffic on Port 7000 (The Quiz App)
  ingress {
    from_port   = 7000
    to_port     = 7000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # CRITICAL: Allow SSH (Port 22) so Jenkins can talk to this server
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Define the EC2 Instance (The Cloud Server)
resource "aws_instance" "quiz_server" {
  ami           = "ami-0dee22c13ea7a9a67" # Ubuntu 24.04 LTS
  instance_type = "t3.micro"

  # Link the new key you created
  key_name      = "my-key" 

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