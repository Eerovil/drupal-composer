alias dex="docker-compose exec web drush csex -y"
alias dim="docker-compose exec web drush csim -y"


function drupal() {
    command=$1
    shift

    source ./web.env
    # cd "$DRUPAL_DOCKER_ROOT" || exit
    case "$command" in
        export)
            args=$*
            if [ "$args" == "" ]; then
                args="-y"
            fi
            docker-compose exec web drush csex $args
            ;;
        import)
            args=$*
            if [ "$args" == "" ]; then
                args="-y"
            fi
            docker-compose exec web drush csim $args
            ;;
        initial_import)
            args=$*
            if [ "$args" == "" ]; then
                args="-y"
            fi
            # site uuid must match
            docker-compose exec web drush config-set "system.site" uuid $DRUPAL_SITE_UUID -y
            # the default shortcuts must be deleted...?
            # https://drupal.stackexchange.com/questions/184495/config-import-error-these-entities-need-to-be-deleted-before-importing
            docker-compose exec web drush ev '\Drupal::entityManager()->getStorage("shortcut_set")->load("default")->delete();'
            # First to regular import. This contains configuration for config_split
            docker-compose exec web drush cim $args
            # Now do config_split import.
            docker-compose exec web drush csim $args
            ;;
        install)
            docker-compose exec web drush si -y --account-name=$DRUPAL_ADMIN_USERNAME --account-pass=$DRUPAL_ADMIN_PASSWORD --locale=$DRUPAL_LOCALE
            ;;
        composer-reload)
            docker-compose rm -svf web
            docker-compose build --no-cache web
            docker-compose up -d
            ;;
        *)
            docker-compose exec web $command $*
        ;;
    esac
}