USE tech_cop;

-- start transaction
START TRANSACTION;

-- customer with id 2 places an order. We record the order in the order table
INSERT INTO orders(order_date, customer_id)
VALUES(CURDATE(), 2);

SET @order_id = LAST_INSERT_ID();

-- first product details
SET @1st_product_id = 1;
SET @1st_product_quantity = 2;

-- second product details
SET @2nd_product_id = 3;
SET @2nd_product_quantity = 5;

-- add individual items in the order to the order details table and reduce the stock quantity in the inventory table
-- 1st product
INSERT INTO order_details(order_id, product_id, quantity, total)
VALUES(@order_id, @1st_product_id, @1st_product_quantity, @1st_product_quantity * (SELECT price FROM product WHERE product_id = @1st_product_id));

UPDATE inventory
SET stock_quantity = stock_quantity - @1st_product_quantity
WHERE product_id = @1st_product_id;

-- 2nd product
INSERT INTO order_details(order_id, product_id, quantity, total)
VALUES(@order_id, @2nd_product_id, @2nd_product_quantity, @2nd_product_quantity * (SELECT price FROM product WHERE product_id = @2nd_product_id));

UPDATE inventory
SET stock_quantity = stock_quantity - @2nd_product_quantity
WHERE product_id = @2nd_product_id;

-- save the transaction
COMMIT;