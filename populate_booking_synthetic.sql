
ALTER PROCEDURE uspGetFeeID
@FeeName varchar(60),
@FeeID INT OUTPUT
AS
SET @FeeID = (SELECT FeeID FROM Fee WHERE FeeName = @FeeName)
GO

ALTER PROCEDURE uspRegisterBookingFee
@Fname1 varchar(60),
@Lname1 varchar(60),
@DOB1 date,
@WebsiteName1 varchar(60),
@FeeN1 varchar(60)

AS
DECLARE @FeeIDNew INT
DECLARE @CustomerIDNew INT
DECLARE @WebsiteIDNew INT
DECLARE @BookingIDNew INT

EXECUTE uspGetFeeID
@FeeName = @FeeN1,
@FeeID = @FeeIDNew OUTPUT

IF @FeeIDNew IS NULL
	BEGIN
	PRINT '@FeeIDNew cannot be NULL'
	RAISERROR ('@FeeIDNew is NULL; Please check spelling of fee name', 12, 1)
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

EXEC uspGetBookingID
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
INSERT INTO BOOKING_FEE (BookingID, FeeID)
VALUES (@BookingIDNew, @FeeIDNew)

IF @@ERROR <> 0 
	ROLLBACK TRAN T1
ELSE
	COMMIT TRAN T1
GO

EXEC uspRegisterBookingFee
@Fname1 = 'Ronni',
@Lname1 = 'Remeder',
@DOB1 = '1953-09-14',
@Websitename1 = 'American Airlines',
@FeeN1 = 'Flight Cancelled'


ALTER PROCEDURE hayakSynthetic_uspRegisterBookingFee
@Run INT
AS

DECLARE @FirstN1 varchar(60)
DECLARE @LastN1 varchar(60)
DECLARE @DateObject1 DATE
DECLARE @WebsiteN1 varchar(60)
DECLARE @FeeName1 varchar(60)

DECLARE @Num1 INT
DECLARE @Num2 INT
DECLARE @Num3 INT

DECLARE @CustomerCount INT = (SELECT Count(*) FROM Customer)
DECLARE @WebsiteCount INT = (SELECT Count(*) FROM Website)
DECLARE @BookingFeeCount INT = (SELECT Count(*) FROM Booking_Fee)

DECLARE @CustomerPK INT
DECLARE @WebsitePK INT
DECLARE @FeePK INT

WHILE @RUN > 0
BEGIN

SET @Num1 = (SELECT FLOOR(100))
SET @Num2 = (SELECT FLOOR(1 + RAND( ) * @WebsiteCount))
SET @Num3 = (SELECT FLOOR(1 + RAND() * @BookingFeeCount))

SET @CustomerPK = (SELECT @Num1)
SET @WebsitePK = (SELECT @Num2)
SET @FeePK = (SELECT @Num3)

SET @FirstN1 = (SELECT CustomerFName
FROM Customer
WHERE CustomerID = @CustomerPK)

SET @LastN1 = (SELECT CustomerLName
FROM Customer
WHERE CustomerID = @CustomerPK)

SET @DateObject1 = (SELECT CustomerDOB
FROM Customer
WHERE CustomerID = @CustomerPK)

SET @WebsiteN1 = (SELECT WebsiteName
FROM Website
WHERE WebsiteID = @WebsitePK)

SET @FeeName1 = (SELECT FeeName
FROM Fee
WHERE FeeID = @FeePK)

EXECUTE uspRegisterBookingFee
@Fname1 = @FirstN1,
@Lname1 = @LastN1,
@DOB1 = @DateObject1,
@WebsiteName1 = @WebsiteN1,
@FeeN1 = @FeeName1

SET @Run = @Run - 1
END
