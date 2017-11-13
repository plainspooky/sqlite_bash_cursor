# sqlite_bash_cursor

A cursor like SQLite connection for Bash scripts using coprocess.

## Functions

There are few functions that implements communication between Bash and SQLite.

### sqlite_connect

Creates a coprocess to access SQLite database.

Use:
**sqlite_connect** "_sqlite database filename_"

Example:
``` bash
sqlite_connect "./db/database.db"
```

### sqlite_disconnect

Kills SQLITE coprocess.

Use:
** sqlite_disconnect **

### sqlite_fetch
Fetches one line of query result and sends to STDOUT.

Use:
**sqlite_fetch**

Example:
``` bash
sqlite_fetch | while read LINE; do
   echo "${LINE}"
done
```

### sqlite_query

Sends a query to the database.

Use:
**sqlite_query** "_SQL query_"

Example:
``` bash
sqlite_query "select id,name,address,phone from phonebook"
```

### sqlite_debug

Prints debug messages if **SQLITE_DEBUG** variable is set in 'true'.

Use:
**sqlite_debug** "_debug message_"

Example:
``` bash
sqlite_debug "Fetching record..."
```
