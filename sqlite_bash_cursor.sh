#!/usr/bin/env bash
#
# SQLite Cursor
# A cursor style SQLite connection for Bash (usig coprocess)
#
# Copyright (C) 2017  Giovanni Nunes <giovanni.nunes@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

set -u

VERSION='1'

if [[ ${SQLITE_DEBUG} == true ]]; then
    RED=$( tput setaf 3 )
    RST=$( tput sgr0 )
fi

sqlite_connect(){
    #
    # sqlite_connect:
    # Creates a coprocess to access SQLite database.
    #
    # Use:
    #   sqlite_connect "<< sqlite database filename >>"
    #
    # Example:
    #   sqlite_connect "./db/database.db"
    #
    local db="${1}"
    if [[ -f "${db}" ]]; then
        coproc CURSOR {
            $( which sqlite3 ) -separator ${SQLITE_SEPARATOR} "${db}" ;
        }
        SQLITEPID=$( jobs -l -r | grep 'CURSOR' )
        SQLITEPID=$( echo -n ${SQLITEPID} | cut -d\  -f2 )
        SEND="${CURSOR[1]}"
        RECV="${CURSOR[0]}"
        sqlite_debug "SQLite's PID is ${SQLITEPID} and the file descriptors are '>&${SEND}' and '<&${RECV}'."
    else
        echo "Database '${db}' not found!"
        exit 2
    fi
}


sqlite_disconnect(){
    #
    # sqlite_disconnect:
    # Kills SQLITE coprocess.
    #
    # Use:
    #   sqlite_disconnect
    #
    # There is no parameters.
    #
    echo ".quit" >&${SEND?"Not connected!"}
    [[ SQLITE_DEBUG ]] && sqlite_debug "Stoping coprocess."
}


sqlite_fetch(){
    #
    # sqlite_fetch:
    # Fetches one line of query result and sends to STDOUT.
    #
    # Use:
    #   sqlite_fetch
    #
    # There is no parameters.
    #
    sqlite_debug "Receiving from '<&${RECV}'."
    local let sqlite_counter=-1
    local let sqlite_line_fetch=''
    while [[ true ]] ; do
        # while loop runs in a subshell, needs a trick..
        if (( sqlite_counter == -1 )); then
            echo "select 'END OF QUERY';" >/proc/${SQLITEPID}/fd/0
        else
            sqlite_debug "Fetching #${sqlite_counter} from '<&${RECV}'."
        fi
        read sqlite_line_fetch </proc/${SQLITEPID}/fd/1
        [[ "${sqlite_line_fetch}" = "END OF QUERY" ]] && break
        echo "${sqlite_line_fetch}"
        let sqlite_counter++
    done
}


sqlite_query(){
    #
    # sqlite_query:
    # Sends a SQL query to the database.
    #
    # Use:
    #   sqlite_query "<< SQL query >>"
    #
    # Example:
    #   sqlite_query "select id,name,address,phone from phonebook"
    #
    sqlite_debug "Sending \`\`${1}\`\` to '>&${SEND}'."
    echo -e "${1}\n;" >&${SEND}
}


sqlite_debug(){
    #
    # sqlite_debug:
    # Prints debug messages if SQLITE_DEBUG variable is set in 'true'
    #
    # Use:
    #   sqlite_debug "<< debug message >>"
    #
    # Exxample:
    #   sqlite_debug "Fetching record..."
    #
    if [[ ${SQLITE_DEBUG} == true ]]; then
       echo -e "${RED}<DEBUG>${RST} ${1}" >&2
    fi
}

# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
