FROM registry.gitlab.com/janpoboril/drupal-composer-docker:7.2-apache
RUN apt-get update && apt-get -y install \
    wget \
    curl \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -M -s /bin/bash -G www-data,staff -d /var/www/drupal drupal

RUN chown -R drupal /var/www/drupal
USER drupal

RUN mkdir -p /var/www/drupal/config/sync

COPY ./composer.json /var/www/drupal/composer.json
COPY ./composer.lock /var/www/drupal/composer.lock
COPY ./load.environment.php /var/www/drupal/
COPY ./phpunit.xml.dist /var/www/drupal/
COPY ./scripts /var/www/drupal/scripts

RUN mkdir -p /var/www/drupal/.composer/
RUN echo "{}" > /var/www/drupal/.composer/composer.json

RUN composer global require hirak/prestissimo

RUN composer install --prefer-dist

# Install drush command globally
RUN composer global require drush/drush:9.*
RUN composer global update
RUN ln -s /var/www/drupal/.composer/vendor/bin/drush /usr/local/bin/drush

# composer.json will be bound to the host, so remove it here for clarity
RUN rm /var/www/drupal/composer.json
RUN rm /var/www/drupal/composer.lock

# Extra chowns, here to keep previous caches. (May change often)
USER root
RUN chown -R drupal /var/lock/apache2/
RUN chown -R drupal /var/run/apache2/
USER drupal