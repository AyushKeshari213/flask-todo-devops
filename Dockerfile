FROM python:3.12-slim-bookworm
WORKDIR /app

# ← COPY both app.py and requirements.txt into the image
COPY requirements.txt .

RUN cat requirements.txt


# ← Install pipenv

# ← Install dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000
CMD ["python", "app.py"]
