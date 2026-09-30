# CCM101 – Mission 10: The Enterprise Cloud Architect

## Project Overview

This project implements a secure, persistent, and automated multi-tier web application infrastructure using virtualization, Linux, Docker, Docker Compose, firewall configuration, persistent storage, and Bash automation.

The application stack used for this laboratory is **WordPress with MySQL**. The infrastructure is deployed inside an Ubuntu Server virtual machine running on VirtualBox.

The project demonstrates how a small enterprise application can be deployed using containerized services while maintaining network security, database persistence, backup automation, and operational documentation.

---

## Project Objectives

The main objectives of this project are:

* Provision and configure an Ubuntu Server virtual machine.
* Configure host-to-server network connectivity.
* Install and configure Docker and Docker Compose.
* Deploy a multi-tier WordPress and MySQL application.
* Connect application and database containers through a private Docker network.
* Implement persistent database storage using Docker volumes.
* Configure UFW firewall rules using a default-deny incoming policy.
* Create a Bash automation script for database backups.
* Schedule automated backups using Cron.
* Test application persistence and recovery.
* Document the complete infrastructure and operational procedures.

---

## System Architecture

The implemented infrastructure follows this architecture:

```text
Windows Host Laptop
        |
        v
Microsoft Edge / Chrome
        |
        | Host-Only Network
        | 192.168.56.0/24
        v
VirtualBox
        |
        v
Ubuntu Server
192.168.56.103
        |
        v
UFW Firewall
        |
        | 22/tcp - SSH
        | 8080/tcp - Web Application
        v
Docker Engine / Docker Compose
        |
        v
enterprise-network
        |
        +-----------------------+
        |                       |
        v                       v
enterprise-wordpress     enterprise-mysql
WordPress                 MySQL 8.4
8080 -> 80               Internal 3306
        |                       |
        +----------+------------+
                   |
                   v
        enterprise-cloud_mysql_data
             Persistent Volume
```

The architecture diagram is provided in:

`architecture-diagram.png`

---

## Application Stack

| Component               | Technology            |
| ----------------------- | --------------------- |
| Host Operating System   | Windows               |
| Hypervisor              | VirtualBox            |
| Server Operating System | Ubuntu Server         |
| Container Platform      | Docker                |
| Container Orchestration | Docker Compose        |
| Web Application         | WordPress             |
| Database                | MySQL 8.4             |
| Container Network       | Docker Bridge Network |
| Firewall                | UFW                   |
| Automation              | Bash + Cron           |
| Persistent Storage      | Docker Named Volume   |

---

## Infrastructure Configuration

### Virtual Machine

The server environment is configured using VirtualBox.

| Configuration    | Value                    |
| ---------------- | ------------------------ |
| VM Name          | CCM101-Enterprise-Server |
| Operating System | Ubuntu Server            |
| CPU              | 2 CPUs                   |
| RAM              | 4096 MB                  |
| Storage          | 30 GB                    |
| Hostname         | ccm101-enterprise-server |
| Server IP        | 192.168.56.103           |

---

## Network Configuration

The Ubuntu Server is accessible from the Windows host through a Host-Only network.

```text
Network: 192.168.56.0/24
Server: 192.168.56.103
Application Port: 8080
SSH Port: 22
```

The WordPress application can be accessed from the host browser using:

```text
http://192.168.56.103:8080
```

The MySQL database is not directly exposed to the host. It is accessed by WordPress through the internal Docker network.

---

## Docker Architecture

Two containers are deployed:

### WordPress Container

```text
Container Name: enterprise-wordpress
Image: wordpress:latest
Host Port: 8080
Container Port: 80
```

The WordPress container provides the web application interface.

### MySQL Container

```text
Container Name: enterprise-mysql
Image: mysql:8.4
Internal Port: 3306
```

The MySQL container stores the application's database.

It does not publish its database port to the host. WordPress communicates with MySQL through:

```text
enterprise-network
```

---

## Persistent Storage

The MySQL database uses a Docker named volume:

```text
enterprise-cloud_mysql_data
```

The volume is mounted inside the MySQL container at:

```text
/var/lib/mysql
```

This allows database information to remain available when containers are stopped, recreated, or when the Ubuntu Server is restarted.

A WordPress persistence test was performed to verify that application data remained available after a server restart.

---

## Security Configuration

UFW is enabled on the Ubuntu Server.

The firewall uses:

```text
Default incoming: DENY
Default outgoing: ALLOW
```

Required ports are explicitly allowed:

```text
22/tcp
8080/tcp
```

Port 22 is used for SSH administration.

Port 8080 is used to access the WordPress application.

The MySQL port is not exposed through the host firewall because the database is only required internally by the WordPress container.

---

## Backup Automation

A custom Bash script named:

```text
automation-script.sh
```

is used to create MySQL database backups.

The script uses `mysqldump` to create a SQL backup of the WordPress database.

Backups are stored under:

```text
~/enterprise-cloud/backups/
```

The script also maintains backup storage by retaining the most recent seven database backup files.

---

## Cron Automation

The backup script is scheduled through Cron.

Current schedule:

```text
0 2 * * *
```

This executes the backup script every day at 2:00 AM according to the server's configured time zone.

The Cron task also records execution information in:

```text
~/enterprise-cloud/backups/backup.log
```

---

## Testing and Recovery

The infrastructure was tested through several operational scenarios.

### Application Test

The WordPress application was accessed successfully through:

```text
http://192.168.56.103:8080
```

### Database Health Test

The MySQL container was verified as healthy using Docker Compose.

### Persistence Test

A WordPress post named **Persistence Test** was created and remained available after restarting the Ubuntu Server.

### Failure and Recovery Test

The MySQL container was intentionally stopped to simulate a database service failure.

The container was then started again and verified as healthy.

The WordPress application remained available after recovery, and the persistence test data remained visible.

### Backup Test

The Bash backup script was manually executed and successfully produced SQL database backup files.

Cron execution was also tested during development.

---

## Project Structure

```text
Laboratory-10-Enterprise-Cloud-Architect/
│
├── README.md
├── architecture-diagram.png
├── docker-compose.yml
├── automation-script.sh
├── operational-manual.md
├── final-reflection.md
└── .gitignore
```

---

## Deployment Summary

The complete deployment process consists of:

1. Provisioning the Ubuntu Server virtual machine.
2. Configuring the server network.
3. Installing Docker.
4. Installing Docker Compose.
5. Creating the Docker Compose configuration.
6. Creating the WordPress and MySQL containers.
7. Creating the persistent database volume.
8. Configuring UFW.
9. Creating the automated database backup script.
10. Scheduling the backup using Cron.
11. Testing application persistence and service recovery.
12. Documenting the infrastructure and operational procedures.

---

## Conclusion

This project demonstrates the implementation of an enterprise-style application environment using virtualization and containerization.

The final infrastructure provides a multi-tier application consisting of WordPress and MySQL, protected by a host firewall, connected through a private Docker network, backed by persistent database storage, and supported by automated database backups.

The project also demonstrates practical cloud infrastructure concepts including virtualization, containerization, networking, security hardening, persistent storage, automation, monitoring, recovery, and technical documentation.
