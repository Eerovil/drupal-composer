FROM registry.gitlab.com/janpoboril/drupal-composer-docker:7.1-apache

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN mkdir -p /var/www/drupal/config/sync

COPY ./composer.json /var/www/drupal/
COPY ./load.environment.php /var/www/drupal/
COPY ./phpunit.xml.dist /var/www/drupal/
COPY ./scripts /var/www/drupal/scripts

RUN composer global require hirak/prestissimo


RUN composer install