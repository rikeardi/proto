FROM ghcr.io/ironpeakservices/iron-alpine/iron-alpine:3.20.3

LABEL maintainer="Risto Lievonen"

ENV PYTHON_VERSION 3.12.7-r0
ENV PIP_VERSION 24.0-r2
ENV NODE_VERSION 20.15.1-r0
ENV NPM_VERSION 10.8.0-r0

COPY . /app

RUN apk add --no-cache python3=${PYTHON_VERSION} py3-pip=${PIP_VERSION}
RUN pip install -r /app/backend/requirements.txt --break-system-packages

RUN apk add --no-cache nodejs=${NODE_VERSION} npm=${NPM_VERSION}
WORKDIR /app/frontend
RUN npm install

#ENTRYPOINT [ "python" ]

USER app

EXPOSE 5000
EXPOSE 8000
CMD ["python", "/app/backend/manage.py", "runserver", "0.0.0.0:8000", "&", "npm", "run", "dev", "--", "--host"]
