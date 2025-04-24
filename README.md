# Threat-model-and-security-assessment
Open Source App Hosted on ECS with Terraform 🚀

This project is based on Amazon's Threat Composer Tool, an open source tool designed to facilitate threat modeling and improve security assessments. You can explore the tool's dashboard here: [Threat Composer Tool](https://awslabs.github.io/threat-composer/workspaces/default/dashboard)

It features:
- 🏗️ Fully modular **Terraform infrastructure**
- 🚢 CI/CD pipeline via **GitHub Actions**
- ☁️ Deployment on **ECS Fargate**
- 📦 Container image management with **Amazon ECR**
- 🌐 HTTPS & DNS setup via **ALB, ACM & Route 53**
- 🔐 OIDC-authenticated GitHub Actions pipeline

---
## Task/Assignment 📝

- Create your own repository and complete the task there. You may create a `app` in your repo and copy all the files in this directory into it. Or alternatively, you can use this directory as is. Your choice.

- Your task will be to create a container image for the app, push it to ECR (recommended) or DockerHub. Ideally, you should use a CI/CD pipeline to build, test, and push the container image.

- Deploy the app on ECS using Terraform. All the resources should be provisioned using Terraform. Use TF modules.

- Make sure the app is live on `https://tm.<your-domain>` or `https://tm.labs.<your-domain>`

- App must use HTTPS. Hosted on ECS. Figure out the rest. Once app is live, add screenshots to the README.md file.

- Add architecture diagram of how the infrastructure is setup. (Use Lucidchart or draw.io or mermaid) You are free to use any diagramming tool.

## Local app setup 💻

```bash
yarn install
yarn build
yarn global add serve
serve -s build

#yarn start
http://localhost:3000/workspaces/default/dashboard

## or
yarn global add serve
serve -s build
```
## 🧱 Infrastructure Overview

| Component            | Description |
|----------------------|-------------|
| **VPC**              | Custom VPC with public/private subnets, NAT gateway (optional) |
| **ALB**              | Application Load Balancer to route HTTPS traffic to ECS |
| **ECS**              | AWS Fargate cluster running containerized Threat Composer |
| **ECR**              | Docker image storage |
| **ACM**              | SSL certificate for `https://tm.<your-domain>` |
| **Route 53**         | DNS setup to map domain to ALB |
| **GitHub Actions**   | CI/CD pipeline to build, push, and deploy app |

---

## 🌐 Deployment URL

After a successful deployment, the app will be available at:
https://tm.hasnatur-devops.com`)

---

## 📦 Project Structure

```bash
terraform-infra/
├── main.tf                # Root module calling all other modules
├── variables.tf           # Variables used across the infrastructure
├── terraform.tfvars       # Actual values for your environment
├── providers.tf           # AWS provider config
├── modules/
│   ├── vpc/               # VPC, subnets, IGW, route tables
│   ├── alb/               # Load balancer + listeners + target group
│   ├── ecs/               # ECS cluster, task definition, service
│   ├── acm/               # SSL certificate (ACM)
│   └── route53/           # DNS alias record
├── ecs-task-def.json      # ECS task definition used in CI/CD
└── .github/workflows/
    └── deploy.yml         # CI/CD pipeline for build & deploy
```
## 🚀 CI/CD Pipeline
✅ What It Does:
On each push to main:

Builds the Docker image

Authenticates to AWS via OIDC

Pushes the image to ECR

Deploys the image to ECS using task definition

Waits for ECS service to stabilize

## 📋 Prerequisites
✅ AWS account with:

Route 53 domain (e.g. hasnatur-devops.com)

IAM Role for GitHub OIDC

✅ Terraform CLI installed

✅ GitHub secrets:

AWS_OIDC_ROLE_ARN → IAM role with OIDC trust + permissions

## 📄 Deploying the Infra
Clone the repo

Update terraform.tfvars with your values

Run:

```bash
Copy
Edit
terraform init
terraform apply
```

## 🧪 Test Deployment
Visit your domain:
https://tm.hasnatur-devops.com

Or use:

```bash
Copy
Edit
curl -v https://tm.hasnatur-devops.com
Check for HTTP 200 and content from the app.
```
## 🧼 Clean Up
```bash
Copy
Edit
terraform destroy
This will tear down the entire infrastructure.
```

## Useful links 🔗

- [Terraform AWS Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform AWS ECS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster)
- [Terraform Docs](https://www.terraform.io/docs/index.html)
- [ECS Docs](https://docs.aws.amazon.com/ecs/latest/userguide/what-is-ecs.html)

## Advice & Tips �

- This is just a simple app, you may use another app if you'd like. 
- Use best practices for your Terraform code. Use best practices for your container image. Use best practices for your CI/CD pipeline.

