ALTER PROCEDURE uspGetFeeType
@FeeTypeName varchar(60),
@FeeTypeID INT OUTPUT

AS

SET @FeeTypeID = (SELECT FeeTypeID FROM Fee_Type
					WHERE FeeTypeName = @FeeTypeName)
GO

ALTER PROCEDURE uspPutFee
@FeeName varchar(60),
@FeeDescr varchar(60),
@FeeTypeNameNew varchar(100)

AS
DECLARE @FeeTypeIDNew INT

EXECUTE uspGetSeatTypeID
@FeeTypeName = @FeeTypeNameNew,
@FeeTypeID = @FeeTypeIDNew OUTPUT

IF @FeeTypeIDNew IS NULL
	BEGIN
	PRINT 'FeeTypeID cannot be NULL'
	RAISERROR ('@FeeTypeID is Null; Please check spelling of FeeTypeName', 12, 1)
	RETURN
	END

BEGIN TRAN T1
INSERT INTO Fee (FeeName, FeeDescr)
VALUES (@FeeName, @FeeDescr)

IF @@ERROR <> 0
	ROLLBACK TRAN T1
ELSE
	COMMIT TRAN T1
GO

/* Nested Stored Procedure to populate Room table */
ALTER PROCEDURE uspGetRoomTypeID
@RoomTypeName varchar(60),
@RoomTypeID INT OUTPUT
       
AS    
      
SET @RoomTypeID = (SELECT RoomTypeID FROM Room_Type
	  				WHERE RoomTypeName = @RoomTypeName)
GO   
     
ALTER PROCEDURE uspPutRoom
@RoomTypeName1 varchar(60),
@RoomNumber INT,
@RoomSize INT
     
AS    
DECLARE @RoomTypeIDNew INT

EXECUTE uspGetRoomTypeID
@RoomTypeName = @RoomTypeName1,
@RoomTypeID = @RoomTypeIDNew OUTPUT

IF @RoomTypeIDNew IS NULL
	BEGIN
	PRINT 'RoomTypeID cannot be NULL'
	RAISERROR ('@RoomTypeID is NULL; Please check spelling of RoomTypeName', 12, 1)
	RETURN
	END

BEGIN TRAN T1
INSERT INTO Room (RoomTypeID, RoomNumber, RoomSize)
VALUES (@RoomTypeIDNew, @RoomNumber, @RoomSize)

IF @@ERROR <> 0 
	ROLLBACK TRAN T1
ELSE
	COMMIT TRAN T1
GO

EXECUTE uspPutRoom
@RoomTypeName1 = 'Double',
@RoomNumber = 700,
@RoomSize = 200
