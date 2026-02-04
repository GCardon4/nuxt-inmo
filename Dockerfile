# Etapa de build
FROM node:20-alpine AS build

WORKDIR /app

RUN corepack enable && corepack prepare pnpm@10.28.2 --activate

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

COPY . .
RUN pnpm build

# Etapa de produccion
FROM node:20-alpine

WORKDIR /app

COPY --from=build /app/.output .output

ENV HOST=0.0.0.0
ENV PORT=3000

EXPOSE 3000

CMD ["node", ".output/server/index.mjs"]
