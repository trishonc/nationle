FROM node:18-alpine AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
COPY --from=build-stage /app/.svelte-kit .svelte-kit
COPY --from=build-stage /app/build build
RUN npm install --production

CMD ["node", "build"]

