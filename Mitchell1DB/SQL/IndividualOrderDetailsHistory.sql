SELECT * FROM Orders 
INNER JOIN OrderDetails od ON Orders.OrderId = od.OrderId 
WHERE CustomerID = 1

