resource "aws_instance" "web_ngix" {
  ami           = var.AMI_Machine
  instance_type = "t2.micro"


  #VPC
  subnet_id = aws_subnet.test-subnet-public-1.id

  #Security group
  vpc_security_group_ids = ["${aws_security_group.ssh_security.id}"]

  #public ssh key
  key_name = aws_key_pair.SSH-key-pair.id

  ##############################           Ngix           ##############################
    provisioner "file" {
      source      = "ngix.sh"
      destination = "/tmp/ngix.sh"
    }

    provisioner "remote-exec" {
      inline = [
        "chmod +x /tmp/ngix.sh",
        "sudo /tmp/ngix.sh"
      ]
    }

  connection {
    type        = "ssh"
    user        = var.EC2_user
    private_key = file("${var.PRIVATE_KEY_PATH}")
    host        = self.public_ip
  }
}

# Sends your public key to the instance
resource "aws_key_pair" "SSH-key-pair" {
  key_name   = "SSH-key-pair"
  public_key = file("${var.PUBLIC_KEY_PATH}")
}