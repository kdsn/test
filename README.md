# PHP Environment Test Container

Simple Docker-based PHP environment test package for validating server and network configuration before deploying a real application.

The purpose of this package is to verify that the complete request path is working:

Internet → DNS → Firewall → Load Balancer / Reverse Proxy → Docker → Nginx → PHP-FPM → PHP

This helps identify infrastructure issues before application deployment.

---

## Purpose

This package verifies:

- Docker can run correctly
- Nginx is reachable
- PHP-FPM is working
- Domain routing functions correctly
- Reverse proxy headers are forwarded correctly
- Load balancer configuration works
- External access is functioning

The application displays diagnostic information directly in the browser.

---

## Displayed Information

The test page shows:

- PHP status
- Server time
- PHP version
- Hostname
- Remote IP
- Host
- URI
- Request method
- X-Forwarded-For
- X-Forwarded-Proto
- X-Real-IP
- Request headers

---

## Requirements

Minimum requirements:

- Ubuntu 24.04 LTS
- Docker installed
- SSH access
- Port access configured
- Domain DNS configured (optional)

HTTPS certificates are not handled inside the container.

Expected architecture:

Internet  
↓  
DNS  
↓  
Firewall / Load Balancer / Reverse Proxy  
↓  
HTTPS termination  
↓  
HTTP  
↓  
Docker container  
