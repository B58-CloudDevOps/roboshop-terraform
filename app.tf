resource "null_resource" "app" {
  depends_on = [aws_route53_record.main, aws_instance.main]

  count = length(var.components)

  triggers = {
    always_run = timestamp()
  }

  connection {
    host     = aws_instance.main.*.private_ip[count.index]
    user     = data.vault_generic_secret.ssh.data["username"]
    password = data.vault_generic_secret.ssh.data["password"]
    type     = "ssh"
  }
  provisioner "remote-exec" { # This let's the execution to happen on the remote node
    inline = [
      "sudo pip3.11 install ansible",
      "ansible-pull -U https://github.com/B58-CloudDevOps/roboshop-ansible.git -i localhost, -e component=${component} -e env=${env} -e vault_token=${vault_token} main.yml"
    ]
  }
}