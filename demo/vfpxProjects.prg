* a) prepare the environment

DO (JUSTPATH(SYS(16)) + "\..\src\zintbarcode.prg")

* b) fetch the data from VFPX site

LOCAL HTTP AS MSXML2.ServerXMLHTTP60
LOCAL Source AS String

m.HTTP = CREATEOBJECT("MSXML2.ServerXMLHTTP.6.0")
m.HTTP.Open("Get", "https://vfpx.github.io/projects/", .F.)
m.HTTP.Send()

m.Source = STRTRAN(STRTRAN(STREXTRACT("" + m.HTTP.ResponseBody, "<tbody>", "</tbody>", 1, 4), "&" + "nbsp;", " "), "&" + "check;", "X")

* c) create a cursor to hold the information

CREATE CURSOR curVFPX (name Varchar(200), url Varchar(200), description Memo, type Varchar(20), status Varchar(20))

* d) parse the HTML in the projects' page and populate the cursor

LOCAL XML AS MSXML2.DOMDocument60
LOCAL TRowList AS MSXML2.IXMLDOMNodeList
LOCAL TRow AS MSXML2.IXMLDOMElement
LOCAL TDataList AS MSXML2.IXMLDOMNodeList
LOCAL TData AS MSXML2.IXMLDOMElement
LOCAL TDindex AS Integer
LOCAL VFPX AS Object

m.XML = CREATEOBJECT("MSXML2.DOMDocument.6.0")
m.XML.Async = .F.
m.XML.LoadXML(m.Source)

* each project in its row
m.TRowList = m.XML.selectnodes("tbody/tr")
FOR EACH m.TRow IN m.TRowList

	SCATTER NAME m.VFPX MEMO BLANK

	m.TDindex = 1
	m.TDataList = m.TRow.selectNodes("td") 
	FOR EACH m.TData IN m.TDataList

		DO CASE
		CASE m.TDindex = 1
			m.VFPX.name = m.TData.text
			m.VFPX.url = m.TData.firstChild.getAttribute("href")
		CASE m.TDindex = 2
			m.VFPX.description = m.TData.text
		CASE m.TDindex = 3
			m.VFPX.type = m.TData.text
		CASE m.TDindex = 4
			m.VFPX.status = m.TData.text
		ENDCASE

		m.TDindex = m.TDindex + 1
	ENDFOR

	INSERT INTO curVFPX FROM NAME m.VFPX

ENDFOR

GO TOP

* e) prepare an object to generate the QR codes

* Attention: mark it as private to be visible in the report

* since we want to use dynamic settings, the ZintBarcode will be subclassed (at the end of this demo)
PRIVATE ZS
LOCAL ZE AS ZintEnumerations

m.ZS = CREATEOBJECT("ZintBarcodeExtended")
m.ZE = CREATEOBJECT("ZintEnumerations")

m.ZS.SetSymbology(m.ZE.Barcode_qrcode)

* f) run the report
REPORT FORM (JUSTPATH(SYS(16)) + "\vfpxProjects") PREVIEW

* the subclassing of ZintSymbol
DEFINE CLASS ZintBarcodeExtended AS ZintBarcode

	PROCEDURE DynamicSettings (InputData AS String)

		LOCAL QRColor AS Integer

		DO CASE
		CASE curVFPX.status == "Planning"
			m.QRColor = RGB(250, 242, 197)
		CASE curVFPX.status == "Alpha"
			m.QRColor = RGB(235, 207, 52)
		CASE curVFPX.status == "Beta"
			m.QRColor = RGB(145, 129, 35)
		CASE curVFPX.status == "Release candidate"
			m.QRColor = RGB(64, 64, 64)
		OTHERWISE
			m.QRColor = RGB(0, 0, 0)
		ENDCASE

		This.SetFGColour(m.QRColor)
	ENDPROC

ENDDEFINE
