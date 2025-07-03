# terraform-eks
A sample repository to create EKS on AWS using Terraform with automatic application deployment.

This Terraform configuration creates:
- **EKS Cluster** with managed node groups
- **VPC** with public and private subnets
- **Security Groups** and networking configuration
- **Kubernetes Deployments** for:
  - Pharmetrade frontend application
  - API Gateway backend service
  - Adminer database management tool

### Install AWS CLI 

As the first step, you need to install AWS CLI as we will use the AWS CLI (`aws configure`) command to connect Terraform with AWS in the next steps.

Follow the below link to Install AWS CLI.
```
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
```

### Install Terraform

Next, Install Terraform using the below link.
```
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
```

### Install kubectl (optional)

If you want to manage the Kubernetes cluster directly, install kubectl:
```
https://kubernetes.io/docs/tasks/tools/
```

### Connect Terraform with AWS

Its very easy to connect Terraform with AWS. Run `aws configure` command and provide the AWS Security credentials as shown in the video.

### Initialize Terraform

Clone the repository and Run `terraform init`. This will intialize the terraform environment for you and download the modules, providers and other configuration required.

### Optionally review the terraform configuration

Run `terraform plan` to see the configuration it creates when executed.

### Finally, Apply terraform configuation to create EKS cluster with applications

`terraform apply`

This will create:
1. EKS cluster with VPC and networking
2. Deploy three applications automatically:
   - API Gateway service (internal)
   - Pharmetrade frontend (external LoadBalancer)
   - Adminer database management (external LoadBalancer)

### Access Your Applications

After deployment, Terraform will output URLs for your services:

- **Pharmetrade Frontend**: Access via the LoadBalancer URL
- **Adminer**: Database management interface via LoadBalancer URL (you can connect to external databases)
- **API Gateway**: Internal service for backend APIs

### Configure kubectl (optional)

To access the cluster with kubectl, run the command shown in the Terraform output:
```bash
aws eks update-kubeconfig --name pharmetrade-eks-cluster --region <your-region>
```

Then you can use standard kubectl commands:
```bash
kubectl get pods
kubectl get services
kubectl logs -f deployment/pharmetrade-deployment
```

### Cleanup

To destroy all resources:
```bash
terraform destroy
```
