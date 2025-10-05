-- TESTING QUERIES -- 

-- =================================================================
-- ========================= CRM QUERIES ===========================
-- =================================================================


-- Query 1: identify the top 5 most valuable customers based on total spending in the past year.
— This helps the marketing team target them for exclusive loyalty rewards.

SELECT
    c.customer_id,
    c.name,
    SUM(p.amount) AS total_spending
FROM
    customer c
JOIN
    booking b ON c.customer_id = b.customer_id
JOIN
    payment p ON b.booking_id = p.booking_id
WHERE
    p.payment_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY
    c.customer_id, c.name
ORDER BY
    total_spending DESC
LIMIT 5;

-- Query 2: List all customers in the loyalty program with their tier and points.
-- Useful for marketing and customer retention efforts.
SELECT
    c.name AS customer_name,
    c.email,
    lp.tier_level,
    lp.points
FROM
    customer c
JOIN
    loyalty_program lp ON c.customer_id = lp.customer_id
ORDER BY
    lp.points DESC;


-- Query 3: Identify rooms with specific amenities.
-- Helps front-desk staff find suitable rooms for guests with particular requests.
SELECT
    r.room_number,
    br.location,
    r.room_type_name
FROM
    room r
JOIN
    room_amenities ra ON r.room_id = ra.room_id
JOIN
    branch br ON r.branch_id = br.branch_id
WHERE
    ra.amenity = 'Wi-Fi' -- Example: Can change 'Wi-Fi' to other amenities like 'TV' or 'AC'.
ORDER BY
    br.location, r.room_number;


-- =================================================================
-- ========================= ERP QUERIES ===========================
-- =================================================================

-- Query 1: Generate a payroll list for all employees.
-- Shows each employee's name, department, and salary for payroll processing.
SELECT
    e.name AS employee_name,
    d.name AS department_name,
    e.salary
FROM
    employee e
JOIN
    department d ON e.department_id = d.department_id
ORDER BY
    d.name, e.name;


-- Query 2: Calculate the number of employees and the average salary per department.
-- Useful for HR to analyze workforce distribution and budget allocation.
SELECT
    d.name AS department_name,
    COUNT(e.employee_id) AS number_of_employees,
    AVG(e.salary) AS average_salary
FROM
    department d
JOIN
    employee e ON d.department_id = e.department_id
GROUP BY
    d.name
ORDER BY
    number_of_employees DESC;


-- Query 3: List all currently pending tasks and their assigned staff member.
-- Helps managers track open tasks and employee workload.
SELECT
    t.description,
    t.due_date,
    e.name AS assigned_to
FROM
    task t
JOIN
    staff s ON t.assigned_to_staff_id = s.employee_id
JOIN
    employee e ON s.employee_id = e.employee_id
WHERE
    t.status = 'Pending'
ORDER BY
    t.due_date ASC;


-- Query 4: Find all employees who have been with the company for more than 5 years.
-- This helps in identifying long-serving employees for recognition or succession planning.
SELECT
    name,
    hire_date,
    -- Calculates the difference in years between the current date and hire date.
    TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS years_of_service
FROM
    employee
WHERE
    TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) > 5
ORDER BY
    hire_date ASC;

-- =================================================================
-- ========================= SCM QUERIES ===========================
-- =================================================================


-- Query 1: Show current inventory levels for all products across all warehouses.
-- A critical query for inventory management and restocking decisions.
SELECT
    w.location AS warehouse_location,
    p.name AS product_name,
    i.quantity_on_hand
FROM
    inventory i
JOIN
    warehouse w ON i.warehouse_id = w.warehouse_id
JOIN
    product p ON i.product_id = p.product_id
ORDER BY
    w.location, p.name;


-- Query 2: List all suppliers and their contact persons.
-- A straightforward query to create a supplier contact list.
SELECT
    s.name AS supplier_name,
    s.contact_info,
    scp.contact_person
FROM
    supplier s
JOIN
    supplier_contact_persons scp ON s.supplier_id = scp.supplier_id
ORDER BY
    s.name, scp.contact_person;


-- Query 3: Identify products that need restocking (quantity below a certain threshold).
-- This helps automate the process of inventory control.
SELECT
    w.location AS warehouse_location,
    p.name AS product_name,
    i.quantity_on_hand
FROM
    inventory i
JOIN
    warehouse w ON i.warehouse_id = w.warehouse_id
JOIN
    product p ON i.product_id = p.product_id
WHERE
    i.quantity_on_hand < 50  -- Example threshold: can adjust '50' as needed.
ORDER BY
    i.quantity_on_hand ASC;
