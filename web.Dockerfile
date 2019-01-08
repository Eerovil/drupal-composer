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

# Install Drush 6.
RUN composer global require drush/drush:6.*
RUN composer global update
RUN ln -s /root/.composer/vendor/bin/drush /usr/local/bin/drush

# Add drush registry_rebuild command https://www.drupal.org/project/registry_rebuild
RUN wget http://ftp.drupal.org/files/projects/registry_rebuild-7.x-2.2.tar.gz && \
    tar xzf registry_rebuild-7.x-2.2.tar.gz && \
    rm registry_rebuild-7.x-2.2.tar.gz && \
    mv registry_rebuild /root/.composer/vendor/drush/drush/commands

RUN composer install