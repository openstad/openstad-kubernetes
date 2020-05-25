# Nodejs 8.0.0 alpine 3.6.0
FROM node:8.0.0-alpine

# Label for tracking
LABEL nl.openstad.container="api_container" nl.openstad.version="0.0.1-beta" nl.openstad.release-date="2020-05-07"


# Environment variables
ENV APP_HOST=""
ENV APP_PORT=""

ENV DB_HOST=""
ENV DB_USER=""
ENV DB_PWD=""
ENV DB_DATABASE=""

ENV MAIL_HOST=""
ENV MAIL_PORT=""
ENV MAIL_USER=""
ENV MAIL_PWD=""
ENV MAIL_FROM=""

ENV COOKIE_SECRET=""
ENV JWT_SECRET=""

ENV AUTH_HOST=""
ENV AUTH_PORT=""
ENV AUTH_CLIENT_ID=""
ENV AUTH_CLIENT_SECRET=""
ENV AUTH_FIXED_TOKEN=""
ENV AUTH_FIXED_USER_ID=""



# Install all base dependencies.
RUN apk add --no-cache --update g++ make python musl-dev

# Set the working directory to the root of the container
WORKDIR /home/app

# Bundle app source
COPY . /home/app

# Install node dependencies
RUN npm install

# Remove unused packages only used for building.
RUN apk del g++ make python && rm -rf /var/cache/apk/*

# Set node ownership to /home/app
RUN chown -R node:node/home/app
USER node


# ----------------------------------------------
# Already present in dockerfile:

# # Must execute on run instead of build
#create database
#script forcing wait for mysql needs to be set
# RUN node reset.js


# Already present in dockerfile:
# Mount persistent storage
# ----------------------------------------------


# Exposed ports for application
EXPOSE 8111/tcp
EXPOSE 8111/udp

# Run the application
CMD [ "npm", "start" ]
