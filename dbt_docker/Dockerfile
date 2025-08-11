FROM python:3.11-slim

WORKDIR /usr/app

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip
RUN pip install --no-cache-dir dbt-core==1.10.5 dbt-postgres==1.9.0
