--CREATE schema OLTP;
--CREATE schema OLAP;

/*	CategoriesTransfer	*/
SELECT	*
INTO	OLTP.Categories
FROM	NWOLTP.dbo.Categories

ALTER TABLE OLTP.Categories
ADD deleted dateTime null, deleted_by nvarchar(50) null

/*	CustomersTransfer	*/
SELECT	*
INTO	OLTP.Customers
FROM	NWOLTP.dbo.Customers

ALTER TABLE OLTP.Customers
ADD deleted dateTime null, deleted_by nvarchar(50) null

/*	EmployeesTransfer	*/
SELECT	*
INTO	OLTP.Employees
FROM	NWOLTP.dbo.Employees

ALTER TABLE OLTP.Employees
ADD deleted dateTime null, deleted_by nvarchar(50) null

/*	EmployeeTerritoriesTransfer	*/
SELECT	*
INTO	OLTP.EmployeeTerritories
FROM	NWOLTP.dbo.EmployeeTerritories

ALTER TABLE OLTP.EmployeeTerritories
ADD deleted dateTime null, deleted_by nvarchar(50) null

/*	"Order Details"Transfer	*/
SELECT	*
INTO	OLTP."Order Details"
FROM	NWOLTP.dbo."Order Details"
ALTER TABLE OLTP."Order Details"
ADD deleted dateTime null, deleted_by nvarchar(50) null

/*	OrdersTransfer	*/
SELECT	*
INTO	OLTP.Orders
FROM	NWOLTP.dbo.Orders

ALTER TABLE OLTP.Orders
ADD deleted dateTime null, deleted_by nvarchar(50) null

/*	ProductsTransfer	*/
SELECT	*
INTO	OLTP.Products
FROM	NWOLTP.dbo.Products

ALTER TABLE OLTP.Products
ADD deleted dateTime null, deleted_by nvarchar(50) null

/*	RegionTransfer	*/
SELECT	*
INTO	OLTP.Region
FROM	NWOLTP.dbo.Region

ALTER TABLE OLTP.Region
ADD deleted dateTime null, deleted_by nvarchar(50) null

/*	ShippersTransfer	*/
SELECT	*
INTO	OLTP.Shippers
FROM	NWOLTP.dbo.Shippers

ALTER TABLE OLTP.Shippers
ADD deleted dateTime null, deleted_by nvarchar(50) null

/*	SuppliersTransfer	*/
SELECT	*
INTO	OLTP.Suppliers
FROM	NWOLTP.dbo.Suppliers

ALTER TABLE OLTP.Suppliers
ADD deleted dateTime null, deleted_by nvarchar(50) null

/*	TerritoriesTransfer	*/
SELECT	*
INTO	OLTP.Territories
FROM	NWOLTP.dbo.Territories

ALTER TABLE OLTP.Territories
ADD deleted dateTime null, deleted_by nvarchar(50) null