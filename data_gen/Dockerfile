FROM python:3.13-slim

WORKDIR /app

RUN pip install --no-cache-dir Faker==37.5.3 pandas[pyarrow]==2.3.1

COPY generator.py .

ENTRYPOINT ["python", "generator.py"]
