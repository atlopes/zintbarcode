* a) prepare the environment

DO (JUSTPATH(SYS(16)) + "\..\src\zintbarcode.prg")

* b) setup a zintBarcode object

LOCAL ZB AS ZintBarcode
LOCAL ZE AS ZintEnumerations

m.ZB = CREATEOBJECT("ZintBarcode")
m.ZE = CREATEOBJECT("ZintEnumerations")

m.ZB.SetSymbology(m.ZE.Barcode_code39)

* c) fetch the data from Northwind database

IF !DBUSED("Northwind")
	OPEN DATABASE (HOME(0) + "\Samples\Northwind\Northwind") NOUPDATE SHARED
ENDIF

SELECT cpl.ProductId, ;
		cpl.ProductName, ;
		m.ZB.Imagefile(TRANSFORM(cpl.ProductId)) AS barcode ;
	FROM Northwind!Current_Product_List cpl ;
	INTO CURSOR curReport

* f) run the report
REPORT FORM (JUSTPATH(SYS(16)) + "\northwindCatalog") PREVIEW
