# Linux Container for Windows Development

This project provides a persistent Ubuntu-based development environment with Node.js, Python, Terraform, and CDKTF pre-installed. Your codebase is mounted inside the container for seamless development on Windows.

## Features

- Ubuntu latest
- Node.js 22.17.0 via NVM
- Python 3.12.11 via Pyenv & Pipenv
- Terraform 1.7.5
- CDKTF CLI 0.21.0
- Persistent container with auto-restart
- Bind-mount your local codebase for live editing

## Getting Started

### 1. Configure Your Codebase Mount

Edit [`docker-compose.yaml`](docker-compose.yaml) and replace `/YOUR/PREFERRED/DIRECTORY/HERE` with the absolute path to your local codebase folder.

```yaml
volumes:
  - /YOUR/PREFERRED/DIRECTORY/HERE:/my_desktop # Bind mount your repo folder
```

### 2. Start the Container

```sh
docker compose up -d
```

## Accessing the Development Environment

### Option 1: Attach to the Running Container

```sh
docker attach my-persistent-dev-container
```
You'll be dropped into the container's bash shell. All installed tools (Node, Python, Terraform, etc.) are available. Your files are accessible at `/my_desktop`.

### Option 2: Open a New Bash Terminal in the Container

```sh
docker compose exec dev_env bash
```

### 3. Stopping and Removing the Container

```sh
docker compose stop
docker compose down
```

## Notes

- Tool installations are baked into the image; no extra setup required.
- For persistent app data, define named volumes in [`docker-compose.yaml`](docker-compose.yaml) as needed.

## Troubleshooting

- Ensure your codebase folder path is correct in [`docker-compose.yaml`](docker-compose.yaml).
- If you need additional tools, modify [`Dockerfile`](Dockerfile) and rebuild.

---
For more details, see [`Dockerfile`](Dockerfile) and [`docker-compose.yaml`](docker-compose.yaml).