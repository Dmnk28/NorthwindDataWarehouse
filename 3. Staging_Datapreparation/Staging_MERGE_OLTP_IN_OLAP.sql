/*******************************************************************/
/*  MERGE THE OLTP-TABLES INTO THE OLAP-TABLES IN THE STAGING DB   */
/*******************************************************************/

/****************/
/*  Dimensions  */
/****************/

/*	Merging into the Categories Dimension	*/
MERGE
INTO	OLAP.DimCategories as trgt
USING	OLTP.Categories as src
ON      (trgt.CategoryID = src.CategoryID)
WHEN MATCHED 
    THEN    UPDATE
            SET     trgt.CategoryName   = src.CategoryName,
                    trgt.CategoryDescription  = src."Description"        
WHEN NOT MATCHED BY TARGET 
    THEN    INSERT (CategoryName, CategoryDescription) 
            VALUES (src.CategoryName, src."Description")     
WHEN NOT MATCHED BY SOURCE 
    THEN    UPDATE
            SET     trgt.deleted = getDate();

-- SELECT * FROM OLAP.DimCategories;


/*	Merging into the Customers Dimension	*/
MERGE
INTO	OLAP.DimCustomers as trgt
USING	OLTP.Customers as src
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
                    trgt.Fax            = src.Fax,
                    trgt.deleted        = src.deleted          
WHEN NOT MATCHED BY TARGET 
    THEN    INSERT (CompanyName, ContactName, ContactTitle, "Address", City, Region, PostalCode, Country, Phone, Fax, deleted) 
            VALUES (src.CompanyName, src.ContactName, src.ContactTitle, src."Address", src.City, src.Region, src.PostalCode, src.Country, src.Phone, src.Fax, deleted)
WHEN NOT MATCHED BY SOURCE 
    THEN    UPDATE
            SET     trgt.deleted = getDate();

-- SELECT * FROM OLAP.DimCustomers


/*	Merging into the Employees Dimension	*/
MERGE
INTO	OLAP.DimEmployees as trgt
USING	OLTP.Employees as src
ON      (trgt.EmployeeID = src.EmployeeID)
WHEN MATCHED 
    THEN    UPDATE
            SET     trgt."Name"             = CONCAT(src.Firstname, ' ', src.LastName),
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
                    trgt.Notes              = src.Notes,          
                    trgt.ReportsTo          = src.ReportsTo          
WHEN NOT MATCHED BY TARGET 
    THEN    INSERT ("Name", Title, TitleOfCourtesy, BirthDate, HireDate, "Address", City, Region, PostalCode, Country, HomePhone, Extension, Notes, ReportsTo) 
            VALUES (CONCAT(src.Firstname, ' ', src.LastName), src.Title, src.TitleOfCourtesy, src.BirthDate, src.HireDate, src."Address", src.City, src.Region, src.PostalCode, src.Country, src.HomePhone, src.Extension, src.Notes, src.ReportsTo)
WHEN NOT MATCHED BY SOURCE 
    THEN    UPDATE
            SET     trgt.deleted = getDate();

-- SELECT * FROM OLAP.DimEmployees


/*	Merging into the EmployeeTerritories Dimension	*/
-- Kept for Later ;-)


/*	Merging into the Date Dimension	*/
MERGE
INTO	OLAP.DimDate as trgt
USING	OLTP.Orders as src
ON      (trgt.OrderDate     = CONVERT(date, src.Orderdate))
AND     (trgt.ShippedDate   = CONVERT(date, src.Shippeddate))
AND     (trgt.RequiredDate  = CONVERT(date, src.Requireddate))
AND     (trgt.OrderHour     = DATEPART(HH, src.OrderDate))
WHEN NOT MATCHED BY TARGET 
    THEN    INSERT (OrderDate, ShippedDate, RequiredDate, OrderYear, OrderMonth, OrderDay, OrderHour, OrderWeekday) 
            VALUES (CONVERT(date, src.OrderDate), CONVERT(date, src.ShippedDate), CONVERT(date, src.RequiredDate), YEAR(src.OrderDate), MONTH(src.OrderDate), DAY(src.OrderDate), DATEPART(HH, src.OrderDate), DATEPART(dw, src.OrderDate));

-- SELECT * FROM OLAP.DimDate


/*	ProductsMerge	*/
-- Check The With 
-- WITH (  SELECT  *   
--         FROM    OLTP.Products as OP
--         JOIN    OLTP.Suppliers as OS
--         ON      OP.SupplierID = OS.SupplierID
-- ) as #ProdSuppJoin
-- MERGE
-- INTO	OLAP.DimProducts as trgt
-- USING	#ProdSuppJoin as src
-- ON      (trgt.ProductID = src.ProductID)
-- WHEN MATCHED 
--     THEN    UPDATE
--             SET     trgt.ProductName        = src.ProductName,
--                     trgt.SupplierID         = src.SupplierID,
--                     trgt.CategoryID         = src.CategoryID,          
--                     trgt.QuantityPerUnit    = src.QuantityPerUnit,          
--                     trgt.ListPrice          = src.UnitPrice,          
--                     trgt.UnitsInStock       = src.UnitsInStock,          
--                     trgt.UnitsOnOrder       = src.UnitsOnOrder,          
--                     trgt.ReorderLevel       = src.ReorderLevel,          
--                     trgt.Discontinued       = src.Discontinued       
-- WHEN NOT MATCHED BY TARGET 
--     THEN    INSERT (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued) 
--             VALUES (src.ProductName, src.SupplierID, src.CategoryID, src.QuantityPerUnit, src.UnitPrice, src.UnitsInStock, src.UnitsOnOrder, src.ReorderLevel, src.Discontinued)  
-- WHEN NOT MATCHED BY SOURCE 
--     THEN    UPDATE
--             SET     trgt.deleted = getDate();

-- SELECT * FROM OLAP.DimProducts


/*	RegionMerge	*/
-- Kept for later ;-)



-- /*	ShippersMerge	*/
-- MERGE
-- INTO	OLTP.Shippers as trgt
-- USING	NWOLTP.dbo.Shippers as src
-- ON      (trgt.ShipperID = src.ShipperID)
-- WHEN MATCHED 
--     THEN    UPDATE
--             SET     trgt.CompanyName    = src.CompanyName,          
--                     trgt.Phone          = src.Phone          
-- WHEN NOT MATCHED BY TARGET 
--     THEN    INSERT (CompanyName, Phone) 
--             VALUES (src.CompanyName, Phone)
-- WHEN NOT MATCHED BY SOURCE 
--     THEN    UPDATE
--             SET     trgt.deleted = getDate();

-- SELECT * FROM OLTP.Shippers


-- /*	SuppliersMerge	*/
-- MERGE
-- INTO	OLTP.Suppliers as trgt
-- USING	NWOLTP.dbo.Suppliers as src
-- ON      (trgt.SupplierID = src.SupplierID)
-- WHEN MATCHED 
--     THEN    UPDATE
--             SET     trgt.CompanyName    = src.CompanyName,
--                     trgt.ContactName    = src.ContactName,
--                     trgt.ContactTitle   = src.ContactTitle,          
--                     trgt.Address        = src.Address,          
--                     trgt.City           = src.City,          
--                     trgt.Region         = src.Region,          
--                     trgt.PostalCode     = src.PostalCode,          
--                     trgt.Country        = src.Country,          
--                     trgt.Phone          = src.Phone,       
--                     trgt.Fax            = src.Fax,       
--                     trgt.HomePage       = src.HomePage       
-- WHEN NOT MATCHED BY TARGET 
--     THEN    INSERT (CompanyName, ContactName, ContactTitle, "Address", City, Region, PostalCode, Country, Phone, Fax, HomePage) 
--             VALUES (src.CompanyName, src.ContactName, src.ContactTitle, src."Address", src.City, src.Region, src.PostalCode, src.Country, src.Phone, src.Fax, src.HomePage)  
-- WHEN NOT MATCHED BY SOURCE 
--     THEN    UPDATE
--             SET     trgt.deleted = getDate();

-- -- SELECT * FROM OLTP.Suppliers


-- /*	TerritoriesMerge	*/
-- -- Kept for later ;-)


-- /***********/
-- /*  Facts  */
-- /***********/

-- /*	Merging into the OrderEvents Facts	*/
-- MERGE
-- INTO	OLTP."Order Details" as trgt
-- USING	NWOLTP.dbo."Order Details" as src
-- ON      (trgt.OrderID = src.OrderID)
-- AND     (trgt.ProductID = src.ProductID)
-- WHEN MATCHED 
--     THEN    UPDATE
--             SET     trgt.UnitPrice  = src.UnitPrice,
--                     trgt.Quantity   = src.Quantity,
--                     trgt.Discount   = src.Discount          
-- WHEN NOT MATCHED BY TARGET 
--     THEN    INSERT (UnitPrice, Quantity, Discount) 
--             VALUES (src.UnitPrice, src.Quantity, src.Discount)
-- WHEN NOT MATCHED BY SOURCE 
--     THEN    UPDATE
--             SET     trgt.deleted = getDate();

-- -- SELECT * FROM OLTP."Order Details"