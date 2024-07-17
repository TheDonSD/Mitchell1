-- 2.	Create a procedure that accepts this parameter: CustId
-- Return a dataset that contains a list of a customer's purchase history. That history will contain a list of products, quantity, and the total cost per product.


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Don Riedel
-- Create Date: 07/16/2024
-- Description: Returns customer order history
-- =============================================
CREATE PROCEDURE [dbo].[ReturnOrderHistory]
(
    @CustomerId INT
)
AS
BEGIN

SET NOCOUNT ON

BEGIN TRANSACTION TranOrderHistory
    BEGIN TRY 
        IF @CustomerId IS NULL
            BEGIN
                PRINT N'@CustomerId parameter is NULL. Please fix error and try again.'
            END
        ELSE
        IF 
            EXISTS(SELECT @CustomerId FROM Orders WHERE CustomerId = @CustomerId)
            BEGIN 
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
            WHERE o.CustomerId = @CustomerId
            GROUP BY 
                    o.CustomerId, 
                    c.CustomerName,
                    p.ProductId, 
                    p.ProductName
            END
        ELSE
            PRINT N'No order history exists for this customer.' 
        COMMIT TRANSACTION TranOrderHistory
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION TranOrderHistory
    END CATCH
END
GO