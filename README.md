# 🚀 Terraform AWS Secure Web Stack

> **Modular AWS Infrastructure as Code using Terraform, EC2, RDS, VPC, Security Groups, AWS Secrets Manager, and GitHub Actions.**

A production-style AWS infrastructure project built with **Terraform** to deploy a Flask web application on Amazon EC2 with a private MySQL database on Amazon RDS.

The infrastructure is organized using reusable Terraform modules and includes network isolation, security groups, secrets management, resource tagging, encrypted database storage, and automated Terraform validation through GitHub Actions.

---

## 📌 Project Overview

This project demonstrates how to design and deploy a complete AWS web application infrastructure using **Infrastructure as Code (IaC)**.

The application architecture consists of:

- 🌐 Amazon VPC
- 🖥️ EC2 web server
- 🗄️ Private Amazon RDS MySQL database
- 🔐 Security Groups
- 🔑 AWS Secrets Manager
- 🌍 Internet Gateway
- 🛣️ Route Tables
- 🧩 Reusable Terraform Modules
- ⚙️ GitHub Actions CI
- 🏷️ Common AWS resource tagging
- 🔒 Encrypted RDS storage

The EC2 instance is publicly accessible for the web application, while the RDS database remains inside private subnets and accepts database connections only from the EC2 security group.

---

# 🏗️ Architecture

```text
                         ┌──────────────────┐
                         │     INTERNET     │
                         └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │ Internet Gateway │
                         └────────┬─────────┘
                                  │
                                  ▼
┌──────────────────────────────────────────────────────────────┐
│                         AWS VPC                              │
│                      10.0.0.0/16                             │
│                                                              │
│  ┌────────────────────────┐                                  │
│  │      PUBLIC SUBNET     │                                  │
│  │       10.0.1.0/24      │                                  │
│  │                        │                                  │
│  │   ┌────────────────┐   │                                  │
│  │   │ EC2 Web Server │   │                                  │
│  │   │ Ubuntu + Flask │   │                                  │
│  │   └───────┬────────┘   │                                  │
│  └───────────┼────────────┘                                  │
│              │                                               │
│              │ MySQL :3306                                   │
│              ▼                                               │
│  ┌────────────────────────────────────────────────────────┐  │
│  │                  PRIVATE SUBNETS                       │  │
│  │                                                        │  │
│  │  ┌──────────────┐        ┌──────────────┐             │  │
│  │  │ 10.0.2.0/24  │        │ 10.0.3.0/24  │             │  │
│  │  │              │        │              │             │  │
│  │  │              └────────┼──────────────┘             │  │
│  │  │                       │                            │  │
│  │  │                 ┌─────▼─────┐                      │  │
│  │  │                 │ RDS MySQL │                      │  │
│  │  │                 └───────────┘                      │  │
│  │  └────────────────────────────────────────────────────┘  │
│  └──────────────────────────────────────────────────────────┘
│                                                              │
└──────────────────────────────────────────────────────────────┘

                    AWS Secrets Manager
                           │
                           ▼
                    Database Credentials
```

---

# 🔄 Application Traffic Flow

```text
User
  │
  ▼
Internet
  │
  ▼
Internet Gateway
  │
  ▼
Public Subnet
  │
  ▼
EC2 Flask Application
  │
  │ MySQL :3306
  ▼
Private RDS MySQL
```

### Security Boundary

```text
Internet
   │
   │ HTTP :80
   ▼
┌─────────────────────┐
│   EC2 Security      │
│       Group         │
└─────────┬───────────┘
          │
          │ MySQL :3306
          ▼
┌─────────────────────┐
│   RDS Security      │
│       Group         │
└─────────┬───────────┘
          │
          ▼
      RDS MySQL
```

The database is **not publicly accessible**.

---

# ✨ Key Features

| Feature | Description |
|---|---|
| 🏗️ Infrastructure as Code | Entire AWS infrastructure managed using Terraform |
| 🧩 Modular Architecture | Infrastructure separated into reusable Terraform modules |
| 🌐 VPC Networking | Public and private subnet architecture |
| 🖥️ EC2 | Hosts the Flask web application |
| 🗄️ RDS | Private MySQL database |
| 🔐 Security Groups | Controls HTTP, SSH, and database traffic |
| 🔑 Secrets Manager | Automatically generated database password |
| 🔒 Encryption | RDS storage encryption enabled |
| 🏷️ Resource Tagging | Consistent Project, Environment, and ManagedBy tags |
| ⚙️ GitHub Actions | Automated Terraform validation |
| 🧹 Cleanup | Terraform destroy for infrastructure removal |

---

# ☁️ AWS Resources

| AWS Service | Purpose |
|---|---|
| **Amazon VPC** | Provides isolated networking |
| **Public Subnet** | Hosts the EC2 web server |
| **Private Subnets** | Hosts the RDS database |
| **Internet Gateway** | Provides internet connectivity |
| **Route Table** | Routes public subnet traffic |
| **Amazon EC2** | Runs the Flask application |
| **Amazon RDS** | Runs MySQL database |
| **Security Groups** | Controls network access |
| **AWS Secrets Manager** | Stores database credentials |

---

# 📁 Project Structure

```text
terraform-aws-rds-webapp/
│
├── .github/
│   └── workflows/
│       └── terraform.yml
│
├── diagrams/
│
├── docs/
│
├── modules/
│   │
│   ├── compute/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── templates/
│   │       └── user_data.sh
│   │
│   ├── database/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── secrets/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── security/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
│
├── terraform.tfvars.example
├── .gitignore
├── README.md
├── demo_guide.md
└── task.md
```

---

# 🧩 Terraform Module Architecture

The project follows a modular Terraform architecture.

```text
                    Root Module
                        │
        ┌───────────────┼────────────────┐
        │               │                │
        ▼               ▼                ▼
     Network         Security          Secrets
        │               │                │
        │               │                │
        └───────────────┼────────────────┘
                        │
                 ┌──────┴──────┐
                 │             │
                 ▼             ▼
              Compute       Database
                 │             │
                 ▼             ▼
                EC2           RDS
```

---

## 🌐 Network Module

**Location:**

```text
modules/network/
```

Responsible for creating:

- VPC
- Public subnet
- Private subnet 1
- Private subnet 2
- Internet Gateway
- Public route table
- Route table associations

### Network Configuration

```text
VPC
10.0.0.0/16

Public Subnet
10.0.1.0/24

Private Subnet 1
10.0.2.0/24

Private Subnet 2
10.0.3.0/24
```

---

## 🔐 Security Module

**Location:**

```text
modules/security/
```

Creates security groups for the web server and database.

### Web Security Group

Allows:

```text
HTTP : 80
SSH  : 22
```

SSH access is controlled using:

```hcl
ssh_allowed_cidr = "YOUR_PUBLIC_IP/32"
```

### Database Security Group

Allows:

```text
MySQL : 3306
```

only from the EC2 web security group.

This creates the following security relationship:

```text
Internet
    │
    │ HTTP :80
    ▼
   EC2
    │
    │ MySQL :3306
    ▼
   RDS
```

---

## 🗄️ Database Module

**Location:**

```text
modules/database/
```

Responsible for creating:

- RDS MySQL instance
- DB subnet group
- Private database networking
- Encrypted database storage

### Database Configuration

```text
Engine          : MySQL
Version         : 8.0
Instance Class  : db.t3.micro
Storage         : 10 GB
Storage Type    : gp3
Encryption      : Enabled
Public Access   : Disabled
```

---

## 🔑 Secrets Module

**Location:**

```text
modules/secrets/
```

The Secrets module:

1. Generates a random database password.
2. Creates an AWS Secrets Manager secret.
3. Stores the generated credentials.
4. Provides the password to the infrastructure.

The database password is **not hard-coded** in the Terraform configuration.

---

## 🖥️ Compute Module

**Location:**

```text
modules/compute/
```

Responsible for creating the EC2 web server.

The module configures:

- Ubuntu EC2 instance
- Flask application
- Python environment
- MySQL client
- Application configuration
- Systemd service
- EC2 resource tags

---

# 🔐 Security Design

Security is one of the main improvements in this project.

## Private RDS

The RDS database is configured as:

```hcl
publicly_accessible = false
```

This prevents direct public access to the database.

---

## Security Group Isolation

The RDS security group only accepts MySQL traffic from the web server security group.

```text
                 INTERNET
                     │
                     │ HTTP :80
                     ▼
              ┌──────────────┐
              │     EC2      │
              │ Web Server   │
              └──────┬───────┘
                     │
                     │ MySQL :3306
                     ▼
              ┌──────────────┐
              │     RDS      │
              │ MySQL Server │
              └──────────────┘
```

---

## 🔒 RDS Encryption

RDS storage encryption is enabled:

```hcl
storage_encrypted = true
```

---

## 🔑 Secrets Manager

Database credentials are managed through AWS Secrets Manager instead of storing a plain-text password inside the Git repository.

---

## 🔐 SSH Access

For development, avoid allowing SSH from the entire internet.

Instead of:

```hcl
ssh_allowed_cidr = "0.0.0.0/0"
```

use:

```hcl
ssh_allowed_cidr = "YOUR_PUBLIC_IP/32"
```

For example:

```hcl
ssh_allowed_cidr = "49.204.123.45/32"
```

The `/32` means only that specific IP address can access SSH.

> **Important:** Do not use the EC2 public IP as the SSH source CIDR. Use your own current public IP.

---

# 🛠️ Prerequisites

Install the following tools before deploying the project:

- Terraform
- AWS CLI
- Git
- An AWS account
- AWS credentials with permissions to create the required resources

### Check Terraform

```bash
terraform version
```

### Check AWS CLI

```bash
aws --version
```

### Check AWS Authentication

```bash
aws sts get-caller-identity
```

---

# ⚙️ Configuration

First create your local Terraform variables file.

### Windows

```powershell
copy terraform.tfvars.example terraform.tfvars
```

### Linux / macOS

```bash
cp terraform.tfvars.example terraform.tfvars
```

Then edit:

```text
terraform.tfvars
```

Example:

```hcl
project_name = "terraform-rds-webapp"
environment  = "dev"
aws_region   = "us-east-1"

vpc_cidr             = "10.0.0.0/16"
public_subnet_cidr   = "10.0.1.0/24"
private_subnet_cidrs = ["10.0.2.0/24", "10.0.3.0/24"]

ec2_instance_type = "t3.micro"

ssh_allowed_cidr = "YOUR_PUBLIC_IP/32"

db_name              = "webappdb"
db_username          = "admin"
db_instance_class    = "db.t3.micro"
db_allocated_storage = 10
db_engine_version    = "8.0"
```

---

# ⚠️ Important Security Note

Never commit:

```text
terraform.tfvars
```

The project `.gitignore` excludes Terraform variable files.

Only the example file should be committed:

```text
terraform.tfvars.example
```

The actual database password is automatically generated and stored in AWS Secrets Manager.

---

# 🚀 Deployment

## Step 1 — Initialize Terraform

```bash
terraform init
```

---

## Step 2 — Format Terraform Files

```bash
terraform fmt -recursive
```

---

## Step 3 — Validate Configuration

```bash
terraform validate
```

Expected result:

```text
Success! The configuration is valid.
```

---

## Step 4 — Review the Plan

```bash
terraform plan
```

Review the resources before deployment.

---

## Step 5 — Deploy Infrastructure

```bash
terraform apply
```

Terraform will create the AWS infrastructure.

```text
Terraform
   │
   ▼
VPC
├── Public Subnet
│   └── EC2
│
├── Private Subnet
│   └── RDS
│
├── Security Groups
│
├── Internet Gateway
│
└── Secrets Manager
```

---

# 🌐 Access the Application

After deployment, Terraform provides outputs containing information about the application.

### Get Application URL

```bash
terraform output application_url
```

### Get EC2 Public IP

```bash
terraform output web_server_public_ip
```

### Get EC2 Public DNS

```bash
terraform output web_server_public_dns
```

Open the application URL in your browser.

---

# 🔗 Application Endpoints

The Flask application provides the following endpoints.

| Endpoint | Purpose |
|---|---|
| `/` | Application home page |
| `/health` | Health and connectivity check |
| `/db-info` | Displays database information |

### Home

```text
/
```

Displays the application home page.

### Health Check

```text
/health
```

Used to verify application availability and database connectivity.

### Database Information

```text
/db-info
```

Displays information about the connected MySQL database.

Example:

```text
MySQL Version: 8.0.x
Database: webappdb
```

---

# ⚙️ GitHub Actions CI

The project includes a GitHub Actions workflow:

```text
.github/workflows/terraform.yml
```

The workflow automatically validates Terraform configuration whenever changes are pushed or pull requests are created.

### CI Pipeline

```text
Developer
    │
    │ git push
    ▼
GitHub Repository
    │
    ▼
GitHub Actions
    │
    ├── Checkout Repository
    │
    ├── Setup Terraform
    │
    ├── terraform fmt -check
    │
    ├── terraform init
    │
    └── terraform validate
```

The workflow is intentionally designed as a **validation-only CI pipeline**.

It does not automatically create or destroy AWS infrastructure.

---

# 📤 Terraform Outputs

| Output | Description |
|---|---|
| `vpc_id` | ID of the created VPC |
| `web_server_public_ip` | Public IP address of EC2 |
| `web_server_public_dns` | Public DNS of EC2 |
| `application_url` | Application URL |
| `rds_endpoint` | RDS database endpoint |
| `rds_port` | RDS database port |
| `database_name` | Application database name |

---

# 🔄 Terraform Workflow

```text
                Write Terraform Code
                        │
                        ▼
                 terraform fmt
                        │
                        ▼
                terraform init
                        │
                        ▼
              terraform validate
                        │
                        ▼
                 terraform plan
                        │
                        ▼
                terraform apply
                        │
                        ▼
                 AWS Resources
                        │
                        ▼
                Test Application
                        │
                        ▼
               terraform destroy
```

---

# 🧪 Troubleshooting

## Application is Not Responding

The EC2 user-data script may still be installing packages and starting the Flask application.

Wait a few minutes and try again.

---

## Database Connection Failed

Check the following:

1. RDS status is `available`.
2. EC2 security group is correct.
3. RDS security group allows port `3306`.
4. RDS allows traffic from the EC2 security group.
5. RDS endpoint is correctly passed to the application.
6. Flask application is running.

---

## Check Flask Service

SSH into the EC2 instance and run:

```bash
sudo systemctl status flask-app
```

---

## View Flask Logs

```bash
sudo journalctl -u flask-app -f
```

---

## Check RDS

From AWS Console:

```text
AWS Console
   │
   ▼
RDS
   │
   ▼
Databases
   │
   ▼
Your RDS Instance
```

Make sure the database status is:

```text
Available
```

---

# 💰 Cost Management

AWS resources can generate charges.

The main resources that may incur costs include:

- EC2
- RDS
- Networking resources
- AWS Secrets Manager

This project uses relatively small instance types for learning and portfolio purposes.

However, **always destroy resources when you are finished testing**.

---

# 🧹 Destroy Infrastructure

When the project is no longer required:

```bash
terraform destroy
```

Confirm the operation when Terraform asks for confirmation.

Expected result:

```text
Destroy complete!
```

After destruction, verify the AWS Console to ensure that unwanted resources have not been left behind.

---

# 📚 Technologies Used

## Infrastructure

```text
Terraform
AWS
VPC
EC2
RDS
Security Groups
Secrets Manager
Internet Gateway
Route Tables
```

## Application

```text
Python
Flask
MySQL
Ubuntu Linux
Systemd
```

## DevOps

```text
Git
GitHub
GitHub Actions
Infrastructure as Code
CI
```

---

# 🎯 Skills Demonstrated

### ☁️ AWS

- VPC
- Subnets
- Internet Gateway
- Route Tables
- EC2
- RDS
- Security Groups
- AWS Secrets Manager

### 🏗️ Terraform

- Infrastructure as Code
- Terraform Modules
- Variables
- Outputs
- Locals
- Resource Dependencies
- Provider Configuration
- Validation
- State Management
- Resource Tagging

### ⚙️ DevOps

- Git
- GitHub
- GitHub Actions
- CI pipelines
- Automated validation
- Infrastructure automation

### 🐧 Linux

- Ubuntu
- SSH
- Systemd
- Linux services
- Shell commands
- Application deployment

### 🐍 Application Deployment

- Python
- Flask
- MySQL
- EC2 bootstrap
- Database connectivity

---

# 🚀 Future Improvements

The project can be extended with additional production-oriented components.

### Infrastructure

- Application Load Balancer
- Auto Scaling Group
- Multi-AZ architecture
- RDS Multi-AZ
- NAT Gateway
- Route 53
- AWS Certificate Manager
- HTTPS

### DevOps

- Remote Terraform state
- S3 backend
- State locking
- Terraform plan in pull requests
- Automated deployment
- Environment-specific infrastructure
- Dev / Staging / Production pipelines

### Monitoring

- Amazon CloudWatch
- CloudWatch Alarms
- Prometheus
- Grafana

### Containers

- Docker
- Amazon ECR
- ECS
- Kubernetes
- Amazon EKS

---

# 📈 Project Evolution

This project represents the progression from a basic Terraform AWS deployment into a more structured Infrastructure as Code project.

```text
AWS Fundamentals
       │
       ▼
Terraform Basics
       │
       ▼
Terraform Modules
       │
       ▼
VPC + EC2
       │
       ▼
RDS + Private Subnets
       │
       ▼
Security Groups
       │
       ▼
Secrets Manager
       │
       ▼
Resource Tagging
       │
       ▼
GitHub Actions
       │
       ▼
Modular AWS Infrastructure
```

---

# 💡 Why I Built This Project

The purpose of this project is to demonstrate how cloud infrastructure can be created, configured, and managed through **Infrastructure as Code** instead of manually creating resources through the AWS Console.

The project focuses on:

- Reusable Terraform modules
- Secure networking
- Private database architecture
- Secret management
- Automated validation
- Infrastructure automation
- Real-world AWS deployment concepts

The architecture can also be extended into a more production-ready cloud platform.

---

# 🏆 What This Project Demonstrates

```text
┌───────────────────────────────────────────────┐
│             DEVOPS SKILLS DEMONSTRATED        │
├───────────────────────────────────────────────┤
│                                               │
│  AWS Cloud                                    │
│       │                                       │
│       ├── VPC                                 │
│       ├── EC2                                 │
│       ├── RDS                                 │
│       └── Secrets Manager                     │
│                                               │
│  Infrastructure as Code                       │
│       │                                       │
│       └── Terraform                           │
│                                               │
│  Automation                                   │
│       │                                       │
│       └── GitHub Actions                      │
│                                               │
│  Linux                                        │
│       │                                       │
│       └── Ubuntu + Systemd                    │
│                                               │
│  Application                                  │
│       │                                       │
│       └── Flask + MySQL                       │
│                                               │
└───────────────────────────────────────────────┘
```

---

# 📝 Attribution

This project was initially based on a Terraform AWS learning project from **Piyush Sachdeva's Terraform course**.

The project has been reorganized and extended as a personal DevOps and Cloud portfolio project.

Major improvements include:

- Modular Terraform architecture
- Network separation
- Private RDS architecture
- Security Group improvements
- AWS Secrets Manager integration
- RDS encryption
- Environment validation
- Common resource tagging
- GitHub Actions CI
- Improved documentation
- Cleaner project structure

---

# 👨‍💻 Author

## Yashwanth B N

**DevOps & Cloud Engineer | AWS | Terraform | Docker | Kubernetes**

Passionate about cloud infrastructure, automation, Infrastructure as Code, and building practical DevOps projects.

---

# ⭐ Project Philosophy

```text
BUILD
   ↓
AUTOMATE
   ↓
DEPLOY
   ↓
TEST
   ↓
MONITOR
   ↓
IMPROVE
```

> **Infrastructure as Code is not just about creating servers.  
> It is about creating infrastructure that can be understood, reproduced, automated, and improved.**

---

## ⭐ If you found this project useful

Feel free to explore the repository, experiment with the infrastructure, and improve the architecture with additional AWS and DevOps services.

**Build → Automate → Deploy → Improve 🚀**