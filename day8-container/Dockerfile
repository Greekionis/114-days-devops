# Stage 1: Build
FROM python:3.12 AS builder
WORKDIR /app
COPY app.py .
RUN python -m compileall app.py

# Stage 2: Runtime
FROM python:3.12-slim
WORKDIR /app
COPY --from=builder /app/app.py .
EXPOSE 8000
CMD ["python", "app.py"]
