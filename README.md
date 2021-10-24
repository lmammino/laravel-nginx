# laravel-nginx

[![Publish Docker image](https://github.com/lmammino/laravel-nginx/actions/workflows/publish.yml/badge.svg)](https://github.com/lmammino/laravel-nginx/actions/workflows/publish.yml)
[![On Docker Hub](https://img.shields.io/docker/stars/loige/laravel-nginx)](https://hub.docker.com/r/loige/laravel-nginx)
[![MIT License](https://img.shields.io/github/license/lmammino/laravel-nginx)](/LICENSE)

A base image for running Laravel apps on Docker.


## Image spec

This image allows to run Laravel applications using:

  - Nginx
  - php-fpm
  - supervisord (as parent process for both Nginx and php-fpm)

It offers a sensible configuration for running Laravel in both development and production environments.


## Usage

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


## Configuration

The image can be configured at build time using build args and at runtime using environment variables

### Build arguments

  - `platform` (default `linux/amd64`): can be used to build the image for different platforms.

### Environment variables

  - `RUN_MIGRATIONS`: if set it will run the migrations at runtime.


## Contributing

Everyone is very welcome to contribute to this project.
You can contribute just by submitting bugs or suggesting improvements by
[opening an issue on GitHub](https://github.com/lmammino/laravel-nginx/issues).


## License

Licensed under [MIT License](LICENSE). © Luciano Mammino
