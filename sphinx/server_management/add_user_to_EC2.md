# Server Access Management Policy

This is the server access management policy that we use for **internal staff** of the SCC, not for external users who are granted limited access to our instances.

These instructions use `grant` as the example, but you will need to replace values where needed.

### Step 1: Connect to Your EC2 Instance

1. Open your terminal or command prompt.
2. Use SSH to connect to your EC2 instance. Replace `your-key.pem` with your private key.

   ```bash
   ssh -i your-key.pem ubuntu@sp7demofish.specifycloud.org
   ```

   Alternatively, connect via [EC2 Instance Connect](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-connect-methods.html) if you do not yet have access to the instance.

### Step 2: Create a New User

1. Once connected, create a new user with the appropriate name (e.g. `grant`).

   ```bash
   sudo adduser --disabled-password grant
   ```

   Follow the prompts to add additional information for the user.

### Step 3: Add the User's Public Key

1. Create a `.ssh` directory for the new user:

   ```bash
   sudo mkdir /home/grant/.ssh
   ```

2. Set the correct permissions for the directory:

   ```bash
   sudo chmod 700 /home/grant/.ssh
   ```

3. Create an `authorized_keys` file and add the user's public key. Replace `user-public-key` with the actual public key.

   ```bash
   echo "user-public-key" | sudo tee /home/grant/.ssh/authorized_keys
   ```

   It should look something like: 
   
   `echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAWwt7DrPjDtiF4S1G8CRiYrCus5hg6O8bXyK..."`

4. Set the correct permissions for the `authorized_keys` file:

   ```bash
   sudo chmod 600 /home/grant/.ssh/authorized_keys
   ```

5. Change ownership of the `.ssh` directory and its contents to the new user:

   ```bash
   sudo chown -R grant:grant /home/grant/.ssh
   ```

### Step 4: Add User to the `ubuntu` Group

1. Add the new user `grant` to the `ubuntu` group to ensure they have the same permissions as the `ubuntu` user:

   ```bash
   sudo usermod -aG ubuntu grant
   ```

### Step 6: Verify Permissions

1. To verify that the permissions are set correctly, you can check the directory permissions:

   ```bash
   ls -ld /home/ubuntu
   ```

   You should see permissions like `drwxrwx---`, indicating that the owner and group have full permissions.

### Step 7: Test the New User Access

1. Log out of the current session:

   ```bash
   exit
   ```

2. Have the new user (e.g. `grant`) connect to the EC2 instance using their SSH key:

   ```bash
   ssh -i user-key.pem grant@sp7demofish.specifycloud.org
   ```

3. Once logged in, the new user should be able to access the `/home/ubuntu` directory and its contents.