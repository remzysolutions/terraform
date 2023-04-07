provider "aws" {
  region  = "us-east-1"
}



resource "aws_instance" "ec2_jenkins" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.xlarge"
  key_name      = "KEYNAME"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  user_data              = file("jenkins.sh")

  tags = {
    "Name" : "Jenkins"
  }
}

resource "aws_instance" "ec2_sonarqube" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.medium"
  key_name      = "KEYNAME"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  user_data              = file("sonarqube.sh")

  tags = {
    "Name" : "SonarQube"
  }
}


resource "aws_instance" "ec2_artifactory" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.medium"
  key_name      = "KEYNAME"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  user_data              = file("jfrog.sh")

  tags = {
    "Name" : "JFROG"
  }
}
