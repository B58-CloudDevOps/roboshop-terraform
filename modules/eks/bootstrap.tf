# Deploys Nginx Ingress Controller In kube-system namespace
resource "null_resource" "nginx_ingress" {
  triggers = {
    always = timestamp()
  }
  depends_on = [aws_eks_cluster.main, aws_eks_node_group.main]

  provisioner "local-exec" {
    command = <<EOF

aws eks update-kubeconfig --name "${var.env}-eks"
helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace kube-system -f ${path.module}/ingressValues.yaml
EOF
  }
}
