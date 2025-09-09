# 💻📂 Customer Relationship Management (CRM) Database 👨‍👩‍👧‍👦 - Documentation

DEV002 - Assignment 2 - Relational Database Scripts
<br>Submitted: 09/09/2025<br>
Student Number: 16183

## Introduction

> This CRM database has been designed for a not-for-profit organisation funded to deliver multiple community programs. It supports the management of clients, employees, financial records, and program-related support periods.

State funding requirements mandate accurate reporting of Key Performance Indicators (KPIs) and Brokerage Expenditure per support period. This database ensures compliance, efficiency, and accuracy by providing structured, normalised data that is easy to query.

## Entity Relationship Diagram

> The database consists of 8 tables: Programs, Employees, Clients, Accounts, Support Periods, Financials, Payments, and Reconciliations. The Payments table functions as a junction table, linking Financials and Accounts, which allows multiple payments to be associated with a single invoice and a single account.

![ERD](/images/erd.png)

## Entity Relationships

| Relationship                 | Type     | Description                                   |
|-------------------------------|---------|-----------------------------------------------|
| Programs → Support_Periods    | 1:N     | One program has many support periods          |
| Clients → Support_Periods     | 1:N     | A client may have multiple support periods    |
| Clients → Financials          | 1:N     | A client can have many financials             |
| Employees → Support Periods   | 1:N     | One employee has multiple support periods open|
| Employees → Reconciliations   | 1:N     | One employee reconciles many account balances |
| Support Periods → Financials  | 1:N     | One support period captures many financials   |
| Financials → Payments         | 1:N     | One invoice can be paid by multiple payments  |
| Accounts → Payments           | 1:N     | One account can process many payments         |
| Payments                      | Junction| Connects financials and accounts              |
| Accounts → Reconciliation     | 1:N     | Many accounts can be reconciled in one process|

## Flowchart for Entity Relationships and Attributes

ERD Flowchart: Full database overview

![Full Flowchart](images/ERD_flow1.png)

![Flow Chart Part 1](images/ERD_flow2.png)

![FLow Chart Part 2](images/ERD_flow3.png)

Attributes and relationships of the Clients table

![Flow Chart Clients](images/Flow_clients.png)

Attributes and relationships of the Programs table

![Flow Chart Programs](images/Flow_programs.png)

Attributes and relationships of the Employees table

![Flow Chart Employees](images/Flow_employees.png)

Attributes and relationships of the Support Periods table

![Flow Chart Support Periods](images/Flow_supportperiods.png)

Attributes and relationships of the Financials table

![Flow Chart Financials](images/Flow_financials.png)

Shows Payments as a junction table between Accounts and Financials

![Flow Chart Payments](images/Flow_payments.png)

Attributes and relationships of the Accounts table

![Flow Chart Accounts](images/Flow_accounts.png)

Attributes and relationships of the Reconciliations table

![Flow Chart Reconciliations](images/Flow_reconciliations.png)

## Normalising Data

Normalisation was applied to ensure data integrity, reduce redundancy, and make queries efficient. The database has been normalised to Third Normal Form (3NF), meaning:
* 1NF: Eliminates repeating groups and stores atomic values.
* 2NF: Removes partial dependencies by separating related attributes into distinct tables.
* 3NF: Removes transitive dependencies, ensuring every non-key attribute depends solely on its table’s primary key.

#### Unnormalised Data (UNF)

The tables had redundant information and multiple values in the same cell.

![UNF](/images/UNF.png)

#### First Normal Form (1NF)

Repeated or complex values were split up, all values are atomic and unique. I.e. Financial amounts and dates now have their own cells.

![1NF](/images/1NF.png)

#### Second Normal Form (2NF)

Values with partial dependencies were moved to new tables. All non-key attributes depend on the primary key. I.e. One table is divided into Worker, Program, Client, Support Period and Financial.

![2NF](/images/2NF.png)

#### Third Normal Form (3NF)

All transitive dependencies decompose into new tables. Ensuring that each non-key attribute is dependant on the primary key in that table, rather than on other attributes. I.e. Accounts and Reconciliations tables are created. A payment table is created as a future junction table between Financials and Accounts. And the Worker table becomes the Employee table, feeding into Support Periods, Payments and Reconciliations.

![3NF](/images/3NF.png)

## Summary

This database provides a scalable and efficient foundation for managing clients, employees, financials, and programs within a not-for-profit CRM system. It ensures data integrity, supports regulatory reporting, and simplifies business operations.
