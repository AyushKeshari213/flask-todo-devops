FROM python:3.12-slim-bookworm
WORKDIR /app

# ← COPY both app.py and requirements.txt into the image
COPY app.py requirements.txt 

# ← Install dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000
CMD ["python", "app.py"]
