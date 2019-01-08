FROM registry.gitlab.com/janpoboril/drupal-composer-docker:7.1-apache

COPY ./composer.json /var/www/drupal/
COPY ./load.environment.php /var/www/drupal/
COPY ./phpunit.xml.dist /var/www/drupal/
COPY ./scripts /var/www/drupal/scripts