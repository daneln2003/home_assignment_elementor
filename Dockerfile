# === Builder Stage ===
FROM python:3.12-slim AS builder

WORKDIR /app

# Install pip and build dependencies
RUN apt-get update && apt-get install -y gcc && rm -rf /var/lib/apt/lists/*

# Install dependencies
COPY app/requirements.txt .
RUN pip install --upgrade pip && pip install --user -r requirements.txt

# Copy app
COPY app/main.py .

# === Final Stage ===
FROM python:3.12-slim

ENV PATH="/home/appuser/.local/bin:$PATH"
WORKDIR /app

# Create a non-root user
RUN useradd -m appuser
USER appuser

# Copy from builder
COPY --from=builder /root/.local /home/appuser/.local
COPY --from=builder /app/main.py .

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]


