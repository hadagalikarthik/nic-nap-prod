Deploy NGINX Ingress Controller with App ProtectV5 in GCP Cloud
==================================================================================================

## Table of Contents
  - [Introduction](#introduction)
  - [Architecture Diagram](#architecture-diagram)
  - [Prerequisites](#prerequisites)
  - [Assets](#assets)
  - [Tools](#tools)
  - [GitHub Configurations](#github-configurations)
    - [How to Add Secrets](#how-to-add-secrets)
    - [How to Add Variables](#how-to-add-variables)
    - [Required Secrets and Variables](#required-secrets-and-variables)
  - [Workflow Runs](#workflow-runs)
    - [STEP 1: Workflow Branches](#step-1-workflow-branches)
    - [STEP 2: Policy ](#step-2-Policy)
    - [STEP 3: Deploy Workflow](#step-3-deploy-workflow)
    - [STEP 4: Monitor the Workflow](#step-4-Monitor-the-workflow)
    - [STEP 5: Validation](#step-5-validation)
    - [STEP 6: Destroy Workflow](#step-6-Destroy-workflow)
  - [Conclusion](#conclusion)
  - [Support](#support)
  - [Copyright](#copyright)
    - [F5 Networks Contributor License Agreement](#f5-networks-contributor-license-agreement)

## Introduction
This demo guide provides a comprehensive, step-by-step walkthrough for configuring the NGINX Ingress Controller alongside NGINX App Protect v5 on the GCP Cloud platform. It utilizes Terraform scripts to automate the deployment process, making it more efficient and streamlined. For further details, please consult the official [documentation](https://docs.nginx.com/nginx-ingress-controller/installation/integrations/). Also, you can find more insights in the DevCentral article [F5 NGINX Automation Examples [Part 1-Deploy F5 NGINX Ingress Controller with App ProtectV5]](https://community.f5.com/kb/technicalarticles/f5-nginx-automation-examples-part-1-deploy-f5-nginx-ingress-controller-with-app-/340500).

## Architecture Diagram
![System Architecture](assets/google.png)

## Prerequisites
* [NGINX Plus with App Protect and NGINX Ingress Controller license](https://www.nginx.com/free-trial-request/)
* [GCP Account](https://console.cloud.google.com) - Due to the assets being created, the free tier will not work.
* [GitHub Account](https://github.com)

## Assets
* **nap:**       NGINX Ingress Controller for Kubernetes with NGINX App Protect (WAF and API Protection)
* **infra:**     GCP Infrastructure (VPC, Firewall, etc.)
* **gke:**       GCP Kubernetes Engine
* **arcadia:**   Arcadia Finance test web application and API
* **policy:**    NGINX WAF Compiler Docker and Policy
* **gcs:**       GCP storage bucket.

## Tools
* **Cloud Provider:** GCP
* **IAC:** Terraform
* **IAC State:** GCP Cloud Storage
* **CI/CD:** GitHub Actions

## GitHub Configurations

First of all, fork and clone the repo. Next, create the following GitHub Actions secrets and variable in your forked repo.

### How to Add Secrets

1. Navigate to your GitHub repository
2. Go to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Enter the secret name exactly as shown above
5. Paste the secret value
6. Click **Add secret**

### How to Add Variables

1. Navigate to your GitHub repository
2. Go to **Settings** → **Secrets and variables** → **Actions**
3. Click **Variables** tab
4. Click **New repository variable**
5. Enter the variable name exactly as shown above
6. Paste the variable value
7. Click **Add variable**

This workflow requires the following secrets and variable to be configured in your GitHub repository:

### Required Secrets and Variables

| Secret Name                 | Type     | Description                                                                                             |
|-----------------------------|----------|---------------------------------------------------------------------------------------------------------|
| `TF_VAR_GOOGLE_CREDENTIALS` | Secret   | GCP Service Account Credentials in JSON format (in a single line)                                       |      
| `TF_VAR_GCP_PROJECT_ID`     | Secret   | GCP Project ID available in GCP landing page                                                            | 
| `NGINX_JWT`                 | Secret   | JSON Web Token for NGINX license authentication                                                         |    
| `NGINX_REPO_CRT`            | Secret   | NGINX Certificate                                                                                       | 
| `NGINX_REPO_KEY`            | Secret   | Private key for securing HTTPS and verifying SSL/TLS certificates                                       |
| `TF_VAR_PROJECT_PREFIX`     | Variable | Your project identifier name in lowercase letters only - this will be applied as a prefix to all assets | 
| `TF_VAR_GCP_BUCKET_NAME`    | Variable | Unique GCP bucket name                                                                                  | 
| `TF_VAR_GCP_REGION`         | Variable | GCP region name in which you would like to deploy your resources                                        | 

### Github Secrets
 ![secrets](assets/secrets.png)

### Github Variables
![variables](assets/variables.png)

## Workflow Runs

### STEP 1: Workflow Branches

Check out a branch with the branch name as suggested below for the workflow you wish to run using the following naming convention.

**DEPLOY**

  | Workflow            | Branch Name         |
  |---------------------|---------------------|
  | gcp-apply-nic-napv5 | gcp-apply-nic-napv5 |

**DESTROY**

  | Workflow              | Branch Name           |
  |-----------------------|-----------------------|
  | gcp-destroy-nic-napv5 | gcp-destroy-nic-napv5 |
### STEP 2: Policy 

The repository includes a default policy file named `policy.json`, which can be found in the `GCP/policy` directory.

```hcl
{
    "policy": {
        "name": "policy_name",
        "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking"
    }
}
```
 
Users have the option to utilize the existing policy or, if preferred, create a custom policy. To do this, place the custom policy in the designated policy folder and name it `policy.json` or any name you choose. If you decide to use a different name, update the corresponding name in the [`gcp-apply-nic-napv5.yml`](https://github.com/f5devcentral/nginx_automation_examples/blob/main/.github/workflows/gcp-apply-nic-napv5.yml) and  [`gcp-destroy-nic-napv5.yml`](https://github.com/f5devcentral/nginx_automation_examples/blob/main/.github/workflows/gcp-destroy-nic-napv5.yml) workflow files accordingly.

  In the workflow files, locate the terraform_policy job and rename `policy.json` to your preferred name if you've decided to change it.
  
   ![policy](assets/policy.png)


### STEP 3: Deploy Workflow
 
Commit the changes, checkout a branch with name **`gcp-deploy-nic-napv5`** and push your deploy branch to the forked repo
```sh
git commit -a -m "GCP Deploy"
git checkout -b gcp-apply-nic-napv5
git push origin gcp-apply-nic-napv5
```

### STEP 4: Monitor the workflow

Back in GitHub, navigate to the Actions tab of your forked repo and monitor your build. Once the pipeline completes, verify your assets were deployed in GCP

  ![deploy](assets/deploy.png)


### STEP 5: Validation  

Users can now access the application through the NGINX Ingress Controller Load Balancer, which enhances security for the backend application by implementing the configured Web Application Firewall (WAF) policies. This setup not only improves accessibility but also ensures that the application is protected from various web threats.

  ![IP](assets/ext_ip.png)

* Access the application:

  ![arcadia](assets/arcadia.png)

* Verify that the cross-site scripting is detected and blocked by NGINX App Protect.  

  ![block](assets/mitigation.png)
  

### STEP 6: Destroy Workflow  

If you want to destroy the entire setup, checkout a branch with name **`gcp-destroy-nic-napv5`** and push your destroy branch to the forked repo.
```sh
git commit -a -m "GCP Destroy"
git checkout -b gcp-destroy-nic-napv5
git push origin gcp-destroy-nic-napv5
```

Back in GitHub, navigate to the Actions tab of your forked repo and monitor your workflow
  
Once the pipeline is completed, verify that your assets were destroyed  

  ![destroy](assets/destroy.png)

## Support
For support, please open a GitHub issue. Note that the code in this repository is community-supported and is not supported by F5 Networks.

## Copyright
Copyright 2014-2020 F5 Networks Inc.

### F5 Networks Contributor License Agreement
Before you start contributing to any project sponsored by F5 Networks, Inc. (F5) on GitHub, you will need to sign a Contributor License Agreement (CLA).


