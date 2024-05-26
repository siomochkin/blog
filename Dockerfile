# Build stage
FROM ghcr.io/getzola/zola:v0.17.1 as zola

COPY . /project
WORKDIR /project
RUN ["zola", "build"]

# Serve stage
FROM ghcr.io/static-web-server/static-web-server:2
WORKDIR /
COPY --from=zola /project/public /public

# Optional: Expose a port if necessary, e.g., 80 or 8080
EXPOSE 80

# Command to run the static web server
CMD ["--root", "/public"]
