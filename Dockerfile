# -------------------------
# 1. Build stage
# -------------------------
FROM node:20-alpine AS builder
WORKDIR /app

RUN npm install -g pnpm

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

COPY . .
RUN pnpm build

# -------------------------
# 2. Production stage
# -------------------------
FROM node:20-alpine
WORKDIR /app

ENV NODE_ENV=production
EXPOSE 3000

COPY --from=builder /app/.output /app/.output

CMD ["node", ".output/server/index.mjs"]
