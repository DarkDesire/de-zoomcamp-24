FROM python:3.12.1

RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app
COPY scripts/ingest_data.py ingest_data.py 
COPY data data

ENTRYPOINT [ "python", "ingest_data.py" ]