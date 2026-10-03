cat > day8_containers.md << 'EOF'
# Day 8: Container Images (Revised)

## Why containers replaced .deb packages
- Portable across distros
- Isolated (deps bundled)
- Reproducible (Dockerfile)
- Layered (efficient updates)

## Dockerfile anatomy
- FROM — base image
- WORKDIR — working dir inside container
- COPY — copy files into image
- RUN — execute during build
- EXPOSE — document exposed port
- CMD — default command at runtime

## Multi-stage builds
- Stage 1 (builder): heavy tools, compilers
- Stage 2 (runtime): minimal — copy only artifacts
- **Value:** image size reduction (Python: minor; Go/Rust: 50-80x smaller)

## Build / run / clean
```bash
docker build -t name:tag .
docker run -d -p host:container --name cname image:tag
docker ps
docker logs cname
docker stop cname && docker rm cname
docker images
docker history name:tag
