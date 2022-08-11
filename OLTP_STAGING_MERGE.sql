/****************************/
/*  MERGE OLTP TO STAGING   */
/****************************/

/*	CategoriesMerge	*/
MERGE
INTO	OLTP.Categories as trgt
USING	NWOLTP.dbo.Categories as src
ON      (trgt.CategoryID = src.CategoryID)
WHEN MATCHED 
    THEN    UPDATE
            SET     trgt.CategoryName   = src.CategoryName,
                    trgt."Description"  = src."Description",
                    trgt.Picture        = src.Picture          
WHEN NOT MATCHED BY TARGET 
    THEN    INSERT (CategoryName, "Description", Picture) 
            VALUES (src.CategoryName, src."Description", src.Picture)     
WHEN NOT MATCHED BY SOURCE 
    THEN    UPDATE
            SET     trgt.deleted = getDate();

/*	CustomersMerge	*/
MERGE
INTO	OLTP.Customers as trgt
USING	NWOLTP.dbo.Customers as src
ON      (trgt.CustomerID = src.CustomerID)
WHEN MATCHED 
    THEN    UPDATE
            SET     trgt.CompanyName    = src.CompanyName,
                    trgt.ContactName    = src.ContactName,
                    trgt.ContactTitle   = src.ContactTitle,          
                    trgt.Address        = src.Address,          
                    trgt.City           = src.City,          
                    trgt.Region         = src.Region,          
                    trgt.PostalCode     = src.PostalCode,          
                    trgt.Country        = src.Country,          
                    trgt.Phone          = src.Phone,          
                    trgt.Fax            = src.Fax          
WHEN NOT MATCHED BY TARGET 
    THEN    INSERT (CompanyName, ContactName, ContactTitle, "Address", City, Region, PostalCode, Country, Phone, Fax) 
            VALUES (src.CompanyName, src.ContactName, src.ContactTitle, src."Address", src.City, src.Region, src.PostalCode, src.Country, src.Phone, src.Fax)
WHEN NOT MATCHED BY SOURCE 
    THEN    UPDATE
            SET     trgt.deleted = getDate();

-- SELECT * FROM OLTP.Customers

/*	EmployeesMerge	*/
MERGE
INTO	OLTP.Employees as trgt
USING	NWOLTP.dbo.Employees as src
ON      (trgt.EmployeeID = src.EmployeeID)
WHEN MATCHED 
    THEN    UPDATE
            SET     trgt.LastName           = src.LastName,
                    trgt.FirstName          = src.FirstName,
                    trgt.Title              = src.Title,          
                    trgt.TitleOfCourtesy    = src.TitleOfCourtesy,          
                    trgt.BirthDate          = src.BirthDate,          
                    trgt.HireDate           = src.HireDate,          
                    trgt.Address            = src.Address,          
                    trgt.City               = src.City,          
                    trgt.Region             = src.Region,          
                    trgt.PostalCode         = src.PostalCode,          
                    trgt.Country            = src.Country,          
                    trgt.HomePhone          = src.HomePhone,          
                    trgt.Extension          = src.Extension,          
                    trgt.Photo              = src.Photo,          
                    trgt.Notes              = src.Notes,          
                    trgt.ReportsTo          = src.ReportsTo,          
                    trgt.PhotoPath          = src.PhotoPath          
WHEN NOT MATCHED BY TARGET 
    THEN    INSERT (LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, "Address", City, Region, PostalCode, Country, HomePhone, Extension, Photo, Notes, ReportsTo, PhotoPath) 
            VALUES (src.LastName, src.FirstName, src.Title, src.TitleOfCourtesy, src.BirthDate, src.HireDate, src."Address", src.City, src.Region, src.PostalCode, src.Country, src.HomePhone, src.Extension, src.Photo, src.Notes, src.ReportsTo, src.PhotoPath)
WHEN NOT MATCHED BY SOURCE 
    THEN    UPDATE
            SET     trgt.deleted = getDate();

-- SELECT * FROM OLTP.Employees

/*	EmployeeTerritoriesMerge	*/
-- Skipped for later Implementation of a Snowflake-Pattern

/*	"Order Details"Merge	*/
MERGE
INTO	OLTP.Employees as trgt
USING	NWOLTP.dbo.Employees as src
ON      (trgt.EmployeeID = src.EmployeeID)
WHEN MATCHED 
    THEN    UPDATE
            SET     trgt.LastName           = src.LastName,
                    trgt.FirstName          = src.FirstName,
                    trgt.Title              = src.Title,          
                    trgt.TitleOfCourtesy    = src.TitleOfCourtesy,          
                    trgt.BirthDate          = src.BirthDate,          
                    trgt.HireDate           = src.HireDate,          
                    trgt.Address            = src.Address,          
                    trgt.City               = src.City,          
                    trgt.Region             = src.Region,          
                    trgt.PostalCode         = src.PostalCode,          
                    trgt.Country            = src.Country,          
                    trgt.HomePhone          = src.HomePhone,          
                    trgt.Extension          = src.Extension,          
                    trgt.Photo              = src.Photo,          
                    trgt.Notes              = src.Notes,          
                    trgt.ReportsTo          = src.ReportsTo,          
                    trgt.PhotoPath          = src.PhotoPath          
WHEN NOT MATCHED BY TARGET 
    THEN    INSERT (LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, "Address", City, Region, PostalCode, Country, HomePhone, Extension, Photo, Notes, ReportsTo, PhotoPath) 
            VALUES (src.LastName, src.FirstName, src.Title, src.TitleOfCourtesy, src.BirthDate, src.HireDate, src."Address", src.City, src.Region, src.PostalCode, src.Country, src.HomePhone, src.Extension, src.Photo, src.Notes, src.ReportsTo, src.PhotoPath)
WHEN NOT MATCHED BY SOURCE 
    THEN    UPDATE
            SET     trgt.deleted = getDate();

-- SELECT * FROM OLTP.Employees

/*	OrdersMerge	*/
SELECT	*
INTO	OLTP.Orders
FROM	NWOLTP.dbo.Orders

ALTER TABLE OLTP.Orders
ADD deleted dateTime null, deleted_by nvarchar(50) null

/*	ProductsMerge	*/
SELECT	*
INTO	OLTP.Products
FROM	NWOLTP.dbo.Products

ALTER TABLE OLTP.Products
ADD deleted dateTime null, deleted_by nvarchar(50) null

/*	RegionMerge	*/
SELECT	*
INTO	OLTP.Region
FROM	NWOLTP.dbo.Region

ALTER TABLE OLTP.Region
ADD deleted dateTime null, deleted_by nvarchar(50) null

/*	ShippersMerge	*/
SELECT	*
INTO	OLTP.Shippers
FROM	NWOLTP.dbo.Shippers

ALTER TABLE OLTP.Shippers
ADD deleted dateTime null, deleted_by nvarchar(50) null

/*	SuppliersMerge	*/
SELECT	*
INTO	OLTP.Suppliers
FROM	NWOLTP.dbo.Suppliers

ALTER TABLE OLTP.Suppliers
ADD deleted dateTime null, deleted_by nvarchar(50) null

/*	TerritoriesMerge	*/
SELECT	*
INTO	OLTP.Territories
FROM	NWOLTP.dbo.Territories

ALTER TABLE OLTP.Territories
ADD deleted dateTime null, deleted_by nvarchar(50) null