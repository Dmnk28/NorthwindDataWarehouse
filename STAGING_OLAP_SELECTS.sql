/************************/
/*	ONLY ON FIRST RUN	*/
/************************/

/*
    CREATE SCHEMA Facts;
*/

/*
    CREATE SCHEMA Dimensions;
*/

/****************************/
/*	Importing Dimensions	*/
/****************************/

SELECT  *
INTO    Dimensions.DimCategories
FROM    NWStaging.OLAP.DimCategories

SELECT  *
INTO    Dimensions.DimCustomers
FROM    NWStaging.OLAP.DimCustomers

SELECT  *
INTO    Dimensions.DimDate
FROM    NWStaging.OLAP.DimDate

SELECT  *
INTO    Dimensions.DimEmployees
FROM    NWStaging.OLAP.DimEmployees

SELECT  *
INTO    Dimensions.DimGeography
FROM    NWStaging.OLAP.DimGeography

SELECT  *
INTO    Dimensions.DimProducts
FROM    NWStaging.OLAP.DimProducts

SELECT  *
INTO    Dimensions.DimShippers
FROM    NWStaging.OLAP.DimShippers

SELECT  *
INTO    Dimensions.DimSuppliers
FROM    NWStaging.OLAP.DimSuppliers



/********************/
/*	Importing Facts	*/
/********************/

SELECT  *
INTO    Facts.FactOrderEvents
FROM    NWStaging.OLAP.FactOrderEvents