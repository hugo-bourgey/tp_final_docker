# Stage 1: Build Stage
FROM composer:2 as build

WORKDIR /app

COPY . .

RUN composer install --no-scripts --no-autoloader && \
    composer dump-autoload --optimize --no-dev

# Stage 2: Production Stage
FROM php:7.4-apache

WORKDIR /var/www/html

# Install dependencies and PHP extensions
RUN apt-get update && \
    apt-get install -y \
        libicu-dev \
        libzip-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure intl && \
    docker-php-ext-install \
        pdo_mysql \
        intl \
        zip \
    && a2enmod rewrite

# Copy files from the build stage
COPY --from=build /app .

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
