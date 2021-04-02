#!/bin/dash

# Call the global script helper to verify the data
{% if system.debug %}
/usr/local/sbin/homebox-backup --action check-data --config '{{ location.name }}' --log-level DEBUG
{% else %}
/usr/local/sbin/homebox-backup --action check-data --config '{{ location.name }}'
{% endif %}
