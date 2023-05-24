
/* Data Manipulation Language
   DML is used for inserting, deleting, and updating data in a database. It is used to retrieve and
   manipulate data in a relational database. It includes INSERT, UPDATE, and DELETE. Let's discuss
   these commands one at a time. */


/* INSERT
    Insert statement is used to insert data in a SQL table. Using the Insert query, we can add one
    or more rows to the table. Following is the syntax of the MySQL INSERT Statement. */

    INSERT INTO table_name
    (attribute1, attribute2, ...)
    VALUES(val1, val2, ...)

    -- Let's take a quick instance for understanding this better. Suppose that we need to insert 2 rows {"myName3", 2, true} and {"myName4", 28, false}. This is how we would accomplish that:
    -- We don't necessarily have to include all column values. We can for example omit the age column as shown below:
    insert into my_table
    values("myName3", 5, false),
    ("myName4", 51, true);


/* UPDATE
    This command is used to make changes to the data in the table. Its syntax is: */

    UPDATE table_name
    SET column1 = val1,
    column2 = val2,
    ...
    WHERE CLAUSE;
    
    -- How about we update the employment status of myName of age 12 which has it as NULL? This is how we achieve it:

    update my_table
    set employed=true
    where age=12;


/* DELETE
    This command is used to remove a row from a table. the syntax for delete is */

    DELETE FROM table_name
    WHERE CLAUSE;
    
    -- The where clause is optional. To delete the row with first_name "myName5 run this query:

    delete from my_table
    where first_name = "myName5";
    
    -- It is to be noted that omitting the use where clause results in the emptying of the table just as truncating does.
