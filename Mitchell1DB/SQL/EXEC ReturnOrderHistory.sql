DECLARE @RC int
DECLARE @CustomerId int = 1

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[ReturnOrderHistory] 
   @CustomerId
GO