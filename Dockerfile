FROM jenkins/jenkins:lts

USER root

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Docker GPG
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg \
    | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Repo Docker
RUN echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
$(lsb_release -cs) stable" \
> /etc/apt/sources.list.d/docker.list

# Solo CLI (mejor práctica)
RUN apt-get update && apt-get install -y docker-ce-cli

# docker-compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

RUN usermod -aG docker jenkins

USER jenkins