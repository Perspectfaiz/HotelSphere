-- == TESTING QUERIES ==

-- Query 1: Find all rooms, with their types, located at the 'Hanamkonda Central' branch.
SELECT
    b.location,
    r.room_number,
    r.room_type_name
FROM
    room AS r
JOIN
    branch AS b ON r.branch_id = b.branch_id
WHERE
    b.location = 'Hanamkonda Central';

-- ==========================================================

-- Query 2: List all employees who work in the 'Front Desk' department.
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

-- ==========================================================

-- Query 3: Retrieve the loyalty program status (tier and points) for the customer 'John Doe'.
SELECT
    c.name,
    c.email,
    lp.tier_level,
    lp.points
FROM
    customer AS c
JOIN
    loyalty_program AS lp ON c.customer_id = lp.customer_id
WHERE
    c.name = 'John Doe';

-- ==========================================================

-- Query 4: Check all items and their quantities for purchase order with ID 1.
SELECT
    poi.order_id,
    p.name AS product_name,
    poi.quantity
FROM
    purchase_order_item AS poi
JOIN
    product AS p ON poi.product_id = p.product_id
WHERE
    poi.order_id = 1;

-- ==========================================================

-- Query 5: Find which staff member is assigned to the task 'Prepare welcome kits for VIP guests'.
SELECT
    t.description,
    t.status,
    e.name AS assigned_to
FROM
    task AS t
JOIN
    employee AS e ON t.assigned_to_staff_id = e.employee_id
WHERE
    t.description = 'Prepare welcome kits for VIP guests';
