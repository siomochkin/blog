# Build stage
FROM debian:bullseye-slim as builder

# Install necessary tools
RUN apt-get update && apt-get install -y git wget

# Install Zola
RUN wget https://github.com/getzola/zola/releases/download/v0.17.1/zola-v0.17.1-x86_64-unknown-linux-gnu.tar.gz && \
    tar -xzf zola-v0.17.1-x86_64-unknown-linux-gnu.tar.gz && \
    mv zola /usr/local/bin/zola

WORKDIR /project
COPY . .

# Initialize and update submodules
RUN git submodule update --init --recursive

# Build the site
RUN zola build

# Serve stage
FROM ghcr.io/static-web-server/static-web-server:2
WORKDIR /
COPY --from=builder /project/public /public

# Optional: Expose a port if necessary, e.g., 80 or 8080
EXPOSE 80

# Command to run the static web server
CMD ["--root", "/public"]
