ALTER TABLE client_addresses ADD CONSTRAINT client_addresses_client_id_fk FOREIGN KEY (client_id) REFERENCES clients (client_id) ON DELETE CASCADE;

-- ALTER TABLE client_phone_numbers ADD CONSTRAINT phone_number_unique UNIQUE (phone_number);

ALTER TABLE client_phone_numbers ADD CONSTRAINT client_phone_numbers_client_id_foreign FOREIGN KEY (client_id) REFERENCES clients (client_id) ON DELETE CASCADE;

ALTER TABLE client_social_accounts ADD CONSTRAINT client_social_accounts_client_id_fk FOREIGN KEY (client_id) REFERENCES clients (client_id) ON DELETE CASCADE;

ALTER TABLE client_social_accounts ADD CONSTRAINT client_social_accounts_social_account_platform_id_fk FOREIGN KEY (social_account_platform_id) REFERENCES social_account_platforms (social_account_platform_id) ON DELETE CASCADE;

ALTER TABLE notes ADD CONSTRAINT notes_client_id_fk FOREIGN KEY (client_id) REFERENCES clients (client_id) ON DELETE CASCADE;
ALTER TABLE notes ADD CONSTRAINT notes_order_id_fk FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE CASCADE;

ALTER TABLE sub_categories ADD CONSTRAINT sub_categories_category_id_fk FOREIGN KEY (category_id) REFERENCES categories (category_id);

ALTER TABLE products ADD CONSTRAINT products_category_id_fk FOREIGN KEY (category_id) REFERENCES categories (category_id) ON DELETE CASCADE;

ALTER TABLE products ADD CONSTRAINT products_sub_category_id_fk FOREIGN KEY (sub_category_id) REFERENCES sub_categories (sub_category_id) ON DELETE CASCADE;

ALTER TABLE products ADD CONSTRAINT products_brand_id_fk FOREIGN KEY (brand_id) REFERENCES brands (brand_id) ON DELETE CASCADE;

ALTER TABLE pictures ADD CONSTRAINT pictures_product_id_fk FOREIGN KEY (product_id) REFERENCES products (product_id);

ALTER TABLE pictures ADD CONSTRAINT pictures_store_id_fk FOREIGN KEY (store_id) REFERENCES stores (store_id);

ALTER TABLE order_items ADD CONSTRAINT order_items_order_id_fk FOREIGN KEY (order_id) REFERENCES orders (order_id);

ALTER TABLE order_items ADD CONSTRAINT order_items_product_id_fk FOREIGN KEY (product_id) REFERENCES products (product_id);

ALTER TABLE inventories ADD CONSTRAINT inventories_product_id_fk FOREIGN KEY (product_id) REFERENCES products (product_id);

ALTER TABLE order_items ADD CONSTRAINT order_items_discount_id_fk FOREIGN KEY (discount_id) REFERENCES discounts (discount_id);

ALTER TABLE order_statuses ADD CONSTRAINT order_statuses_order_id_fk FOREIGN KEY (order_id) REFERENCES orders (order_id);

ALTER TABLE order_statuses ADD CONSTRAINT order_statuses_status_id_fk FOREIGN KEY (status_id) REFERENCES status_types (status_type_id);

ALTER TABLE payments ADD CONSTRAINT payments_currency_rate_id_fk FOREIGN KEY (currency_rate_id) REFERENCES currency_rates (currency_rate_id);

ALTER TABLE payments ADD CONSTRAINT payments_order_id_fk FOREIGN KEY (order_id) REFERENCES orders (order_id);

ALTER TABLE payments ADD CONSTRAINT payments_client_id_fk FOREIGN KEY (client_id) REFERENCES clients (client_id);

ALTER TABLE products_change_history ADD CONSTRAINT products_change_history_product_id_fk FOREIGN KEY (product_id) REFERENCES products (product_id);

ALTER TABLE products_change_history ADD CONSTRAINT products_change_history_category_id_fk FOREIGN KEY (category_id) REFERENCES categories (category_id);

ALTER TABLE products_change_history ADD CONSTRAINT products_change_history_sub_category_id_fk FOREIGN KEY (sub_category_id) REFERENCES sub_categories (sub_category_id);

ALTER TABLE products_change_history ADD CONSTRAINT products_change_history_brand_id_fk FOREIGN KEY (brand_id) REFERENCES brands (brand_id);

ALTER TABLE clients_change_history ADD CONSTRAINT clients_change_history_client_id_fk FOREIGN KEY (client_id) REFERENCES clients (client_id);