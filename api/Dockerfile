FROM node:14-alpine

RUN mkdir -p /home/node/api/node_modules && chown -R node:node /home/node/api
WORKDIR /home/node/api
COPY package*.json ./

USER node
RUN npm install

COPY --chown=node:node . .

EXPOSE 3000
CMD [ "node", "server.js" ]