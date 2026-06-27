# AWS Three-Tier Application Infrastructure using Terraform

> **Provisioned a production-ready AWS three-tier architecture using Terraform, featuring VPC, Application Load Balancer, EC2, Auto Scaling, RDS, NAT Gateways, and secure Infrastructure as Code (IaC) deployment.**

---

## 📖 Overview

This project demonstrates the deployment of a **production-ready three-tier architecture** on AWS using **Terraform**. The infrastructure is designed following AWS best practices for **security**, **high availability**, **scalability**, and **fault tolerance**.

The application is divided into three logical tiers:

* **Presentation Tier** – Web servers behind an Application Load Balancer.
* **Application Tier** – Private EC2 instances responsible for business logic.
* **Database Tier** – Amazon RDS deployed in private subnets.

All infrastructure is provisioned using **Infrastructure as Code (IaC)**, enabling repeatable and automated deployments.

---

## 🏗️ Architecture

```text
                   Internet
                       │
               Application Load Balancer
                       │
          ┌────────────┴────────────┐
          │                         │
      Public Subnet            Public Subnet
          │                         │
      EC2 Web Server          EC2 Web Server
          │                         │
          └────────────┬────────────┘
                       │
              Private Application Tier
          ┌────────────┴────────────┐
          │                         │
      App Server              App Server
          │                         │
          └────────────┬────────────┘
                       │
                 Amazon RDS (MySQL)
                 Private Subnets
```

---

## Features

* Infrastructure as Code using Terraform
* Modular and reusable Terraform code
* Highly available architecture across multiple Availability Zones
* Public and private subnet design
* Application Load Balancer for traffic distribution
* Auto Scaling Groups for automatic scaling
* Secure Security Group configuration
* Internet Gateway and NAT Gateway configuration
* Amazon RDS deployed in private subnets
* Easily customizable through Terraform variables

---

## AWS Services Used

* Amazon VPC
* Public & Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables
* Security Groups
* EC2
* Application Load Balancer
* Target Groups
* Launch Templates
* Auto Scaling Groups
* Amazon RDS
* IAM Roles & Instance Profiles

---

## 🛠️ Technologies

* Terraform
* AWS
* Git & GitHub
* Linux
* Infrastructure as Code (IaC)

---

## 📂 Project Structure

```text
three-tier-app/
│
├── modules/
│   ├── networking/
│   ├── security/
│   ├── compute/
│   ├── load-balancer/
│   ├── autoscaling/
│   └── database/
│
├── provider.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── README.md
```

---

```

Initialize Terraform:

```bash
terraform init
```

Review the execution plan:

```bash
terraform plan
```

Provision the infrastructure:

```bash
terraform apply
```

Destroy the infrastructure:

```bash
terraform destroy
```

---

##  Learning Outcomes

This project demonstrates practical experience with:

* Infrastructure as Code (IaC)
* Terraform modules
* AWS networking
* Multi-tier architecture
* High Availability (HA)
* Auto Scaling
* Load Balancing
* Cloud Security
* Production infrastructure deployment

---

## Future Improvements

* Remote Terraform state using S3 & DynamoDB
* GitHub Actions CI/CD pipeline
* AWS WAF integration
* HTTPS with ACM certificates
* Route 53 DNS
* CloudWatch monitoring and alarms
* Blue/Green deployments
* ECS/EKS container deployment

---

## 👨‍💻 Author

**Ritwik Kumar**

Cloud & DevOps Engineer | AWS | Terraform | Linux | Infrastructure as Code
