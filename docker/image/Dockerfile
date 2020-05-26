FROM node:alpine

# Label for tracking
LABEL nl.openstad.container="frontend" nl.openstad.version="0.0.1-beta" nl.openstad.release-date="2020-05-07"

# Frontend container name
ENV DEFAULT_HOST=""

# frontend url + port `example.com:port`
ENV HOST_DOMAIN=""

# Create app directory
WORKDIR /app

# Copy all content to the Docker image.
COPY . .

# Set node ownership to/home/app
RUN chown -R node:node/home/app
USER node

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./
COPY knexfile.js ./
COPY knex ./knex

RUN mkdir -p images

RUN apk add --no-cache --virtual .gyp python make g++ \
    && npm install  --ignore-optional --ignore-scripts --pure-lockfile --non-interactive \
    && apk del .gyp

RUN npm install knex -g


COPY knex/migrations ./migrations

# Bundle app source
COPY . .

CMD [ "npm", "start" ]
