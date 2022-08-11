/****************************/
/*	CREATE DimCategories	*/
/****************************/

SELECT	C.CategoryID,
		C.CategoryName,
		C.[Description] as CategoryDescription,
		C.deleted,
		C.deleted_by	
INTO	OLAP.DimCategories
FROM	OLTP.Categories as C

-- EXEC sp_help "OLAP.DimCategories";
-- drop table OLAP.DimCategories


/****************************/
/*	CREATE DimCustomers	*/
/****************************/

SELECT	C.CustomerID,
		C.CompanyName,
		C.ContactName,
		C.ContactTitle,
		C.Address,
		C.City,
		C.Region,
		C.PostalCode,
		C.Country,
		C.Phone,
		C.Fax,
		C.deleted,
		C.deleted_by	
INTO	OLAP.DimCustomers
FROM	OLTP.Customers as C


-- EXEC sp_help "OLAP.DimCustomers";
-- drop table OLAP.DimCustomers;

/************************/
/*	CREATE DimDate	*/
/************************/


CREATE TABLE OLAP.DimDate (
	DateID			INT				NOT NULL	IDENTITY(1,1),
	OrderDate		DATE			NOT NULL	,
	ShippedDate		DATE			NULL		,
	RequiredDate	DATE			NOT NULL	,
	OrderYear		SMALLINT		NOT NULL	,
	OrderMonth		TINYINT			NOT NULL	,
	OrderDay		TINYINT			NOT NULL	,
	OrderHour		TINYINT			NOT NULL	,
	OrderWeekday	TINYINT			NOT NULL	,
)

INSERT INTO	OLAP.DimDate
SELECT	DISTINCT O.OrderDate,
		O.ShippedDate,
		O.RequiredDate,
		YEAR(O.OrderDate),
		MONTH(O.OrderDate),
		DAY(O.OrderDate),
		DATEPART(HH, O.OrderDate),
		DATEPART(DW, O.OrderDate)
FROM	OLTP.Orders as O

-- Select * from OLAP.DimDate;
-- EXEC sp_help "OLAP.DimDate";
-- drop table OLAP.DimDate;


/************************/
/*	CREATE DimEmployees	*/
/************************/

SELECT	E.EmployeeID,
		CONCAT(E. FirstName, ' ', E.LastName) as "Name",
		E.Title,
		E.TitleOfCourtesy,
		E.BirthDate,
		E.HireDate,
		E.Address,
		E.City,
		E.Region,
		E.PostalCode,
		E.Country,
		E.HomePhone,
		E.Extension,
		E.Notes,
		E.ReportsTo	--,
		-- T.TerritoryID,
		-- T.TerritoryDescription,
		-- R.RegionID,
		-- R.RegionDescription,
		-- T.deleted as TerritoryRemoved,
		-- T.deleted_by as TerritoryRemoved_by,
		-- E.deleted as EmployeeDeleted,
		-- E.deleted_by as EmployeeDeleted_by	
INTO	OLAP.DimEmployees
FROM	OLTP.Employees as E
-- JOIN	OLTP.EmployeeTerritories as ET
-- ON		E.EmployeeID = ET.EmployeeID
-- JOIN	OLTP.Territories as T
-- ON		ET.TerritoryID = T.TerritoryID
-- JOIN	OLTP.Region as R
-- ON		T.RegionID = R.RegionID

-- Select * from OLAP.DimEmployees;
-- EXEC sp_help "OLAP.DimEmployees";
-- drop table OLAP.DimEmployees;

/************************/
/*	CREATE DimGeography	*/
/************************/


CREATE TABLE OLAP.DimGeography (
	GeoID				INT				NOT NULL	IDENTITY(1,1),
	AddressType			NVARCHAR(30)	NOT NULL	,
	"Address"			NVARCHAR(120)	NULL		,
	City				NVARCHAR(30)	NULL		,
	Region				NVARCHAR(30)	NULL		,
	PostalCode			NVARCHAR(20)	NULL		,
	Country				NVARCHAR(30)	NULL		
)

INSERT INTO	OLAP.DimGeography
SELECT	DISTINCT 'Shipping' as AddressType,
		O.ShipAddress,
		O.ShipCity,
		O.ShipRegion,
		O.ShipPostalCode,
		O.ShipCountry
FROM	OLTP.Orders as O

INSERT INTO	OLAP.DimGeography
SELECT	DISTINCT 'Customer' as AddressType,
		C.Address,
		C.City,
		C.Region,
		C.PostalCode,
		C.Country
FROM	OLTP.Customers as C

INSERT INTO	OLAP.DimGeography
SELECT	DISTINCT 'Supplier' as AddressType,
		S.Address,
		S.City,
		S.Region,
		S.PostalCode,
		S.Country
FROM	OLTP.Suppliers as S

INSERT INTO	OLAP.DimGeography
SELECT	DISTINCT 'Employee' as AddressType,
		E.Address,
		E.City,
		E.Region,
		E.PostalCode,
		E.Country
FROM	OLTP.Employees as E
-- Select * from OLAP.DimGeography;
-- EXEC sp_help "OLAP.DimGeography";
-- drop table OLAP.DimGeography;


/************************/
/*	CREATE DimProducts	*/
/************************/
SELECT	P.ProductID,
		P.ProductName,
		P.QuantityPerUnit,
		P.UnitPrice as Listprice,
		P.UnitsInStock,
		P.UnitsOnOrder,
		P.ReorderLevel,
		P.Discontinued,
		P.CategoryID,
		C.CategoryName,
		C.[Description] as CategoryDescription,
		P.SupplierID,
		S.CompanyName as SupplierName,
		S.City as SupplierCity,
		S.Region as SupplierRegion,
		S.Country as SupplierCountry,
		P.deleted,
		P.deleted_by	
INTO	OLAP.DimProducts
FROM	OLTP.Products as P
JOIN	OLTP.Categories as C
ON		P.CategoryID = C.CategoryID
JOIN	OLTP.Suppliers as S
ON		P.SupplierID = S.SupplierID

-- EXEC sp_help "OLAP.DimProducts";

/************************/
/*	CREATE DimShippers	*/
/************************/

SELECT	S.ShipperID,
		S.CompanyName,
		S.Phone	
INTO	OLAP.DimShippers
FROM	OLTP.Shippers as S

-- Select * from OLAP.DimShippers;
-- EXEC sp_help "OLAP.DimShippers";
-- drop table OLAP.DimShippers;

/************************/
/*	CREATE DimSuppliers	*/
/************************/

SELECT	S.SupplierID,
		S.CompanyName,
		S.ContactName,
		S.ContactTitle,
		S.Address,
		S.City,
		S.Region,
		S.PostalCode,
		S.Country,
		S.Phone,
		S.Fax,
		S.HomePage,
		S.deleted,
		S.deleted_by
INTO	OLAP.DimSuppliers
FROM	OLTP.Suppliers as S

-- Select * from OLAP.DimSuppliers;
-- EXEC sp_help "OLAP.DimSuppliers";
-- drop table OLAP.DimSuppliers;




/****************************/
/*	CREATE FactOrderEvents	*/
/****************************/

SELECT 	OD.OrderID,
		OD.ProductID,
		OD.UnitPrice as OrderPrice,
		P.UnitPrice as ListPrice,
		OD.Quantity,
		CONVERT(decimal(3,2), OD.Discount) as Discount,
		OD.UnitPrice * OD.Quantity * (1 - CONVERT(decimal(3,2), OD.Discount)) as LineTotal,
		OD.deleted,
		OD.deleted_by,
		(	SELECT	DateID
			FROM	OLAP.DimDate as D
			WHERE	CONVERT(date, O.OrderDate) = D.OrderDate
			AND		CONVERT(date, O.ShippedDate) = D.ShippedDate
			AND		CONVERT(date, O.RequiredDate) = D.RequiredDate
			AND		DATEPART(HH, O.OrderDate) = D.OrderHour	) as DateID,
		O.CustomerID,
		P.CategoryID,
		(	SELECT	GeoID
			FROM	OLAP.DimGeography
			WHERE	"Address" 	= (	SELECT "Address" FROM OLTP.Customers WHERE CustomerID = O.CustomerID )
			AND		City 		= (	SELECT City FROM OLTP.Customers WHERE CustomerID = O.CustomerID )
			AND		AddressType = 'Customer'	) as CustomerGeoID,
		(	SELECT	GeoID
			FROM	OLAP.DimGeography
			WHERE	"Address" = O.ShipAddress
			AND		City = O.ShipCity
			AND		AddressType = 'Shipping'	) as ShippingGeoID,
		P.SupplierID,
		(	SELECT	GeoID
			FROM	OLAP.DimGeography
			WHERE	"Address" 	= (	SELECT "Address" FROM OLTP.Suppliers WHERE SupplierID = P.SupplierID )
			AND		City 		= (	SELECT City FROM OLTP.Suppliers WHERE SupplierID = P.SupplierID )
			AND		AddressType = 'Supplier'	) as SupplierGeoID,
		O.EmployeeID,
		(	SELECT	GeoID
			FROM	OLAP.DimGeography
			WHERE	"Address" 	= (	SELECT "Address" FROM OLTP.Employees WHERE EmployeeID = O.EmployeeID )
			AND		City 		= (	SELECT City FROM OLTP.Employees WHERE EmployeeID = O.EmployeeID )
			AND		AddressType = 'Employee'	) as EmployeeGeoID,
		O.ShipVia as ShipperID
INTO 	OLAP.FactOrderEvents
FROM	OLTP.[Order Details] as OD
JOIN	OLTP.Orders as O
ON		OD.OrderID = O.OrderID
JOIN	OLTP.Products as P
ON		OD.ProductID = P.ProductID


SELECT * from OLAP.FactOrderEvents;
Select * from OLTP.[Order Details];
DROP TABLE OLAP.FactOrderEvents;

/* Old Table attempt
CREATE table FactOrderEvents (
	OrderID			int				not null	,
	ProductID		int				not null	,
	OrderPrice		decimal(16,2)	null		,
	ListPrice		decimal(16,2)	null		,
	Quantity		int				null		,
	Discount		decimal(3,2)	null		,
	Linetotal		decimal(16,2)	null		,
	DateID			int				not null	,
	CustomerID		int				not null	,
	CategoryID		int				not null	,
	SupplierID		int				not null	,
	GeoID			int				not null	,
	ShipperID		int				not null	
)
*/
/*
Constraints for OLAP
CREATE table FactOrderEvents (
	OrderID			int				not null	,
	ProductID		int				not null	constraint FK_Products references DimProducts,
	OrderPrice		decimal(16,2)	null		,
	ListPrice		decimal(16,2)	null		,
	Quantity		int				null		,
	Discount		decimal(3,2)	null		,
	Linetotal		decimal(16,2)	null		,
	DateID			int				not null	constraint FK_Date references DimDate,
	CustomerID		int				not null	constraint FK_Customer references DimCustomers,
	CategoryID		int				not null	constraint FK_Category references DimCategories,
	SupplierID		int				not null	constraint FK_Supplier references DimSuppliers,
	GeoID			int				not null	constraint FK_Geo references DimGeography,
	ShipperID		int				not null	constraint FK_Shipper references DimShippers
	constraint PK_FactOrderEvents primary key (OrderID, ProductID)
)
*/