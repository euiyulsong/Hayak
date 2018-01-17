CREATE PROCEDURE uspGetCustomerID
@Fname varchar(60),
@Lname varchar(60),
@DOB date,
@CustomerID INT OUTPUT
       
AS    
      
SET @CustomerID = (SELECT CustomerID FROM Customer
	  				WHERE CustomerFName = @Fname
	  				AND CustomerLName = @Lname
	 				AND CustomerDOB = @DOB)
GO   
     
CREATE PROCEDURE uspGetWebsiteID
@WebsiteName varchar(60),
@WebsiteID INT OUTPUT

AS

SET @WebsiteID = (SELECT WebsiteID FROM Website
					WHERE WebsiteName = @WebsiteName)
GO
      
CREATE PROCEDURE uspPutBooking
@Fname1 varchar(60),
@Lname1 varchar(60),
@DOB1 date,
@WebsiteName1 varchar(60)
     
AS    
DECLARE @CustomerIDNew INT
DECLARE @WebsiteIDNew INT
DECLARE @BookingDateTime DATE = (SELECT GetDate())
     
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

BEGIN TRAN T1
INSERT INTO Booking (CustomerID, WebsiteID, BookDateTime)
VALUES (@CustomerIDNew, @WebsiteIDNew, @BookingDateTime)

IF @@ERROR <> 0 
	ROLLBACK TRAN T1
ELSE
	COMMIT TRAN T1
GO

EXECUTE uspPutBooking
@Fname1 = 'Delinda',
@Lname1 = 'Broekemeier',
@DOB1 = '1945-12-31',
@WebsiteName1 = 'Hotwire'
GO


ALTER PROCEDURE hayakSynthetic_uspRegisterBooking3
@Run INT
AS

DECLARE @FirstN varchar(60)
DECLARE @LastN varchar(60)
DECLARE @BirthDate Date

DECLARE @WebsiteN varchar(60)

DECLARE @Num1 INT
DECLARE @Num2 INT

DECLARE @CustomerCount INT = (SELECT Count(*) FROM Customer)
DECLARE @WebsiteCount INT = (SELECT Count(*) FROM Website)

DECLARE @CustomerPK INT
DECLARE @WebsitePK INT

WHILE @RUN > 0
BEGIN

SET @Num1 = (SELECT FLOOR(1 + RAND( ) * @CustomerCount))
SET @Num2 = (SELECT FLOOR(1 + RAND( ) * @WebsiteCount))

SET @CustomerPK = (SELECT @Num1)
SET @WebsitePK = (SELECT @Num2)

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

EXECUTE uspPutBooking
@Fname1 = @FirstN,
@Lname1 = @LastN,
@DOB1 = @BirthDate,
@WebsiteName1 = @WebsiteN

SET @Run = @Run - 1
END

EXECUTE hayakSynthetic_uspRegisterBooking3 1000




