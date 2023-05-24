
/* Complex examples of DQL queries. */

-- JOIN example:
    --This query retrieves the name of the user, along with the order ID and order date, by joining the "users" table with the "orders" table based on the user ID.
        SELECT users.name, orders.order_id, orders.order_date
        FROM users
        INNER JOIN orders ON users.id = orders.user_id;

    --In this query, we are retrieving information related to customers, orders, order items, and products. The query performs the following joins:
        SELECT customers.customer_id, customers.name, orders.order_id, products.product_name, order_items.quantity
        FROM customers
        INNER JOIN orders ON customers.customer_id = orders.customer_id
        INNER JOIN order_items ON orders.order_id = order_items.order_id
        INNER JOIN products ON order_items.product_id = products.product_id
        WHERE customers.country = 'USA'
            AND orders.order_date >= '2022-01-01'
            AND products.category = 'Electronics';
        
        /* 
        -Joining the "customers" table with the "orders" table using the common column "customer_id".
        -Joining the resulting table with the "order_items" table based on the "order_id" column.
        -Finally, joining the previous table with the "products" table using the "product_id" column.
        -The query includes some conditions as well:
         -Only customers from the USA are selected (customers.country = 'USA').
         -Only orders placed on or after January 1, 2022, are considered (orders.order_date >= '2022-01-01').
         -Only products in the "Electronics" category are included (products.category = 'Electronics').*/



--Subquery example:
    /*This query retrieves the name and email of users who have placed orders with a total amount greater than 100. 
      The subquery is used to get the user IDs meeting the condition, which is then used in the main query.*/
        SELECT name, email
        FROM users
        WHERE id IN (SELECT user_id FROM orders WHERE total_amount > 100);


    /*In this example, the subquery is used to calculate the average total items per order. The main query then selects
      customer, order, and total items information from multiple tables based on certain conditions.*/
        SELECT c.customer_id, c.name, o.order_id, o.order_date, oi.total_items
        FROM customers c
        INNER JOIN orders o ON c.customer_id = o.customer_id
        INNER JOIN (
            SELECT order_id, SUM(quantity) AS total_items
            FROM order_items
            GROUP BY order_id
        ) oi ON o.order_id = oi.order_id
        WHERE oi.total_items > (
            SELECT AVG(total_items)
            FROM (
                SELECT order_id, SUM(quantity) AS total_items
                FROM order_items
                GROUP BY order_id
            ) subquery
        );


        /*-The subquery calculates the total items per order by grouping the rows in the order_items table by order_id
           and summing the quantity.
          -The main query joins the customers and orders tables based on the customer_id and performs an inner join with
           the subquery result, aliased as oi, using the order_id.
          -The outer WHERE clause filters the results based on the total_items calculated in the subquery. It compares the
           total_items in each order (oi.total_items) with the average total_items across all orders calculated in the subquery.*/



--Conditional statement example:
    --This query updates the "status" column of the "users" table based on the condition. Users who haven't logged in within the last 6 months are marked as "inactive," while others are marked as "active."
    UPDATE users
    SET status = CASE
        WHEN last_login < DATE_SUB(NOW(), INTERVAL 6 MONTH) THEN 'inactive'
        ELSE 'active'
        END;


--Aggregate function example:
    -- This query calculates the average price and total count of products in the "Electronics" category using the AVG and COUNT aggregate functions, respectively.
    SELECT AVG(price) AS average_price, COUNT(*) AS total_count
    FROM products
    WHERE category = 'Electronics';


 --Dynamic column names using a similar approach as in the previous example. Here's an example using T-SQL:
    DECLARE @columnName NVARCHAR(50) = 'product_name';
    DECLARE @sql NVARCHAR(MAX);

    SET @sql = N'SELECT ' + QUOTENAME(@columnName) + N' FROM products';

    EXEC sp_executesql @sql;


--Coalescence
    /* Coalescence, in the context of SQL, refers to the COALESCE function, which is used to return the first non-null expression from
     a list of expressions. It allows you to provide a fallback value or alternative in case a particular expression evaluates to null.
       
       The syntax of the COALESCE function is as follows:
           COALESCE(expression1, expression2, expression3, ...)
       
       The function takes multiple expressions as arguments and returns the value of the first non-null expression from the provided list.

       The COALESCE function is useful when you want to handle null values gracefully and provide a default or alternative
       value in your queries. It helps in simplifying and enhancing the readability of your code by reducing the need for complex 
       null-checking logic.*/

    --Basic COALESCE usage:
      --This query selects the first non-null value among column1, column2, and column3 from the specified table.
            SELECT COALESCE(column1, column2, column3) AS result
            FROM table;
    
    --COALESCE with literal values:
      /*In this example, if column1 is null, the COALESCE function returns the literal value 'N/A'. It allows you to provide a default
        value when a column value is null.*/
            SELECT COALESCE(column1, 'N/A') AS result
            FROM table;

    --COALESCE in conjunction with a subquery:
      /*Here, if column1 is null, the COALESCE function retrieves a value from a subquery. It can be useful when you need to replace null
        values with dynamically retrieved values.*/
            SELECT COALESCE(column1, (SELECT value FROM other_table WHERE condition)) AS result
            FROM table;

    --Nesting COALESCE functions:
      /*This example demonstrates nesting COALESCE functions. If column1 is null, it checks column2, and if column2 is also null,
        it finally checks column3. It allows you to prioritize fallback values in a cascading manner.*/
            SELECT COALESCE(COALESCE(column1, column2), column3) AS result
            FROM table;


    --COALESCE with aggregate functions:
      /*In this case, the COALESCE function is used with the SUM aggregate function. If the result of the SUM operation is null
       (e.g., when no rows match the conditions), the COALESCE function returns 0 as the result. It provides a default value for the aggregate result.*/
            SELECT COALESCE(SUM(column1), 0) AS result
            FROM table;


--DATE functions:

    --Finding the age of employees:
        /*This query calculates the age of employees by subtracting their birth dates from the current date using the DATEDIFF function.
          It returns the employee name and their age in years.*/
            SELECT employee_name, DATEDIFF(YEAR, birth_date, GETDATE()) AS age
            FROM employees;


    --Calculating the number of months between two dates:
        /*This example uses the DATEDIFF function to calculate the number of months between the start_date and end_date columns in 
          the projects table. It returns the month difference as an integer value.*/
            SELECT DATEDIFF(MONTH, start_date, end_date) AS month_diff
            FROM projects;

    --Extracting the year and month from a date:
        /*This query uses the DATEPART function to extract the year and month from the order_date column in the orders table. It returns
          the order year and order month as separate columns.*/  
            SELECT DATEPART(YEAR, order_date) AS order_year, DATEPART(MONTH, order_date) AS order_month
            FROM orders;

    --Adding a specific number of days to a date:
        /*In this example, the DATEADD function is used to add 7 days to the order_date column in the orders table. It returns the original
          order date and the new order date after adding 7 days.*/
            SELECT order_date, DATEADD(DAY, 7, order_date) AS new_order_date
            FROM orders;


    --Formatting the date in a specific style:
        /*This query uses the CONVERT function to format the order_date column in the orders table using the style 103 (dd/mm/yyyy).
          It returns the original order date and the formatted date as a string.*/
            SELECT order_date, CONVERT(VARCHAR(10), order_date, 103) AS formatted_date
            FROM orders;

--String manipulation functions
    
    --Concatenating multiple columns with a separator:
      --This query uses the CONCAT function to concatenate the values of column1, column2, and column3, with a hyphen (-) as the separator.
            SELECT CONCAT(column1, ' - ', column2, ' - ', column3) AS concatenated_string
            FROM table;

    --Extracting a substring based on a pattern:
      /*This example uses the SUBSTRING function with PATINDEX to extract a numeric substring from column1. It searches for the first
        occurrence of a digit and the first occurrence of a non-digit character, and retrieves the substring in between.*/
            SELECT SUBSTRING(column1, PATINDEX('%[0-9]%', column1), PATINDEX('%[^0-9]%', column1 + 'X') - PATINDEX('%[0-9]%', column1) + 1) AS extracted_number
            FROM table;
        
    --Replacing multiple patterns within a string:
      /*In this query, the REPLACE function is used to replace occurrences of both 'foo' and 'abc' in column1 with 'bar' and 'xyz', respectively.*/
            SELECT REPLACE(REPLACE(column1, 'foo', 'bar'), 'abc', 'xyz') AS replaced_string
            FROM table;
        
    --Converting a string to title case:
      /*This example uses UPPER and LOWER functions in conjunction with SUBSTRING to convert the first letter of column1 to uppercase
        and the remaining letters to lowercase, effectively transforming it to title case.*/
            SELECT CONCAT(UPPER(SUBSTRING(column1, 1, 1)), LOWER(SUBSTRING(column1, 2, LEN(column1) - 1))) AS title_case_string
            FROM table;
        
    --Removing leading and trailing whitespace from a string:
        /*The LTRIM and RTRIM functions are used here to remove leading and trailing whitespace (spaces) from column1, respectively,
          resulting in a trimmed string.*/
            SELECT LTRIM(RTRIM(column1)) AS trimmed_string
            FROM table;



--Conditional functions in SQL:

    --Using CASE to categorize data based on conditions:
      /*In this query, the CASE statement is used to categorize data in column2 based on different conditions. It assigns the corresponding 
       category ('High', 'Medium', or 'Low') to each row in the result.*/
            SELECT column1,
                CASE
                    WHEN column2 > 100 THEN 'High'
                    WHEN column2 > 50 THEN 'Medium'
                    ELSE 'Low'
                END AS category
            FROM table;
        
    --Applying multiple conditions with nested CASE statements:
      /*This example showcases nested CASE statements. It applies different conditions based on the value of column2 and column3 to
        determine the resulting value in the result column.*/
            SELECT column1,
                CASE
                    WHEN column2 = 'A' THEN 
                        CASE
                            WHEN column3 > 10 THEN 'X'
                            ELSE 'Y'
                        END
                    WHEN column2 = 'B' THEN 'Z'
                    ELSE 'Other'
                END AS result
            FROM table;
            

    --Using NULLIF to handle division by zero:
      /*The NULLIF function is employed here to handle division by zero. If column2 is zero, the NULLIF function replaces it with NULL,
        avoiding the division error and resulting in a NULL value for the result column.*/
            SELECT column1, column2, column1 / NULLIF(column2, 0) AS result
            FROM table;
      

    --Combining multiple conditions with logical operators:
      /*This query utilizes logical operators (AND, OR) to combine multiple conditions within the CASE statement. It assigns different
        values to the result column based on various combinations of conditions.*/
            SELECT column1,
                CASE
                    WHEN column2 = 'A' AND column3 > 100 THEN 'X'
                    WHEN column2 = 'B' OR (column3 > 50 AND column4 = 'C') THEN 'Y'
                    ELSE 'Z'
                END AS result
            FROM table;
      
--Complex aggregation functions in SQL:

    --Calculating the median:
      /*This query calculates the median value from the val column of the table. It uses a subquery with the ROW_NUMBER function to
        assign row numbers based on the ascending order of values. Then, it selects the row(s) corresponding to the median position(s) 
        based on the total count of rows.*/
            SELECT
            AVG(val) AS median
            FROM
            (
                SELECT
                val,
                ROW_NUMBER() OVER (ORDER BY val) AS row_num,
                COUNT(*) OVER () AS total_count
                FROM
                table
            ) sub
            WHERE
            row_num IN ((total_count + 1) / 2, (total_count + 2) / 2);
           

    --Computing the weighted average:
      /*In this example, the query calculates the weighted average of values from the value column using the corresponding weights 
        from the weight column of the table. It sums up the products of each value and its weight, and divides it by the total sum of weights.*/
            SELECT
            SUM(weight * value) / SUM(weight) AS weighted_average
            FROM
            table;
            

    --Finding the mode (most frequent value):
      /*This query determines the mode (most frequent value) from the value column of the table. It uses a subquery to find
        the maximum frequency count, and then selects the value(s) with that frequency.*/
            SELECT
                value AS mode,
                COUNT(*) AS frequency
            FROM
                table
            GROUP BY
                value
            HAVING
                COUNT(*) = (
                    SELECT MAX(freq)
                    FROM (
                    SELECT
                        value,
                        COUNT(*) AS freq
                    FROM
                        table
                    GROUP BY
                        value
                    ) sub
                );
            
    --Aggregating values into a comma-separated list:
        /*Here, the GROUP_CONCAT function is used to concatenate the values from the value column of the table into a 
          comma-separated list. The SEPARATOR parameter specifies the separator to use between the values.*/
            SELECT
            GROUP_CONCAT(value SEPARATOR ', ') AS concatenated_values
            FROM
            table;
            




