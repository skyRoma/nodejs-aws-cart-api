FROM node:12-alpine as base

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
ENV PORT=8080
EXPOSE 8080
CMD [ "npm", "run", "start:prod" ]
