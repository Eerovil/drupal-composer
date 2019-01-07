FROM registry.gitlab.com/janpoboril/drupal-composer-docker:7.1-apache

COPY composer /var/www/drupal

WORKDIR /var/www/drupal

RUN composer install