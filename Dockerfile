FROM node:14-alpine
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm set progress=false && \
    npm config set depth 0 && \
    npm install --only=production && \
    npm cache clean --force
COPY app.js ./
EXPOSE 8080
ENTRYPOINT ["node", "app.js"]