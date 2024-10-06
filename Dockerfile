FROM python:3.12-slim AS base

RUN apt-get update && \
    apt-get install -y gcc g++ make && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
ARG SPACY_MODEL
ENV PYTHONBUFFERED=1 SENSE2VEC=0 SPACY_MODEL=en_core_web_lg
RUN python -m spacy download en_core_web_lg
COPY src/main.py src/main.py
EXPOSE 8000
# HEALTHCHECK --timeout=2s --start-period=2s --retries=1 \
#     CMD curl -f http://localhost:8000/health_check
RUN useradd user
USER user
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0"]
