# Build stage
FROM ghcr.io/getzola/zola:v0.17.1 as zola

WORKDIR /project
COPY . .

# Ensure Git is available
RUN apt-get update && apt-get install -y git

# Initialize and update submodules
RUN git submodule update --init --recursive

# Build the site
RUN ["zola", "build"]

# Serve stage
FROM ghcr.io/static-web-server/static-web-server:2
WORKDIR /
COPY --from=zola /project/public /public

# Optional: Expose a port if necessary, e.g., 80 or 8080
EXPOSE 80

# Command to run the static web server
CMD ["--root", "/public"]
