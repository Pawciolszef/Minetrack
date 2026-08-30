FROM node:18-bullseye

# install tini & sqlite3
RUN apt-get update \
 && apt-get install --quiet --yes --no-install-recommends tini sqlite3 \
 && apt-get clean --quiet --yes \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

EXPOSE 8090
ENTRYPOINT ["tini", "--"]
CMD ["node", "main.js"]

