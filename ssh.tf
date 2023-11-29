resource "tls_private_key" "my_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-key-pair"
  public_key = tls_private_key.my_ssh_key.public_key_openssh
}

resource "local_file" "private_key" {
  content = tls_private_key.my_ssh_key.private_key_pem
  filename = "my-key-pair.pem"
  file_permission = "0400"
}