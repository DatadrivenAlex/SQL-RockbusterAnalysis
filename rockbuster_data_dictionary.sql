-- Rockbuster Data Dictionary (Achievement 3.10)
-- This script defines the main schema based on the provided documentation.

-- Example: payment table
CREATE TABLE payment (
    payment_id SERIAL PRIMARY KEY,
    customer_id INT2 REFERENCES customer(customer_id),
    staff_id INT2 REFERENCES staff(staff_id),
    rental_id INT4 REFERENCES rental(rental_id),
    amount NUMERIC(5,2),
    payment_date TIMESTAMP
);

-- Other tables would follow the structure outlined in the Data Dictionary PDF.
-- See rockbuster_3.10_data_dictionary.pdf for full definitions.
