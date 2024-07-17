                SELECT 
                    o.CustomerId, 
                    c.CustomerName,
                    p.ProductId, 
                    p.ProductName, 
                    SUM(od.Quantity) ProductQuantity,
                    SUM(od.Quantity * p.Price) TotalCost
                FROM [dbo].[Orders] o
                INNER JOIN [dbo].OrderDetails od ON o.OrderId = od.OrderId
                INNER JOIN [dbo].[Products] p ON od.ProductId = p.ProductId
                INNER JOIN [dbo].[Customers] c ON o.CustomerId = c.CustomerId
            GROUP BY 
                    o.CustomerId, 
                    c.CustomerName,
                    p.ProductId, 
                    p.ProductName
            ORDER BY o.CustomerId, ProductId
