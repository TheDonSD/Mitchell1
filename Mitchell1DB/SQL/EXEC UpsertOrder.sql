DECLARE @RC int
DECLARE @CustomerId int = 1 
DECLARE @ProductId int = 101
DECLARE @OrderId int = 1
DECLARE @Quantity int = 8

EXECUTE @RC = [dbo].[UpsertOrder] 
   @CustomerId      
  ,@ProductId
  ,@OrderId
  ,@Quantity
GO