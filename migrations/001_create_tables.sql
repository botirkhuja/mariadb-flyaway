-- Create clients table
CREATE TABLE
    clients (
        client_id CHAR(20) PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
    );

CREATE TABLE clients_change_history (
    client_change_history_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    client_id CHAR(20) NOT NULL,
    name VARCHAR(255) NOT NULL,
    is_deleted BOOLEAN NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Create addresses table
CREATE TABLE
    client_addresses (
        client_address_id CHAR(10) PRIMARY KEY,
        client_id CHAR(20) NOT NULL,
        street VARCHAR(255) NOT NULL,
        city VARCHAR(255),
        state VARCHAR(255),
        zip_code VARCHAR(255),
        country VARCHAR(255) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
    );

-- Create phones table
CREATE TABLE
    client_phone_numbers (
        client_phone_number_id CHAR(10) PRIMARY KEY,
        client_id CHAR(20) NOT NULL,
        phone_number VARCHAR(20) NOT NULL,
        phone_country_code VARCHAR(4) NOT NULL,
        -- phone_number_type_id SMALLINT NOT NULL,
        is_primary BOOLEAN DEFAULT FALSE,
        is_deleted BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
    );

-- Create social_accounts table
CREATE TABLE
    client_social_accounts (
        client_social_account_id CHAR(10) NOT NULL UNIQUE PRIMARY KEY,
        client_id CHAR(20) NOT NULL,
        social_account_platform_id SMALLINT NOT NULL,
        client_social_account_user_name VARCHAR(255) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
    );

CREATE TABLE
    social_account_platforms (
        social_account_platform_id SMALLINT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(255) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
    );

INSERT INTO
    social_account_platforms (name)
VALUES
    ('instagram'),
    ('telegram'),
    ('facebook'),
    ('other');

-- Create notes table with id as a string
CREATE TABLE
    notes (
        note_id CHAR(20) PRIMARY KEY,
        client_id CHAR(20),
        order_id CHAR(20),
        note TEXT NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
    );

-- Create the categories table
CREATE TABLE
    categories (
        category_id CHAR(10) PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
    );

-- Create the subcategories table
CREATE TABLE
    sub_categories (
        sub_category_id CHAR(10) PRIMARY KEY,
        category_id CHAR(10) NOT NULL,
        name VARCHAR(255) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
    );

-- Create the brands table
CREATE TABLE
    brands (
        brand_id CHAR(10) PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
    );

-- Create the stores table
CREATE TABLE
    stores (
        store_id CHAR(10) PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
    );

-- Create the products table
CREATE TABLE
    products (
        product_id CHAR(20) PRIMARY KEY,
        name VARCHAR(500) NOT NULL,
        description TEXT,
        price DECIMAL(10, 4),
        category_id CHAR(10) NOT NULL,
        sub_category_id CHAR(10),
        brand_id CHAR(10) NOT NULL,
        primary_picture_id CHAR(20),
        is_deleted BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );

-- Create the pictures table
CREATE TABLE
    pictures (
        picture_id CHAR(20) NOT NULL UNIQUE PRIMARY KEY,
        product_id CHAR(20),
        store_id CHAR(10),
        url LONGTEXT NOT NULL,
        order_number SMALLINT,
        is_primary BOOLEAN DEFAULT FALSE,
        is_deleted BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
    );

CREATE TABLE
    currency_rates (
        currency_rate_id CHAR(10) NOT NULL UNIQUE PRIMARY KEY,
        iso_code VARCHAR(5) NOT NULL,
        rate DECIMAL(10, 4) NOT NULL,
        name VARCHAR(255) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE,
        -- store the date when the exchange rate was last updated
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
    );

INSERT INTO
    currency_rates (currency_rate_id, iso_code, rate, name)
VALUES
    ('bj2ro5thar', 'USD', '1.00', 'United States Dollar'),
    ('tr518jdt54', 'SUM', '12750', 'Uzbek Som');

CREATE TABLE
    discounts (
        discount_id CHAR(10) NOT NULL UNIQUE PRIMARY KEY,
        discount_currency_id CHAR(10) NOT NULL,
        discount_amount DECIMAL(10, 4) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
    );

CREATE TABLE
    order_types (
        order_type_id SMALLINT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(255) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
    );

INSERT INTO
    order_types (name)
VALUES
    ('sales'),
    ('purchase'),
    ('return'),
    ('cancel');

CREATE TABLE
    orders (
        order_id CHAR(20) PRIMARY KEY,
        client_id CHAR(20),
        order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        total_price DECIMAL(10, 4) NOT NULL,
        order_discount_id CHAR(10),
        currency_rate_id CHAR(10) NOT NULL,
        shipping_address_id CHAR(10),
        shipping_fee DECIMAL(10, 4),
        contact_phone_number_id CHAR(10),
        order_type_id SMALLINT NOT NULL,
        tax_amount DECIMAL(10, 4),
        store_id CHAR(10),
        is_deleted BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
    );

CREATE TABLE
    order_items (
        order_item_id CHAR(20) PRIMARY KEY,
        order_id CHAR(20) NOT NULL,
        product_id CHAR(20) NOT NULL,
        quantity SMALLINT NOT NULL,
        price DECIMAL(10, 4) NOT NULL,
        discount_id CHAR(10)
    );

CREATE TABLE
    inventories (
        inventory_id INTEGER PRIMARY KEY AUTO_INCREMENT,
        product_id CHAR(20) NOT NULL,
        quantity INT DEFAULT 0,
        is_deleted BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
    );

CREATE TABLE
    status_types (
        status_type_id SMALLINT PRIMARY KEY AUTO_INCREMENT,
        label VARCHAR(255) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
    );

CREATE TABLE
    order_statuses (
        order_status_id CHAR(10) PRIMARY KEY,
        order_id CHAR(20) NOT NULL,
        status_id SMALLINT NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
    );

CREATE TABLE
    payments (
        payment_id CHAR(20) PRIMARY KEY,
        currency_rate_id CHAR(10) NOT NULL,
        amount DECIMAL(10, 4) NOT NULL,
        payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        order_id CHAR(20),
        client_id CHAR(20) NOT NULL,
        is_deleted BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
    );

CREATE TABLE
    products_change_history (
        product_change_history_id INTEGER PRIMARY KEY AUTO_INCREMENT,
        product_id CHAR(20) NOT NULL,
        name VARCHAR(255) NOT NULL,
        description TEXT,
        price DECIMAL(10, 4),
        category_id CHAR(10) NOT NULL,
        sub_category_id CHAR(10),
        brand_id CHAR(10) NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    );