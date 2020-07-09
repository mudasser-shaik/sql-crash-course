
## DDL - CREATE , DROP , TRUNCATE , ALTER
# List all databases on the sql server.
show databases ;

# Create a database on the sql server.
# create database [database name];
create database magnimindSQL;

# Switch to a database.
# use [db name];
use magnimindSQL;

# To see all the tables in the database.
show tables;

## CRATE TABLE
# CREATE TABLE [table name] (
#   [Column1] VARCHAR(20),
#   [Column2] INT(3),
#   [Column3] DOUBLE(35),
#   [Column4] DATE,
#   [Column5] time,
#   [Column6] VARCHAR(255));

CREATE TABLE magnimindUsers (
        firstname VARCHAR(20),
        middleinitial VARCHAR(3),
        lastname VARCHAR(35),
        suffix VARCHAR(3),
        batchid VARCHAR(10),
        datestamp DATE,
        timestamp time,
        email VARCHAR(255));

# To see database's field Types, NullCheck , KEYS, Formats.
# describe [table name];
describe magnimindUsers;

# Returns the columns and column information pertaining to the designated table.
# show columns from [table name];
show columns from magnimindUsers;

# Delete a column.
# alter table [table name] drop column [column name];
alter table magnimindUsers drop column suffix;

# Add a new column to db.
# alter table [table name] add column [new column name] [dataType] (20);
alter table magnimindUsers add column address varchar (20);

### NOTE -
## Change column name.
# alter table [table name] change [old column name] [new column name] varchar (50);
## Make a unique column so you get no dupes.
# alter table [table name] add unique ([column name]);
## Make a column bigger.
# alter table [table name] modify [column name] VARCHAR(3);
## Delete unique from table.
# alter table [table name] drop index [colmn name];

# To delete a table.
# drop table [table name];
drop table magnimindUsers;

# To delete a database.
# drop database [database name];
drop database magnimindSQL;

## NOTE:
# DROP and TRUNCATE are DDL commands, whereas DELETE is a DML command.
# DELETE operations can be rolled back (undone), while DROP and TRUNCATE operations cannot be rolled back

# Lets import the classicmodels Database via Docker
# [mysql_dir]/bin/mysql -u username -ppassword databasename < /tmp/databasename.sql

use classicmodels;
describe customers;

# Show all data in a table.
# SELECT * FROM [table name];
SELECT * FROM customers;

