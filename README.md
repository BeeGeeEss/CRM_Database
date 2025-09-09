# 💻📂 Customer Relationship Management (CRM) Database 👨‍👩‍👧‍👦

> This project implements a Customer Relationship Management (CRM) database using PostgreSQL.
It stores and manages data for programs, employees, clients, financials, payments, reconciliations, and accounts.

The database supports:

* Tracking support periods for clients
* Managing financials and payments
* Reconciling accounts
* Generating reports with aggregate and complex queries

## Prerequisites

* **PostgreSQL** (v14 or later recommended)
* **Beekeeper Studio** (optional, for GUI database management)
* Command-line access
* Basic understanding of SQL

## Database Setup

1. **Clone the Project:**

```git
git clone https://github.com/BeeGeeEss/CRM_Database.git
cd crm_database
```

Or download the ZIP folder and extract it

2. **Create the database**:

```sql
CREATE DATABASE crm_database;
```

3. **Connect to the database**:

```sql
psql -U postgres -d crm_database
```

or inside psql

```sql
\c crm_database
```

4. **Run the Setup Script:**

Run the provided SQL setup file to:
* Create all tables
* Add constraints and relationships
* Load sample data
* Provide queries for testing

```SQL
psql -U your_username -d crm_database -f crm_setup.sql
```

## Entity Relationships

* Programs - Lists the organisations Support Programs
* Employees - Stores Employee information
* Clients - Stores Client information
* Accounts - Tracks payment Accounts
* Support Periods - Links Clients to Programs & Employees
* Financials - Stores invoices and billing details
* Payments - Tracks Payments for Financial records using Account information
* Reconciliations - Tracks Account Reconciliation by Employees

![ERD Diagram](/images/erd.png)

## Integrity & Checks

| **Parent Table**     | **On Delete** | **On Update** | **Checks**              |
| -------------------- | ------------- | ------------- | ----------------------- |
| **programs**         | CASCADE       | CASCADE       | —                       |
| **employees**        | SET NULL      | CASCADE       | —                       |
| **clients**          | CASCADE       | CASCADE       | —                       |
| **support\_periods** | CASCADE       | CASCADE       | `end_date > start_date` |
| **financials**       | CASCADE       | CASCADE       | `amount_due >= 0`       |
| **accounts**         | RESTRICT      | CASCADE       | `account_balance >= 0`     |
| **payments**         | —             | —             | `amount_paid > 0`       |

## Example Table Schema

---

```markdown
 ## Payments Table Schemas

| Column          | Type                     | Nullable | Keys               |
|-----------------|--------------------------|----------|--------------------|
| payment_id      | SERIAL / INT             | NO       | PRIMARY KEY        |
| employee_id     | INT                      | NO       | FOREIGN KEY        |
| financial_id    | INT                      | NO       | FOREIGN KEY        |
| account_id      | INT                      | NO       | FOREIGN KEY        |
| payment_date    | DATE                     | NO       |                    |
| amount_paid     | NUMERIC(10,2)            | NO       |                    |
| payment_method  | VARCHAR(50)              | NO       |                    |
| created_at      | TIMESTAMP                | YES      |                    |
| updated_at      | TIMESTAMP                | YES      |                    |

```

## Testing the Database

1. **View all Employees records:**

```sql
SELECT * FROM employees;
```

```SQL
SELECT employee_id, employee_name
FROM employees;
```

2. **Update a Client Record:**

```SQL
UPDATE clients
SET client_dob = '1991-02-08'
WHERE client_id = '1';
```

3. **Delete a Program record:**

```SQL
DELETE FROM programs
WHERE program_name = 'Family Support';
```

## Running Complex Queries

**Using Beekeeper Studio (or your chosen GUI) - You can now run complex queries and view results.**

1. **Example: Data for reporting on a program's client numbers and brokerage expended:**

![Complex Query 1](./images/query23.png)

2. **Example data for reporting on the top 5 accounts by total amount paid, earliest payment date (excluding NULL values)**

![Complex Query 2](./images/query24.png)

## Troubleshooting

**Common Errors:**

- **Error:** `syntax error at or near ")"`  
  **Cause:** You might have a trailing comma in your `CREATE TABLE` statement.  
  **Fix:** Remove the extra comma after the last column.

- **Error:** `relation "employees" does not exist`  
  **Cause:** You tried inserting or querying before creating the table.  
  **Fix:** Make sure you run the `CREATE TABLE` command first.

- **Error:** `duplicate key value violates unique constraint`  
  **Cause:** You tried to insert an employee with the same email or full-name.  
  **Fix:** Use a unique value or update the existing record. If you would like to start fresh for the table: `DROP TABLE IF EXISTS table_name;`

## Future Improvements

- Add an `employees_audit` table to track changes
- Include more sample data for testing

## Summary

This README guides you through:

- Creating a database
- Building a `programs` table
- Inserting and managing data
- Running basic SQL queries
- Providing an example of a Schema
- Basic troubleshooting

## Author

Developed by ✨BeeGeeEss ✨
