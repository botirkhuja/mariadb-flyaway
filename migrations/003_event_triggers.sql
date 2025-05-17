DELIMITER //
CREATE OR REPLACE TRIGGER create_clients_change_history BEFORE UPDATE ON clients FOR EACH ROW BEGIN
INSERT INTO
    clients_change_history (client_id, name, is_deleted, created_at, updated_at)
VALUES
    (OLD.client_id, OLD.name, OLD.is_deleted, OLD.created_at, OLD.updated_at);
END;
//

CREATE TRIGGER OR REPLACE update_picture_insert_order_number BEFORE INSERT ON pictures FOR EACH ROW BEGIN DECLARE current_picture_order_number INT;
-- -- Check if the order_number record exists
SELECT
    order_number INTO current_picture_order_number
FROM
    pictures
WHERE
    product_id = NEW.product_id
ORDER BY
    order_number DESC
LIMIT 1;
-- -- If the record exists, update the order_number
IF current_picture_order_number IS NOT NULL THEN
SET
    NEW.order_number = current_picture_order_number + 1;

-- -- If the record does not exist, insert a new record
ELSE
SET
    NEW.order_number = 0;
END IF;
END;

//
    
DELIMITER ;

-- Create trigger that updates the lower_case_name column when a new client is inserted
-- CREATE OR REPLACE TRIGGER update_client_lower_case_name BEFORE INSERT ON clients FOR EACH ROW BEGIN
-- SET
--     NEW.lower_case_name = LCASE(NEW.name);
-- END;
