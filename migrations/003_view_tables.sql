-- CREATE VIEW clients_with_addresses_view AS
-- SELECT client_id, name, client_address_id, street, city, state, zip_code, country, shipping_type_label 
-- FROM clients LEFT JOIN (
--   SELECT client_id as client_id_ref, client_address_id, street, city, state, zip_code, country, label as shipping_type_label
--   FROM client_addresses LEFT JOIN address_types ON client_addresses.address_type_id = address_types.address_type_id
-- ) as client_addresses ON clients.client_id = client_addresses.client_id_ref;

-- CREATE VIEW client_addresses_view AS
-- SELECT client_address_id, client_id, street, city, state, zip_code, country, client_addresses.address_type_id, address_types.label AS address_type_label
--     FROM client_addresses LEFT JOIN address_types ON client_addresses.address_type_id = address_types.address_type_id;



-- SELECT * FROM clients_with_addresses_view;
SELECT * FROM client_addresses;
SELECT * FROM clients;
SELECT * FROM clients_change_history;
SELECT * FROM client_phone_numbers;
SELECT * FROM stores;

SELECT *
FROM clients LEFT JOIN (
    SELECT client_address_id, client_id, street, city, state, zip_code, country
    FROM client_addresses
) AS client_addresses ON clients.client_id = client_addresses.client_id;

SELECT notes.note_id, notes.note, notes.client_id, notes.order_id, notes.is_deleted, notes.created_at, notes.updated_at FROM notes WHERE notes.client_id = "20sdrt";

SELECT
    order_number
FROM
    pictures
WHERE
    product_id = "m3xofpZh";

    SELECT order_number
    FROM pictures
    WHERE product_id = "m3xofpZh"
    ORDER BY order_number DESC
    LIMIT 1;

    SELECT * FROM orders;

SELECT * FROM orders LEFT JOIN discounts ON orders.order_discount_id = discounts.discount_id;