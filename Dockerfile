# Stage 1: Build Stage
FROM composer:2 as build

WORKDIR /app

COPY . .

RUN composer install --no-scripts --no-autoloader && \
    composer dump-autoload --optimize

# Stage 2: Production Stage
FROM php:8.2-apache

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

# Apache configuration
COPY apache-config/000-default.conf /etc/apache2/sites-available/000-default.conf

# Enable Apache modules and configure the default virtual host
RUN a2enmod rewrite && \
    sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/sites-available/000-default.conf

# Copy files from the build stage
COPY --from=build /app .

# Adjust file ownership to allow Symfony to write to the cache directory
RUN chown -R www-data:www-data var

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
