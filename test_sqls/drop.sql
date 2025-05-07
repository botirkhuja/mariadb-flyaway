SET
  foreign_key_checks = 0;

DROP TABLE,
`clients`,
`client_addresses`;

DROP TABLE `phone_number_types`,
`client_phone_numbers`;

DROP TABLE `social_account_platforms`;

SET
  foreign_key_checks = 0;

DROP TABLE `brands`,
`categories`,
`clients`,
`clients_change_history`,
`client_addresses`,
`client_phone_numbers`,
`client_social_accounts`,
`currency_rates`,
`discounts`,
`notes`,
`orders`,
`order_statuses`,
`order_types`,
`pictures`,
`products`,
`products_change_history`,
`social_account_platforms`,
`status_types`,
`stores`,
`sub_categories`,
`inventory`,
`order_items`,
`payments`;