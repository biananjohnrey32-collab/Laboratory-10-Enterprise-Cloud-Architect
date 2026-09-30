# CCM101 – Cloud Computing

# Enterprise Cloud Architect – Operational Manual

**Project:** Secure Multi-Tier Web Application
**Application Stack:** WordPress + MySQL
**Virtualization Platform:** VirtualBox
**Server:** Ubuntu Server
**Prepared for:** CCM101 Cloud Computing
**Date:** September 2026

---

# 1. System Overview

This project implements a containerized multi-tier web application using WordPress and MySQL.

The infrastructure is hosted inside an Ubuntu Server virtual machine running on VirtualBox. Docker Compose manages the application and database containers.

The system consists of:

* Windows Host Laptop
* VirtualBox Hypervisor
* Ubuntu Server
* UFW Firewall
* Docker Engine
* Docker Compose
* WordPress container
* MySQL container
* Docker persistent volume
* Bash backup automation
* Cron scheduler

---

# 2. Architecture

The request flow is:

```text
Windows Host
     |
     v
Edge / Chrome Browser
     |
     v
Host-Only Network
192.168.56.0/24
     |
     v
Ubuntu Server
192.168.56.103
     |
     v
UFW Firewall
     |
     v
Docker Compose
     |
     v
enterprise-network
     |
     +--------------------+
     |                    |
     v                    v
WordPress              MySQL
:8080 -> :80           Internal :3306
     |                    |
     +--------->----------+
              |
              v
       Persistent Volume
```

The architecture diagram is stored in:

`architecture-diagram.png`

---

# 3. Server Information

| Item             | Configuration            |
| ---------------- | ------------------------ |
| VM Name          | CCM101-Enterprise-Server |
| Hostname         | ccm101-enterprise-server |
| Operating System | Ubuntu Server            |
| Server IP        | 192.168.56.103           |
| Network          | 192.168.56.0/24          |
| Application Port | 8080                     |
| SSH Port         | 22                       |

---

# 4. Accessing the Application

From the Windows host, open Microsoft Edge or Google Chrome.

Enter:

```text
http://192.168.56.103:8080
```

The WordPress application should load.

If the application does not load, first verify the Docker services.

---

# 5. Checking Docker Services

Enter the Ubuntu Server terminal and run:

```bash
cd ~/enterprise-cloud
docker compose ps
```

The expected services are:

```text
enterprise-wordpress
enterprise-mysql
```

The MySQL service should show a healthy status.

For additional information:

```bash
docker compose logs --tail=50
```

---

# 6. Starting the Application

To start the complete application:

```bash
cd ~/enterprise-cloud
docker compose up -d
```

Then verify:

```bash
docker compose ps
```

---

# 7. Stopping the Application

To stop the containers:

```bash
cd ~/enterprise-cloud
docker compose stop
```

To start them again:

```bash
docker compose start
```

For a complete container recreation:

```bash
docker compose down
docker compose up -d
```

The persistent MySQL volume should not be removed during normal maintenance.

---

# 8. Persistent Storage

The database uses the named Docker volume:

```text
enterprise-cloud_mysql_data
```

The volume is mounted at:

```text
/var/lib/mysql
```

To view Docker volumes:

```bash
docker volume ls
```

To inspect the project volume:

```bash
docker volume inspect enterprise-cloud_mysql_data
```

Do not use:

```bash
docker compose down -v
```

during normal maintenance because removing the volume can delete the persistent database data.

---

# 9. Firewall Configuration

UFW is configured with a default-deny incoming policy.

Check the firewall:

```bash
sudo ufw status verbose
```

Expected important rules:

```text
22/tcp    ALLOW
8080/tcp  ALLOW
```

The database port is not exposed to the host.

The firewall should remain enabled during normal operation.

---

# 10. Backup Automation

The database backup script is located at:

```text
~/enterprise-cloud/automation-script.sh
```

Make sure it is executable:

```bash
chmod +x ~/enterprise-cloud/automation-script.sh
```

To manually perform a backup:

```bash
~/enterprise-cloud/automation-script.sh
```

Backups are stored in:

```text
~/enterprise-cloud/backups/
```

List available backups:

```bash
ls -lh ~/enterprise-cloud/backups/
```

---

# 11. Cron Automation

The backup task is scheduled using Cron.

Check the current Cron configuration:

```bash
crontab -l
```

The scheduled task is:

```text
0 2 * * * /home/adminbianan/enterprise-cloud/automation-script.sh >> /home/adminbianan/enterprise-cloud/backups/backup.log 2>&1
```

This runs the database backup every day at 2:00 AM according to the server's configured time zone.

The log can be checked using:

```bash
tail -30 ~/enterprise-cloud/backups/backup.log
```

---

# 12. Recovery Procedure

If the MySQL service stops:

### Step 1 – Check the containers

```bash
docker compose ps
```

### Step 2 – Check the MySQL container

```bash
docker ps -a
```

### Step 3 – Start the MySQL container

```bash
docker start enterprise-mysql
```

### Step 4 – Wait for the health check

```bash
docker compose ps
```

Wait until MySQL reports:

```text
healthy
```

### Step 5 – Test the application

Open:

```text
http://192.168.56.103:8080
```

Verify that the WordPress application and stored content are available.

---

# 13. Server Restart Procedure

After an Ubuntu Server reboot, verify Docker:

```bash
sudo systemctl status docker
```

Then check the application:

```bash
cd ~/enterprise-cloud
docker compose ps
```

The containers are configured with:

```text
restart: unless-stopped
```

This allows Docker to restart services after normal Docker/host recovery events unless they were intentionally stopped.

---

# 14. Maintenance Commands

Check Docker status:

```bash
docker ps
```

Check Docker Compose services:

```bash
docker compose ps
```

View recent logs:

```bash
docker compose logs --tail=50
```

Check disk space:

```bash
df -h
```

Check memory:

```bash
free -h
```

Check firewall:

```bash
sudo ufw status verbose
```

Check scheduled backup:

```bash
crontab -l
```

---

# 15. Security Guidelines

The following security practices should be followed:

1. Do not publish database passwords to GitHub.
2. Store environment variables in the local `.env` file.
3. Keep `.env` excluded through `.gitignore`.
4. Do not expose MySQL port 3306 to the host unless specifically required.
5. Keep UFW enabled.
6. Use SSH only for server administration.
7. Keep Docker and Ubuntu packages updated.
8. Do not delete the persistent database volume during normal maintenance.
9. Review backup logs regularly.
10. Maintain recent database backups.

---

# 16. Backup Retention

The automation script keeps the seven most recent successful SQL database backups.

Older backups are automatically removed to reduce unnecessary disk usage.

Backup files follow this naming pattern:

```text
wordpress_db_YYYY-MM-DD_HH-MM-SS.sql
```

---

# 17. Troubleshooting

### WordPress does not open

Check:

```bash
docker compose ps
```

Then:

```bash
docker compose logs --tail=50 wordpress
```

Also verify:

```bash
sudo ufw status
```

---

### MySQL is unhealthy

Check:

```bash
docker compose logs --tail=50 db
```

Then:

```bash
docker compose ps
```

Wait for the health check to complete.

---

### Backup fails

Check whether MySQL is running:

```bash
docker ps
```

Check the backup log:

```bash
tail -30 ~/enterprise-cloud/backups/backup.log
```

Run the backup manually:

```bash
~/enterprise-cloud/automation-script.sh
```

---

# 18. Operational Verification

Before considering the system operational, verify:

```text
[ ] Ubuntu Server is running
[ ] Docker service is running
[ ] WordPress container is running
[ ] MySQL container is healthy
[ ] UFW is active
[ ] Port 8080 is accessible
[ ] MySQL remains internal to Docker
[ ] Persistent volume exists
[ ] Backup script is executable
[ ] Cron job is configured
[ ] Recent backup exists
[ ] WordPress data is accessible
```

---

# 19. Conclusion

The completed infrastructure provides a practical enterprise-style deployment using virtualization, containerization, firewall protection, persistent storage, database backup automation, and scheduled maintenance.

This manual provides the procedures necessary to deploy, operate, secure, monitor, back up, and recover the application environment.

