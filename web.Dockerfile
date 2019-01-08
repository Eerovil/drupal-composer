FROM registry.gitlab.com/janpoboril/drupal-composer-docker:7.1-apache
RUN apt-get update && apt-get -y install \
    wget \
  && rm -rf /var/lib/apt/lists/*

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN mkdir -p /var/www/drupal/config/sync

COPY ./composer.json /var/www/drupal/
COPY ./load.environment.php /var/www/drupal/
COPY ./phpunit.xml.dist /var/www/drupal/
COPY ./scripts /var/www/drupal/scripts

RUN composer global require hirak/prestissimo

RUN composer install

# Install drush command globally
RUN composer global require drush/drush:9.*
RUN composer global update
RUN ln -s /root/.composer/vendor/bin/drush /usr/local/bin/drush
