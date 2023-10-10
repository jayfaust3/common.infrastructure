FROM node:18-alpine

WORKDIR /usr/aws-cdk

COPY package.json .

RUN npm install\
    && npm install typescript -g\
    && npm install cdklocal -g

COPY . .

RUN sleep 30s

CMD ["npm", "run", "deploy"]
