# docker-nginx-php7-fpm

# Description
* A Docker project initial created to work with Craft CMS 3

# Prerequisites
* Docker
* Existing PHP application code

# Build
* docker build . -t <TAG_NAME>

# Run
* docker run -p 8000:80 -v "<LOCATION_OF_PHP_CODE>":/app <TAG_NAME>

# References
Built based upon two other docker based projects
* https://github.com/terbolous/docker-php-fpm
* https://github.com/terbolous/docker-nginx-craft3
