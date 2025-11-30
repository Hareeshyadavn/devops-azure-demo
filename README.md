# devops-azure-demo
devops-azure-demo learning purpose
```markdown
# Azure DevOps demo: devops-azure-demo

This repository demonstrates an end-to-end DevOps workflow on Azure (App Service target):

- A small Node.js app
- Dockerized and pushed to Azure Container Registry (ACR)
- Deployed to Azure App Service for Containers
- CI/CD using GitHub Actions
- Terraform skeleton to provision required Azure resources

Quick start
1. Install tools: Git, Docker, Azure CLI (az), Terraform, Node.js
2. Login to Azure:
   - az login
   - az account set --subscription "<SUBSCRIPTION_ID>"
3. Create a resource group:
   - az group create -n demo-rg -l eastus
4. Create ACR (replace <ACR_NAME> - must be globally unique):
   - az acr create -n <ACR_NAME> -g demo-rg --sku Basic
5. Create a Service Principal for GitHub Actions and store it as a GitHub secret AZURE_CREDENTIALS:
   - az ad sp create-for-rbac --name "gh-actions-demo-sp" --role contributor --scopes /subscriptions/<SUB_ID>/resourceGroups/demo-rg
   - Copy the JSON output to the GitHub repo secret AZURE_CREDENTIALS
6. Create required GitHub secrets:
   - AZURE_CREDENTIALS (JSON output from step 5)
   - ACR_NAME (the ACR name only, e.g. mydemoacr123)
   - WEBAPP_NAME (the App Service name to use for deployment)
7. Push to main (or open PR). The workflow will build, push image to ACR, and configure App Service to use the image.

Files included in this PR:
- Dockerfile
- src/index.js, package.json
- .github/workflows/ci-cd.yml
- terraform/main.tf (skeleton)
- README.md

Notes
- The Terraform file is a starting point; customize names and resource sizing before applying.
- For secure production, use least-privilege RBAC and Managed Identities as appropriate.
```