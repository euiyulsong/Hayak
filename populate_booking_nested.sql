CREATE PROCEDURE uspGetItem
@ItemName varchar(60),
@ItemID INT OUTPUT
AS

SET @ItemID = (SELECT ItemID FROM ITEM WHERE Name = @ItemName)
GO

CREATE PROCEDURE uspGetBookingID
@CustomerID INT,
@WebsiteID INT,
@BookingID INT OUTPUT

AS

SET @BookingID = (SELECT BookingID FROM Booking WHERE CustomerID = @CustomerID AND WebsiteID = @WebsiteID)

GO

CREATE PROCEDURE uspRegisterBookingItem
@Fname1 varchar(60),
@Lname1 varchar(60),
@DOB1 date,
@Websitename1 varchar(60),
@ItemName1 varchar(60)
AS    
DECLARE @CustomerIDNew INT
DECLARE @WebsiteIDNew INT
DECLARE @BookingIDNew INT
DECLARE @ItemIDNEW INT

EXEC uspGetItem
@itemName = @ItemName1,
@itemID = @ItemIDNew OUTPUT
IF @ItemIDNew IS NULL
	BEGIN
	PRINT '@ItemIDNew cannot be NULL'
	RAISERROR ('@@ItemIDNew is NULL; Please check spelling of item', 12, 1)
	RETURN
	END     
EXECUTE uspGetCustomerID
@Fname = @Fname1,
@Lname = @Lname1,
@DOB = @DOB1,
@CustomerID = @CustomerIDNew OUTPUT

IF @CustomerIDNew IS NULL
	BEGIN
	PRINT 'CustomerID cannot be NULL'
	RAISERROR ('@CustomerID is NULL; Please check spelling of customer as well as their birthday', 12, 1)
	RETURN
	END

EXEC uspGetWebsiteID
@WebsiteName = @WebsiteName1,
@WebsiteID = @WebsiteIDNew OUTPUT

IF @WebsiteIDNew IS NULL
	BEGIN
	PRINT 'WebsiteID cannot be NULL'
	RAISERROR ('@WebsiteID is NULL; Please check spelling of webste', 12, 1)
	RETURN
	END

EXEC uspGetBookingItemID
@CustomerID = @CustomerIDNew,
@WebsiteID = @WebsiteIDNew,
@BookingID = @BookingIDNew OUTPUT

IF @BookingIDNew IS NULL
	BEGIN
	PRINT '@BookingID cannot be NULL'
	RAISERROR ('@BookingID is NULL; Please check customerID and websiteID', 12, 1)
	RETURN
	END

BEGIN TRAN T1
INSERT INTO Booking_Item (BookingID, ItemID)
VALUES (@BookingIDNew, @ItemIDNew)

IF @@ERROR <> 0 
	ROLLBACK TRAN T1
ELSE
	COMMIT TRAN T1
GO

EXEC uspRegisterBookingItem
@Fname1 = 'Malissa',
@Lname1 = 'Hemond',
@DOB1 = '1967-07-14',
@Websitename1 = 'booking',
@ItemName1 = 'Flight'


ALTER PROCEDURE hayakSynthetic_uspRegisterBookingItem
@Run INT
AS

DECLARE @FirstN varchar(60)
DECLARE @LastN varchar(60)
DECLARE @BirthDate Date
DECLARE @WebsiteN varchar(60)
DECLARE @ItemN varchar(60)


DECLARE @Num1 INT
DECLARE @Num2 INT
DECLARE @Num3 INT

DECLARE @CustomerCount INT = (SELECT Count(*) FROM Customer)
DECLARE @WebsiteCount INT = (SELECT Count(*) FROM Website)
DECLARE @ItemCount INT = (SELECT count(*) FROM Item)

DECLARE @CustomerPK INT
DECLARE @WebsitePK INT
DECLARE @ItemPK INT

WHILE @RUN > 0
BEGIN

SET @Num1 = (SELECT FLOOR(1 + RAND( ) * @CustomerCount))
SET @Num2 = (SELECT FLOOR(1 + RAND( ) * @WebsiteCount))
SET @Num3 = (SELECT FLOOR(1 + RAND() * @ItemCount))

SET @CustomerPK = (SELECT @Num1)
SET @WebsitePK = (SELECT @Num2)
SET @ItemPK = (SELECT @Num3)

SET @FirstN = (SELECT CustomerFName
FROM Customer
WHERE CustomerID = @CustomerPK)

SET @LastN = (SELECT CustomerLName
FROM Customer
WHERE CustomerID = @CustomerPK)

SET @BirthDate = (SELECT CustomerDOB
FROM Customer
WHERE CustomerID = @CustomerPK)

SET @WebsiteN = (SELECT WebsiteName
FROM Website
WHERE WebsiteID = @WebsitePK)

SET @ItemN = (SELECT Name
FROM Item
WHERE ItemID = @ItemPK)

EXECUTE uspRegisterBookingItem
@Fname1 = @FirstN,
@Lname1 = @LastN,
@DOB1 = @BirthDate,
@WebsiteName1 = @WebsiteN,
@ItemName1 = @ItemN

SET @Run = @Run - 1
END

EXECUTE hayakSynthetic_uspRegisterBookingItem 1000
