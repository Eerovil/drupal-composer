FROM registry.gitlab.com/janpoboril/drupal-composer-docker:7.1-apache
RUN apt-get update && apt-get -y install \
    wget \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -M -s /bin/bash -G www-data,staff -d /var/www/drupal drupal

RUN chown -R drupal /var/www/drupal
USER drupal

RUN mkdir -p /var/www/drupal/config/sync

# Change composer file for build step
ENV COMPOSER composer_tmp.json
COPY ./composer.json /var/www/drupal/composer_tmp.json
COPY ./composer.lock /var/www/drupal/composer_tmp.lock
COPY ./load.environment.php /var/www/drupal/
COPY ./phpunit.xml.dist /var/www/drupal/
COPY ./scripts /var/www/drupal/scripts

RUN composer global require hirak/prestissimo

RUN composer install

# Install drush command globally
RUN composer global require drush/drush:9.*
RUN composer global update
RUN ln -s /var/www/drupal/.composer/vendor/bin/drush /usr/local/bin/drush

# Change composer file back. The file composer.json is bound to the host
# with volumes, but cannot be used here just yet.
ENV COMPOSER composer.json
RUN rm /var/www/drupal/composer_tmp.json
RUN rm /var/www/drupal/composer_tmp.lock

# Extra chowns, here to keep previous caches. (May change often)
USER root
RUN chown -R drupal /var/lock/apache2/
RUN chown -R drupal /var/run/apache2/
USER drupal