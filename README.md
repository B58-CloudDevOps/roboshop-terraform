# roboshop-terraform

This repo holds the IAC using Terraform to provision the EKS and deploy the roboshop containerized apps on EKS as deployments.

Mongodb, Rabbitmq, MySQL and Redis would still be there on EC2. 


    Stateless workloads / Apps would be deployed on EKS.
    Statefull workloads would be running on EC2 nodes.


EKS when provisioned will have :
    Grafana, 
    prometheus, 
    Open-Search,
    Metrics-server ( for HPA ), 
    External dns,
    Ingress-Controller,
    TLS_Certificate,
    Pod Identity Association,
    FluentD

Next is: ArgoCD