#!/bin/sh
set -e
echo "***** Setting permisition *****"
chown -R mongodb:mongodb /data/*

echo "***** Checking mongod.conf ********"

if [ -f "/data/config/mongod.conf" ]; then
    echo "** Start by /data/config/mongod.conf **"
    exec gosu mongodb mongod --config /data/config/mongod.conf &
    mongo_pid=$!
    sleep 10
        if [ $(mongo dashboarddb --eval "db.getUsers();" | grep dashboarduser | awk 'FNR == 2 {print}' | awk -F '"' '{print $4}') == "dashboarduser" ]; then
        echo "dashboarduser exists"
        else
        mongo < /docker-entrypoint-initdb.d/db-setup.js
        fi
    wait $mongo_pid
else
    echo "** Start by default config **"
    exec gosu mongodb mongod &
fi