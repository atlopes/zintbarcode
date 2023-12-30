* a) prepare the environment

IF !PEMSTATUS(_Screen, "System", 5) OR !PEMSTATUS(_Screen.System, "Drawing", 5)
	MESSAGEBOX("Please, load GdiPlusX before running this demo.", 48, "ZintBarcode demo")
	RETURN
ENDIF

DO (JUSTPATH(SYS(16)) + "\..\src\zintbarcode.prg")

* b) fetch the data from Virtual Fox Fest site

LOCAL Server AS String
LOCAL HTTP AS MSXML2.ServerXMLHTTP60

m.Server = "https://virtualfoxfest.com/2023/"

m.HTTP = CREATEOBJECT("MSXML2.ServerXMLHTTP.6.0")
m.HTTP.Open("Get", m.Server + "speakers.aspx", .F.)
m.HTTP.Send()

* c) create a cursor to hold the information

CREATE CURSOR curVFFSessions (speaker Varchar(200), sessionTitle Varchar(200), url Varchar(200), photo Blob)

* d) parse the HTML in the speakers' page and populate the cursor

LOCAL HTML AS String
LOCAL Speaker AS String
LOCAL Segment AS String

m.HTML = m.HTTP.ResponseBody

m.Speaker = STREXTRACT(m.HTML, '<div class="speaker"', '</div>')
DO WHILE !EMPTY(m.Speaker)

	APPEND BLANK
	REPLACE speaker WITH STREXTRACT(m.Speaker, '<h3>', '</h3>')

	* download the spearker's photo
	m.Segment = STREXTRACT(m.Speaker, 'src="', '"')
	m.HTTP.Open("Get", m.Server + m.Segment, .F.)
	m.HTTP.Send()

	IF m.HTTP.Status < 400
		REPLACE photo WITH m.HTTP.ResponseBody
	ENDIF

	* title and url of the conference
	m.Segment = STREXTRACT(m.Speaker, '<h4>Sessions:</h4>', '')
	REPLACE sessionTitle WITH STREXTRACT(m.Segment, '">', '</a>'), url WITH m.Server + STREXTRACT(m.Segment, 'href="', '"')

	* get the next one...
	m.Speaker = STREXTRACT(m.HTML, '<div class="speaker"', '</div>', RECNO() + 1)

ENDDO

* e) prepare an object to generate the QR codes

* Attention: it will be private to be visible in the report

* since we want to use dynamic settings, the ZintBarcode will be subclassed (at the end of this demo)
PRIVATE ZB
LOCAL ZE AS ZintEnumerations

m.ZB = CREATEOBJECT("ZintBarcodeExtended")
m.ZE = CREATEOBJECT("ZintEnumerations")

m.ZB.SetSymbology(m.ZE.Barcode_qrcode)
m.ZB.SetOption(1, 2)
m.ZB.SetOption(2, 10)

* create a bigger QR code to overlay better resolution images
m.ZB.SetScale(2.0)

* use a VFP image as the overlay image
m.ZB.SetOverlay(m.ZB.Photo)
* the size
m.ZB.SetOverlayWidth(64)	&& 60x78, 4 pixels for the margin
m.ZB.SetOverlayHeight(82)
* and a margin
m.ZB.SetOverlayMargin(2)
* isometric resizing (it's the default, anyway)
m.ZB.SetOverlayIsometric(.T.)
* and placed at the center (also the default)
m.ZB.SetOverlayPosition("C")

* f) run the report
REPORT FORM (JUSTPATH(SYS(16)) + "\vffSessions") PREVIEW

* the subclassing of ZintSymbol
DEFINE CLASS ZintBarcodeExtended AS ZintBarcode

	ADD OBJECT Photo AS Image

	PROCEDURE DynamicSettings (InputData AS String)

		This.Photo.PictureVal = curVFFSessions.photo

	ENDPROC

ENDDEFINE
