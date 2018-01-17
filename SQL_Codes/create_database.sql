CREATE DATABASE HAYAK2 

CREATE TABLE REGION(
RegionID int identity (1,1) primary key not null,
RegionName varchar(50) not null,
RegionDescr varchar(100)
)

CREATE TABLE COUNTRY (
CountryID int identity (1,1) primary key not null,
RegionID int foreign key references REGION(RegionID),
CountryName varchar(50) not null,
CountryDescr varchar(100)
)

CREATE TABLE CITY(
CityID int identity (1,1) primary key not null,
CountryID int foreign key references COUNTRY(CountryID),
CityName varchar(50) not null,
CityDescr varchar(100)
)

CREATE TABLE AIRPORT_TYPE(
AirportTypeID int identity (1,1) primary key not null,
AirportTypeName varchar(50) not null,
AirportTypeDescr varchar(100)
)

CREATE TABLE AIRPORT(
AirportID int identity (1,1) primary key not null,
AirportTypeID int foreign key references AIRPORT_TYPE(AirportTypeID) not null,
CityID int foreign key references CITY(CityID) not null,
AirportName varchar(50) not null,
AirportDescr varchar(100)
)

CREATE TABLE [ROUTE](
RouteID int identity (1,1) primary key not null,
AirportID int foreign key references AIRPORT(AirportID) not null,
RouteName varchar(50) not null,
RouteDescr varchar(100)
)

CREATE TABLE WEBSITE(
WebsiteID int identity (1,1) primary key not null,
WebsiteName varchar(50) not null,
WebsiteDescr varchar(100)
)

CREATE TABLE CUSTOMER_TYPE(
CustomerTypeID int identity (1,1) primary key not null,
CustomerTypeName varchar(50) not null,
CustomerTypeDescr varchar(100)
)

CREATE TABLE CUSTOMER(
CustomerID int identity (1,1) primary key not null,
CustomerTypeID int foreign key references CUSTOMER_TYPE(CustomerTypeID),
CustomerFName varchar(50) not null,
CustomerLName varchar(50) not null,
CustomerDOB DATE not null
)

CREATE TABLE BOOKING(
BookingID int identity (1,1) primary key not null,
CustomerID int foreign key references CUSTOMER(CustomerID) not null,
WebsiteID int foreign key references WEBSITE(WebsiteID) not null,
BookDateTime DATETIME not null,
Fare varchar(50),
TotalCost int 
)

CREATE TABLE ITEM(
ItemID int identity (1,1) primary key not null,
Cost int,
Name varchar(50),
StartDateTime DATETIME,
EndDateTime DATETIME,
)

CREATE TABLE VEHICLE_TYPE(
VehicleTypeID int identity (1,1) primary key not null,
VehicleTypeName varchar(50) not null,
VehicleTypeDescr varchar(100)
)

CREATE TABLE VEHICLE(
ItemID int foreign key references ITEM(ItemID) not null,
VehicleTypeID int foreign key references VEHICLE_TYPE(VehicleTypeID) not null,
VehicleVIN int,
VehicleMake varchar(50),
VehicleYear int,
VehicleColor varchar(50),
BeginningMileage int,
Primary key (ItemID)
)

CREATE TABLE ROOM_TYPE(
RoomTypeID int identity (1,1) primary key not null,
RoomTypeName varchar(50) not null,
RoomTypeDescr varchar(100)
)

CREATE TABLE ROOM(
RoomID int identity (1,1) primary key not null,
RoomTypeID int foreign key references ROOM_TYPE(RoomTypeID),
RoomName varchar(50) not null,
RoomDescr varchar(100),
RoomSize varchar(50),
)

CREATE TABLE HOTEL(
ItemID int foreign key references ITEM(ItemID) not null,
RoomID int foreign key references ROOM(RoomID) not null, 
HotelDescr varchar(100),
HotelStreet varchar(50),
HotelCity varchar(50) not null,
HotelState varchar(50),
HotelCountry varchar(50),
primary key(ItemID)
)

CREATE TABLE BOOKING_ITEM(
BookingID int foreign key references BOOKING(BookingID) not null,
ItemID int foreign key references ITEM(ItemID) not null
)

CREATE TABLE CLASS(
ClassID int identity (1,1) primary key not null,
ClassName varchar(50) not null,
ClassDescr varchar(100)
)

CREATE TABLE SEAT_TYPE(
SeatTypeID int identity (1,1) primary key not null,
SeatTypeName varchar(50) not null,
SeatTypeDescr varchar(100)
)

CREATE TABLE SEAT(
SeatID int identity (1,1) primary key not null,
SeatTypeID int foreign key references SEAT_TYPE(SeatTypeID) not null,
SeatName varchar(50) not null,
SeatDescr varchar(100)
)

CREATE TABLE PLANE_TYPE(
PlaneTypeID int identity(1,1) primary key not null,
PlaneTypeName varchar(50) not null,
PlaneTypeDescr varchar(100)
)

CREATE TABLE PLANE(
PlaneID int identity (1,1) primary key not null,
PlaneTypeID int foreign key references PLANE_TYPE(PlaneTypeID) not null,
PlaneName varchar(50) not null,
PlaneDescr varchar(100)
)

CREATE TABLE SEAT_PLANE_CLASS(
SeatPlaneClassID int identity (1,1) primary key not null,
SeatID int foreign key references SEAT(SeatID) not null,
PlaneID int foreign key references PLANE(PlaneID) not null,
ClassID int foreign key references CLASS(ClassID) not null
)

CREATE TABLE FLIGHT(
ItemID int foreign key references ITEM(ItemID) not null,
RouteID int foreign key references ROUTE(RouteID) not null,
SeatPlaneClassID int foreign key references SEAT_PLANE_CLASS(SeatPlaneClassID) not null,
Primary key (ItemID)
)

CREATE TABLE [STATUS](
StatusID int identity (1,1) primary key not null,
StatusName varchar(50) not null,
StatusDescr varchar(100)
)

CREATE TABLE FLIGHT_STATUS(
FlightStatusID int identity (1,1) primary key not null,
FlightID int foreign key references FLIGHT(ItemID) not null,
StatusID int foreign key references [STATUS](StatusID) not null,
BeginTime DATETIME not null
)

CREATE TABLE BOOKING_FEE(
BookingID int foreign key references BOOKING(BookingID) not null,
FeeID int foreign key references FEE(FeeID) not null
)

CREATE TABLE FEE(
FeeID int identity (1,1) primary key not null,
FeeName varchar(50) not null,
FeeDescr varchar(100),
FeeAmount numeric (5,2),
FeeTypeID int foreign key references FEE_TYPE(FeeTypeID) not null
)

CREATE TABLE BOOKING_FEE(
FeeTypeID int identity (1,1) primary key not null,
FeeTypeName varchar(50) not null,
FeeTypeDescr varchar(100),
)

