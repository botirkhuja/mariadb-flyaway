-- Create clients table
CREATE TABLE IF NOT EXISTS clients (
  client_id CHAR(36) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  lower_case_name VARCHAR(255) NOT NULL,
  is_deleted BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create addresses table
CREATE TABLE IF NOT EXISTS client_addresses (
  client_address_id CHAR(36) PRIMARY KEY,
  client_id VARCHAR(36) NOT NULL,
  street VARCHAR(255) NOT NULL,
  city VARCHAR(255),
  state VARCHAR(255),
  zip_code VARCHAR(10),
  country VARCHAR(255) NOT NULL,
  address_type ENUM('billing', 'shipping'),
  is_deleted BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE
);

-- Create phones table
CREATE TABLE IF NOT EXISTS client_phone_numbers (
  client_phone_number_id CHAR(36) PRIMARY KEY,
  client_id VARCHAR(36) NOT NULL,
  phone_number VARCHAR(20) NOT NULL,
  phone_country_code VARCHAR(5) NOT NULL,
  phone_type ENUM('home', 'work', 'mobile') NOT NULL,
  is_primary BOOLEAN DEFAULT FALSE,
  is_deleted BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE
);

-- Create social_accounts table
CREATE TABLE IF NOT EXISTS client_social_accounts (
  client_social_account_id CHAR(36) PRIMARY KEY,
  client_id VARCHAR(36) NOT NULL,
  platform ENUM('instagram', 'telegram', 'facebook', 'other') NOT NULL,
  username VARCHAR(255) NOT NULL,
  lower_case_username VARCHAR(255) NOT NULL,
  is_deleted BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE
);

-- Create notes table with id as a string
CREATE TABLE IF NOT EXISTS client_notes (
  client_note_id CHAR(36) PRIMARY KEY,
  client_id VARCHAR(36) NOT NULL,
  note TEXT NOT NULL,
  is_deleted BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE
);

-- Create the categories table
CREATE TABLE IF NOT EXISTS categories (
    category_id CHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    lower_case_name VARCHAR(255) NOT NULL,
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create the subcategories table
CREATE TABLE IF NOT EXISTS sub_categories (
    sub_category_id CHAR(36) PRIMARY KEY,
    category_id CHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    lower_case_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Create the brands table
CREATE TABLE IF NOT EXISTS brands (
    brand_id CHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    lower_case_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- Create the stores table
CREATE TABLE IF NOT EXISTS stores (
    store_id CHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    lower_case_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- Create the products table
CREATE TABLE IF NOT EXISTS products (
    product_id CHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    lower_case_name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 4) NOT NULL,
    category_id CHAR(36),
    sub_category_id CHAR(36),
    brand_id CHAR(36),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (sub_category_id) REFERENCES sub_categories(sub_category_id),
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id)
);

-- Create the pictures table
CREATE TABLE IF NOT EXISTS product_pictures (
    picture_id CHAR(36) PRIMARY KEY,
    product_id CHAR(36) NOT NULL,
    url LONGTEXT NOT NULL,
    description LONGTEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id CHAR(36) PRIMARY KEY,
    client_id CHAR(36) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_price DECIMAL(10, 4) NOT NULL,
    total_price_usd DECIMAL(10, 4) NOT NULL, -- Total price in USD
    total_discount DECIMAL(10, 4), -- Total discount on the order
    total_discount_usd DECIMAL(10, 4), -- Total discount in USD
    shipping_fee DECIMAL(10, 4), -- Shipping fee
    shipping_fee_usd DECIMAL(10, 4), -- Shipping fee in USD
    currency_rate_id VARCHAR(3) NOT NULL,
    currency_exchange_rate DECIMAL(10, 4) DEFAULT 1.00, -- Exchange rate to the base currency
    payment_method ENUM('CASH', 'CARD', 'OTHER'),
    status VARCHAR(50) DEFAULT 'PENDING',
    shipping_address_id CHAR(36), -- Foreign key for the shipping address
    contact_phone_number_id CHAR(36), -- Foreign key for the contact phone number
    is_deleted TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (shipping_address_id) REFERENCES client_addresses(client_address_id),
    FOREIGN KEY (contact_phone_number_id) REFERENCES client_phone_numbers(client_phone_number_id),
    FOREIGN KEY (currency_rate_id) REFERENCES currency_rates(currency_rate_id)
);

CREATE TABLE IF NOT EXISTS order_items (
    order_item_id CHAR(36) PRIMARY KEY,
    order_id CHAR(36) NOT NULL, -- Foreign key to the orders table
    product_id CHAR(36) NOT NULL, -- Foreign key to the products table
    quantity INT NOT NULL, -- Quantity of the product
    price DECIMAL(10, 4) NOT NULL, -- Price of the product
    discount DECIMAL(10, 4), -- Discount applied to this product
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- create currency exchange rates table
CREATE TABLE IF NOT EXISTS currency_rates (
    currency_rate_id CHAR(36) PRIMARY KEY,
    currency_key VARCHAR(3) NOT NULL,
    currency_rate DECIMAL(10, 4) NOT NULL,
    currency_name VARCHAR(255) NOT NULL,
    -- store the date when the exchange rate was last updated
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

INSERT INTO currency_rates (currency_rate_id, currency_key, currency_rate, currency_name)
    VALUES ('2ro', 'USD', '1.00', 'United States Dollar'),
           ('tr5', 'SUM', '12750', 'Uzbek Som');
