#!/bin/sh

DATABASE=$1

if [ -z "$DATABASE" ]; then
    echo I need a database
    exit 1
fi

python3 ./pre-migration.py --db_name=$DATABASE --db_user=odoo

VERSIONS=$(eval echo bin/start_openupgrade*)
for version in $VERSIONS; do
    $version --db_user odoo --db_password= --update=all --stop-after-init --database=$DATABASE || exit 1
done

python3 ./post-migration.py --db_name=$DATABASE --db_user=odoo
