******************************************************
*
*	ZintBarcode
*
*	A VFP connector to the Zint Barcode Library
*
*	Check documentation for usage and terms
*
*

#DEFINE	SAFETHIS		ASSERT !USED("This") AND TYPE("This") == "O"
#DEFINE	ZBVFPSIG		"~zbvfp_"

* install the classes
SET PROCEDURE TO (SYS(16)) ADDITIVE

* and the dependencies (Zint and Vfp2C32 libraries)
SET PATH TO (ADDBS(JUSTPATH(SYS(16))) + "external") ADDITIVE

* instantiate the library and we're ready to go
CREATEOBJECT("ZintLibrary")

*
* ZintBarcode
* a class to produce barcodes images
*
DEFINE CLASS ZintBarcode AS Custom

	* manage storage
	ADD OBJECT PROTECTED ImageFiles AS Collection

	PROTECTED Symbol, ZVersion, TempFolder, OwnFolder, SingleFile
	PROTECTED OverlayImage, OverlayPosition, OverlayWidth, OverlayHeight, OverlayMargin, OverlayIsometric

	* the address of the Zint symbol structure
	Symbol = 0
	* members of a Zint symbol structure
	ZStructure = .NULL.
	* the version of Zint library
	ZVersion = 0
	* location of temporary images (used to set the ControlSource of controls in forms and reports)
	TempFolder = ""
	OwnFolder = .F.
	SingleFile = .F.
	* overlay image and position
	OverlayImage = ""
	OverlayPosition = "C"
	OverlayWidth = 0
	OverlayHeight = 0
	OverlayMargin = 0
	OverlayIsometric = .T.

	_MemberData = '<VFPData>' + ;
						'<memberdata name="getversion" type="method" display="GetVersion" />' + ;
						'<memberdata name="encodesave" type="method" display="EncodeSave" />' + ;
						'<memberdata name="encode" type="method" display="Encode" />' + ;
						'<memberdata name="save" type="method" display="Save" />' + ;
						'<memberdata name="imagefile" type="method" display="ImageFile" />' + ;
						'<memberdata name="dynamicsettings" type="method" display="DynamicSettings" />' + ;
						'<memberdata name="reset" type="method" display="Reset" />' + ;
						'<memberdata name="issupported" type="method" display="IsSupported" />' + ;
						'<memberdata name="getsinglefile" type="method" display="GetSingleFile" />' + ;
						'<memberdata name="setsinglefile" type="method" display="SetSingleFile" />' + ;
						'<memberdata name="getoverlay" type="method" display="GetOverlay" />' + ;
						'<memberdata name="setoverlay" type="method" display="SetOverlay" />' + ;
						'<memberdata name="getoverlayposition" type="method" display="GetOverlayPosition" />' + ;
						'<memberdata name="setoverlayposition" type="method" display="SetOverlayPosition" />' + ;
						'<memberdata name="getoverlaywidth" type="method" display="GetOverlayWidth" />' + ;
						'<memberdata name="setoverlaywidth" type="method" display="SetOverlayWidth" />' + ;
						'<memberdata name="getoverlayheight" type="method" display="GetOverlayHeight" />' + ;
						'<memberdata name="setoverlayheight" type="method" display="SetOverlayHeight" />' + ;
						'<memberdata name="getoverlaymargin" type="method" display="GetOverlayMargin" />' + ;
						'<memberdata name="setoverlaymargin" type="method" display="SetOverlayMargin" />' + ;
						'<memberdata name="getoverlayisometric" type="method" display="GetOverlayIsometric" />' + ;
						'<memberdata name="setoverlayisometric" type="method" display="SetOverlayIsometric" />' + ;
						'<memberdata name="getsymbology" type="method" display="GetSymbology" />' + ;
						'<memberdata name="setsymbology" type="method" display="SetSymbology" />' + ;
						'<memberdata name="getheight" type="method" display="GetHeight" />' + ;
						'<memberdata name="setheight" type="method" display="SetHeight" />' + ;
						'<memberdata name="getwhitespacewidth" type="method" display="GetWhitespaceWidth" />' + ;
						'<memberdata name="setwhitespacewidth" type="method" display="SetWhitespaceWidth" />' + ;
						'<memberdata name="getwhitespaceheight" type="method" display="GetWhitespaceHeight" />' + ;
						'<memberdata name="setwhitespaceheight" type="method" display="SetWhitespaceHeight" />' + ;
						'<memberdata name="getborderwidth" type="method" display="GetBorderWidth" />' + ;
						'<memberdata name="setborderwidth" type="method" display="SetBorderWidth" />' + ;
						'<memberdata name="getoutputoptions" type="method" display="GetOutputOptions" />' + ;
						'<memberdata name="setoutputoptions" type="method" display="SetOutputOptions" />' + ;
						'<memberdata name="getfgcolour" type="method" display="GetFGColour" />' + ;
						'<memberdata name="setfgcolour" type="method" display="SetFGColour" />' + ;
						'<memberdata name="getbgcolour" type="method" display="GetBGColour" />' + ;
						'<memberdata name="setbgcolour" type="method" display="SetBGColour" />' + ;
						'<memberdata name="getoutfile" type="method" display="GetOutfile" />' + ;
						'<memberdata name="setoutfile" type="method" display="SetOutfile" />' + ;
						'<memberdata name="getprimary" type="method" display="GetPrimary" />' + ;
						'<memberdata name="setprimary" type="method" display="SetPrimary" />' + ;
						'<memberdata name="getscale" type="method" display="GetScale" />' + ;
						'<memberdata name="setscale" type="method" display="SetScale" />' + ;
						'<memberdata name="getoption" type="method" display="GetOption" />' + ;
						'<memberdata name="setoption" type="method" display="SetOption" />' + ;
						'<memberdata name="getshowhumanreadabletext" type="method" display="GetShowHumanReadableText" />' + ;
						'<memberdata name="setshowhumanreadabletext" type="method" display="SetShowHumanReadableText" />' + ;
						'<memberdata name="getfontsize" type="method" display="GetFontSize" />' + ;
						'<memberdata name="setfontsize" type="method" display="SetFontSize" />' + ;
						'<memberdata name="getinputmode" type="method" display="GetInputMode" />' + ;
						'<memberdata name="setinputmode" type="method" display="SetInputMode" />' + ;
						'<memberdata name="geteci" type="method" display="GetECI" />' + ;
						'<memberdata name="seteci" type="method" display="SetECI" />' + ;
						'<memberdata name="getdotspermm" type="method" display="GetDotsPerMM" />' + ;
						'<memberdata name="setdotspermm" type="method" display="SetDotsPerMM" />' + ;
						'<memberdata name="getdotsize" type="method" display="GetDotSize" />' + ;
						'<memberdata name="setdotsize" type="method" display="SetDotSize" />' + ;
						'<memberdata name="getguarddescent" type="method" display="GetGuardDescent" />' + ;
						'<memberdata name="setguarddescent" type="method" display="SetGuardDescent" />' + ;
						'<memberdata name="gettext" type="method" display="GetText" />' + ;
						'<memberdata name="getrows" type="method" display="GetRows" />' + ;
						'<memberdata name="getwidth" type="method" display="GetWidth" />' + ;
						'<memberdata name="getencodeddata" type="method" display="GetEncodedData" />' + ;
						'<memberdata name="getrowheight" type="method" display="GetRowHeight" />' + ;
						'<memberdata name="geterrortext" type="method" display="GetErrorText" />' + ;
						'<memberdata name="getbitmappointer" type="method" display="GetBitmapPointer" />' + ;
						'<memberdata name="getbitmapwidth" type="method" display="GetBitmapWidth" />' + ;
						'<memberdata name="getbitmapheight" type="method" display="GetBitmapHeight" />' + ;
						'<memberdata name="getalphamappointer" type="method" display="GetAlphamapPointer" />' + ;
						'<memberdata name="getbitmapbytelength" type="method" display="GetBitmapByteLength" />' + ;
						'<memberdata name="getvectorpointer" type="method" display="GetVectorPointer" />' + ;
						'<memberdata name="getdebug" type="method" display="GetDebug" />' + ;
						'<memberdata name="setdebug" type="method" display="SetDebug" />' + ;
						'<memberdata name="getwarnlevel" type="method" display="GetWarnLevel" />' + ;
						'<memberdata name="setwarnlevel" type="method" display="SetWarnLevel" />' + ;
						'</VFPData>'

	PROCEDURE Init

		* get a Zint symbol structure from the Zint library
		This.Symbol = ZBarcode_Create()

		* get the version of the Zint library
		This.ZVersion = ZBarcode_Version()
		This.ZStructure = CREATEOBJECT("ZintStructure", This.GetVersion(.T.))

		* create a folder for temporary images, or use the general temporary folder if that is not possible
		LOCAL Retries AS Integer

		m.Retries = 100
		DO WHILE m.Retries > 0 AND !This.OwnFolder
			TRY
				This.TempFolder = ADDBS(SYS(2023)) + SYS(3)
				MKDIR (This.TempFolder)
				This.OwnFolder = .T.
			CATCH
				m.Retries = m.Retries - 1
			ENDTRY
		ENDDO

		IF !This.OwnFolder
			This.TempFolder = SYS(2023)
		ENDIF

	ENDPROC

	PROCEDURE Destroy

		SAFETHIS

		* on exit, free the Zint symbol structure
		ZBarcode_Delete(This.Symbol)

		* and try to delete all temporary files and temporary folder, if we created one
		IF This.OwnFolder

			TRY
				ERASE (ADDBS(This.TempFolder) + "*.*")
				RMDIR (This.TempFolder)
			CATCH
			ENDTRY

		ELSE

			LOCAL Filename AS String
			FOR EACH m.Filename IN This.ImageFiles
				TRY
					ERASE (m.Filename)
				CATCH
				ENDTRY
			ENDFOR

		ENDIF

	ENDPROC

	* returns Zint Version
	PROCEDURE GetVersion (MajorMinor AS Logical) AS String

		IF m.MajorMinor
			RETURN LTRIM(CHRTRAN(TRANSFORM(FLOOR(This.ZVersion / 100), "@R 99-99"), "-", "."))
		ELSE
			RETURN LTRIM(CHRTRAN(TRANSFORM(This.ZVersion, "@R 99-99-99"), "-", "."))
		ENDIF

	ENDPROC

	* prepare and save a barcode to a file, at a given angle (0-90-180-270)
	PROCEDURE EncodeSave (InputData AS String, Filename AS String, Angle AS Integer) AS Integer

		SAFETHIS

		ZBarcode_Clear(This.Symbol)

		IF PCOUNT() > 1
			This.SetOutfile(m.Filename)
		ENDIF

		LOCAL ZBResult AS Integer

		m.ZBResult = ZBarcode_Encode_And_Print(This.Symbol, m.InputData, LEN(m.InputData), EVL(m.Angle, 0))
		IF m.ZBResult = 0 AND IIF(VARTYPE(This.OverlayImage) == "C", !EMPTY(This.OverlayImage), !ISNULL(This.OverlayImage))
			This.PlaceOverlayImage()
		ENDIF

		RETURN m.ZBResult

	ENDPROC

	* prepare and render a barcode
	PROCEDURE Encode (InputData AS String, Filename AS String) AS Integer

		SAFETHIS

		IF PCOUNT() > 1 AND !EMPTY(m.Filename)
			This.SetOutfile(m.Filename)
		ENDIF
		RETURN ZBarcode_Encode(This.Symbol, m.InputData, LEN(m.InputData))

	ENDPROC

	* save a prepared barcode to a file at a given angle (0-90-180-270)
	PROCEDURE Save (Angle AS Integer) AS Integer

		SAFETHIS

		RETURN ZBarcode_Print(This.Symbol, EVL(m.Angle, 0))

	ENDPROC

	* render a barcode and save it to a temporary file, and return its filename
	* image file format is set as an extension
	PROCEDURE ImageFile (InputData AS String, ImageFormat AS String, Angle AS Integer) AS String

		SAFETHIS

		LOCAL Filename AS String
		LOCAL Extension AS String
		LOCAL ARRAY CheckFile(1)

		m.Extension = EVL(m.ImageFormat, "gif")

		IF This.SingleFile AND This.ImageFiles.Count > 0
			m.Filename = This.ImageFiles(1)
		ELSE
			m.Filename = ADDBS(This.TempFolder) + FORCEEXT(ZBVFPSIG + SYS(3), m.Extension)
			DO WHILE ADIR(m.CheckFile, m.Filename) > 0
				m.Filename = ADDBS(This.TempFolder) + FORCEEXT(ZBVFPSIG + SYS(3), m.Extension)
			ENDDO
			This.ImageFiles.Add(m.Filename)
		ENDIF

		* have other settings dynamically prepared
		This.DynamicSettings(m.InputData)

		IF This.EncodeSave(m.InputData, m.Filename, m.Angle) == 0
			RETURN m.Filename
			* the filename can be used as a ControlSource or Picture in controls
		ELSE
			RETURN ""
			* error should be checked by .GetErrorText()
		ENDIF

	ENDPROC

	* places an overlay image on the image rendered at OutFile
	HIDDEN PROCEDURE PlaceOverlayImage () AS Void

		* test if GdiPlusX library is available, do not proceed if not
		IF !PEMSTATUS(_Screen, "System", 5) OR !PEMSTATUS(_Screen.System, "Drawing", 5)
			RETURN
		ENDIF

		LOCAL RenderedBarcode AS String
		LOCAL OutFileExtension AS String
		LOCAL Encoder AS xfcImageFormat

		* choose the format - note that not all image formats may be available
		m.RenderedBarcode = This.GetOutfile()
		m.OutFileExtension = UPPER(JUSTEXT(m.RenderedBarcode))
		DO CASE
		CASE m.OutFileExtension == "GIF"
			m.Encoder = _Screen.System.Drawing.Imaging.ImageFormat.Gif
		CASE m.OutFileExtension == "PNG"
			m.Encoder = _Screen.System.Drawing.Imaging.ImageFormat.Png
		CASE m.OutFileExtension == "BMP"
			m.Encoder = _Screen.System.Drawing.Imaging.ImageFormat.Bmp
		CASE m.OutFileExtension == "JPG"
			m.Encoder = _Screen.System.Drawing.Imaging.ImageFormat.Jpeg
		OTHERWISE
			RETURN	&& if not supported, return the barcode without the overlaying
		ENDCASE

		* objects/attributes of the base image
		LOCAL ImgBase AS xfcImage
		LOCAL BaseOffsetX AS Integer
		LOCAL BaseOffsetY AS Integer
		LOCAL RectBase AS xfcRectangle

		* objects/attributes of the overlay image
		LOCAL ImgOverlay AS xfcImage
		LOCAL OvrOffsetX AS Integer
		LOCAL OvrOffsetY AS Integer
		LOCAL OvrWidth AS Integer
		LOCAL OvrHeight AS Integer
		LOCAL OvrBox AS Logical
		LOCAL RectOverlay AS xfcRectangle
		LOCAL ResizeFactor AS Double
		LOCAL ResizeFactorX AS Double
		LOCAL ResizeFactorY AS Double
		LOCAL ResizeOffsetX AS Integer
		LOCAL ResizeOffsetY AS Integer

		* objects/attributes of the final image
		LOCAL ImgFinal AS xfcBitmap
		LOCAL ImgGraphic AS xfcGraphics
		LOCAL ImgColor AS xfcColor
		LOCAL ExtraWidth AS Integer
		LOCAL ExtraHeight AS Integer

		* get the rendered barcode (it will be the base for the new image) and the overlay image
		m.ImgBase = _Screen.System.Drawing.Image.FromFile(m.RenderedBarcode)
		DO CASE
		CASE VARTYPE(This.OverlayImage) == "C"
			m.ImgOverlay = _Screen.System.Drawing.Image.FromFile(This.OverlayImage)
		CASE !EMPTY(This.OverlayImage.PictureVal)
			m.ImgOverlay = _Screen.System.Drawing.Image.FromVarbinary(This.OverlayImage.PictureVal)
		OTHERWISE
			m.ImgOverlay = _Screen.System.Drawing.Image.FromFile(This.OverlayImage.Picture)
		ENDCASE

		* forget about overlaying if the overlay image can not be loaded into an object
		IF ISNULL(m.ImgOverlay)
			RETURN
		ENDIF

		* overlay image may be inserted inside a box
		IF EMPTY(This.OverlayWidth) AND EMPTY(This.OverlayHeight)
			m.OvrBox = .F.
			m.OvrHeight = m.ImgOverlay.Height
			m.OvrWidth = m.ImgOverlay.Width
		ELSE
			m.OvrBox = .T.
			m.OvrHeight = This.OverlayHeight
			m.OvrWidth = This.OverlayWidth
		ENDIF

		* if the overlay image is not centered
		IF !This.OverlayPosition == "C"

			* the barcode width and height will increase to place the overlay in one corner
			m.ExtraHeight = INT(m.OvrHeight / 2)
			m.ExtraWidth = INT(m.OvrWidth / 2)

			* depending on the corner on which the overlay will be placed,
			* the offset position of both the base image and the overlay image
			* may require to be set
			DO CASE
			CASE This.OverlayPosition == "TL"		&& top left
				* overlay
				*   base
				m.OvrOffsetX = 0
				m.OvrOffsetY = 0
				m.BaseOffsetX = m.ExtraWidth
				m.BaseOffsetY = m.ExtraHeight

			CASE This.OverlayPosition == "TR"		&& top right
				*   overlay
				* base
				m.OvrOffsetX = m.ImgBase.Width - m.ExtraWidth
				m.OvrOffsetY = 0
				m.BaseOffsetX = 0
				m.BaseOffsetY = m.ExtraHeight

			CASE This.OverlayPosition == "BL"		&& bottom left
				*   base
				* overlay
				m.OvrOffsetX = 0
				m.OvrOffsetY = m.ImgBase.Height - m.ExtraHeight
				m.BaseOffsetX = m.ExtraWidth
				m.BaseOffsetY = 0

			CASE This.OverlayPosition == "BR"		&& bottom right
				* base
				*   overlay
				m.OvrOffsetX = m.ImgBase.Width - m.ExtraWidth
				m.OvrOffsetY = m.ImgBase.Height - m.ExtraHeight
				m.BaseOffsetX = 0
				m.BaseOffsetY = 0

			OTHERWISE

				RETURN		&& placement not recognized, no changes to the rendered barcode

			ENDCASE

		ELSE

			m.BaseOffsetX = 0
			m.BaseOffsetY = 0
			m.ExtraHeight = 0
			m.ExtraWidth = 0

			* if centered, the rendered barcode dimension will not change
			* and the overlay will move to the center
			m.OvrOffsetX = INT(m.ImgBase.Width / 2) - INT(m.OvrWidth / 2)
			m.OvrOffsetY = INT(m.ImgBase.Height / 2) - INT(m.OvrHeight / 2)

		ENDIF

		* the new final image size
		m.ImgFinal = _Screen.System.Drawing.Bitmap.New(m.ImgBase.Width + m.ExtraWidth, m.ImgBase.Height + m.ExtraHeight)

		* prepare an extended graphic canvas
		m.ImgGraphic = _Screen.System.Drawing.Graphics.FromImage(m.ImgFinal)
		m.ImgColor = _Screen.System.Drawing.Color.FromRGB(This.GetBGColour())
		m.ImgGraphic.Clear(m.ImgColor)

		* place the base image at its calculated offset
		m.RectBase = _Screen.System.Drawing.Rectangle.New(m.BaseOffsetX, m.BaseOffsetY, m.ImgBase.Width, m.ImgBase.Height)
		m.ImgGraphic.DrawImage(m.ImgBase, m.RectBase)

		* place the overlay image at its calculated offset
		IF !m.OvrBox
			m.RectOverlay = _Screen.System.Drawing.Rectangle.New(m.OvrOffsetX, m.OvrOffsetY, m.OvrWidth, m.OvrHeight)
			m.ImgGraphic.DrawImage(m.ImgOverlay, m.RectOverlay)
		ELSE

			* in a box, start by clearing it
			m.ImgGraphic.FillRectangle(_Screen.System.Drawing.SolidBrush.New(m.ImgColor), m.OvrOffsetX, m.OvrOffsetY, m.OvrWidth, m.OvrHeight)

			* if needed, make room for a margin
			m.OvrOffsetX = m.OvrOffsetX + This.OverlayMargin
			m.OvrOffsetY = m.OvrOffsetY + This.OverlayMargin
			m.OvrWidth = m.OvrWidth - This.OverlayMargin * 2
			m.OvrHeight = m.OvrHeight - This.OverlayMargin * 2

			* redimension the image while retaining proportions, if isometric
			IF This.OverlayIsometric
				* the target dimensions
				m.ResizeOffsetX = m.OvrWidth
				m.ResizeOffsetY = m.OvrHeight
				* get the dominant resizing factor (width or height)
				m.ResizeFactorX = m.OvrWidth / m.ImgOverlay.Width
				m.ResizeFactorY = m.OvrHeight / m.ImgOverlay.Height
				m.ResizeFactor = MIN(m.ResizeFactorX, m.ResizeFactorY)
				* new dimensions
				m.OvrHeight =  m.ImgOverlay.Height * m.ResizeFactor
				m.OvrWidth = m.ImgOverlay.Width * m.ResizeFactor
				* and adjust to the new empty space, if any
				m.OvrOffsetX = m.OvrOffsetX + (m.ResizeOffsetX - m.OvrWidth) / 2
				m.OvrOffsetY = m.OvrOffsetY + (m.ResizeOffsetY - m.OvrHeight) / 2 
			ENDIF

			* resize the image with the best quality possible
			m.RectOverlay = _Screen.System.Drawing.Rectangle.New(m.OvrOffsetX, m.OvrOffsetY, m.OvrWidth, m.OvrHeight)
			m.ImgGraphic.SmoothingMode = _Screen.System.Drawing.Drawing2d.SmoothingMode.Highquality
			m.ImgGraphic.InterpolationMode = _Screen.System.Drawing.Drawing2d.Interpolationmode.Highqualitybicubic

			* draw it
			m.ImgGraphic.DrawImage(m.ImgOverlay, m.RectOverlay)

		ENDIF

		* overwrite the output file with the new overlayed image, and done
		m.ImgBase = .NULL.
		m.ImgFinal.Save(m.RenderedBarcode, m.Encoder)

	ENDFUNC

	* a placeholder for dynamic settings (subclass ZintBarcode to use this feature)
	PROCEDURE DynamicSettings (InputData AS String)
	ENDPROC

	* reset the Symbol structure to its defaults
	PROCEDURE Reset ()

		SAFETHIS

		ZBarcode_Clear(This.Symbol)

		LOCAL ZB AS ZintBarcode

		m.ZB = CREATEOBJECT("ZintBarCode")

		This.SetSymbology(m.ZB.GetSymbology())
		This.SetHeight(m.ZB.GetHeight())
		This.SetWhitespaceWidth(m.ZB.GetWhitespaceWidth())
		This.SetWhitespaceHeight(m.ZB.GetWhitespaceHeight())
		This.SetBorderWidth(m.ZB.GetBorderWidth())
		This.SetOutputOptions(m.ZB.GetOutputOptions())
		This.SetFGColour(m.ZB.GetFGColour())
		This.SetBGColour(m.ZB.GetBGColour())
		This.SetOutfile(m.ZB.GetOutfile())
		This.SetPrimary(m.ZB.GetPrimary())
		This.SetScale(m.ZB.GetScale())
		This.SetOption(1, m.ZB.GetOption(1))
		This.SetOption(2, m.ZB.GetOption(2))
		This.SetOption(3, m.ZB.GetOption(3))
		This.SetShowHumanReadableText(m.ZB.GetShowHumanReadableText())
		This.SetInputMode(m.ZB.GetInputMode())
		This.SetECI(m.ZB.GetECI())
		This.SetDotSize(m.ZB.GetDotSize())
		This.SetGuardDescent(m.ZB.GetGuardDescent())

	ENDPROC			

	* check if a barcode symbology, or a feature of a barcode symbology, is supported by the library
	PROCEDURE IsSupported (Symbology AS Integer, Feature AS Integer) AS Logical

		SAFETHIS

		IF PCOUNT() > 1
			RETURN ZBarcode_Cap(m.Symbology, m.Feature) == m.Feature
		ELSE
			RETURN ZBarcode_ValidID(m.Symbology) != 0
		ENDIF

	ENDPROC

	* the SingleFile property determines if the ControlSource requires a single file (for instance, in a form)
	* or different files (for several barcodes in a page report)
	PROCEDURE GetSingleFile () AS Logical
		SAFETHIS

		RETURN This.SingleFile
	ENDPROC

	PROCEDURE SetSingleFile (SingleFile AS Logical)
		This.SingleFile = m.SingleFile
	ENDPROC

	* an overlay image may be placed over the resulting barcode at the center or at one of the barcode corners
	PROCEDURE GetOverlay () AS StringOrImage
		SAFETHIS

		RETURN This.OverlayImage
	ENDPROC

	PROCEDURE SetOverlay (ImageFile AS StringOrImage)
		This.OverlayImage = m.ImageFile
	ENDPROC

	* overlay positions: C, TL, TR, BL, BR
	PROCEDURE GetOverlayPosition () AS String
		SAFETHIS

		RETURN This.OverlayPosition
	ENDPROC

	PROCEDURE SetOverlayPosition (OverlayPosition AS String)
		This.OverlayPosition = UPPER(m.OverlayPosition)
	ENDPROC

	* overlay width, height, and margin
	PROCEDURE GetOverlayWidth () AS Integer
		SAFETHIS

		RETURN This.OverlayWidth
	ENDPROC

	PROCEDURE SetOverlayWidth (OverlayWidth AS Integer)
		This.OverlayWidth = m.OverlayWidth
	ENDPROC

	PROCEDURE GetOverlayHeight () AS Integer
		SAFETHIS

		RETURN This.OverlayHeight
	ENDPROC

	PROCEDURE SetOverlayHeight (OverlayHeight AS Integer)
		This.OverlayHeight = m.OverlayHeight
	ENDPROC

	PROCEDURE GetOverlayMargin() AS Integer
		SAFETHIS

		RETURN This.OverlayMargin
	ENDPROC

	PROCEDURE SetOverlayMargin (OverlayMargin AS Integer)
		This.OverlayMargin = m.OverlayMargin
	ENDPROC

	* overlay isometric?
	PROCEDURE GetOverlayIsometric() AS Logical
		SAFETHIS

		RETURN This.OverlayIsometric
	ENDPROC

	PROCEDURE SetOverlayIsometric (OverlayIsometric AS Logical)
		This.OverlayIsometric = m.OverlayIsometric
	ENDPROC

	* getters and setters of the Zint properties
	* check Zint documentation, mainly at https://www.zint.org.uk/manual/chapter/5
	* ordered as in the table in the Zint documentation (point 5.6) or zint.h

	**** Symbology
	PROCEDURE GetSymbology () AS Integer
		SAFETHIS

		RETURN ReadInt(This.Symbol + This.ZStructure.ZSSymbology)
	ENDPROC

	PROCEDURE SetSymbology (Symbology AS Integer)
		SAFETHIS

		WriteInt(This.Symbol + This.ZStructure.ZSSymbology, m.Symbology)
	ENDPROC

	**** Height
	PROCEDURE GetHeight () AS Float
		SAFETHIS

		RETURN ReadFloat(This.Symbol + This.ZStructure.ZSHeight)
	ENDPROC

	PROCEDURE SetHeight (Height AS Float)
		SAFETHIS

		WriteFloat(This.Symbol + This.ZStructure.ZSHeight, m.Height)
	ENDPROC

	**** Scale
	PROCEDURE GetScale () AS Float
		SAFETHIS

		RETURN ReadFloat(This.Symbol + This.ZStructure.ZSScale)
	ENDPROC

	PROCEDURE SetScale (Scale AS Float)
		SAFETHIS

		WriteFloat(This.Symbol + This.ZStructure.ZSScale, m.Scale)
	ENDPROC

	**** Whitespace Width
	PROCEDURE GetWhitespaceWidth () AS Integer
		SAFETHIS

		RETURN ReadInt(This.Symbol + This.ZStructure.ZSWhitespaceWidth)
	ENDPROC

	PROCEDURE SetWhitespaceWidth (WhitespaceWidth AS Integer)
		SAFETHIS

		WriteInt(This.Symbol + This.ZStructure.ZSWhitespaceWidth, m.WhitespaceWidth)
	ENDPROC

	**** Whitespace Height
	PROCEDURE GetWhitespaceHeight () AS Integer
		SAFETHIS

		RETURN ReadInt(This.Symbol + This.ZStructure.ZSWhitespaceHeight)
	ENDPROC

	PROCEDURE SetWhitespaceHeight (WhitespaceHeight AS Integer)
		SAFETHIS

		WriteInt(This.Symbol + This.ZStructure.ZSWhitespaceHeight, m.WhitespaceHeight)
	ENDPROC

	**** Border Width
	PROCEDURE GetBorderWidth () AS Integer
		SAFETHIS

		RETURN ReadInt(This.Symbol + This.ZStructure.ZSBorderWidth)
	ENDPROC

	PROCEDURE SetBorderWidth (BorderWidth AS Integer)
		SAFETHIS

		WriteInt(This.Symbol + This.ZStructure.ZSBorderWidth, m.BorderWidth)
	ENDPROC

	**** Output Options
	PROCEDURE GetOutputOptions () AS Integer
		SAFETHIS

		RETURN ReadInt(This.Symbol + This.ZStructure.ZSOutputOptions)
	ENDPROC

	PROCEDURE SetOutputOptions (OutputOptions AS Integer)
		SAFETHIS

		WriteInt(This.Symbol + This.ZStructure.ZSOutputOptions, m.OutputOptions)
	ENDPROC

	* colors are translated back and forth to VFP's RGB() colors

	*** Foreground Colour
	PROCEDURE GetFGColour () AS Integer
		SAFETHIS

		LOCAL HexString AS String

		m.HexString = PADR(ReadCString(This.Symbol + This.ZStructure.ZSFGColour), 6, "0")
		RETURN EVALUATE("0x" + RIGHT(m.HexString, 2) + SUBSTR(m.HexString, 3, 2) + LEFT(m.HexString, 2))
	ENDPROC

	PROCEDURE SetFGColour (FGColour AS Integer)
		SAFETHIS

		WriteCharArray(This.Symbol + This.ZStructure.ZSFGColour, SUBSTR(TRANSFORM(CTOBIN(BINTOC(m.FGColour, "S"), "4RS"), "@0"), 3, 6) + CHR(0))
	ENDPROC

	*** Background Colour
	PROCEDURE GetBGColour () AS Integer
		SAFETHIS

		LOCAL HexString AS String

		m.HexString = PADR(ReadCString(This.Symbol + This.ZStructure.ZSBGColour), 6, "0")
		RETURN EVALUATE("0x" + RIGHT(m.HexString, 2) + SUBSTR(m.HexString, 3, 2) + LEFT(m.HexString, 2))
	ENDPROC

	PROCEDURE SetBGColour (BGColour AS Integer)
		SAFETHIS

		WriteCharArray(This.Symbol + This.ZStructure.ZSBGColour, SUBSTR(TRANSFORM(CTOBIN(BINTOC(m.BGColour, "S"), "4RS"), "@0"), 3, 6) + CHR(0))
	ENDPROC

	**** Out File
	PROCEDURE GetOutfile () AS String
		SAFETHIS

		RETURN ReadCString(This.Symbol + This.ZStructure.ZSOutfile)
	ENDPROC

	PROCEDURE SetOutfile (Outfile AS String)
		SAFETHIS

		WriteCharArray(This.Symbol + This.ZStructure.ZSOutfile, PADR(m.Outfile, This.ZStructure.ZSOutfileLen - 1, CHR(0)))
	ENDPROC

	**** Primary message data
	PROCEDURE GetPrimary () AS String
		SAFETHIS

		RETURN ReadCString(This.Symbol + This.ZStructure.ZSPrimary)
	ENDPROC

	PROCEDURE SetPrimary (PrimaryMessage AS String)
		SAFETHIS

		WriteCharArray(This.Symbol + This.ZStructure.ZSPrimary, PADR(m.PrimaryMessage, This.ZStructure.ZSPrimaryLen - 1, CHR(0)))
	ENDPROC

	* options are indexed 1..3

	**** Option
	PROCEDURE GetOption (Option AS Integer) AS Integer
		SAFETHIS

		RETURN ReadInt(This.Symbol + (This.ZStructure.ZSOption - 4) + MIN((MAX(INT(m.Option), 1)), 3) * 4)
	ENDPROC

	PROCEDURE SetOption (Option AS Integer, OptionValue AS Integer) AS Integer
		SAFETHIS

		WriteInt(This.Symbol + (This.ZStructure.ZSOption - 4) + MIN((MAX(INT(m.Option), 1)), 3) * 4, m.OptionValue)
	ENDPROC

	**** Show Human Readable Text
	PROCEDURE GetShowHumanReadableText () AS Logical
		SAFETHIS

		RETURN ReadInt(This.Symbol + This.ZStructure.ZSShowHumanReadableText) == 1
	ENDPROC

	PROCEDURE SetShowHumanReadableText (ShowHumanReadableText AS Logical)
		SAFETHIS

		WriteInt(This.Symbol + This.ZStructure.ZSShowHumanReadableText, IIF(m.ShowHumanReadableText, 1, 0))
	ENDPROC

	**** Font Size **** Unused
	PROCEDURE GetFontSize () AS Integer
		SAFETHIS

		RETURN ReadInt(This.Symbol + This.ZStructure.ZSFontSize)
	ENDPROC

	PROCEDURE SetFontSize (FontSize AS Integer)
		SAFETHIS

		WriteInt(This.Symbol + This.ZStructure.ZSFontSize, m.FontSize)
	ENDPROC

	**** Input Mode
	PROCEDURE GetInputMode () AS Integer
		SAFETHIS

		RETURN ReadInt(This.Symbol + This.ZStructure.ZSInputMode)
	ENDPROC

	PROCEDURE SetInputMode (InputMode AS Integer)
		SAFETHIS

		WriteInt(This.Symbol + This.ZStructure.ZSInputMode, m.InputMode)
	ENDPROC

	**** Extended Channel Interpretation
	PROCEDURE GetECI () AS Integer
		SAFETHIS

		RETURN ReadInt(This.Symbol + This.ZStructure.ZSECI)
	ENDPROC

	PROCEDURE SetECI (ECI AS Integer)
		SAFETHIS

		WriteInt(This.Symbol + This.ZStructure.ZSECI, m.ECI)
	ENDPROC

	**** Dots per mm
	PROCEDURE GetDotsPerMM () AS Float
		SAFETHIS

		RETURN IIF(ISNULL(This.ZStructure.ZSDotsPerMM), 0.0, ReadFloat(This.Symbol + This.ZStructure.ZSDotsPerMM))
	ENDPROC

	PROCEDURE SetDotsPerMM (DotsPerMM AS Float)
		SAFETHIS

		IF !ISNULL(This.ZStructure.ZSDotsPerMM)
			WriteFloat(This.Symbol + This.ZStructure.ZSDotsPerMM, m.DotsPerMM)
		ENDIF
	ENDPROC

	**** Dot Size
	PROCEDURE GetDotSize () AS Float
		SAFETHIS

		RETURN ReadFloat(This.Symbol + This.ZStructure.ZSDotSize)
	ENDPROC

	PROCEDURE SetDotSize (DotSize AS Float)
		SAFETHIS

		WriteFloat(This.Symbol + This.ZStructure.ZSDotSize, m.DotSize)
	ENDPROC

	**** Guard descent
	PROCEDURE GetGuardDescent () AS Float
		SAFETHIS

		RETURN IIF(ISNULL(This.ZSstructure.ZSGuardDescent), 0.0, ReadFloat(This.Symbol + This.ZStructure.ZSGuardDescent))
	ENDPROC

	PROCEDURE SetGuardDescent (GuardDescent AS Float)
		SAFETHIS

		IF ! ISNULL(This.ZSstructure.ZSGuardDescent)
			WriteFloat(This.Symbol + This.ZStructure.ZSGuardDescent, m.GuardDescent)
		ENDIF
	ENDPROC

	**** Text
	PROCEDURE GetText () AS String
		SAFETHIS

		RETURN STRCONV(ReadCharArray(This.Symbol + This.ZStructure.ZSText, This.ZStructure.ZSTextLen), 11)
	ENDPROC

	**** Rows
	PROCEDURE GetRows () AS Integer
		SAFETHIS

		RETURN ReadInt(This.Symbol + This.ZStructure.ZSRows)
	ENDPROC

	**** Width
	PROCEDURE GetWidth () AS Integer
		SAFETHIS

		RETURN ReadInt(This.Symbol + This.ZStructure.ZSWidth)
	ENDPROC

	**** Encoded Data
	PROCEDURE GetEncodedData () AS String
		SAFETHIS

		RETURN ReadBytes(This.Symbol + This.ZStructure.ZSEncodedData, This.ZStructure.ZSEncodedDataLen)
	ENDPROC

	**** Row Height
	PROCEDURE GetRowHeight () AS String
		SAFETHIS

		RETURN ReadBytes(This.Symbol + This.ZStructure.ZSRowHeight, 800)	&& 200 * sizeof(float)
	ENDPROC

	**** Error Text
	PROCEDURE GetErrorText () AS String
		SAFETHIS

		RETURN ReadCString(This.Symbol + This.ZStructure.ZSErrorText)
	ENDPROC

	**** Bitmap Pointer
	PROCEDURE GetBitmapPointer () AS Long
		SAFETHIS

		RETURN ReadInt(This.Symbol + This.ZStructure.ZSBitmapPointer)
	ENDPROC

	**** Bitmap Width
	PROCEDURE GetBitmapWidth () AS Integer
		SAFETHIS

		RETURN ReadInt(This.Symbol + This.ZStructure.ZSBitmapWidth)
	ENDPROC

	**** Bitmap Height
	PROCEDURE GetBitmapHeight () AS Integer
		SAFETHIS

		RETURN ReadInt(This.Symbol + This.ZStructure.ZSBitmapHeight)
	ENDPROC

	**** Alphamap Pointer
	PROCEDURE GetAlphamapPointer () AS Long
		SAFETHIS

		RETURN ReadInt(This.Symbol + This.ZStructure.ZSAlphamapPointer)
	ENDPROC

	**** Bitmap Byte Length
	PROCEDURE GetBitmapByteLength () AS Integer
		SAFETHIS

		RETURN ReadUInt(This.Symbol + This.ZStructure.ZSBitmapByteLength)
	ENDPROC

	**** Vector Pointer
	PROCEDURE GetVectorPointer () AS Long
		SAFETHIS

		RETURN ReadInt(This.Symbol + This.ZStructure.ZSVectorPointer)
	ENDPROC

	**** Debug
	PROCEDURE GetDebug () AS Integer
		SAFETHIS

		RETURN ReadInt(This.Symbol + This.ZStructure.ZSDebug)
	ENDPROC

	PROCEDURE SetDebug (Debug AS Integer)
		SAFETHIS

		WriteInt(This.Symbol + This.ZStructure.ZSDebug, m.Debug)
	ENDPROC

	**** Warn Level [int32@30136]
	PROCEDURE GetWarnLevel () AS Integer
		SAFETHIS

		RETURN ReadInt(This.Symbol + This.ZStructure.ZSWarnLevel)
	ENDPROC
        
	PROCEDURE SetWarnLevel (WarnLevel AS Integer)
		SAFETHIS

		WriteInt(This.Symbol + This.ZStructure.ZSWarnLevel, m.WarnLevel)
	ENDPROC

ENDDEFINE

*
* ZintStructure
* a version-aware class to address elements of the Zint.Symbol structure
*
DEFINE CLASS ZintStructure AS Custom

	ZSSymbology = .NULL.
	ZSHeight = .NULL.
	ZSWhitespaceWidth = .NULL.
	ZSWhitespaceHeight = .NULL.
	ZSBorderWidth = .NULL.
	ZSOutputOptions = .NULL.
	ZSFGColour = .NULL.
	ZSBGColour = .NULL.
	ZSOutfile = .NULL.
	ZSOutfileLen = .NULL.
	ZSScale = .NULL.
	ZSOption = .NULL.
	ZSShowHumanReadableText = .NULL.
	ZSFontSize = .NULL.
	ZSInputMode = .NULL.
	ZSECI = .NULL.
	ZSDotsPerMM = .NULL.
	ZSDotSize = .NULL.
	ZSGuardDescent = .NULL.
	ZSText = .NULL.
	ZSTextLen = .NULL.
	ZSRows = .NULL.
	ZSWidth = .NULL.
	ZSPrimary = .NULL.
	ZSPrimaryLen = .NULL.
	ZSEncodedData = .NULL.
	ZSEncodedDataLen = .NULL.
	ZSRowHeight = .NULL.
	ZSErrorText = .NULL.
	ZSBitmapPointer = .NULL.
	ZSBitmapWidth = .NULL.
	ZSBitmapHeight = .NULL.
	ZSAlphamapPointer = .NULL.
	ZSBitmapByteLength = .NULL.
	ZSVectorPointer = .NULL.
	ZSDebug = .NULL.
	ZSWarnLevel = .NULL.

	PROCEDURE Init (ZintVersion AS String)

		LOCAL Offset AS Integer
		LOCAL NVersion AS Number

		m.NVersion = VAL(CHRTRAN(m.ZintVersion, ".", SET("Point")))

		This.ZSSymbology = 0
		This.ZSHeight = 4

		IF m.NVersion < 2.11
			This.ZSScale = 308
			m.Offset = 0
		ELSE
			This.ZSScale = 8
			m.Offset = 4		&& skip scale
		ENDIF

		This.ZSWhitespaceWidth = m.Offset + 8
		This.ZSWhitespaceHeight = m.Offset + 12
		This.ZSBorderWidth = m.Offset + 16
		This.ZSOutputOptions = m.Offset + 20
		This.ZSFGColour = m.Offset + 24
		* after 2.12, color may be specified as CMYK
*!*			IF m.NVersion > 2.12
*!*				m.Offset = m.Offset + 6		&& color info size increased by 6
*!*			ENDIF
		This.ZSBGColour = m.Offset + 34
*!*			IF m.NVersion > 2.12
*!*				m.Offset = m.Offset + 6		&& color info size increased by 6
*!*			ENDIF
		This.ZSOutfile = m.Offset + 52
		This.ZSOutfileLen = 256

		This.ZSPrimaryLen = 128
		IF m.NVersion < 2.11
			This.ZSPrimary = m.Offset + 476
		ELSE
			This.ZSPrimary = m.Offset + 308
			m.Offset = m.Offset + 128 - 4		&& skip primary, get scale back
		ENDIF

		This.ZSOption = m.Offset + 312
		This.ZSShowHumanReadableText = m.Offset + 324
		This.ZSFontSize = m.Offset + 328
		This.ZSInputMode = m.Offset + 332
		This.ZSECI = m.Offset + 336

		IF m.NVersion >= 2.11
			IF m.NVersion >= 2.12
				This.ZSDotsPerMM = m.Offset + 340
				m.Offset = m.Offset + 4			&& skip dpmm
			ENDIF
			This.ZSDotSize = m.Offset + 340
			This.ZSGuardDescent = m.Offset + 344
			m.Offset = m.Offset + 48			&& skip these + structapp
			This.ZSWarnLevel = m.Offset + 340
			This.ZSDebug = m.Offset + 344
			m.Offset = m.Offset + 8				&& skip warning level and debug, these were moved upwards
		ELSE
			This.ZSDotSize = m.Offset + 30124
			This.ZSWarnLevel = m.Offset + 30136
			This.ZSDebug = m.Offset + 30132
		ENDIF

		This.ZSText = m.Offset + 340
		This.ZSTextLen = 128
		This.ZSRows = m.Offset + 468
		This.ZSWidth = m.Offset + 472

		IF m.NVersion < 2.11
			This.ZSEncodedDataLen = 200 * 143
		ELSE
			This.ZSEncodedDataLen = 200 * 144
			m.Offset = m.Offset - 128			&& get primary back
		ENDIF

		This.ZSEncodedData = m.Offset + 604

		IF m.NVersion >= 2.11
			m.Offset = m.Offset + 200			&& skip one row of encoded data
		ENDIF

		This.ZSRowHeight = m.Offset + 29204
		This.ZSErrorText = m.Offset + 30004
		This.ZSBitmapPointer = m.Offset + 30104
		This.ZSBitmapWidth = m.Offset + 30108
		This.ZSBitmapHeight = m.Offset + 30112
		This.ZSAlphamapPointer = m.Offset + 30116
		This.ZSBitmapByteLength = m.Offset + 30120

		IF m.NVersion >= 2.11
			m.Offset = m.Offset - 4			&& get back dot size
		ENDIF

		This.ZSVectorPointer = m.Offset + 30136

	ENDPROC

ENDDEFINE

*
* ZintEnumerations
* the enumerations used in ZintSymbol settings
*
* for instance
* m.ZS.SetSymbology(m.ZE.BARCODE_PDF417)
*
DEFINE CLASS ZintEnumerations AS Custom

	* imported from zint.h

	BARCODE_CODE11 = 1
	BARCODE_C25STANDARD = 2
	BARCODE_C25MATRIX = 2 && Legacy
	BARCODE_C25INTER = 3
	BARCODE_C25IATA = 4
	BARCODE_C25LOGIC = 6
	BARCODE_C25IND = 7
	BARCODE_CODE39 = 8
	BARCODE_EXCODE39 = 9
	BARCODE_EANX = 13
	BARCODE_EANX_CHK = 14
	BARCODE_GS1_128 = 16
	BARCODE_EAN128 = 16 && Legacy
	BARCODE_CODABAR = 18
	BARCODE_CODE128 = 20
	BARCODE_DPLEIT = 21
	BARCODE_DPIDENT = 22
	BARCODE_CODE16K = 23
	BARCODE_CODE49 = 24
	BARCODE_CODE93 = 25
	BARCODE_FLAT = 28
	BARCODE_DBAR_OMN = 29
	BARCODE_RSS14 = 29 && Legacy
	BARCODE_DBAR_LTD = 30
	BARCODE_RSS_LTD = 30 && Legacy
	BARCODE_DBAR_EXP = 31
	BARCODE_RSS_EXP = 31 && Legacy
	BARCODE_TELEPEN = 32
	BARCODE_UPCA = 34
	BARCODE_UPCA_CHK = 35
	BARCODE_UPCE = 37
	BARCODE_UPCE_CHK = 38
	BARCODE_POSTNET = 40
	BARCODE_MSI_PLESSEY = 47
	BARCODE_FIM = 49
	BARCODE_LOGMARS = 50
	BARCODE_PHARMA = 51
	BARCODE_PZN = 52
	BARCODE_PHARMA_TWO = 53
	BARCODE_PDF417 = 55
	BARCODE_PDF417COMP = 56
	BARCODE_PDF417TRUNC = 56 && Legacy
	BARCODE_MAXICODE = 57
	BARCODE_QRCODE = 58
	BARCODE_CODE128B = 60
	BARCODE_AUSPOST = 63
	BARCODE_AUSREPLY = 66
	BARCODE_AUSROUTE = 67
	BARCODE_AUSREDIRECT = 68
	BARCODE_ISBNX = 69
	BARCODE_RM4SCC = 70
	BARCODE_DATAMATRIX = 71
	BARCODE_EAN14 = 72
	BARCODE_VIN = 73
	BARCODE_CODABLOCKF = 74
	BARCODE_NVE18 = 75
	BARCODE_JAPANPOST = 76
	BARCODE_KOREAPOST = 77
	BARCODE_DBAR_STK = 79
	BARCODE_RSS14STACK = 79 && Legacy
	BARCODE_DBAR_OMNSTK = 80
	BARCODE_RSS14STACK_OMNI = 80 && Legacy
	BARCODE_DBAR_EXPSTK = 81
	BARCODE_RSS_EXPSTACK = 81 && Legacy
	BARCODE_PLANET = 82
	BARCODE_MICROPDF417 = 84
	BARCODE_USPS_IMAIL = 85
	BARCODE_ONECODE = 85 && Legacy
	BARCODE_PLESSEY = 86

    && Tbarcode 8 codes 
	BARCODE_TELEPEN_NUM = 87
	BARCODE_ITF14 = 89
	BARCODE_KIX = 90
	BARCODE_AZTEC = 92
	BARCODE_DAFT = 93
	BARCODE_DPD = 96
	BARCODE_MICROQR = 97

    && Tbarcode 9 codes 
	BARCODE_HIBC_128 = 98
	BARCODE_HIBC_39 = 99
	BARCODE_HIBC_DM = 102
	BARCODE_HIBC_QR = 104
	BARCODE_HIBC_PDF = 106
	BARCODE_HIBC_MICPDF = 108
	BARCODE_HIBC_BLOCKF = 110
	BARCODE_HIBC_AZTEC = 112

    && Tbarcode 10 codes 
	BARCODE_DOTCODE = 115
	BARCODE_HANXIN = 116

    &&Tbarcode 11 codes
	BARCODE_MAILMARK_2D = 119
	BARCODE_UPU_S10 = 120
	BARCODE_MAILMARK_4S = 121
	BARCODE_MAILMARK = 121 && Legacy

    && Zint specific 
	BARCODE_AZRUNE = 128
	BARCODE_CODE32 = 129
	BARCODE_EANX_CC = 130
	BARCODE_GS1_128_CC = 131
	BARCODE_EAN128_CC = 131 && Legacy
	BARCODE_DBAR_OMN_CC = 132
	BARCODE_RSS14_CC = 132 && Legacy
	BARCODE_DBAR_LTD_CC = 133
	BARCODE_RSS_LTD_CC = 133 && Legacy
	BARCODE_DBAR_EXP_CC = 134
	BARCODE_RSS_EXP_CC = 134 && Legacy
	BARCODE_UPCA_CC = 135
	BARCODE_UPCE_CC = 136
	BARCODE_DBAR_STK_CC = 137
	BARCODE_RSS14STACK_CC = 137 && Legacy
	BARCODE_DBAR_OMNSTK_CC = 138
	BARCODE_RSS14_OMNI_CC = 138 && Legacy
	BARCODE_DBAR_EXPSTK_CC = 139
	BARCODE_RSS_EXPSTACK_CC = 139 && Legacy
	BARCODE_CHANNEL = 140
	BARCODE_CODEONE = 141
	BARCODE_GRIDMATRIX = 142
	BARCODE_UPNQR = 143
	BARCODE_ULTRA = 144
	BARCODE_RMQR = 145
	BARCODE_BC412 = 146

&& Output options
	BARCODE_BIND_TOP = 1
	BARCODE_BIND = 2
	BARCODE_BOX = 4
	BARCODE_STDOUT = 8
	READER_INIT = 16
	SMALL_TEXT = 32
	BOLD_TEXT = 64
	CMYK_COLOUR = 128
	BARCODE_DOTTY_MODE = 256
	GS1_GS_SEPARATOR = 512
	OUT_BUFFER_INTERMEDIATE = 1024
	BARCODE_QUIET_ZONES = 2048
	BARCODE_NO_QUIET_ZONES = 4096
	COMPLIANT_HEIGHT = 8192

&& Input data types
	DATA_MODE = 0
	UNICODE_MODE = 1
	GS1_MODE = 2
	ESCAPE_MODE = 8
	GS1PARENS_MODE = 16
	GS1NOCHECK_MODE = 32
	HEIGHTPERROW_MODE = 64
	FAST_MODE = 128

&& Data Matrix specific options (option_3)
	DM_SQUARE = 100
	DM_DMRE = 101

&& QR, Han Xin, Grid Matrix specific options (option_3)
	ZINT_FULL_MULTIBYTE = 200

&& Ultracode specific option (option_3)
	ULTRA_COMPRESSION = 128

&& Warning and error conditions
	ZINT_WARN_INVALID_OPTION = 2
	ZINT_WARN_USES_ECI = 3
	ZINT_WARN_NONCOMPLIANT = 4
	ZINT_ERROR = 5 && Warn/error marker, not returned 
	ZINT_ERROR_TOO_LONG = 5
	ZINT_ERROR_INVALID_DATA = 6
	ZINT_ERROR_INVALID_CHECK = 7
	ZINT_ERROR_INVALID_OPTION = 8
	ZINT_ERROR_ENCODING_PROBLEM = 9
	ZINT_ERROR_FILE_ACCESS = 10
	ZINT_ERROR_MEMORY = 11
	ZINT_ERROR_FILE_WRITE = 12
	ZINT_ERROR_USES_ECI = 13
	ZINT_ERROR_NONCOMPLIANT = 14

&& File types
	OUT_BUFFER = 0
	OUT_SVG_FILE = 10
	OUT_EPS_FILE = 20
	OUT_EMF_FILE = 30
	OUT_PNG_FILE = 100
	OUT_BMP_FILE = 120
	OUT_GIF_FILE = 140
	OUT_PCX_FILE = 160
	OUT_JPG_FILE = 180
	OUT_TIF_FILE = 200

&& Warning warn
	WARN_DEFAULT = 0
	WARN_ZPL_COMPAT = 1
	WARN_FAIL_ALL = 2

&& Capability flags
	ZINT_CAP_HRT = 0x0001
	ZINT_CAP_STACKABLE = 0x0002
	ZINT_CAP_EXTENDABLE = 0x0004
	ZINT_CAP_COMPOSITE = 0x0008
	ZINT_CAP_ECI = 0x0010
	ZINT_CAP_GS1 = 0x0020
	ZINT_CAP_DOTTY = 0x0040
	ZINT_CAP_FIXED_RATIO = 0x0100 && Aspect ratio 
	ZINT_CAP_READER_INIT = 0x0200
	ZINT_CAP_FULL_MULTIBYTE = 0x0400
	ZINT_CAP_MASK = 0x0800
	ZINT_CAP_STRUCTAPP = 0x1000
	ZINT_CAP_COMPLIANT_HEIGHT = 0x2000

&& Debug flags
	ZINT_DEBUG_PRINT = 1
	ZINT_DEBUG_TEST = 2

ENDDEFINE

*
* ZintLibrary
* a loader of dependencies
* - zint.dll - barcode generator
* - vfp2c32.fll - VFP to C structures connector
*
DEFINE CLASS ZintLibrary AS Custom

	PROCEDURE Init

		SET LIBRARY TO (LOCFILE("vfp2c32.fll")) ADDITIVE

		LOCAL ZintDLL AS String

		m.ZintDLL = LOCFILE("zint.dll")

		DECLARE LONG ZBarcode_Create IN (m.ZintDLL)
		DECLARE ZBarcode_Clear IN (m.ZintDLL) ;
			LONG zint_symbol
		DECLARE ZBarcode_Delete IN (m.ZintDLL) ;
			LONG zint_symbol
		DECLARE INTEGER ZBarcode_Encode_and_Print IN (m.ZintDLL) ;
			LONG zint_symbol, STRING input_data, INTEGER length, INTEGER rotate_angle
		DECLARE INTEGER ZBarcode_Encode IN (m.ZintDLL) ;
			LONG zint_symbol, STRING input_data, INTEGER length
		DECLARE INTEGER ZBarcode_Print IN (m.ZintDLL) ;
			LONG zint_symbol, INTEGER rotate_angle
		DECLARE INTEGER ZBarcode_ValidID IN (M.ZintDLL) ;
			LONG symbol_id
		DECLARE INTEGER ZBarcode_Cap IN (m.ZintDLL) ;
			LONG symbol_id, LONG cap_flag
		DECLARE INTEGER ZBarcode_Version IN (m.ZintDLL)

	ENDPROC

ENDDEFINE
