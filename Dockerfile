FROM node:16

WORKDIR /app

COPY . .

RUN npm install -y

EXPOSE 3000

CMD ["npm", "start"]

