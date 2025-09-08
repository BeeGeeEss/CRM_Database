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
    ('Community Connections'),
    ('Tenant Advice'),
    ('Advocacy Services'),
    ('Homelessness Services'),
    ('Family Support');

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
INSERT INTO financials (client_id, support_period_id, amount_due, invoice_number, invoice_due_date) VALUES
    (1, 1, 1500.00, 'INV1001', '2025-07-01'),
    (2, 2, 2000.00, 'INV1002', '2025-09-01'),
    (3, 3, 1750.00, 'INV1003', '2025-10-01'),
    (4, 4, 2200.00, 'INV1004', '2025-10-20'),
    (5, 5, 1800.00, 'INV1005', '2025-10-05');

-- Insert sample data into Reconciliations table
INSERT INTO reconciliations (employee_id, account_id, start_date, end_date, bank_balance) VALUES
    (2, 1, '2025-06-01', '2025-06-30', 5000.00),
    (3, 2, '2025-06-01', '2025-06-30', 7500.00),
    (2, 3, '2025-06-01', '2025-06-30', 6200.00),
    (3, 4, '2025-06-01', '2025-06-30', 8100.00),
    (2, 5, '2025-06-01', '2025-06-30', 4300.00);

-- Insert sample data into Payments table
INSERT INTO payments (employee_id, financial_id, account_id, payment_date, amount_paid, payment_method) VALUES
    (2, 1, 1, '2025-07-05', 1500.00, 'Direct Deposit'),
    (3, 2, 2, '2025-09-05', 2000.00, 'Credit Card'),
    (2, 3, 3, '2025-10-05', 1750.00, 'Direct Deposit'),
    (3, 4, 4, '2025-10-25', 2200.00, 'Bank Transfer'),
    (2, 5, 5, '2025-10-10', 1800.00, 'Credit Card');

-- NOTE: TO create tables with multiple IDs, run the following simple query to find the IDs created in other tables:
--      SELECT * FROM table_name;


-- ============================================
-- Simple Queries
-- ============================================

-- Run the first two queries below before the created_at / updated_at queries 
-- Ensures that the entries are not all created on the same date:
--------------------------------------------------------------------------------------------------------------------------------------------
-- 1a. Update the created_at timestamp record
    UPDATE employees
    SET created_at = '2025-08-09'
    WHERE employee_id = 1;

-- 1b. Update the updated_at timestamp record
    UPDATE accounts
    SET updated_at = '2025-08-09'
    WHERE account_id = 1;

-- Run the next two queries to use the created_at timestamps for filtering and sorting:
------------------------------------------------------------------------------------------
-- 2a. Find all clients created today
    SELECT *
    FROM clients
    WHERE created_at::date = CURRENT_DATE;

-- 2b. List all employees, newest first
    SELECT *
    FROM employees
    ORDER BY created_at DESC;

-- Run the next two queries to use the updated_at timestamps for filtering and sorting:
------------------------------------------------------------------------------------------
-- 3a. Find all financial records updated in the last 7 days
    SELECT *
    FROM financials
    WHERE updated_at >= NOW() - INTERVAL '7 days';

-- 3b. Show all accounts, most recently updated first
    SELECT *
    FROM accounts
    ORDER BY updated_at DESC;

-- Run the next three queries to find a single record:
---------------------------------------------------------
-- 4a. Query the reconciliations table for Reconcilaition_ID = 1
    SELECT *
    FROM reconciliations
    WHERE reconciliation_id = 1;

-- 4b. Run a subquery to find the employee name who made a payment on 2025-10-05
    SELECT employee_name
    FROM EMPLOYEES
    WHERE employee_id IN (
        SELECT employee_id 
        FROM PAYMENTS 
        WHERE payment_date::date = '2025-10-05'
    );   

-- 4c. Run a join query to find the employee name who made a payment on 2025-10-05
    SELECT e.employee_name
    FROM employees e
    JOIN payments p ON e.employee_id = p.employee_id
    WHERE p.payment_date::date = '2025-10-05';

-- Run the next two queries to insert records:
--------------------------------------------------
-- 5a. Insert a record into the client table
    INSERT INTO clients (client_name, client_dob, client_address, client_phone_number) 
    VALUES ('Angela Clegg', '1988-12-25', '789 New St, Hobart, TAS', '0478123456');

-- 5b. Insert a record with appropriate foreign-key data to the financials table
-- (Referencing client Holly Rupert)
    INSERT INTO financials (client_id, support_period_id, amount_due, invoice_number, invoice_due_date) 
    VALUES (5, 5, 1600.00, 'INV1006', '2025-11-01');

-- Run the next query to delete a record:
---------------------------------------------
-- 6a. Delete the record with Payment_ID = 2
    DELETE FROM payments
    WHERE payment_id = 2;


-- ============================================
-- Complex Queries
-- ============================================

-- Run the below five aggregate function examples (Count, Sum, Average, Minimum, Maximum):
------------------------------------------------
-- 7a. Count the number of clients
    SELECT COUNT(*) AS total_clients
    FROM clients;

-- 7b. Calculate the total amount due from all financial records
    SELECT SUM(amount_due) AS total_amount_due
    FROM financials;

-- 7c. Calculate the average bank balance from all reconciliations
    SELECT AVG(bank_balance) AS average_bank_balance
    FROM reconciliations;

-- 7d. Find the minimum amount paid in the payments table
    SELECT MIN(amount_paid) AS minimum_payment
    FROM payments;

-- 7e. Find the maximum amount due in the financials table
    SELECT MAX(amount_due) AS maximum_amount_due
    FROM financials;

-- Run the below ORDER BY, GROUP, SORT, FILTER function examples:
--------------------------------------------------------------------
-- 8a. Provide data for reporting on a program's client numbers and brokerage expended
    SELECT 
        pr.program_id as program_id,
        pr.program_name as program_name,
        COUNT(DISTINCT sp.client_id) AS new_clients,
        COUNT(DISTINCT sp.employee_id) AS support_workers,
        COALESCE(SUM(p.amount_paid), 0) AS brokerage_expended
    FROM programs pr
    LEFT JOIN support_periods sp 
        ON pr.program_id = sp.program_id
    LEFT JOIN payments p 
        ON sp.support_period_id = p.financial_id
    GROUP BY pr.program_id, pr.program_name
    ORDER BY brokerage_expended DESC, program_id ASC;

-- 8b. Provide data for reporting on the top 5 accounts by total amount paid, earliest payment date (excluding NUL values)
    SELECT 
        a.account_id,
        a.account_name,
        a.bank_name,
        COUNT(p.payment_id) AS total_payments,
        SUM(p.amount_paid) AS total_amount,
        MIN(p.payment_date) AS payment_date
    FROM accounts a
    LEFT JOIN payments p 
        ON a.account_id = p.account_id
    WHERE p.payment_date IS NOT NULL
    GROUP BY a.account_id, a.account_name, a.bank_name
    HAVING SUM(p.amount_paid) > 0
    ORDER BY total_amount DESC, payment_date ASC
    LIMIT 5;

-- 8c. Provide data for reporting on the employee with the highest total payments made in the last 10 days
    SELECT 
        e.employee_id,
        e.employee_name,
        e.employee_department,
        COUNT(p.payment_id) AS total_payments,
        SUM(p.amount_paid) AS total_amount,
        MAX(p.payment_date) AS last_payment_date
    FROM employees e
    JOIN payments p 
        ON e.employee_id = p.employee_id
    WHERE p.payment_date >= CURRENT_DATE - INTERVAL '10 days'
    GROUP BY e.employee_id, e.employee_name, e.employee_department
    HAVING SUM(p.amount_paid) > 0
    ORDER BY total_amount DESC, last_payment_date DESC
    LIMIT 1;

-- Run the below five subquery and join examples:
----------------------------------------------------------------------------------------------
-- 9a. Find employees who have made payments using 'Bank Transfer'
    SELECT employee_id, employee_name, employee_department
    FROM employees e
    WHERE EXISTS (
        SELECT 1
        FROM payments p
        WHERE e.employee_id = p.employee_id AND p.payment_method = 'Bank Transfer'
    );

-- Inner Join example
-- 9b. Selects only the records that match in both tables
    SELECT clients.client_id,
    support_periods.client_id,
    clients.client_name,
    support_periods.start_date,
    support_periods.end_date
    FROM clients
    INNER JOIN support_periods ON 
    clients.client_id = support_periods.client_id
    WHERE support_periods.start_date >= '2025-01-09'
    ORDER BY support_periods.start_date;

-- Outer Join example
-- 9c. Selects all records from both tables, with NULLs where there are no matches

    SELECT 
        e.employee_id,
        e.employee_name,
        e.employee_email,
        p.payment_id,
        p.amount_paid,
        p.payment_date,
        p.payment_method
    FROM employees e
    FULL OUTER JOIN payments p
        ON e.employee_id = p.employee_id
    ORDER BY e.employee_id, p.payment_date;

-- Left Join example
-- 9d. All of the records from the left table, and the matched records from the right table

    SELECT c.client_id,
        c.client_name,
        sp.support_period_id,
        sp.start_date,
        sp.end_date,
        e.employee_name,
        p.program_name
    FROM clients c
    LEFT JOIN support_periods sp ON c.client_id = sp.client_id
    LEFT JOIN employees e ON sp.employee_id = e.employee_id
    LEFT JOIN programs p ON sp.program_id = p.program_id;

-- Right Join example
-- 9e. All of the records from the right table, and the matched records from the left table

    SELECT sp.support_period_id,
        sp.start_date,
        sp.end_date,
        c.client_name,
        e.employee_name,
        p.program_name
    FROM support_periods sp
    RIGHT JOIN clients c ON sp.client_id = c.client_id
    LEFT JOIN employees e ON sp.employee_id = e.employee_id
    LEFT JOIN programs p ON sp.program_id = p.program_id;