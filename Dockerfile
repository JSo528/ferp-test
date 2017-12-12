FROM node:6.10.0

# Install Node.js and other dependencies
RUN apt-get update && \
    apt-get -y install curl && \
    apt-get -y install git && \
    apt-get -y install wget && \
    curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - && \
    apt-get install --yes nodejs

RUN npm install -g pm2

RUN mkdir -p /var/www/ferp-test

# Define working directory
WORKDIR /var/www/ferp-test

COPY . .

RUN npm install

EXPOSE 3000

CMD pm2 start app.js