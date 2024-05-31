# AWS Infrastructure for WordPress with RDS Aurora

This repository contains a Terraform template to set up a scalable and secure infrastructure on AWS for hosting WordPress with an RDS Aurora database.

## Architecture Overview

The architecture consists of the following components:
- **VPC**: A Virtual Private Cloud with multiple subnets.
  - Public Subnets: For load balancer and NAT gateway.
  - Private Subnets: For EC2 instances and RDS.
- **Subnets**: Five subnets across two availability zones.
  - Public Subnets (for ALB and NAT Gateway).
  - Private Subnets (for EC2 instances).
  - Private Subnet for RDS.
- **Internet Gateway**: To allow traffic from the internet to the public subnets.
- **NAT Gateway**: To allow instances in the private subnets to connect to the internet for updates and patches.
- **Route Tables**: Configured for public and private routing.
- **Security Groups**: For controlling access to instances.
  - SSH access.
  - HTTP access.
  - MySQL access for RDS.
- **Bastion Host**: For secure SSH access to instances.
- **Launch Template**: For WordPress instances.
- **Application Load Balancer**: For distributing traffic to WordPress instances.
- **Auto Scaling Group**: For scaling WordPress instances.
- **RDS Aurora**: For the WordPress database.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) 1.0.0 or later.
- AWS account with appropriate permissions.
- An SSH key pair in your AWS account.

## Usage

### 1. Clone the repository

```bash
git clone https://github.com/kopamak990/capstone-project.git
cd wordpress-aws-terraform

2. Customize Variables
Modify the variables.tf file if you need to customize the defaults.

3. Initialize Terraform
bash
Copy code
terraform init
4. Plan the deployment
bash
Copy code
terraform plan
5. Apply the configuration
bash
Copy code
terraform apply
Confirm the apply step with yes. This will create all the resources described in the template.

6. Access the WordPress site
After the resources are created, Terraform will output the DNS name of the Application Load Balancer. You can use this DNS name to access the WordPress site.

bash
Copy code
output "alb_dns_name" {
  value = aws_lb.wordpress_lb.dns_name
}
