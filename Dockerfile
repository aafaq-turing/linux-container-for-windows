# Use Ubuntu as the base image
FROM ubuntu:latest

# Set environment variables for non-interactive apt installations
ENV DEBIAN_FRONTEND=noninteractive

# Install basic tools and dependencies, including unzip
RUN apt update && apt upgrade -y && \
    apt install -y curl make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget llvm \
    libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git sudo \
    python3-openssl **unzip** \
    && rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------------------------
# Install NVM and Node.js 22.17.0
# NVM will be installed to /root/.nvm in the image.
# ----------------------------------------------------------------------
ENV NVM_DIR="/root/.nvm"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install 22.17.0 && \
    nvm alias default 22.17.0 && \
    nvm use default

# ----------------------------------------------------------------------
# Install Pyenv and Python 3.12.11
# Pyenv will be installed to /root/.pyenv in the image.
# ----------------------------------------------------------------------
ENV PYENV_ROOT="/root/.pyenv"
# Consolidate the pyenv installation, initialization, python installation,
# and pipenv installation into a single RUN command.
RUN curl https://pyenv.run | bash && \
    export PATH="$PYENV_ROOT/bin:$PATH" && \
    eval "$(pyenv init --path)" && \
    eval "$(pyenv init -)" && \
    pyenv install 3.12.11 && \
    pyenv global 3.12.11 && \
    # Now that python is available, install pip and pipenv
    python -m pip install --upgrade pip && \
    pip install pipenv==2025.0.4

# Add Pyenv initialization to bashrc so it's loaded for every shell
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /root/.bashrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /root/.bashrc && \
    echo 'eval "$(pyenv init --path)"' >> /root/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> /root/.bashrc

# ----------------------------------------------------------------------
# Install Terraform
# We'll install it to /usr/local/bin to be directly available in the PATH
# ----------------------------------------------------------------------
ENV TERRAFORM_VERSION="1.7.5"
RUN wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip /tmp/terraform.zip -d /usr/local/bin && \
    rm /tmp/terraform.zip

# ----------------------------------------------------------------------
# Install CDKTF-CLI 0.21.0 (requires Node.js)
# ----------------------------------------------------------------------
RUN . "$NVM_DIR/nvm.sh" && \
    npm install -g cdktf-cli@0.21.0

# Clean up APT cache to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the default command to run when the container starts
CMD ["bash"]