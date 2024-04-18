# Stage 1: Build the frontend files
FROM node:latest as frontend

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

# Stage 2: Build Laravel backend
FROM php:8.2-fpm as backend

WORKDIR /app

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install PHP dependencies
# TODO: Check if this is mandatory
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    && docker-php-ext-install zip pdo pdo_mysql \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY . .
COPY --from=frontend /app/public ./public

RUN composer install --no-interaction --no-plugins --no-scripts --prefer-dist

# EXPOSE 8000

ENTRYPOINT ["./docker_entrypoint.sh"]
