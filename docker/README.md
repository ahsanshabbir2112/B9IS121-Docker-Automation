# Part 3 - Docker Container Deployment

## Purpose
Containerises a static sample web application using Nginx and deploys it to the EC2 instance configured in Part 2.

## Files
- index.html: the sample web application (static HTML/CSS page).
- Dockerfile: builds an Nginx-based image serving index.html.

## Build and Deployment Steps
1. Files copied to the server via SCP.
2. Logged into the server via SSH.
3. Docker image built on the server using docker build.
4. Container started using docker run, mapping port 80 to port 80.
5. Verified locally with curl, then verified externally via browser.

## Note on Automation
This step was performed manually to validate the Dockerfile and application before automating it. In a fully automated pipeline this would be handled by an Ansible task or triggered by the CI/CD pipeline in Part 4.
