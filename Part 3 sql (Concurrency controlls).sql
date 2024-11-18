USE tech_cop;

SET @smart_speaker_id = 5;

-- Starts Transaction 1 for Alex
START TRANSACTION;

SELECT stock_quantity
FROM inventory
WHERE product_id = @smart_speaker_id
FOR UPDATE;

-- Alex buys 5 units of the speaker so we decrease the stock quantity for that product by 5
UPDATE inventory
SET stock_quantity = stock_quantity - 5
WHERE product_id = @smart_speaker_id;

-- After decreasing the stock's quantity for that particular product, we then save the transaction to release the lock
COMMIT;

-- The commit also ends the transaction

-- Simulating Transaction 2 (Taylor's order)

START TRANSACTION;

SELECT stock_quantity
FROM inventory
WHERE product_id = @smart_speaker_id
FOR UPDATE;

UPDATE inventory
SET stock_quantity = stock_quantity - 5
WHERE product_id = @smart_speaker_id;

COMMIT;