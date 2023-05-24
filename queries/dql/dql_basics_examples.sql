
--Retrieve all columns from a table:
  /*This query selects all columns from the "employees" table and retrieves all rows.*/
    SELECT * FROM employees;


--Retrieve specific columns from a table:
  /*This query selects the "name" and "age" columns from the "students" table and retrieves all rows.*/
    SELECT name, age FROM students;


--Retrieve data with a condition:
  /*This query selects all columns from the "orders" table where the "status" column is set to 'completed'. It retrieves only the rows that meet this condition.*/
    SELECT * FROM orders WHERE status = 'completed';


--Retrieve data with multiple conditions:
  /*This query selects all columns from the "products" table where the "price" column is greater than 50 and the "category" column is set to 'electronics'. It retrieves only the rows that satisfy both conditions.*/
    SELECT * FROM products WHERE price > 50 AND category = 'electronics';


--Retrieve data with sorting:
  /*This query selects the "name" and "age" columns from the "students" table and retrieves all rows. The result is sorted in descending order based on the "age" column.*/
    SELECT name, age FROM students ORDER BY age DESC;
