
/*Some basic DML (Data Manipulation Language) examples. 
Here are a few examples for each DML operation: SELECT, INSERT, UPDATE, and DELETE.
 These examples assume a hypothetical "users" table with columns "id," "name," and "email." */

--SELECT example:
    --This query retrieves all columns and rows from the "users" table.
    SELECT * FROM users;

-- INSERT example:
    --This query inserts a new row into the "users" table with the specified name and email values.
    INSERT INTO users (name, email) VALUES ('John Doe', 'johndoe@example.com');
    
-- UPDATE example:
    -- This query updates the name of the user with ID 1 to "Jane Smith" in the "users" table.
    UPDATE users SET name = 'Jane Smith' WHERE id = 1;

-- DELETE example:
    -- This query deletes the row with ID 2 from the "users" table.
    DELETE FROM users WHERE id = 2;

