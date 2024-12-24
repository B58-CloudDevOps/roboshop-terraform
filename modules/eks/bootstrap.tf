# Deploys Nginx Ingress Controller In kube-system namespace
resource "null_resource" "nginxIngress" {
  depends_on = [aws_eks_cluster.main, aws_eks_node_group.main]

  provisioner "local-exec" {
    command = <<EOF

aws eks update-kubeconfig --name "${var.env}-eks"
helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace kube-system -f ${path.module}/conf/ingressValues.yaml
EOF
  }
}


# Deploys External-DNS In kube-system namespace ; This will ensure needed DNS Records would automatically
resource "null_resource" "externalDns" {
  triggers = {
    always = timestamp()
  }
  depends_on = [aws_eks_cluster.main, aws_eks_node_group.main, null_resource.nginxIngress]

  provisioner "local-exec" {
    command = <<EOF

aws eks update-kubeconfig --name "${var.env}-eks"
helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/
helm upgrade --install external-dns external-dns/external-dns --version 1.15.0 --namespace kube-system
EOF
  }
}