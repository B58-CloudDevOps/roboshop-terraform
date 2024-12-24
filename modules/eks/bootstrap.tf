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

  depends_on = [aws_eks_cluster.main, aws_eks_node_group.main, null_resource.nginxIngress]

  provisioner "local-exec" {
    command = <<EOF

aws eks update-kubeconfig --name "${var.env}-eks"
helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/
helm upgrade --install external-dns external-dns/external-dns --version 1.15.0 --namespace kube-system
EOF
  }
}

# Pod-Identity-Association For external-dns
resource "aws_eks_pod_identity_association" "external_dns" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "kube-system"
  service_account = "external-dns"
  role_arn        = aws_iam_role.external_dns_role.arn
}

# Deploys Prometheus & Grafana Stack
resource "null_resource" "prometheus_grafana_stack" {
  triggers = {
    always = timestamp()
  }
  depends_on = [aws_eks_cluster.main, aws_eks_node_group.main, null_resource.nginxIngress, null_resource.externalDns]

  provisioner "local-exec" {
    command = <<EOF

aws eks update-kubeconfig --name "${var.env}-eks"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install prom-stack prometheus-community/kube-prometheus-stack --namespace kube-system -f ${path.module}/conf/promStackValues.yaml
kubectl apply -f ${path.module}/conf/ingress-dev.yaml
EOF
  }
}

resource "null_resource" "hpa_metrics_server" {
  depends_on = [aws_eks_cluster.main, aws_eks_node_group.main, null_resource.nginxIngress, null_resource.externalDns]

  provisioner "local-exec" {
    command = <<EOF

aws eks update-kubeconfig --name "${var.env}-eks"
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml --namespace kube-system
EOF
  }
}