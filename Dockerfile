FROM node:12-alpine AS base
WORKDIR /app
COPY package*.json ./
ENV NODE_ENV=production
RUN npm i && npm cache clean --force
COPY . .
RUN npm run build

FROM node:12-alpine AS release
COPY --from=base /app/package*.json ./
COPY --from=base /app/node_modules ./node_modules
COPY --from=base /app/dist ./dist

EXPOSE 8080
ENTRYPOINT ["node", "dist/main.js"]