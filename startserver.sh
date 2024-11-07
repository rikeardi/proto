#!/bin/sh

cd /app/backend
python manage.py runserver 0.0.0.0:8000 &
cd /app/frontend
npm run dev -- --host
