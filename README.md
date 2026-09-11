# AWS Windows Web Server AMI

This repository contains the infrastructure-as-code to build a custom AWS Windows Web Server AMI using **Packer**, **Ansible**, and **InSpec**.

---

## Tools Used

- **Ansible** — installs and configures required packages on the AMI
- **Packer** — orchestrates provisioners (Ansible playbooks) to build the AMI
- **InSpec** — runs automated compliance tests against the final AMI

---

## Repository Structure

```
├── boot_config/
│   └── winrm_bootstrap.ps1      # WinRM bootstrap script required for Packer to communicate with Windows
├── webserver/
│   ├── windows-webserver.json   # Packer template
│   └── inspec.rb                # InSpec compliance tests
├── playbooks/                   # Ansible playbooks for each package
│   ├── cleanup_defaultiis.yml
│   ├── install_aspnetmvc.yml
│   ├── install_aspnetmvc4.yml
│   ├── install_urlrewrite.yml
│   ├── install_webdeploy.yml
│   └── install_webserver.yml
└── windows-webserver-pipeline.yml  # Azure DevOps pipeline
```

---

## Pipeline

The pipeline is defined in `windows-webserver-pipeline.yml` and runs on Azure DevOps.

- Commits to any branch **other than `main`** run the pipeline against a **test AWS account**
- Commits to **`main`** run the pipeline against the **production AWS account** and share the resulting AMI with target accounts
- To contribute, open a pull request to `main` — the AMI version number in `webserver/windows-webserver.json` (`ami_name`) should be incremented with each change

> **Note:** Always use a Windows Golden AMI as the source AMI for these builds.

---

## Prerequisites

### Install Ansible

```bash
sudo yum install python2-pip-9.0.3-1.amzn2.0.2.noarch
pip install ansible==2.9.14
```

### Install Packer

```bash
sudo wget https://releases.hashicorp.com/packer/1.6.4/packer_1.6.4_linux_amd64.zip
sudo unzip packer_1.6.4_linux_amd64.zip -d /usr/local/bin/
```

### Install InSpec

```bash
sudo wget https://omnitruck.chef.io/install.sh
bash install.sh -s -- -P inspec
```

---

## Local Testing

### Required Environment Variables

Set the following environment variables before running Packer locally:

| Variable | Description |
|----------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS access key |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key |
| `AWS_SUBNET_ID` | Subnet ID to launch the builder instance in |
| `AWS_VPC_ID` | VPC ID to launch the builder instance in |
| `AWS_WINRM_USERNAME` | WinRM username for Packer to connect (e.g. `Administrator`) |
| `AWS_INSTANCE_TYPE` | EC2 instance type (e.g. `t3.medium`) |
| `AWS_SOURCE_AMI_WIN_GOLDEN` | Source Windows Golden AMI ID to build from |
| `AWS_REGION` | AWS region (e.g. `us-east-1`) |
| `Team1_AccountID` | AWS account ID for the first AMI share target |
| `Team2_AccountID` | AWS account ID for the second AMI share target |

### Run Packer

```bash
cd webserver/
packer validate windows-webserver.json
packer build windows-webserver.json
```
