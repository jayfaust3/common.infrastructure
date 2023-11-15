FROM node:18-alpine

WORKDIR /usr/aws-cdk

COPY package.json .

RUN npm install\
    && npm install -g aws-cdk-local aws-cdk typescript

COPY . .

RUN sleep 30s

CMD ["npm", "run", "deploy"]
