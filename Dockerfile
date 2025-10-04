# Image de base
FROM python:3.11-slim

# Répertoire de travail
WORKDIR /app

# Copier les fichiers de dépendances
COPY requirements.txt .

# Installer les dépendances
RUN pip install --no-cache-dir -r requirements.txt

# Copier le code de l'application
COPY app/ ./app/

# Exposer le port de l'application
EXPOSE 8000

# Commande de démarrage
CMD ["python", "app/main.py"]
