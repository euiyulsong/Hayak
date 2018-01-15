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
@RoomTypeName1 = 'Single',
@RoomNumber = 102,
@RoomSize = 100
DELETE the Wrong Data From the Room Database
DELETE FROM Room
WHERE RoomID = 35
