provider "aws" {
  region     = "ap-south-1"
  shared_config_files = ["/root/.aws/credentials"]
}

resource "aws_instance" "my_monitoring_server" {
  ami           = "ami-05e00961530ae1b55"
  instance_type = "t2.medium"
  key_name      = "medicure"

  # Use the default security group
  security_groups = ["default"]
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("./medicure.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "my_monitoring_server"
    }
  provisioner "local-exec" {
        command = " echo ${aws_instance.my_monitoring_server.public_ip} > inventory "
  }
  provisioner "local-exec" {
  command = "ansible-playbook /var/lib/jenkins/workspace/banking_job/scripts/monitoring/monitoring.yaml "
  } 
}
