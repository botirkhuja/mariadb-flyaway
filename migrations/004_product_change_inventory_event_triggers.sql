CREATE TRIGGER create_product_change_history BEFORE UPDATE ON products FOR EACH ROW BEGIN
INSERT INTO
    products_change_history (product_id, name, description is_deleted, created_at, updated_at)
VALUES
    (OLD.client_id, OLD.name, OLD.description, OLD.is_deleted, OLD.created_at, OLD.updated_at);
END;

CREATE TRIGGER update_invetory_insert_quantity AFTER INSERT ON order_items FOR EACH ROW BEGIN DECLARE current_quantity, current_order_type, sales_order_type INT;

-- -- Get the inventory quantity for the product (it may be NULL)
SELECT
    quantity INTO current_quantity
FROM
    inventories
WHERE
    product_id = NEW.product_id
ORDER BY
    inventory_id DESC
LIMIT 1;

-- -- Get order type id from new order
SELECT
    order_type_id INTO current_order_type
FROM
    orders
WHERE
    order_id = NEW.order_id;

-- -- Get sales order type id from order types
SELECT
    order_type_id INTO sales_order_type
FROM
    order_types
WHERE
    label = 'sales';

-- -- If the record exists, update the quantity
IF current_quantity IS NULL THEN
  -- Make current quantity 0
  SET
      current_quantity = 0;
END IF;
-- -- -- Check if order is sales type
IF current_order_type = sales_order_type THEN
  -- -- -- If the record exists, update the current quantity variable
    SET
        current_quantity = current_quantity - NEW.quantity;
    ELSE
  -- -- -- If the record does not exist, update the current quantity variable
    SET
        current_quantity = current_quantity + NEW.quantity;
END IF;

INSERT INTO
    inventories (product_id, quantity)
VALUES
    (NEW.product_id, current_quantity);
END;
--
