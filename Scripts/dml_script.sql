## Switch to the mysql db. Create a new user.
# INSERT INTO [table name] (Host,User,Password) VALUES('%','user',PASSWORD('password'));

## Change a users password.(from unix shell).
# [mysql dir]/bin/mysqladmin -u root -h hostname.blah.org -p password 'new-password'

## Change a users password.(from MySQL prompt).
# SET PASSWORD FOR 'user'@'hostname' = PASSWORD('passwordhere');

## Switch to mysql db.Give user privilages for a db.
# INSERT INTO [table name] (Host,Db,User,Select_priv,Insert_priv,Update_priv,Delete_priv,Create_priv,Drop_priv) VALUES ('%','db','user','Y','Y','Y','Y','Y','N');

## To update info already in a table.
# UPDATE [table name] SET Select_priv = 'Y',Insert_priv = 'Y',Update_priv = 'Y' where [field name] = 'user';

##Delete a row(s) from a table.
# DELETE from [table name] where [field name] = 'whatever_condition';