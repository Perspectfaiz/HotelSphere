# HotelSphere :  Integrated Hotel Management Database Schema

## 1\. Introduction

This project provides a comprehensive and normalized relational database schema for an integrated hotel management system. The design logically separates business functions into three core modules: Customer Relationship Management (CRM), Enterprise Resource Planning (ERP), and Supply Chain Management (SCM).

The schema is designed to be robust, scalable, and maintainable, adhering to database normalization principles (up to Third Normal Form - 3NF) to ensure data integrity and minimize redundancy. It serves as the backend foundation for a full-scale hotel management application.

## 2\. Schema Description

The database is structured into three distinct but interconnected modules, each representing a major functional area of the hotel business.

  * **CRM Module:** Focuses on all customer-facing activities. It handles customer information, room bookings, payments, and feedback.
  * **ERP Module:** Manages the internal resources and operations of the hotel. This includes employee and department management, role specialization, and task assignments.
  * **SCM Module:** Deals with the procurement and management of goods. It tracks suppliers, products, purchase orders, and warehouse inventory.

### Key Design Features

  * **Normalization:** The schema eliminates redundant data by breaking down complex tables. For example, multivalued attributes like phone numbers, room amenities, and product allergens are stored in separate linking tables to achieve 1NF. Transitive dependencies, such as `room price` depending on `room type`, have been resolved by creating a separate `room_type` table, thus satisfying 3NF.
  * **Data Integrity:** Strong data integrity is enforced through primary keys, foreign key constraints, `UNIQUE` constraints, and `CHECK` constraints (e.g., feedback rating).
  * **Specialization Hierarchy:** The ERP module implements an employee specialization hierarchy (`employee` -\> `manager`/`staff` -\> `general_manager`/`warehouse_manager`) to represent different roles and permissions cleanly.
  * **Modularity:** The separation into CRM, ERP, and SCM allows for easier development, maintenance, and scaling of each part of the system independently.

## 3\. Modules in Detail

### 3.1. Customer Relationship Management (CRM)

This module is the heart of guest interactions.

  * **Core Tables:** `branch`, `room`, `customer`, `booking`, `payment`, `feedback`.
  * **Functionality:**
      * Manages multiple hotel branches and their specific rooms.
      * Stores detailed customer profiles.
      * Handles the entire booking lifecycle from check-in to check-out.
      * Processes payments and collects guest feedback for service improvement.

### 3.2. Enterprise Resource Planning (ERP)

This module manages the hotel's internal workforce and administrative tasks.

  * **Core Tables:** `department`, `employee`, `manager`, `staff`, `task`.
  * **Functionality:**
      * Organizes employees into departments and branches.
      * Defines a clear hierarchy for staff and management roles.
      * Assigns and tracks operational tasks for staff members.

### 3.3. Supply Chain Management (SCM)

This module handles the logistics of inventory and procurement.

  * **Core Tables:** `supplier`, `product`, `purchase_order`, `warehouse`, `inventory`.
  * **Functionality:**
      * Maintains a database of suppliers and the products they provide.
      * Creates and tracks purchase orders.
      * Manages inventory levels for various products within warehouses linked to specific hotel branches.
   
 <img width="1688" height="1327" alt="EER diagram" src="https://github.com/user-attachments/assets/69cff56f-aac9-4a2f-ba12-e647aff0aec9" />


## 4\. Setup and Usage

To use this database schema, follow these steps:

1.  **Schema Creation:** Execute the provided SQL script to create all the tables, relationships, and constraints.
2.  **Data Population:** Run the corresponding data insertion script to populate the tables with realistic sample data. This will allow you to test queries and understand the table relationships.
3.  **Querying:** Use the provided business queries as a starting point to interact with the database and retrieve meaningful business insights.

### Example Query

The following query retrieves a list of all employees working in the 'Front Desk' department, demonstrating a simple `JOIN` between the `employee` and `department` tables.

```sql
SELECT
    e.name AS employee_name,
    e.hire_date,
    d.name AS department_name
FROM
    employee AS e
JOIN
    department AS d ON e.department_id = d.department_id
WHERE
    d.name = 'Front Desk';
```

## 5\. Potential Enhancements

  * **Views:** Create database views for simplified reporting (e.g., a `v_booking_details` view that joins booking, customer, and room information).
  * **Triggers:** Implement triggers to automate actions, such as updating inventory levels in the `inventory` table whenever a `purchase_order` is marked as 'Delivered'.
  * **Indexes:** Add indexes to frequently queried columns (e.g., `customer.name`, `room.branch_id`) to improve query performance.
  * **Stored Procedures:** Develop stored procedures for common complex operations, such as creating a new booking, which would involve inserting records into multiple tables within a single transaction.
