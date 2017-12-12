FROM node:6.10.0

# Install Node.js and other dependencies
RUN yum update
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash
RUN . ~/.nvm/nvm.sh
RUN nvm install 6.11.5

RUN npm install -g pm2

RUN mkdir -p /var/www/ferp-test

# Define working directory
WORKDIR /var/www/ferp-test

COPY . .

RUN npm install

EXPOSE 3000

CMD pm2 start app.js