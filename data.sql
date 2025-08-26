-- == DATA INSERTION == --

SET FOREIGN_KEY_CHECKS = 0;

SELECT GROUP_CONCAT(CONCAT('TRUNCATE TABLE `', table_name, '`') SEPARATOR '; ')
INTO @truncate_cmd
FROM information_schema.tables
WHERE table_schema = 'HotelSphere';

PREPARE stmt FROM @truncate_cmd;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET FOREIGN_KEY_CHECKS = 1;


-- =================================================================
-- Step 1: Populate Independent Tables (No Foreign Keys)
-- =================================================================


-- Insert data into 'department'
INSERT INTO department (name) VALUES
('Management'), ('Front Office'), ('Housekeeping'), ('Food & Beverage'), ('Maintenance'),
('Supply Chain'), ('Security'), ('Human Resources'), ('Sales & Marketing');

-- Insert data into 'room_type'
INSERT INTO room_type (type_name, price) VALUES
('Standard Queen', 7500.00), ('Standard King', 8500.00), ('Deluxe King', 11000.00),
('Deluxe Twin', 11500.00), ('Executive Suite', 18500.00), ('Honeymoon Suite', 22000.00),
('Presidential Suite', 45000.00);

-- Insert data into 'supplier'
INSERT INTO supplier (name, contact_info) VALUES
('Telangana Hospitality Supplies', 'info@ths.co.in'), ('Deccan Linens Pvt. Ltd.', 'sales@deccanlinens.com'),
('Hyderabad Food Services', 'orders@hydfoods.com'), ('Modern Kitchen Equipment', 'support@mke.com'),
('SecureTech Solutions', 'contact@securetech.in'), ('Global Office Needs', 'go@needs.com');

-- Insert data into 'product'
INSERT INTO product (name) VALUES
('Luxury Bath Towel'), ('Queen Size Bedsheet'), ('Pillowcase - Standard'), ('Shampoo - 100ml'),
('Soap Bar - 50g'), ('Coffee Beans - 1kg'), ('Mineral Water Bottle - 1L'), ('Kitchen Chef Knife'),
('Industrial Dishwasher'), ('CCTV Camera Model X'), ('A4 Printer Paper Ream'), ('Black Ballpoint Pens (Box)'),
('Fresh Orange Juice - 10L'), ('Sanitizer Fluid - 5L');

-- Insert data into 'customer'
INSERT INTO customer (name, email, address) VALUES
('Ravi Kumar', 'ravi.k@email.com', '123 Jubilee Hills, Hyderabad'), ('Priya Sharma', 'priya.s@email.com', '456 Banjara Hills, Hyderabad'),
('Arjun Reddy', 'arjun.r@email.com', '789 Gachibowli, Hyderabad'), ('Sunita Rao', 'sunita.r@email.com', '101 Hitech City, Hyderabad'),
('Mahesh Babu', 'mahesh.b@email.com', '222 Film Nagar, Hyderabad'), ('Anushka Shetty', 'anushka.s@email.com', '333 Madhapur, Hyderabad'),
('Nikhil Gupta', 'nikhil.g@email.com', '555 Kukatpally, Hyderabad'), ('Aisha Khan', 'aisha.k@email.com', '777 Secunderabad, Hyderabad'),
('Vijay Devarakonda', 'vijay.d@email.com', '888 Kondapur, Hyderabad'), ('Samantha Ruth', 'samantha.r@email.com', '999 Manikonda, Hyderabad'),
('Kiran Desai', 'kiran.d@email.com', '111 Begumpet, Hyderabad'), ('Lakshmi Prasad', 'lakshmi.p@email.com', '444 Somajiguda, Hyderabad'),
('Aditya Roy', 'aditya.r@email.com', '321 Ameerpet, Hyderabad'), ('Deepika Padukone', 'deepika.p@email.com', '654 Miyapur, Hyderabad'),
('Ranbir Kapoor', 'ranbir.k@email.com', '987 Lingampally, Hyderabad'), ('Alia Bhatt', 'alia.b@email.com', '159 HITEC City, Hyderabad'),
('Varun Dhawan', 'varun.d@email.com', '753 Nampally, Hyderabad'), ('Shraddha Kapoor', 'shraddha.k@email.com', '852 Abids, Hyderabad'),
('Rajkummar Rao', 'rajkummar.r@email.com', '963 Koti, Hyderabad'), ('Kriti Sanon', 'kriti.s@email.com', '852 Dilsukhnagar, Hyderabad'),
('Siddharth Malhotra', 'sid.m@email.com', '741 Uppal, Hyderabad'), ('Kiara Advani', 'kiara.a@email.com', '963 Tarnaka, Hyderabad'),
('Prakash Raj', 'prakash.r@email.com', '147 Bowenpally, Hyderabad'), ('Ramya Krishnan', 'ramya.k@email.com', '258 Medchal, Hyderabad');


-- =================================================================
-- Step 2: Populate ERP Hierarchy (Employees, Managers, Staff)
-- =================================================================

-- Insert all employees into the 'employee' superclass table
INSERT INTO employee (name, hire_date, salary, department_id) VALUES
-- General Management
('Vikram Singh', '2020-01-15', 350000.00, 1), ('Anjali Menon', '2021-03-10', 320000.00, 1), ('Rakesh Sharma', '2019-11-01', 380000.00, 1),
-- Warehouse Management
('Suresh Patil', '2022-05-20', 120000.00, 6), ('Deepa Iyer', '2022-08-01', 115000.00, 6), ('Imran Khan', '2021-09-15', 125000.00, 6),
-- Staff (Branch 1)
('Rajesh Gupta', '2023-02-11', 55000.00, 2), ('Meena Kumari', '2023-04-05', 45000.00, 3), ('Harish Kumar', '2022-10-10', 65000.00, 4),
-- Staff (Branch 2)
('Amit Verma', '2023-06-18', 56000.00, 2), ('Fatima Sheikh', '2023-07-22', 46000.00, 3), ('David John', '2023-01-20', 70000.00, 4),
-- Staff (Branch 3)
('Pooja Singh', '2022-03-15', 58000.00, 2), ('Kavita Nair', '2022-05-25', 48000.00, 3), ('Rohan Mehta', '2021-12-01', 72000.00, 4),
-- New Staff (Branch 1)
('Anil Kapoor', '2023-08-01', 42000.00, 7), ('Sridevi Rao', '2023-08-05', 68000.00, 9),
-- New Staff (Branch 2)
('Sanjay Dutt', '2023-09-10', 43000.00, 7), ('Madhuri Dixit', '2023-09-15', 69000.00, 9),
-- New Staff (Branch 3)
('Govinda Ahuja', '2023-10-01', 44000.00, 7), ('Karisma Kapoor', '2023-10-05', 71000.00, 9);

-- Populate the 'manager' subclass
INSERT INTO manager (employee_id) VALUES (1), (2), (3), (4), (5), (6);

-- Populate the 'staff' subclass
INSERT INTO staff (employee_id) VALUES (7), (8), (9), (10), (11), (12), (13), (14), (15), (16), (17), (18), (19), (20), (21);

-- Populate the 'general_manager' sub-subclass
INSERT INTO general_manager (employee_id) VALUES (1), (2), (3);

-- Populate the 'warehouse_manager' sub-subclass
INSERT INTO warehouse_manager (employee_id) VALUES (4), (5), (6);


-- =================================================================
-- Step 3: Populate Core Infrastructure (Branch, Room, Warehouse)
-- =================================================================

-- Insert data into 'branch'
INSERT INTO branch (location, manager_id) VALUES
('Hanamkonda, Telangana', 1), ('Banjara Hills, Hyderabad', 2), ('Gachibowli, Hyderabad', 3);

-- Now, update employees with their respective branch_id
UPDATE employee SET branch_id = 1 WHERE employee_id IN (1, 4, 7, 8, 9, 16, 17);
UPDATE employee SET branch_id = 2 WHERE employee_id IN (2, 5, 10, 11, 12, 18, 19);
UPDATE employee SET branch_id = 3 WHERE employee_id IN (3, 6, 13, 14, 15, 20, 21);

-- Insert data into 'room'
INSERT INTO room (room_number, branch_id, room_type_name) VALUES
-- Branch 1 Rooms
('101', 1, 'Deluxe King'), ('102', 1, 'Standard Queen'), ('201', 1, 'Executive Suite'), ('202', 1, 'Standard Queen'), ('301', 1, 'Deluxe King'), ('302', 1, 'Standard King'),
-- Branch 2 Rooms
('101', 2, 'Deluxe King'), ('102', 2, 'Deluxe King'), ('201', 2, 'Presidential Suite'), ('202', 2, 'Executive Suite'), ('301', 2, 'Deluxe Twin'), ('302', 2, 'Honeymoon Suite'), ('401', 2, 'Standard Queen'),
-- Branch 3 Rooms
('101', 3, 'Standard King'), ('102', 3, 'Standard King'), ('201', 3, 'Deluxe Twin'), ('202', 3, 'Deluxe Twin'), ('301', 3, 'Executive Suite'), ('401', 3, 'Executive Suite'), ('402', 3, 'Standard Queen');

-- Insert data into 'warehouse'
INSERT INTO warehouse (location, branch_id, manager_id) VALUES
('Main Storage - Hanamkonda', 1, 4), ('Main Storage - Banjara Hills', 2, 5), ('Main Storage - Gachibowli', 3, 6);


-- =================================================================
-- Step 4: Populate Transactional Data (Bookings, Payments, etc.)
-- =================================================================

-- Insert data into 'booking'
INSERT INTO booking (check_in_date, check_out_date, customer_id, room_id) VALUES
('2025-08-10', '2025-08-12', 1, 1), ('2025-08-11', '2025-08-15', 2, 7), ('2025-08-14', '2025-08-16', 3, 2),
('2025-08-20', '2025-08-25', 4, 9), ('2025-09-01', '2025-09-05', 5, 14), ('2025-09-02', '2025-09-04', 6, 12),
('2025-09-10', '2025-09-12', 7, 1), ('2025-09-15', '2025-09-20', 8, 8), ('2025-09-18', '2025-09-19', 9, 15),
('2025-10-01', '2025-10-10', 10, 9), ('2025-10-05', '2025-10-07', 11, 4), ('2025-10-12', '2025-10-15', 12, 18),
('2025-11-01', '2025-11-03', 13, 1), ('2025-11-02', '2025-11-06', 14, 7), ('2025-11-05', '2025-11-08', 15, 2),
('2025-11-10', '2025-11-15', 16, 9), ('2025-11-12', '2025-11-14', 17, 14), ('2025-11-15', '2025-11-18', 18, 12),
('2025-11-20', '2025-11-22', 19, 1), ('2025-11-21', '2025-11-25', 20, 8), ('2025-11-24', '2025-11-26', 21, 15),
('2025-12-01', '2025-12-10', 22, 9), ('2025-12-05', '2025-12-08', 23, 4), ('2025-12-10', '2025-12-12', 24, 18);

-- Insert data into 'payment'
INSERT INTO payment (amount, payment_method, booking_id) VALUES
(22000.00, 'Credit Card', 1), (44000.00, 'UPI', 2), (15000.00, 'Debit Card', 3), (225000.00, 'Credit Card', 4),
(34000.00, 'Credit Card', 5), (44000.00, 'Net Banking', 6), (22000.00, 'UPI', 7), (55000.00, 'Credit Card', 8),
(8500.00, 'Debit Card', 9), (450000.00, 'Net Banking', 10), (22000.00, 'UPI', 11), (55500.00, 'Credit Card', 12),
(22000.00, 'UPI', 13), (44000.00, 'Debit Card', 14), (15000.00, 'Credit Card', 15), (225000.00, 'Net Banking', 16),
(34000.00, 'UPI', 17), (44000.00, 'Credit Card', 18), (22000.00, 'Debit Card', 19), (55000.00, 'Net Banking', 20),
(8500.00, 'UPI', 21), (450000.00, 'Credit Card', 22), (33000.00, 'Debit Card', 23), (55500.00, 'UPI', 24);

-- Insert data into 'feedback'
INSERT INTO feedback (rating, comments, booking_id) VALUES
(5, 'Excellent service and beautiful room. Will visit again!', 1), (4, 'Great location and friendly staff. The food could be better.', 2),
(5, 'Absolutely flawless stay. The presidential suite is worth every penny.', 4), (3, 'The room was clean, but the check-in process was very slow.', 7),
(5, 'Loved the honeymoon suite! Very romantic and private.', 6), (4, 'Good value for money. The standard room was comfortable.', 9),
(5, 'The staff went above and beyond for our anniversary. Thank you!', 16), (2, 'The Wi-Fi was very unreliable in my room.', 19);

-- Insert data into 'loyalty_program'
INSERT INTO loyalty_program (customer_id, tier_level, points) VALUES
(1, 'Gold', 1500), (2, 'Silver', 800), (3, 'Bronze', 200), (4, 'Platinum', 5500), (5, 'Silver', 500),
(6, 'Gold', 2200), (7, 'Bronze', 150), (8, 'Silver', 950), (9, 'Bronze', 50), (10, 'Platinum', 8500),
(11, 'Gold', 1800), (12, 'Silver', 1100),
(13, 'Bronze', 100), (14, 'Silver', 600), (15, 'Bronze', 150), (16, 'Gold', 3000), (17, 'Silver', 750),
(18, 'Gold', 1250), (19, 'Bronze', 250), (20, 'Silver', 850), (21, 'Bronze', 100), (22, 'Platinum', 6000),
(23, 'Gold', 2500), (24, 'Silver', 1300);

-- Insert data into 'task'
INSERT INTO task (description, due_date, status, assigned_to_staff_id) VALUES
('Prepare Room 201 for VIP guest arrival.', '2025-08-10', 'Completed', 8), ('Follow up with Mr. Reddy regarding his stay.', '2025-08-17', 'Pending', 7),
('Restock minibar for room 301 at Gachibowli branch.', '2025-09-01', 'Completed', 14), ('Deliver welcome fruit basket to room 102 Banjara Hills.', '2025-09-02', 'Completed', 11),
('Conduct monthly fire safety drill.', '2025-09-30', 'Pending', 9), ('Service AC unit in room 401 Gachibowli.', '2025-10-15', 'Pending', 15),
('Update marketing brochures.', '2025-10-20', 'Pending', 17), ('Perform security sweep of parking area.', '2025-10-25', 'Completed', 16);


-- =================================================================
-- Step 5: Populate SCM Transactional Data
-- =================================================================

-- Insert data into 'purchase_order'
INSERT INTO purchase_order (order_date, status, supplier_id) VALUES
('2025-07-20', 'Received', 1), ('2025-07-25', 'Received', 2), ('2025-08-01', 'Placed', 3),
('2025-08-15', 'Received', 4), ('2025-08-20', 'Placed', 5), ('2025-09-01', 'Received', 6),
('2025-09-05', 'Placed', 1), ('2025-09-10', 'Placed', 3),
('2025-09-15', 'Received', 2), ('2025-09-20', 'Received', 1), ('2025-10-01', 'Placed', 4),
('2025-10-05', 'Placed', 6);

-- Insert data into 'purchase_order_item'
INSERT INTO purchase_order_item (order_id, product_id, quantity) VALUES
(1, 4, 200), (1, 5, 500), (1, 14, 50), (2, 1, 100), (2, 2, 150), (2, 3, 300),
(3, 6, 50), (3, 13, 20), (4, 8, 20), (4, 9, 2), (5, 10, 50), (6, 11, 200),
(6, 12, 500), (7, 4, 300), (7, 5, 600), (8, 7, 1000),
(9, 1, 200), (9, 3, 400), (10, 14, 100), (11, 8, 30), (12, 11, 300);

-- Insert data into 'inventory'
INSERT INTO inventory (quantity_on_hand, warehouse_id, product_id) VALUES
-- Warehouse 1 Final Stock
(290, 1, 1),  -- Initial 90 + 200 from PO
(480, 1, 4),  -- Initial 180 + 300 from PO
(1050, 1, 5), -- Initial 450 + 600 from PO
(65, 1, 8),   -- Initial 15 + 50 from POs
(195, 1, 14), -- Initial 45 + 150 from POs

-- Warehouse 2 Final Stock
(140, 2, 2),  -- Initial 140
(950, 2, 3),  -- Initial 250 + 700 from POs
(40, 2, 6),   -- Initial 40
(3, 2, 9),    -- Initial 1 + 2 from PO
(35, 2, 13),  -- Initial 15 + 20 from PO

-- Warehouse 3 Final Stock
(90, 3, 10),  -- Initial 40 + 50 from PO
(680, 3, 11), -- Initial 180 + 500 from POs
(980, 3, 12), -- Initial 480 + 500 from PO
(1000, 3, 7); -- New stock from PO


-- =================================================================
-- Step 6: Populate Multivalued Attribute Tables
-- =================================================================

-- Insert data into 'branch_phone_numbers'
INSERT INTO branch_phone_numbers (branch_id, phone_number) VALUES
(1, '+91-870-2550101'), (1, '+91-870-2550102'), (2, '+91-40-4550201'), (3, '+91-40-6550301'), (3, '+91-40-6550302');

-- Insert data into 'room_amenities'
INSERT INTO room_amenities (room_id, amenity) VALUES
(1, 'Wi-Fi'), (1, '4K TV'), (1, 'Mini Bar'), (2, 'Wi-Fi'), (2, 'HD TV'), (3, 'Wi-Fi'), (3, '4K TV'),
(3, 'Mini Bar'), (3, 'Jacuzzi'), (6, 'Wi-Fi'), (6, '8K TV'), (6, 'Full Bar'), (6, 'Private Butler'),
(11, 'Wi-Fi'), (11, '4K TV'), (11, 'Jacuzzi'), (11, 'Balcony'), (12, 'Wi-Fi'), (12, '4K TV'), (12, 'Ocean View');

-- Insert data into 'customer_phone_numbers'
INSERT INTO customer_phone_numbers (customer_id, phone_number) VALUES
(1, '+91-9876543210'), (2, '+91-8765432109'), (2, '+91-7654321098'), (3, '+91-9988776655'),
(4, '+91-9123456789'), (5, '+91-9234567890'), (6, '+91-9345678901'), (7, '+91-9456789012'),
(8, '+91-9567890123'), (9, '+91-9678901234'), (10, '+91-9789012345'), (11, '+91-9890123456'),
(12, '+91-9901234567'), (13, '+91-8888888888'), (14, '+91-7777777777'), (15, '+91-6666666666'),
(16, '+91-5555555555'), (17, '+91-4444444444'), (18, '+91-3333333333'), (19, '+91-2222222222'),
(20, '+91-1111111111'), (21, '+91-9876543211'), (22, '+91-9876543212'), (23, '+91-9876543213'), (24, '+91-9876543214');

-- Insert data into 'booking_special_requests'
INSERT INTO booking_special_requests (booking_id, request) VALUES
(1, 'Extra pillows'), (1, 'Late check-out if possible'), (4, 'Decoration for anniversary'),
(6, 'Quiet room away from elevator'), (10, 'Full vegan menu for room service'), (12, 'Airport transfer required'),
(15, 'Crib for infant'), (22, 'Champagne on arrival');

-- Insert data into 'supplier_contact_persons'
INSERT INTO supplier_contact_persons (supplier_id, contact_person) VALUES
(1, 'Mr. Anand'), (2, 'Ms. Lakshmi'), (2, 'Mr. Prakash'), (3, 'Mr. Saleem'), (4, 'Ms. Geeta'), (5, 'Mr. Robert'),
(6, 'Ms. Sunita');

-- Insert data into 'product_allergens'

INSERT INTO product (product_id, name) VALUES (15, 'Chocolate Chip Cookies');
-- Now, populate its allergens
INSERT INTO product_allergens (product_id, allergen) VALUES
(15, 'Gluten'),
(15, 'Dairy'),
(15, 'May contain traces of Nuts');