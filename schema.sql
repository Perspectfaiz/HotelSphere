-- =================================================================
-- ========================= CRM MODULE ============================
-- =================================================================

CREATE TABLE branch (
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    location VARCHAR(255) NOT NULL,
    manager_id INT,
    phone_numbers TEXT -- NON-NORMALIZED: Stored as a comma-separated string.
);

CREATE TABLE room (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) NOT NULL,
    type VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    branch_id INT,
    amenities TEXT, -- NON-NORMALIZED: Stored as a comma-separated string (e.g., 'Wi-Fi,TV,AC').
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    address TEXT,
    phone_numbers TEXT -- NON-NORMALIZED: Stored as a comma-separated string.
);

CREATE TABLE loyalty_program (
    program_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT UNIQUE NOT NULL,
    tier_level VARCHAR(50) DEFAULT 'Bronze',
    points INT DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);

CREATE TABLE booking (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    customer_id INT,
    room_id INT,
    special_requests TEXT, -- NON-NORMALIZED: Stored as a delimited string.
    -- Derived Attribute: duration_of_stay would be calculated as (check_out_date - check_in_date) in a query.
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (room_id) REFERENCES room(room_id)
);

CREATE TABLE payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50),
    booking_id INT,
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
);

CREATE TABLE feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    booking_id INT,
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
);

-- =================================================================
-- ========================= ERP MODULE ============================
-- =================================================================

CREATE TABLE department (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE employee (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2),
    branch_id INT,
    department_id INT,
    -- Derived Attribute: years_of_service would be calculated as (CURRENT_DATE - hire_date) in a query.
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id),
    FOREIGN KEY (department_id) REFERENCES department(department_id)
);

CREATE TABLE manager (
    employee_id INT PRIMARY KEY,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id) ON DELETE CASCADE
);

CREATE TABLE staff (
    employee_id INT PRIMARY KEY,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id) ON DELETE CASCADE
);

CREATE TABLE general_manager (
    employee_id INT PRIMARY KEY,
    FOREIGN KEY (employee_id) REFERENCES manager(employee_id) ON DELETE CASCADE
);

CREATE TABLE warehouse_manager (
    employee_id INT PRIMARY KEY,
    FOREIGN KEY (employee_id) REFERENCES manager(employee_id) ON DELETE CASCADE
);

CREATE TABLE task (
    task_id INT PRIMARY KEY AUTO_INCREMENT,
    description TEXT,
    due_date DATE,
    status VARCHAR(50) DEFAULT 'Pending',
    assigned_to_staff_id INT,
    FOREIGN KEY (assigned_to_staff_id) REFERENCES staff(employee_id)
);

-- =================================================================
-- ========================= SCM MODULE ============================
-- =================================================================

CREATE TABLE supplier (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    contact_info TEXT,
    contact_persons TEXT -- NON-NORMALIZED: Stored as a comma-separated string.
);

CREATE TABLE product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    allergens TEXT -- NON-NORMALIZED: Stored as a comma-separated string.
);

CREATE TABLE purchase_order (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATE NOT NULL,
    status VARCHAR(50) DEFAULT 'Placed',
    supplier_id INT,
    -- Derived Attribute: total_amount would be calculated by summing the (quantity * price) from purchase_order_items.
    FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);

CREATE TABLE purchase_order_item (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES purchase_order(order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE warehouse (
    warehouse_id INT PRIMARY KEY AUTO_INCREMENT,
    location VARCHAR(255),
    branch_id INT,
    manager_id INT,
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id),
    FOREIGN KEY (manager_id) REFERENCES warehouse_manager(employee_id)
);

CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    quantity_on_hand INT NOT NULL,
    warehouse_id INT,
    product_id INT,
    -- Derived Attribute: stock_value would be calculated as (quantity_on_hand * product.price) in a query.
    UNIQUE (warehouse_id, product_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouse(warehouse_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- =================================================================
-- ===================== ADD FINAL CONSTRAINTS =====================
-- =================================================================

ALTER TABLE branch
ADD CONSTRAINT fk_branch_manager
FOREIGN KEY (manager_id) REFERENCES general_manager(employee_id);




-- == NORMALISATION IS DONE == --




-- =================================================================
-- ========================= CRM MODULE ============================
-- =================================================================

CREATE TABLE branch (
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    location VARCHAR(255) NOT NULL,
    manager_id INT -- This will be a foreign key to the general_manager table
);

-- NORMALIZED: Table for multivalued attribute 'phone_numbers'
CREATE TABLE branch_phone_numbers (
    branch_id INT,
    phone_number VARCHAR(20) NOT NULL,
    PRIMARY KEY (branch_id, phone_number),
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

-- NORMALIZED: New table to satisfy 3NF by removing transitive dependency from room table
CREATE TABLE room_type (
    type_name VARCHAR(50) PRIMARY KEY,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE room (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) NOT NULL,
    branch_id INT,
    room_type_name VARCHAR(50), -- Foreign key to the new room_type table
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id),
    FOREIGN KEY (room_type_name) REFERENCES room_type(type_name)
);

-- NORMALIZED: Table for multivalued attribute 'amenities'
CREATE TABLE room_amenities (
    room_id INT,
    amenity VARCHAR(100) NOT NULL,
    PRIMARY KEY (room_id, amenity),
    FOREIGN KEY (room_id) REFERENCES room(room_id) ON DELETE CASCADE
);

CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    address TEXT
);

-- NORMALIZED: Table for multivalued attribute 'phone_numbers'
CREATE TABLE customer_phone_numbers (
    customer_id INT,
    phone_number VARCHAR(20) NOT NULL,
    PRIMARY KEY (customer_id, phone_number),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);

CREATE TABLE loyalty_program (
    program_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT UNIQUE NOT NULL,
    tier_level VARCHAR(50) DEFAULT 'Bronze',
    points INT DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);

CREATE TABLE booking (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    customer_id INT,
    room_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (room_id) REFERENCES room(room_id)
);

-- NORMALIZED: Table for multivalued attribute 'special_requests'
CREATE TABLE booking_special_requests (
    booking_id INT,
    request VARCHAR(255) NOT NULL,
    PRIMARY KEY (booking_id, request),
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id) ON DELETE CASCADE
);

CREATE TABLE payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50),
    booking_id INT,
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
);

CREATE TABLE feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    booking_id INT,
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
);

-- =================================================================
-- ========================= ERP MODULE ============================
-- =================================================================

CREATE TABLE department (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE employee (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2),
    branch_id INT,
    department_id INT,
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id),
    FOREIGN KEY (department_id) REFERENCES department(department_id)
);

CREATE TABLE manager (
    employee_id INT PRIMARY KEY,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id) ON DELETE CASCADE
);

CREATE TABLE staff (
    employee_id INT PRIMARY KEY,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id) ON DELETE CASCADE
);

CREATE TABLE general_manager (
    employee_id INT PRIMARY KEY,
    FOREIGN KEY (employee_id) REFERENCES manager(employee_id) ON DELETE CASCADE
);

CREATE TABLE warehouse_manager (
    employee_id INT PRIMARY KEY,
    FOREIGN KEY (employee_id) REFERENCES manager(employee_id) ON DELETE CASCADE
);

CREATE TABLE task (
    task_id INT PRIMARY KEY AUTO_INCREMENT,
    description TEXT,
    due_date DATE,
    status VARCHAR(50) DEFAULT 'Pending',
    assigned_to_staff_id INT,
    FOREIGN KEY (assigned_to_staff_id) REFERENCES staff(employee_id)
);

-- =================================================================
-- ========================= SCM MODULE ============================
-- =================================================================

CREATE TABLE supplier (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    contact_info TEXT
);

-- NORMALIZED: Table for multivalued attribute 'contact_persons'
CREATE TABLE supplier_contact_persons (
    supplier_id INT,
    contact_person VARCHAR(255) NOT NULL,
    PRIMARY KEY (supplier_id, contact_person),
    FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id) ON DELETE CASCADE
);

CREATE TABLE product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL
);

-- NORMALIZED: Table for multivalued attribute 'allergens'
CREATE TABLE product_allergens (
    product_id INT,
    allergen VARCHAR(100) NOT NULL,
    PRIMARY KEY (product_id, allergen),
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE
);

CREATE TABLE purchase_order (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATE NOT NULL,
    status VARCHAR(50) DEFAULT 'Placed',
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);

CREATE TABLE purchase_order_item (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES purchase_order(order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE warehouse (
    warehouse_id INT PRIMARY KEY AUTO_INCREMENT,
    location VARCHAR(255),
    branch_id INT,
    manager_id INT,
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id),
    FOREIGN KEY (manager_id) REFERENCES warehouse_manager(employee_id)
);

CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    quantity_on_hand INT NOT NULL,
    warehouse_id INT,
    product_id INT,
    UNIQUE (warehouse_id, product_id),
    FOREIGN KEY (warehouse_id) REFERENCES warehouse(warehouse_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- =================================================================
-- ===================== ADDING FINAL CONSTRAINTS =====================
-- =================================================================

ALTER TABLE branch
ADD CONSTRAINT fk_branch_manager
FOREIGN KEY (manager_id) REFERENCES general_manager(employee_id);