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
MERGE
INTO	OLTP.EmployeeTerritories as trgt
USING	NWOLTP.dbo.EmployeeTerritories as src
ON      (trgt.EmployeeID = src.EmployeeID)
AND     (trgt.TerritoryID = src.TerritoryID)        
WHEN NOT MATCHED BY TARGET 
    THEN    INSERT (EmployeeID, TerritoryID) 
            VALUES (src.EmployeeID, src.TerritoryID)
WHEN NOT MATCHED BY SOURCE 
    THEN    UPDATE
            SET     trgt.deleted = getDate();

-- SELECT * FROM OLTP.EmployeeTerritories


/*	"Order Details"Merge	*/
MERGE
INTO	OLTP."Order Details" as trgt
USING	NWOLTP.dbo."Order Details" as src
ON      (trgt.OrderID = src.OrderID)
AND     (trgt.ProductID = src.ProductID)
WHEN MATCHED 
    THEN    UPDATE
            SET     trgt.UnitPrice  = src.UnitPrice,
                    trgt.Quantity   = src.Quantity,
                    trgt.Discount   = src.Discount          
WHEN NOT MATCHED BY TARGET 
    THEN    INSERT (UnitPrice, Quantity, Discount) 
            VALUES (src.UnitPrice, src.Quantity, src.Discount)
WHEN NOT MATCHED BY SOURCE 
    THEN    UPDATE
            SET     trgt.deleted = getDate();

-- SELECT * FROM OLTP."Order Details"


/*	OrdersMerge	*/
MERGE
INTO	OLTP.Orders as trgt
USING	NWOLTP.dbo.Orders as src
ON      (trgt.OrderID = src.OrderID)
WHEN MATCHED 
    THEN    UPDATE
            SET     trgt.CustomerID     = src.CustomerID,
                    trgt.EmployeeID     = src.EmployeeID,
                    trgt.OrderDate      = src.OrderDate,          
                    trgt.RequiredDate   = src.RequiredDate,          
                    trgt.ShippedDate    = src.ShippedDate,          
                    trgt.ShipVia        = src.ShipVia,          
                    trgt.Freight        = src.Freight,          
                    trgt.ShipName       = src.ShipName,          
                    trgt.ShipAddress    = src.ShipAddress,          
                    trgt.ShipCity       = src.ShipCity,          
                    trgt.ShipRegion     = src.ShipRegion,          
                    trgt.ShipPostalCode = src.ShipPostalCode,          
                    trgt.ShipCountry    = src.ShipCountry         
WHEN NOT MATCHED BY TARGET 
    THEN    INSERT (CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipRegion, ShipPostalCode, ShipCountry) 
            VALUES (src.CustomerID, src.EmployeeID, src.OrderDate, src.RequiredDate, src.ShippedDate, src.ShipVia, src.Freight, src.ShipName, src.ShipAddress, src.ShipCity, src.ShipRegion, src.ShipPostalCode, src.ShipCountry) 
WHEN NOT MATCHED BY SOURCE 
    THEN    UPDATE
            SET     trgt.deleted = getDate();

-- SELECT * FROM OLTP.Orders


/*	ProductsMerge	*/
MERGE
INTO	OLTP.Products as trgt
USING	NWOLTP.dbo.Products as src
ON      (trgt.ProductID = src.ProductID)
WHEN MATCHED 
    THEN    UPDATE
            SET     trgt.ProductName        = src.ProductName,
                    trgt.SupplierID         = src.SupplierID,
                    trgt.CategoryID         = src.CategoryID,          
                    trgt.QuantityPerUnit    = src.QuantityPerUnit,          
                    trgt.UnitPrice          = src.UnitPrice,          
                    trgt.UnitsInStock       = src.UnitsInStock,          
                    trgt.UnitsOnOrder       = src.UnitsOnOrder,          
                    trgt.ReorderLevel       = src.ReorderLevel,          
                    trgt.Discontinued       = src.Discontinued       
WHEN NOT MATCHED BY TARGET 
    THEN    INSERT (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued) 
            VALUES (src.ProductName, src.SupplierID, src.CategoryID, src.QuantityPerUnit, src.UnitPrice, src.UnitsInStock, src.UnitsOnOrder, src.ReorderLevel, src.Discontinued)  
WHEN NOT MATCHED BY SOURCE 
    THEN    UPDATE
            SET     trgt.deleted = getDate();

-- SELECT * FROM OLTP.Products


/*	RegionMerge	*/
MERGE
INTO	OLTP.Region as trgt
USING	NWOLTP.dbo.Region as src
ON      (trgt.RegionID = src.RegionID)
WHEN MATCHED 
    THEN    UPDATE
            SET     trgt.RegionDescription  = src.RegionDescription          
WHEN NOT MATCHED BY TARGET 
    THEN    INSERT (RegionDescription) 
            VALUES (src.RegionDescription)
WHEN NOT MATCHED BY SOURCE 
    THEN    UPDATE
            SET     trgt.deleted = getDate();

-- SELECT * FROM OLTP.Region


/*	ShippersMerge	*/
MERGE
INTO	OLTP.Shippers as trgt
USING	NWOLTP.dbo.Shippers as src
ON      (trgt.ShipperID = src.ShipperID)
WHEN MATCHED 
    THEN    UPDATE
            SET     trgt.CompanyName    = src.CompanyName,          
                    trgt.Phone          = src.Phone          
WHEN NOT MATCHED BY TARGET 
    THEN    INSERT (CompanyName, Phone) 
            VALUES (src.CompanyName, Phone)
WHEN NOT MATCHED BY SOURCE 
    THEN    UPDATE
            SET     trgt.deleted = getDate();

-- SELECT * FROM OLTP.Shippers


/*	SuppliersMerge	*/
MERGE
INTO	OLTP.Suppliers as trgt
USING	NWOLTP.dbo.Suppliers as src
ON      (trgt.SupplierID = src.SupplierID)
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
                    trgt.Fax            = src.Fax,       
                    trgt.HomePage       = src.HomePage       
WHEN NOT MATCHED BY TARGET 
    THEN    INSERT (CompanyName, ContactName, ContactTitle, "Address", City, Region, PostalCode, Country, Phone, Fax, HomePage) 
            VALUES (src.CompanyName, src.ContactName, src.ContactTitle, src."Address", src.City, src.Region, src.PostalCode, src.Country, src.Phone, src.Fax, src.HomePage)  
WHEN NOT MATCHED BY SOURCE 
    THEN    UPDATE
            SET     trgt.deleted = getDate();

-- SELECT * FROM OLTP.Suppliers


/*	TerritoriesMerge	*/
MERGE
INTO	OLTP.Territories as trgt
USING	NWOLTP.dbo.Territories as src
ON      (trgt.TerritoryID = src.TerritoryID)
WHEN MATCHED 
    THEN    UPDATE
            SET     trgt.TerritoryDescription   = src.TerritoryDescription,
                    trgt.RegionID               = src.RegionID          
WHEN NOT MATCHED BY TARGET 
    THEN    INSERT (TerritoryDescription, RegionID) 
            VALUES (src.TerritoryDescription, src.RegionID)
WHEN NOT MATCHED BY SOURCE 
    THEN    UPDATE
            SET     trgt.deleted = getDate();

-- SELECT * FROM OLTP.Territories
