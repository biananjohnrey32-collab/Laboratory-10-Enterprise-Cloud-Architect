# Final Reflection

## CCM101 – Mission 10: The Enterprise Cloud Architect

This laboratory provided me with practical experience in designing and implementing an enterprise-style cloud infrastructure using virtualization and containerization.

One of the most important things I learned was how different infrastructure components work together. I started by creating an Ubuntu Server virtual machine using VirtualBox. I then configured the server network so that the Windows host could access the application through the Host-Only network.

I also learned how Docker and Docker Compose can be used to deploy a multi-tier application. Instead of installing WordPress and MySQL directly on the Ubuntu Server, I deployed them as separate containers. The WordPress container handles the web application while the MySQL container provides the database service. Both containers communicate through a private Docker network.

Another important lesson was persistent storage. I configured a Docker named volume for MySQL so that database information would remain available after container and server restarts. I tested this by creating content in WordPress and restarting the Ubuntu Server. The content remained available after the restart, demonstrating the importance of persistent storage in an application environment.

Security was another major part of the laboratory. I configured UFW with a default-deny incoming policy and explicitly allowed only the ports needed for SSH and web application access. The MySQL database was not directly exposed to the host, which reduced unnecessary network exposure.

I also learned how automation can reduce repetitive administrative work. I created a Bash script that performs MySQL database backups and configured Cron to execute the script automatically. During testing, the backup log also helped demonstrate whether the database backup operation succeeded or failed.

The failure and recovery testing helped me understand that infrastructure should not only work under normal conditions but should also be tested when services fail. I intentionally stopped the MySQL container, checked the service state, restarted the database, waited for the health check, and verified that the WordPress application and persistent data remained available.

Overall, this laboratory improved my understanding of virtualization, Docker, networking, firewall configuration, persistent storage, automation, backup management, and recovery procedures. More importantly, it showed me that an infrastructure project requires not only deployment but also security, maintenance, testing, documentation, and recovery planning.

The experience gave me a better understanding of how cloud and enterprise infrastructure components can be combined into a structured and maintainable system.

