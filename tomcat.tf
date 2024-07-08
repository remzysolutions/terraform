resource "aws_instance" "Dev" {
  ami           = "ami-"
  instance_type = "t2.micro"
  key_name      = "keyname"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  user_data              = file("tomcat.sh")

  tags = {
    "Name" : "Dev"
  }
}

resource "aws_instance" "QA" {
  ami           = "ami-"
  instance_type = "t2.small"
  key_name      = "keyname"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  user_data              = file("tomcat.sh")

  tags = {
    "Name" : "QA"
  }
}


resource "aws_instance" "Prod" {
  ami           = "ami-"
  instance_type = "t2.medium"
  key_name      = "keyname"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  user_data              = file("tomcat.sh")

  tags = {
    "Name" : "Prod"
  }
}
