#!/bin/sh

cd /app/data/backend
./docker-entrypoint.sh &

cd /app/data/frontend
npm run dev
