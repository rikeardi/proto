FROM ghcr.io/ironpeakservices/iron-alpine/iron-alpine:3.20.3

LABEL maintainer="Risto Lievonen"

RUN mkdir /app/backend
COPY . /app/backend/

RUN apk add --no-cache python3=3.12.7-r0 py3-pip=24.0-r2
RUN pip install -r /app/backend/requirements.txt --break-system-packages

#ENTRYPOINT [ "python" ]

EXPOSE 8000
CMD ["python", "/app/backend/manage.py", "runserver", "0.0.0.0:8000"]