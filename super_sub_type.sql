-- Add Hotel
EXECUTE uspAddHotel
@ItemCost = 100,
@ItemName = 'Hotel',
@StartDateTime = NULL,
@EndDateTime = NULL,
@RoomNumber = 110,
@HotelName = 'Greg Hotel',
@HotelDescr = NULL,
@HotelStreet = NULL,
@HotelCity = 'Seattle',
@HotelState = 'Washington',
@HotelCountry = 'United States',
@RoomTypeName = 'Double'
GO

-- Add Vehicle
EXECUTE uspAddVehicle
@Cost = 200,
@ItemName = 'Vehicle',
@StartDateTime = NULL,
@EndDateTime = NULL,
@VehicleTypeName = 'Hatchback',
@VehicleVIN = 'KNAFE121885079874',
@VehicleMake = 'Greg',
@VehicleYear = 2006,
@VehicleColor = 'Pink',
@BeginningMileage = 23,
@VehicleModel = 'Greg'
GO

--Add Flight
EXECUTE uspAddFlight
@ItemCost = 1000,
@ItemName = 'Flight',
@StartDateTime = NULL,
@EndDateTime = NULL,
@RouteName = 'Seattle to Madrid',
@SeatName = '1C',
@ClassName = 'First Class',
@PlaneName= 'Boeing 737',
@ScheduledArrival = NULL,
@ScheduledDepart = NULL,
@Airline = 'Greg Airline',
@StatusName = 'On Time'
GO


