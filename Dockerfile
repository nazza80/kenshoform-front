# Build stage
FROM node:22-alpine AS build
WORKDIR /app

# Abilita Corepack e prepara Yarn 4
RUN corepack enable && corepack prepare yarn@stable --activate

# Copia tutti i file necessari (inclusi .yarnrc.yml e la cartella .yarn se presente)
COPY . .

# Installa le dipendenze
RUN yarn install --immutable

# Build del progetto (Vite genera la cartella /app/dist)
RUN yarn build

# Debug: mostra i contenuti della cartella /app e /app/dist (se esiste)
RUN ls -la /app && ls -la /app/dist || true

# Production stage
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
