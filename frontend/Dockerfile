FROM ghcr.io/ironpeakservices/iron-alpine/iron-alpine:3.20.3

LABEL maintainer="Risto Lievonen"

ENV NODE_VERSION 20.15.1-r0
ENV NPM_VERSION 10.8.0-r0

COPY . /app

RUN apk add --no-cache nodejs=${NODE_VERSION} npm=${NPM_VERSION}
WORKDIR /app/frontend
RUN npm install

RUN chown -R app:app /app
#ENTRYPOINT [ "python" ]

USER app

EXPOSE 5173
CMD ["npm", "run", "dev", "--", "--host"]
