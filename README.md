#  Flask‑ToDo DevOps

**Automate your simple ToDo API from code to cloud—no manual ops!**

---

##  Project Overview

Learn how to build a **ToDo list** REST API with Python/Flask and automate its entire lifecycle:

1. **Code & test** locally.
2. **Containerize** with Docker.
3. **Provision** or use an existing VM via Terraform (any cloud or on-prem).
4. **Automate** builds and deploys using GitHub Actions.
5. **Monitor** basic server health (optional).

Anyone can follow these copy‑and‑paste steps—no AWS account required unless you choose to provision via AWS.

---

##  Repo Structure

```text
flask-todo-devops/
├─ app.py             # Flask REST API code
├─ Dockerfile         # How to build the Docker image
├─ main.tf            # Terraform scripts (provider of your choice)
├─ .github/
│   └─ workflows/
│       └─ ci-cd.yml  # GitHub Actions pipeline
└─ README.md          # This guide
```

---

##  Prerequisites

- **Git** & GitHub account
- **Docker** installed
- **Python 3.8+**
- **Terraform 1.0+**
- **A Linux VM** reachable over SSH (either already running, or provisioned by you via Terraform)
- **Docker registry** account (e.g., Docker Hub)

---

## Step 1: Clone the Project

```bash
git clone https://github.com/AyushKeshari213/flask-todo-devops.git
cd flask-todo-devops
```

---

## Step 2: Test Locally

1. (Optional) Create a virtual environment:
   ```bash
   python3 -m venv venv
   source venv/bin/activate     # macOS/Linux
   venv\Scripts\activate      # Windows
   ```
2. Install Flask and run the app:
   ```bash
   pip install Flask==2.2.5
   python app.py                # → http://localhost:5000/todos
   ```
3. In another shell, add a task:
   ```bash
   curl -X POST http://localhost:5000/todos \
        -H "Content-Type: application/json" \
        -d '{"item":"Buy milk"}'
   ```

---

## Step 3: Run in Docker

```bash
# Build and tag the image
docker build -t todo-app:dev .

# Run the container
docker run --rm -p 5000:5000 todo-app:dev
```

Visit **http://localhost:5000/todos** to see your app running in Docker.

---

## Step 4: Provision or Prepare Your VM (Terraform Optional)

If you already have a Linux VM with Docker installed, skip to Step 5.

To **provision a new VM** via Terraform (choose your cloud/provider):



## Step 5: Configure GitHub Actions Secrets

In your GitHub repo, go to **Settings → Secrets and variables → Actions** and add:

- `DOCKERHUB_USER`: your Docker Hub username
- `DOCKERHUB_TOKEN`: Docker Hub access token
- `VM_IP`: the public or private IP address of the virtual machine where your app will run
- `SSH_KEY`: the private SSH key used to connect to your VM (PEM or RSA format)

---

## Step 6: Trigger CI/CD Deploy

Push any change to the `main` branch to start the pipeline:

```bash
git commit --allow-empty -m "Deploy to VM"
git push origin main
```

The GitHub Actions workflow will:
1. **Build** your Docker image
2. **Push** it to Docker Hub
3. **SSH** into your VM, **pull** the new image, and **restart** the container

---

## Step 7: Verify Your Live API

In your browser or via curl:

```bash
curl http://<HOST_IP>:5000/todos
```
Should return a JSON array (e.g., `[]`).

---

## Optional: Basic Monitoring

On your VM, run Prometheus Node Exporter:

```bash
ssh -i /path/to/key user@<HOST_IP>

docker run -d --net host --name node-exporter prom/node-exporter
```

Scrape metrics at `http://<HOST_IP>:9100/metrics` in your Prometheus or other monitoring tool.

---


