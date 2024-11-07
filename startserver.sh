#!/bin/sh

cd /app/data/backend
python manage.py runserver 0.0.0.0:8000 &

cd /app/data/frontend
npm run dev
