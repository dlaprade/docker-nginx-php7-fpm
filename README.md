# docker-nginx-php7-fpm

# Prerequisites
* Docker
* Existing PHP application code

# Build
* docker build . -t <TAG_NAME>

# Run
* docker run -p 8000:80 -v "<LOCATION_OF_PHP_CODE>":/app <TAG_NAME>
