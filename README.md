# laravel-nginx

A base image for running Laravel apps on Docker


# Usage

In your Laravel project create a `Dockerfile` with the following content:

```Dockerfile
FROM loige/laravel-nginx

# copy your sources in /app within the container
COPY . .

# Install PHP dependencies
RUN composer install --optimize-autoloader --no-dev
RUN chown -R www-data:www-data /app

# Install JavaScript/Node.js dependencies with NPM, compile assets with Mix
RUN yarn && yarn run production
```