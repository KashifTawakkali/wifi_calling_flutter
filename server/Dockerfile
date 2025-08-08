# syntax=docker/dockerfile:1
FROM node:20-alpine AS base
WORKDIR /app

# Install deps
COPY package*.json ./
RUN npm ci

# Copy source
COPY tsconfig.json ./
COPY src ./src

# Build
RUN npm run build

# --- Runtime image ---
FROM node:20-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production

# Only copy production deps and built files
COPY package*.json ./
RUN npm ci --only=production
COPY --from=base /app/dist ./dist

EXPOSE 3000
CMD ["node", "dist/index.js"] 