FROM bitnami/php-fpm

# Copy PHP files
COPY index.php /app
WORKDIR /app

# Expose and start PHP-FPM
EXPOSE 9000
CMD [ "php-fpm", "-F", "--pid", "/opt/bitnami/php/tmp/php-fpm.pid", "-y", "/opt/bitnami/php/etc/php-fpm.conf" ]