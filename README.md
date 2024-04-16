## pieceformation

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