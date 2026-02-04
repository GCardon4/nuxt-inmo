# Etapa de build
FROM node:20-alpine AS build

WORKDIR /app

# Copiar archivos de dependencias
COPY package*.json ./

# Instalar dependencias
RUN npm ci --only=production=false

# Copiar código fuente
COPY . .

# Construir la aplicación
RUN npm run build

# Etapa de producción con NGINX
FROM nginx:alpine

# Copiar archivos generados de Quasar
COPY --from=build /app/dist/spa /usr/share/nginx/html

# Copiar configuración de nginx optimizada para SPA Vue/Quasar
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponer puerto 80
EXPOSE 80

# Agregar healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1

# Iniciar nginx
CMD ["nginx", "-g", "daemon off;"]