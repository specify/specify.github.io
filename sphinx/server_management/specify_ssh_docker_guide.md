# Specify Test Panel User Guide

This guide summarizes how to work with the [Specify 7 Test Panel](https://github.com/specify/specify7-test-panel) as an SSH user.


## 🔑 Create and Use SSH Keys for the Specify Test Panel


### 1. **Create a Directory for Your Keys**

Open your terminal and run:

```bash
mkdir -p ~/Documents/specify_keys
cd ~/Documents/specify_keys
```

### 2. **Generate a New SSH Key**

Run the following command to create a secure SSH key:

```bash
ssh-keygen -t rsa -b 2048
```

- When prompted:  
  **Enter file in which to save the key:**  
  Type: `specify_key` and press **Enter**

- When prompted:  
  **Enter passphrase:**  
  Press **Enter** (leave empty unless you want to secure it with a passphrase)

- When prompted again:  
  **Enter same passphrase again:**  
  Press **Enter**

### 3. **Verify Key Creation**

Run:

```bash
ls
```

You should see:

```
specify_key
specify_key.pub
```

### 4. **Copy Your Public Key**

Run:

```bash
cat specify_key.pub
```

- Copy the full output.
- Send this to the person managing the Specify test panel server so they can add your key.

---

## 🖥️ Connect to the Test Panel Server

Once your key has been added, connect by running:

```bash
ssh -i ~/Documents/specify_keys/specify_key ubuntu@test.specifysystems.org
```

> Replace the path if your folder or key is named differently.

When prompted:

```
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

Type `yes` and press **Enter**.

You are now connected to the **Specify Test Panel**.

---

## 🐳 Docker: View and Access Running Containers

### 1. **See All Running Docker Instances**

Run:

```bash
docker stats --no-stream
```

### 2. **Filter by Instance Name**

To search for a specific instance, run:

```bash
docker stats --no-stream | grep <instance-name>
```

_Example:_

```bash
docker stats --no-stream | grep ojsmnh2025-production
```

### 3. **Access the Container**

Copy the **second column** from the output (example: `specify7-test-panel-osjmnh2025-production-2-1`), then run:

```bash
docker exec -it <container-name> bash
```

_Example:_

```bash
docker exec -it specify7-test-panel-osjmnh2025-production-2-1 bash
```

Now you're inside the running Docker container.

---

## 🛠️ Django Migrations

### 1. **View List Of All Migrations**

Run:

```bash
ve/bin/python manage.py showmigrations
```

- Migrations that have already run will be marked with `[X]`.

### 2. **Run a Migration**

Run:

```bash
ve/bin/python manage.py migrate <app-name> <migration-name or number>
```

_Example:_

```bash
ve/bin/python manage.py migrate specify 0029
```
