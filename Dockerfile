FROM node:6.10.0
RUN npm install -g pm2
RUN mkdir -p /usr/local/app
WORKDIR /usr/local/app

COPY . .

RUN npm install
CMD pm2 start app.js