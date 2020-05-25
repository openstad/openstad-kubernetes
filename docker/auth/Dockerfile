# Nodejs 10.16.0 / alpine 3.9.4
FROM node:10.16.0-alpine

# Label for tracking
LABEL nl.openstad.container="auth" nl.openstad.version="0.0.1-beta" nl.openstad.release-date="2020-05-07"


# Host variable
ENV APP_URL=""

# Frontend URL variable
ENV ADMIN_REDIRECT_URL=""

# MySQL database variables
ENV DB_HOST=""
ENV DB_USER=""
ENV DB_PASSWORD=""
ENV DB_NAME=""

# Mail variables
ENV MAIL_SERVER_URL=""
ENV MAIL_SERVER_PORT=""
ENV MAIL_SERVER_SECURE=""
ENV MAIL_SERVER_PASSWORD=""
ENV MAIL_SERVER_USER_NAME=""
ENV EMAIL_ASSETS_URL=""
ENV FROM_NAME=""
ENV FROM_EMAIL=""


# Install all base dependencies.
RUN apk add --no-cache --update openssl g++ make python3 musl-dev

# Set the working directory to the root of the container
WORKDIR /home/app

# Bundle app source
COPY . /home/app

# Generate certificates
RUN openssl genrsa -out privatekey.pem 2048 \     
    && openssl req -new -key privatekey.pem -out certrequest.csr -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=$APP_URL"     && openssl x509 -req -in certrequest.csr -signkey privatekey.pem -out certificate.pem

# Move certificates
RUN mkdir -p/home/app/certs     && mv certificate.pem/home/app/certs/     && mv certrequest.csr/home/app/certs/     && mv privatekey.pem/home/app/certs/

# This packages must be installed seperatly to prevent crash
# @since node 10.16
RUN npm install -g node-gyp
RUN npm install bcrypt

# Install all npm packages
RUN npm install


# ----------------------------------------------
# TODO: Migrate to database
RUN npm install knex -g
#  Must execute on run instead of build
# RUN knex migrate:latest
# ----------------------------------------------


# Remove unused packages only used for building.
RUN apk del openssl g++ make && rm -rf /var/cache/apk/*

# Owner rights for node user
RUN chown -R node:node/home/app
USER node

# Exposed ports for application
EXPOSE 4000/tcp
EXPOSE 4000/udp

# Run the application
CMD [ "npm", "start" ]
