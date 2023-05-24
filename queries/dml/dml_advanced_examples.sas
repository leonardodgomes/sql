
/* Complex examples of DML queries. */

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

