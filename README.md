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
  - `INSTALL_DEV_DEPS_AT_RUNTIME`: if set set then allows dev dependencies (e.g. debug bar) and run `yarn run dev`


## Advanced configuration

If more advanced configuration is needed, all configuration files can be overridden with explicit `COPY` commands. You could copy the original files from this repo into your own project, change them and then override the original file by adding a `COPY` command to override the file in your container.

This is where the original configuration files are copied:

| **File location in repo** | **File location in container** | **Notes** |
| --- | --- | --- |
| [`./config/fastcgi-php.conf`](/config/fastcgi-php.conf) | `/etc/nginx/fastcgi-php.conf` | |
| [`./config/nginx.conf`](/config/nginx.conf) | `/etc/nginx/nginx.conf` | |
| [`./config/php-fpm.conf`](/config/php-fpm.conf) | `/usr/local/etc/php/php-fpm.conf` | |
| [`./config/php-fpm.conf`](/config/php.ini) | `/usr/local/etc/php/php.ini` | |
| [`./config/start.sh`](/config/start.sh) | `/usr/bin/start.sh` | Needs to be executable |
| [`./config/nginx-healthcheck.sh`](/config/nginx-healthcheck.sh) | `/usr/bin/nginx-healthcheck.sh` | Needs to be executable |
| [`./config/supervisord.ini`](/config/supervisord.ini) | `/etc/supervisor.d/supervisord.ini` | |


## Testing the image

A sample `index.php` file is automatically created in `/app/public/index.php`.

This allows to easily test the container locally without having to setup a full Laravel application.

One approach you could be using for testing configuration changes is the following:

### 1. Build the container locally

```bash
docker build . -t laravel-nginx-local
```

### 2. Run the container with a bash prompt

```bash
docker run -it laravel-nginx-local bash
```

### 3. Start supervisord

Inside the bash prompt within the container:

```bash
supervisord -c /etc/supervisor.d/supervisord.ini -l /var/log/supervisord.log -j /var/run/supervisord.pid;
```

This should already show if you are able to start php-fpm and nginx correctly.

### 4. Run another bash prompt in the container

In another terminal you can get the container id with:

```bash
docker ps
```

Then you can run another bash terminal inside the same container with:

```bash
docker exec -it <container_id> bash
````

In this new shell you could for instance run:

```bash
curl -vvv localhost
```

To see if nginx is able to connect to php-fpm and render the sample `index.php` page.


## Contributing

Everyone is very welcome to contribute to this project.
You can contribute just by submitting bugs or suggesting improvements by
[opening an issue on GitHub](https://github.com/lmammino/laravel-nginx/issues).


## License

Licensed under [MIT License](LICENSE). © Luciano Mammino

