
-- A procedure that takes in the order info and rollback if an error occurs

DELIMITER //

USE tech_cop;

CREATE PROCEDURE PlaceOrder(
    IN customerId INT,
    IN firstProductId INT,
    IN firstProductQuantity INT,
    IN secondProductId INT,
    IN secondProductQuantity INT
)
BEGIN
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		ROLLBACK;
    
    -- Start transaction
    START TRANSACTION;

    -- Insert the order into the orders table
    INSERT INTO orders(order_date, customer_id)
    VALUES(CURDATE(), customerId);

    -- Get the ID of the newly created order
    SET @orderId = LAST_INSERT_ID();

    -- Add the first product to order details and update inventory
    INSERT INTO order_details(order_id, product_id, quantity, total)
    VALUES(@orderId, firstProductId, firstProductQuantity, 
           firstProductQuantity * (SELECT price FROM product WHERE product_id = firstProductId));

    UPDATE inventory
    SET stock_quantity = stock_quantity - firstProductQuantity
    WHERE product_id = firstProductId;

    -- Add the second product to order details and update inventory
    INSERT INTO order_details(order_id, product_id, quantity, total)
    VALUES(@orderId, secondProductId, secondProductQuantity, 
           secondProductQuantity * (SELECT price FROM product WHERE product_id = secondProductId));

    UPDATE inventory
    SET stock_quantity = stock_quantity - secondProductQuantity
    WHERE product_id = secondProductId;

    -- Commit the transactionPlaceOrder
    COMMIT;
END //

DELIMITER ;