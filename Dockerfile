FROM node:16

# Poprawka dla archiwalnego wydania Debian Buster (EOL)
RUN sed -i s/deb.debian.org/archive.debian.org/g /etc/apt/sources.list && \
    sed -i s/security.debian.org/archive.debian.org/g /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list && \
    sed -i '/buster-updates/d' /etc/apt/sources.list

# install tini
ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /sbin/tini
RUN chmod +x /sbin/tini

# install sqlite3
RUN apt-get update -o Acquire::Check-Valid-Until=false \
 && apt-get install --quiet --yes --no-install-recommends sqlite3 \
 && apt-get clean --quiet --yes \
 && apt-get autoremove --quiet --yes \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

EXPOSE 8090
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "main.js"]
