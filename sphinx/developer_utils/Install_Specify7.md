# Installing Specify 7 Locally

## 1) Install required software

- VS Code IDE  
- DBeaver CE  
- Docker + Docker Compose (plugin)  
- Git  
- (Optional) MySQL via CLI

> **Optional MySQL via CLI:** only if you want a local server outside Docker.  
> macOS (Homebrew): `brew install mysql`  
> Ubuntu/Debian: `sudo apt-get update && sudo apt-get install -y mysql-server`

---

## 2) Clone the Specify 7 repo

```bash
git clone https://github.com/specify/specify7.git
```
> `git clone` checks out the **main** branch by default.

---

## 3) Check out the requested tag

Open a terminal in VS Code (or any shell) and run:

```bash
cd specify7
git checkout tags/v7.11.1
```

---

## 4) Python virtual environment + dependencies

Set up a Python venv and install dependencies:

```bash
# Create a venv
python3 -m venv specify7/ve

# Activate it (macOS/Linux)
source specify7/ve/bin/activate
# On Windows (PowerShell) use:
# .\specify7\ve\Scripts\Activate.ps1

# Install deps
pip3 install wheel
pip3 install --upgrade -r requirements.txt
```
> The app runs in Docker. This venv is just for helper scripts.

---

## 5) Get a seed database

Download a database from the Specify test panel.

Then:

1. Open the downloaded `.sql` in an editor.  
2. **Remove** the line:
   ```sql
   USE database 'db_name';
   ```
3. Save the file.  
4. Move it into the repo under:
   ```
   seed_database/
   ```
> Removing `USE ...;` avoids importing into the wrong DB name.

---

## 6) Configure DBeaver (MySQL/MariaDB)

In **DBeaver**: **Database → New Connection → MySQL** (or **MariaDB**).

Fill exactly:

- **Server Host:** `localhost`  
- **Port:** `3306`  
- **Database:** `DATABASE_NAME` 
- **Show all databases:** ✅ checked  
- **Username:** `root`  
- **Password:** your root password (must match `MYSQL_ROOT_PASSWORD` below)

Click **Test Connection** (optional) → **Finish**.

> Screenshot included in this repo-friendly path:
>
> <img width="558" height="326" alt="Main Advanced Driver properties" src="https://github.com/user-attachments/assets/66bf0913-5dd2-46d3-b27c-eb7ac74f6f35" />


## 7) Edit the project `.env`

Open the project’s `.env` and set:

```dotenv
MYSQL_ROOT_PASSWORD=root_pw_here
DATABASE_NAME=db_name_downloaded_locally
MASTER_NAME=master_name_here
MASTER_PASSWORD=master_pw_here
```

- `DATABASE_NAME` must match the seed DB you intend to use (e.g., `ciscollections_2025_02_10_4__2025_08_22`).  
- Save the file.

---

## 8) Run Specify 7

From the repo root:

```bash
docker compose up --build
```

Open the app:

- http://localhost/specify

Login:

- **Username:** i.e `spadmin`
- **Password:** `testuser`

Select any collection from the drop-down.

---

## 9) Troubleshooting

### Access denied / DB not found after `docker compose up --build`

Do this:

1. In Docker Desktop, delete all containers and images related to this project.  
2. Prune old images/volumes:
   ```bash
   # CAUTION: removes unused images/volumes. You will lose local DB volumes.
   docker image prune -a
   docker volume prune -a
   ```
3. Rebuild:
   ```bash
   docker compose up --build
   ```
4. If needed, verify inside the DB container:
   ```bash
   # In Docker Desktop: open the 'mariadb' container → Exec → bash
   bash
   mysql -uroot -proot     # replace 'root' with your actual MYSQL_ROOT_PASSWORD
   SHOW DATABASES;
   USE db_name;            # use the same name you set in DATABASE_NAME
   ```
5. Back in VS Code terminal, you can re-run:
   ```bash
   docker compose up --build
   ```

### DBeaver shows “Unknown database”

- Ensure the **Database** field equals your `.env` `DATABASE_NAME`.  
- Confirm the `.sql` file didn’t have a `USE ...;` line.  
- Make sure the `.sql` was placed in `seed_database/` before the first run.

---

## 10) Notes

- App URL: http://localhost/specify  
- Repo: https://github.com/specify/specify7  
- Common test login: `spadmin` / `test user`  
- If you installed a local MySQL server instead of Docker, mirror the same credentials and DB name in DBeaver and `.env`.
