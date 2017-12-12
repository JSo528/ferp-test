FROM node:6.10.0
RUN mkdir -p /usr/local/app
WORKDIR /usr/local/app


COPY package*.json ./
RUN npm install

COPY . .
EXPOSE 3001

CMD ["npm", "start"]