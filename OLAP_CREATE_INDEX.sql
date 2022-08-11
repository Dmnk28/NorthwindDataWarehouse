/****************************************************/
/*	Preparing Dimension Keys & Columstore Indexes	*/
/****************************************************/
-- Regarding the short project time I switched between clusterd columstore and clustered primary key, simply depending on the tables containing LOB-Data or not.  

/*  DimCategories   */
ALTER TABLE Dimensions.DimCategories
ADD CONSTRAINT PK_Categories PRIMARY KEY (CategoryID);

CREATE COLUMNSTORE INDEX COL_Categories
ON Dimensions.DimCategories(CategoryID);

/*  DimCustomers   */
ALTER TABLE Dimensions.DimCustomers
ADD CONSTRAINT Uniq_Customers PRIMARY KEY NONCLUSTERED (CustomerID);

CREATE CLUSTERED COLUMNSTORE INDEX CL_COL_Customers
ON Dimensions.DimCustomers;

/*  DimDate   */
ALTER TABLE Dimensions.DimDate
ADD CONSTRAINT PK_Date PRIMARY KEY NONCLUSTERED (DateID);

CREATE CLUSTERED COLUMNSTORE INDEX CL_COL_Date
ON Dimensions.DimDate;

/*  DimEmployees   */
ALTER TABLE Dimensions.DimEmployees
ADD CONSTRAINT PK_Employees PRIMARY KEY (EmployeeID);

CREATE COLUMNSTORE INDEX COL_Employees
ON Dimensions.DimEmployees(EmployeeID);

/*  DimGeography   */
ALTER TABLE Dimensions.DimGeography
ADD CONSTRAINT PK_Geography PRIMARY KEY NONCLUSTERED (GeoID);

CREATE CLUSTERED COLUMNSTORE INDEX CL_COL_Geography
ON Dimensions.DimGeography;

/*  DimProducts   */
ALTER TABLE Dimensions.DimProducts
ADD CONSTRAINT PK_Products PRIMARY KEY (ProductID);

CREATE COLUMNSTORE INDEX COL_Products
ON Dimensions.DimProducts(ProductID);

/*  DimShippers   */
ALTER TABLE Dimensions.DimShippers
ADD CONSTRAINT PK_Shippers PRIMARY KEY NONCLUSTERED (ShipperID);

CREATE CLUSTERED COLUMNSTORE INDEX CL_COL_Shippers
ON Dimensions.DimShippers;

/*  DimSuppliers   */
ALTER TABLE Dimensions.DimSuppliers
ADD CONSTRAINT PK_Suppliers PRIMARY KEY CLUSTERED (SupplierID);

CREATE COLUMNSTORE INDEX COL_Suppliers
ON Dimensions.DimSuppliers(SupplierID);


/********************************************************************/
/*	Setting Primary and Foreign Keys in the FactOrderEvents Table	*/
/********************************************************************/

ALTER TABLE Facts.FactOrderEvents
ADD     CONSTRAINT PK_OrderEvents PRIMARY KEY NONCLUSTERED (OrderID, ProductID),
        CONSTRAINT FK_OrderEvents_Products FOREIGN KEY (ProductID) REFERENCES Dimensions.DimProducts(ProductID),
        CONSTRAINT FK_OrderEvents_Date FOREIGN KEY (DateID) REFERENCES Dimensions.DimDate(DateID),
        CONSTRAINT FK_OrderEvents_Customers FOREIGN KEY (CustomerID) REFERENCES Dimensions.DimCustomers(CustomerID),
        CONSTRAINT FK_OrderEvents_Categories FOREIGN KEY (CategoryID) REFERENCES Dimensions.DimCategories(CategoryID),
        CONSTRAINT FK_OrderEvents_Suppliers FOREIGN KEY (SupplierID) REFERENCES Dimensions.DimSuppliers(SupplierID),
        CONSTRAINT FK_OrderEvents_Shippers FOREIGN KEY (ShipperID) REFERENCES Dimensions.DimShippers(ShipperID),
        CONSTRAINT FK_OrderEvents_Employees FOREIGN KEY (EmployeeID) REFERENCES Dimensions.DimEmployees(EmployeeID),
        CONSTRAINT FK_OrderEvents_Geo_Ship FOREIGN KEY (ShippingGeoID) REFERENCES Dimensions.DimGeography(GeoID),
        CONSTRAINT FK_OrderEvents_Geo_Cust FOREIGN KEY (CustomerGeoID) REFERENCES Dimensions.DimGeography(GeoID),
        CONSTRAINT FK_OrderEvents_Geo_Supp FOREIGN KEY (SupplierGeoID) REFERENCES Dimensions.DimGeography(GeoID),
        CONSTRAINT FK_OrderEvents_Geo_Empl FOREIGN KEY (EmployeeGeoID) REFERENCES Dimensions.DimGeography(GeoID);

/********************************/
/*	Columstore for Fact Tables	*/
/********************************/

CREATE CLUSTERED COLUMNSTORE INDEX CL_COL_OrderEvents
ON Facts.FactOrderEvents;