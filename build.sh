#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
pip install -r requirements.txt

# Navigate to Django project directory
cd prudok

# Collect static files
python manage.py collectstatic --no-input

# Run migrations
python manage.py migrate

# Create superuser automatically (only if doesn't exist)
# Username: admin, Password: from DJANGO_SUPERUSER_PASSWORD env var
python manage.py create_superuser_if_none
