-- 1.	Create a procedure which accepts these parameters: CustId, ProductId, OrderId (OrderId is an optional parameter, default is NULL), Quantity
-- The procedure inserts or updates the data in these tables: Orders and OrderDetails.
-- If OrderId = NULL insert data, if OrderId exists, update the Quantity, if OrderId doesn’t exist, generate an error.

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Don Riedel
-- Create Date: 07/16/2024
-- Description: Inserts new order or updates existing order based on @OrderId
-- =============================================


IF OBJECT_ID('[dbo].[UpsertOrder]') IS NULL
EXEC('CREATE PROCEDURE [dbo].[UpsertOrder] AS SET NOCOUNT ON;')
GO

ALTER PROCEDURE [dbo].[UpsertOrder]
(
    @CustomerId INT,
    @ProductId INT,
    @OrderId INT = NULL, -- Optional parameter, default is NULL
    @Quantity INT
)
AS
BEGIN

SET NOCOUNT ON

BEGIN TRANSACTION TranUpsertOrder
    BEGIN TRY 

        -- Validate CustomerId
        IF NOT EXISTS (SELECT CustomerId FROM Customers WHERE CustomerId = @CustomerId)
        BEGIN
            RAISERROR ('CustomerId does not exist. Please provide a valid CustomerId.', 16, 1)
            ROLLBACK TRANSACTION TranUpsertOrder
            RETURN
        END
        
        -- Validate ProductId
        IF NOT EXISTS (SELECT ProductId FROM Products WHERE ProductId = @ProductId)
        BEGIN
            RAISERROR ('ProductId does not exist. Please provide a valid ProductId.', 16, 1)
            ROLLBACK TRANSACTION TranUpsertOrder
            RETURN
        END

        --  IF @OrderID IS NULL, insert new order in Orders and OrderDetails tables
        IF @OrderID IS NULL
            BEGIN
                INSERT INTO [dbo].[Orders] VALUES (@CustomerId, GETDATE())
                SET @OrderID = SCOPE_IDENTITY() -- Gets newly generated OrderId
                INSERT INTO [dbo].[OrderDetails] VALUES (@OrderId, @ProductId, @Quantity, GETDATE())
                PRINT N'Your order has been processed.'
                END
        ELSE
            BEGIN   
                -- Validate CustomerId is attached to OrderId
                IF NOT EXISTS (SELECT CustomerId FROM Orders WHERE OrderId = @OrderId AND CustomerId = @CustomerId)
                BEGIN
                    RAISERROR ('CustomerId is not associated with this order. Please provide correct CustomerId.', 16, 1)
                    ROLLBACK TRANSACTION TranUpsertOrder
                    RETURN
                END
                
                -- Validate ProductId is attached to OrderId
                IF NOT EXISTS (SELECT ProductId FROM OrderDetails WHERE OrderId = @OrderId AND ProductId = @ProductId)
                BEGIN
                    RAISERROR ('ProductId is not associated with this order. Please provide correct ProductId.', 16, 1)
                    ROLLBACK TRANSACTION TranUpsertOrder
                    RETURN
                END

            -- If @OrderID exists in Orders table, update OrderDetails table quantity
                IF EXISTS(SELECT OrderId FROM Orders WHERE OrderId = @OrderId) 
                BEGIN 
                    UPDATE [dbo].[OrderDetails] SET Quantity = @Quantity, LastUpdatedDate = GETDATE() WHERE OrderId = @OrderId
                    PRINT N'Your order quantity has been updated.'

                END
        END
        COMMIT TRANSACTION TranUpsertOrder
    END TRY

    BEGIN CATCH
        PRINT N'An error occured while processing the order.'
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR (@ErrorMessage, 16, 1);
        ROLLBACK TRANSACTION TranUpsertOrder
    END CATCH
END
GO