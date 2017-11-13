# sqlite bash cursor

Implements a "cursor like" interface between **SQLite** and **Bash** using coprocess.

## How it works

Implements asynchronous communication between Bash and SQLite. The database manager runs in parallel as coprocess of Bash. Only one SQLite's instance is started per script execution and data sent and received by file descriptors.

## Functions

There are few functions that implements communication between Bash and SQLite.

### sqlite_connect

Creates a coprocess to access SQLite database.

Use: **sqlite_connect** "_sqlite database filename_"

Example:

``` bash
sqlite_connect "./db/database.db"
```

### sqlite_disconnect

Kills SQLite coprocess.

Use: **sqlite_disconnect**

### sqlite_fetch

Fetches one line of query result and sends it to STDOUT.

Use: **sqlite_fetch**

Example:

``` bash
sqlite_fetch | while read LINE; do
   echo "${LINE}"
done
```

### sqlite_query

Sends a query to database.

Use: **sqlite_query** "_SQL query_"

Example:

``` bash
sqlite_query "select id,name,address,phone from phonebook"
```

### sqlite_debug

Prints debug messages if **SQLITE_DEBUG** variable is set in 'true'.

Use: **sqlite_debug** "_debug message_"

Example:

``` bash
sqlite_debug "Fetching record..."
```

## Sample code

To more information take a look at ```example.sh```, it contains an example of
how to use this library.
