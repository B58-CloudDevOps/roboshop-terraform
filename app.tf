# resource "null_resource" "app" {
#   depends_on = [aws_route53_record.main, aws_instance.main]

#   count = length(var.components)

#   triggers = {
#     always_run = timestamp()
#   }
#   provisioner "remote-exec" { # This let's the execution to happen on the remote node
#     connection {
#       host     = aws_instance.main.*.private_ip[count.index]
#       user     = data.vault_generic_secret.ssh.data["username"]
#       password = data.vault_generic_secret.ssh.data["password"]
#     }

#     inline = [
#       "sudo pip3.11 install ansible",
#       "pip3.11 install hvac",
#       "ansible-pull  -i localhost, -U https://github.com/B58-CloudDevOps/roboshop-ansible.git -e component=${var.components[count.index]} -e env=${var.env} -e vault_token=${var.vault_token} main.yml"
#     ]
#   }
# }