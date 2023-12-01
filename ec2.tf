//Public Instance
resource "aws_instance" "public_instance" {
  ami           = "ami-0e27f6f1f255d553a"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key_pair.key_name
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.my_vpc_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "public-instance"
  }
  
  user_data = file("userdata.sh")

  provisioner "file" {
    source      = "./${aws_key_pair.my_key_pair.key_name}.pem"
    destination = "/home/ubuntu/${aws_key_pair.my_key_pair.key_name}.pem"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${aws_key_pair.my_key_pair.key_name}.pem")
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = ["chmod 400 ~/${aws_key_pair.my_key_pair.key_name}.pem"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${aws_key_pair.my_key_pair.key_name}.pem")
      host        = self.public_ip
    }
  }
}

output "public_instance_ip" {
    value = aws_instance.public_instance.public_ip
  }

// Private Instance
resource "aws_instance" "private_instance" {
  ami           = "ami-0e27f6f1f255d553a"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key_pair.key_name
  subnet_id     = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.my_vpc_sg.id]

  tags = {
    Name = "private-instance"
  }
  
  user_data = file("userdata.sh")
}