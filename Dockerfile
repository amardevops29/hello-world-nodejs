FROM node:8.16.1-alpine
WORKDIR /app
COPY . /app
RUN npm install
EXPOSE 5000
CMD node index.js
#RUN ["chmod", "+x", "/usr/local/bin/docker-entrypoint.sh"]

#ENTRYPOINT ["node", "index.js"]
#COPY package.json /app
