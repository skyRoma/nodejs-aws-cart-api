FROM node:14-alpine as base

# Build layer
FROM base as build
WORKDIR /build
COPY package*.json ./
RUN npm i
COPY . .
RUN npm run build && npm prune --production

# Release layer
FROM base
WORKDIR ../app
COPY package*.json ./
COPY --from=build /build/node_modules ./node_modules
COPY --from=build /build/dist ./dist
USER node
EXPOSE 8080
ENTRYPOINT ["node", "dist/main.js"]
