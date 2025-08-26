-- == TESTING QUERIES ==

-- Query 1: Find Available Rooms (Deluxe) in a Hotel during a Date Range
SELECT r.RoomID, r.RoomNumber, rt.TypeName, rt.BasePrice
FROM Room r
JOIN RoomType rt ON r.RoomTypeID = rt.RoomTypeID
WHERE r.HotelID = 1 AND rt.TypeName = 'Deluxe'
  AND r.RoomID NOT IN (
    SELECT b.RoomID
    FROM Booking b
    WHERE b.CheckInDate < '2025-09-15' AND b.CheckOutDate > '2025-09-10'
);

-- Query 2: Get a Customer's Complete Booking History
SELECT c.FirstName, c.LastName, b.BookingID, b.CheckInDate, b.CheckOutDate, h.Name AS HotelName, rt.TypeName
FROM Customer c
JOIN Booking b ON c.CustomerID = b.CustomerID
JOIN Room r ON b.RoomID = r.RoomID
JOIN RoomType rt ON r.RoomTypeID = rt.RoomTypeID
JOIN Hotel h ON r.HotelID = h.HotelID
WHERE c.FirstName = 'John' AND c.LastName = 'Smith';

-- Query 3: Calculate Total Revenue Per Hotel for a Month
SELECT h.Name AS HotelName, SUM(p.Amount) AS TotalRevenue
FROM Payment p
JOIN Booking b ON p.BookingID = b.BookingID
JOIN Room r ON b.RoomID = r.RoomID
JOIN Hotel h ON r.HotelID = h.HotelID
WHERE MONTH(p.PaymentDate) = 8 AND YEAR(p.PaymentDate) = 2025
GROUP BY h.Name
ORDER BY TotalRevenue DESC;

-- Query 4: Find Top-Rated Customers (Assume Rating Stored in Booking Notes as Extension)
-- (If Feedback table existed, we'd use that. For now, placeholder.)
-- SELECT c.FirstName, c.LastName, c.Email, f.Comments
-- FROM Feedback f
-- JOIN Booking b ON f.BookingID = b.BookingID
-- JOIN Customer c ON b.CustomerID = c.CustomerID
-- WHERE f.Rating = 5;

-- Query 5: List All Staff Members by Department in a Hotel
SELECT e.FirstName, e.LastName, e.EmployeeID, d.DeptName, h.Name AS HotelName
FROM Employee e
JOIN Department d ON e.DeptID = d.DeptID
JOIN Hotel h ON e.HotelID = h.HotelID
WHERE d.DeptName = 'Housekeeping' AND e.HotelID = 3;

-- Query 6: (Not Applicable - No Task Table in Schema)
-- Would require a Task/Assignment table.

-- Query 7: Check Stock Level of a Product Across All Warehouses
SELECT p.ProductName, w.Location, i.Quantity
FROM Inventory i
JOIN Product p ON i.ProductID = p.ProductID
JOIN Warehouse w ON i.WarehouseID = w.WarehouseID
WHERE p.ProductName = 'Luxury Bath Towel'
ORDER BY w.Location;

-- Query 8: Generate a Low Stock Alert for a Warehouse
SELECT p.ProductName, i.Quantity
FROM Inventory i
JOIN Product p ON i.ProductID = p.ProductID
WHERE i.WarehouseID = 1 AND i.Quantity < 100;

-- Query 9: Get All Line Items for a Specific Purchase Order
SELECT p.ProductName, od.Quantity, od.UnitPrice
FROM OrderDetail od
JOIN Product p ON od.ProductID = p.ProductID
WHERE od.POID = 2;

-- Query 10: Find Which Suppliers Provide a Specific Product (via Purchase Orders)
SELECT DISTINCT s.SupplierName, s.ContactPerson, s.PhoneNumber
FROM Supplier s
JOIN PurchaseOrder po ON s.SupplierID = po.SupplierID
JOIN OrderDetail od ON po.POID = od.POID
JOIN Product p ON od.ProductID = p.ProductID
WHERE p.ProductName = 'Luxury Bath Towel';
