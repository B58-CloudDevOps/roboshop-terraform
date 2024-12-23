# Deploys Nginx Ingress Controller In kube-system namespace
resource "null_resource" "nginxIngress" {

  depends_on = [aws_eks_cluster.main, aws_eks_node_group.main]

  provisioner "local-exec" {
    command = <<EOF

aws eks update-kubeconfig --name "${var.env}-eks"
helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace kube-system -f ${path.module}/ingressValues.yaml
EOF
  }
}


resource "null_resource" "externalDns" {

  depends_on = [aws_eks_cluster.main, aws_eks_node_group.main]

  triggers = {
    always = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOF

aws eks update-kubeconfig --name "${var.env}-eks"
helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/
helm upgrade --install external-dns external-dns/external-dns --version 1.15.0 --namespace kube-system
EOF
  }
}

# EKS Pod Identity Association
resource "aws_eks_pod_identity_association" "main" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "kube-system"
  service_account = "external-dns"
  role_arn        = aws_iam_role.external_dns_role.arn
}