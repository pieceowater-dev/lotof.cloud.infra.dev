## pieceformation


### AWS Configuration

Before using Terraform to manage your infrastructure, make sure you have configured your AWS credentials. If you haven't done so already, you can set up your AWS CLI by running:

```bash
aws configure
```

Follow the prompts to enter your Access Key ID, Secret Access Key, default region, and output format.

### Terraform Initialization

Once your AWS credentials are configured, navigate to your Terraform project directory and initialize Terraform by running:

```bash
terraform init
```

This command initializes your working directory and downloads any necessary plugins.

### Terraform Apply

After initialization, apply your Terraform configuration to create the resources defined in your Terraform files:

```bash
terraform apply -auto-approve
```

Terraform will generate an execution plan and prompt you to confirm before making any changes. Use the `-auto-approve` flag to automatically approve the plan and apply changes without user input.


### SSH to Development Server

To SSH into your development server, follow these steps:

1. **Change Permissions of Private Key**: First, ensure that the permissions of your private key file are set correctly. Run the following command in your terminal:

   ```bash
   chmod 400 ~/.ssh/pieceowater-dev-serv.pem
   ```

2. **SSH Command**: Once the permissions are set, use the following command to SSH into your development server:

   ```bash
   ssh -i "~/.ssh/pieceowater-dev-serv.pem" ec2-user@ec2-16-171-242-247.eu-north-1.compute.amazonaws.com
   ```

   Replace `~/.ssh/pieceowater-dev-serv.pem` with the path to your private key file and `ec2-16-171-242-247.eu-north-1.compute.amazonaws.com` with the Public IPv4 DNS of your development server.

   After running this command, you should be able to access your development server via SSH.