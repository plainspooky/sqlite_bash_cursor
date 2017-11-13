#!/usr/bin/env bash
# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4

# # # #
#
#   'sqlite_bash_cursor' example program
#   v1.0
#
# # # #

SQLITE_DEBUG=true
SQLITE_SEPARATOR=";;;"
source sqlite_bash_cursor.sh

# Creates database if needed...
[[ ! -f "./example.db" ]] && {
    echo "Creating database";
    $( which sqlite3 ) ./example.db <./example.sql;
}

#
# Connect to the database
#
sqlite_connect "./example.db"

#
# Insert a record
#
sqlite_query "INSERT INTO users (name,address,email,phone,sites) VALUES('Giovanni dos Reis Nunes','${$}, None Street','giovanni@donotexist.org','(99) 9999-8888','giovannireisnunes.wordpress.com,www.retrocomputaria.com.br');"

#
# Query records
#
sqlite_query "select * from users"
sqlite_fetch | while read LINE; do
   echo "${LINE}"
done

#
# Disconnect
#
sqlite_disconnect

