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
            docker-compose exec web drush config-set "system.site" uuid $DRUPAL_SITE_UUID -y
            docker-compose exec web drush csex $args
            ;;
        import)
            args=$*
            if [ "$args" == "" ]; then
                args="-y"
            fi
            docker-compose exec web drush config-set "system.site" uuid $DRUPAL_SITE_UUID -y
            docker-compose exec web drush csim $args
            ;;
        *)
            docker-compose exec web $command $*
        ;;
    esac
}