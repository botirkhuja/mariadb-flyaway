-- Create trigger that updates the lower_case_name column when a new client is inserted
-- CREATE OR REPLACE TRIGGER update_client_lower_case_name BEFORE INSERT ON clients FOR EACH ROW BEGIN
-- SET
--     NEW.lower_case_name = LCASE(NEW.name);
-- END;

INSERT INTO clients (client_id, name) VALUES ('21sdrt', 'John Aka');

INSERT INTO clients (client_id, name) VALUES ('20sdrt', 'John Aka');
UPDATE clients SET name = 'John Doe' WHERE client_id = '20sdrt';

SELECT * FROM clients;
SELECT * FROM clients_change_history;

INSERT INTO client_addresses (client_address_id, street, address_type_id, country, client_id) VALUES ('4rsd3t', '123 Secondary St', 2, 'Uzbekistan', '20sdrt');



-- change table clients to have id column as integer and make it primary key and client_id as non-unique
ALTER TABLE clients ADD COLUMN id INT PRIMARY KEY AUTO_INCREMENT;
ALTER TABLE clients DROP COLUMN client_id;
ALTER TABLE clients ADD COLUMN client_id CHAR(6) NOT NULL;

ALTER TABLE client_phone_numbers DROP CONSTRAINT client_phone_numbers_client_id_foreign;
ALTER TABLE client_social_accounts DROP CONSTRAINT client_social_accounts_client_id_fk;
ALTER TABLE notes DROP CONSTRAINT notes_client_id_fk;
ALTER TABLE payments DROP CONSTRAINT payments_client_id_fk;
ALTER TABLE clients ADD CONSTRAINT unique_client_id UNIQUE (client_id);



SELECT * FROM clients;

INSERT INTO client_addresses (client_address_id, street, address_type_id, country, client_id) VALUES ('4rsd2t', '123 Main St', 1, 'uzbekistan', '20sdrt');

SELECT * FROM client_addresses;

SELECT * FROM address_types;
SELECT *
    FROM client_addresses LEFT JOIN address_types ON client_addresses.address_type_id = address_types.address_type_id;
SELECT *
FROM clients LEFT JOIN (
    SELECT client_address_id, client_id, street, city, state, zip_code, country, address_types.label AS address_type
    FROM client_addresses LEFT JOIN address_types ON client_addresses.address_type_id = address_types.address_type_id
) AS client_addresses ON clients.client_id = client_addresses.client_id;
SELECT *, label as shipping_label
FROM clients LEFT JOIN client_addresses ON clients.client_id = client_addresses.client_id
LEFT JOIN address_types ON client_addresses.address_type_id = address_types.address_type_id;

INSERT INTO stores (store_id, name) VALUES ('123', 'Store 1');
UPDATE stores SET name = 'Store 2' WHERE store_id = '123';