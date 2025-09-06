-- =================================================================
-- Customer Relationship Management Database - Setup Script
-- =================================================================

-- Create a new database
-- CREATE DATABASE crm_database;

-- Connect to the newly created database (requires a separate psql command or a connection string)
-- \c crm_database;


-- ============================================
-- Drop existing tables to avoid errors
-- ============================================
    DROP TABLE IF EXISTS payments;
    DROP TABLE IF EXISTS reconciliations;
    DROP TABLE IF EXISTS financials;
    DROP TABLE IF EXISTS support_periods;
    DROP TABLE IF EXISTS accounts;
    DROP TABLE IF EXISTS clients;
    DROP TABLE IF EXISTS employees;
    DROP TABLE IF EXISTS programs;


-- ============================================
-- Create tables
-- ============================================

-- Programs Table - stores program details
-- Links to the Support Periods tabble

CREATE TABLE programs (
    program_id SERIAL PRIMARY KEY,
    program_name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

-- Employees Table - stores employee details 
-- Links to the Support Periods, Payments and Reconciliations tables

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    employee_name VARCHAR(50) NOT NULL,
    employee_email VARCHAR(100) NOT NULL UNIQUE,
    employee_department VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

-- Clients Table - stores client details
-- Links to the Support Periods and Financials tables

CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    client_name VARCHAR(50) NOT NULL,
    client_dob DATE NOT NULL,
    client_address VARCHAR(100) NOT NULL,
    client_phone_number VARCHAR(15) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_client UNIQUE (client_name, client_dob)
    );

-- Accounts Table - stores account details
-- Links to the Payments and Reconciliations tables

CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    account_name VARCHAR(50) NOT NULL,
    bank_name VARCHAR(50) NOT NULL,
    bsb VARCHAR(7) NOT NULL,
    account_number VARCHAR(15) NOT NULL,
    payee VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_account UNIQUE (bsb, account_number)
    );

-- Support Periods Table - stores support period details
-- Links to the Programs, Employees, Clients and Financials tables

CREATE TABLE support_periods (
    support_period_id SERIAL PRIMARY KEY,
    program_id INT NOT NULL,
    employee_id INT NOT NULL,
    client_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (program_id) REFERENCES programs(program_id) ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE
    );

-- Financials Table - stores financial details
-- Links to the Clients and Support Periods tables

CREATE TABLE financials (
    financial_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL,
    support_period_id INT NOT NULL,
    amount_due DECIMAL(10, 2) NOT NULL,
    invoice_number VARCHAR(50) NOT NULL,
    invoice_due_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (support_period_id) REFERENCES support_periods(support_period_id) ON DELETE CASCADE
    );

-- Reconciliations Table - stores reconciliation details
-- Links to the Employees and Accounts tables

CREATE TABLE reconciliations (
    reconciliation_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    account_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    bank_balance DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE ON UPDATE CASCADE
    );

-- Payments Table - stores payment details
-- Links to the Employees, Financials and Accounts tables
-- Junction table between Financials and Accounts

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    financial_id INT NOT NULL,
    account_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount_paid DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (financial_id) REFERENCES financials(financial_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE RESTRICT ON UPDATE CASCADE
    );


-- ============================================
-- Insert Sample Data
-- ============================================

-- Insert sample data into Programs table
INSERT INTO programs (program_name) VALUES
    ('community_connections'),
    ('tenants_Advice'),
    ('advocacy_services'),
    ('homelessness_services'),
    ('family_support');

-- Insert sample data into Employees table
INSERT INTO employees (employee_name, employee_email, employee_department) VALUES
    ('Ashley Bunny', 'ashley.bunny@org.au', 'Support Services'),
    ('Nick Hulme', 'nick.hulme@org.au', 'Financial Services'),
    ('Georgia Arbuckle', 'georgia.arbuckle.org.au', 'Financial Services'),
    ('Rachael Green', 'rachael.green@org.au', 'Support Services'),
    ('Monica Zass', 'monica.zass@org.au', 'Support Services');

-- Insert sample data into Clients table
INSERT INTO clients (client_name, client_dob, client_address, client_phone_number) VALUES
    ('Lucy Howle', '1980-05-15', '123 Main St, Sydney, NSW', '0412345678'),
    ('Nicholas Payne', '1990-07-22', '456 Oak St, Melbourne, VIC', '0498765432'),
    ('Rita Fabrizzi', '1975-03-30', '789 Pine St, Brisbane, QLD', '0387654321'),
    ('Rowan Wayne', '1985-11-12', '321 Cedar St, Perth, WA', '0276543210'),
    ('Holly Rupert', '1992-09-05', '654 Maple St, Adelaide, SA', '0887654321');

-- Insert sample data into Accounts table
INSERT INTO accounts (account_name, bank_name, bsb, account_number, payee) VALUES
    ('Alex Tan', 'Commonwealth Bank', '062-000', '12345678', 'Fantastic Furniture'),
    ('Cheree Wescombe', 'Westpac', '032-000', '87654321', 'Harvey Norman'),
    ('Peter Farmer', 'ANZ', '012-000', '23456789', 'Good Guys'),
    ('Lani Heads', 'NAB', '082-000', '98765432', 'Gold Coast Furnishings'),
    ('Sharon Jacobs', 'St George', '112-000', '34567890', 'City Wood Hotel');

-- Insert sample data into Support Periods table
INSERT INTO support_periods (program_id, employee_id, client_id, start_date, end_date) VALUES
    (5, 1, 1, '2025-01-01', '2025-06-30'),
    (4, 4, 2, '2025-02-15', '2025-08-15'),
    (3, 4, 3, '2025-03-10', '2025-09-10'),
    (2, 5, 4, '2025-04-20', '2025-09-09'),
    (1, 5, 5, '2025-05-05', '2025-09-05');

-- Insert sample data into Financials table
-- INSERT INTO financials (client_id, support_period_id, amount_due, invoice_number, invoice_due_date) VALUES
    -- (1, 1, 1500.00, 'INV1001', '2025-07-01'),
    -- (2, 2, 2000.00, 'INV1002', '2025-09-01'),
    -- (3, 3, 1750.00, 'INV1003', '2025-10-01'),
    -- (4, 4, 2200.00, 'INV1004', '2025-10-20'),
    -- (5, 5, 1800.00, 'INV1005', '2025-10-05');

-- Insert sample data into Reconciliations table
-- INSERT INTO reconciliations (employee_id, account_id, start_date, end_date, bank_balance) VALUES
--     (2, 1, '2025-06-01', '2025-06-30', 5000.00),
--     (3, 2, '2025-06-01', '2025-06-30', 7500.00),
--     (2, 3, '2025-06-01', '2025-06-30', 6200.00),
--     (3, 4, '2025-06-01', '2025-06-30', 8100.00),
--     (2, 5, '2025-06-01', '2025-06-30', 4300.00);

-- Insert sample data into Payments table
-- INSERT INTO payments (employee_id, financial_id, account_id, payment_date, amount_paid, payment_method) VALUES
--     (2, 1, 1, '2025-07-05', 1500.00, 'Direct Deposit'),
--     (3, 2, 2, '2025-09-05', 2000.00, 'Credit Card'),
--     (2, 3, 3, '2025-10-05', 1750.00, 'Direct Deposit'),
--     (3, 4, 4, '2025-10-25', 2200.00, 'Bank Transfer'),
--     (2, 5, 5, '2025-10-10', 1800.00, 'Credit Card');




-- ============================================
-- Queries
-- ============================================

-- Get all clients created today
--      SELECT *
--      FROM clients
--      WHERE created_at::date = CURRENT_DATE;

-- List all employees, newest first
--      SELECT *
--      FROM employees
--      ORDER BY created_at DESC;


-- Get all financial records updated in the last 7 days
--      SELECT *
--      FROM financials
--      WHERE updated_at >= NOW() - INTERVAL '7 days';

-- Show all accounts, most recently updated first
--      SELECT *
--      FROM accounts
--      ORDER BY updated_at DESC;