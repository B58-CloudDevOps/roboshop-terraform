variable "env" {}
variable "subnet_ids" {}
variable "component_name" {}
variable "eks_cluster_version" {}
variable "node_groups" {}
variable "addons" {}

resource "null_resource" "prometheus_grafana_stack" {
  triggers = {
    always = timestamp()
  }
  depends_on = [aws_eks_cluster.main, aws_eks_node_group.main, null_resource.nginxIngress, null_resource.externalDns]

  provisioner "local-exec" {
    command = <<EOF

aws eks update-kubeconfig --name "${var.env}-eks"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || true
helm upgrade --install prom-stack prometheus-community/kube-prometheus-stack --namespace kube-system -f ${path.module}/conf/promStackValues.yaml
kubectl apply -f "ingress-${var.env}.yaml"
EOF
  }
}