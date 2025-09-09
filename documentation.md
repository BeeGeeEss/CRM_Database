# 💻📂 Customer Relationship Management (CRM) Database 👨‍👩‍👧‍👦 - Documentation

DEV002 - Assignment 2 - Relational Database Scripts
<br>Submitted: 09/09/2025<br>
Student Number: 16183

## Introduction

> This database is required for the use of a Customer Relationship Management (CRM) system for a not-for-profit organisation.

The organisation is funded to provide multiple programs. State funding requires reporting of Key Performance Indicators (KPIs), which is reported per Support Period. Reporting on 'Brokerage Expended' is also required.

## Entity Relationship Diagram

> The database consists of 8 tables: Programs, Employees, Clients, Accounts, Support Periods, Financials, Payments, and Reconciliations. Payments acts as a junction table linking Financials and Accounts.

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

![Full Flowchart](images/ERD_flow1.png)

![Flow Chart Part 1](images/ERD_flow2.png)

![FLow Chart Part 2](images/ERD_flow3.png)

![Flow Chart Clients](images/Flow_clients.png)

![Flow Chart Programs](images/Flow_programs.png)

![Flow Chart Employees](images/Flow_employees.png)

![Flow Chart Support Periods](images/Flow_supportperiods.png)

![Flow Chart Financials](images/Flow_financials.png)

![Flow Chart Payments](images/Flow_payments.png)

![Flow Chart Accounts](images/Flow_accounts.png)

![Flow Chart Reconciliations](images/Flow_reconciliations.png)

## Normalising Data
