# Build stage
FROM node:20-alpine AS build
WORKDIR /app

# Abilita Corepack e prepara Yarn 4
RUN corepack enable && corepack prepare yarn@stable --activate

# Copia tutti i file (inclusi .yarn/ e .yarnrc.yml)
COPY . .

# Installa le dipendenze
RUN yarn install --frozen-lockfile

# Build del progetto (Vite genera /dist)
RUN yarn build

# Production stage
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
