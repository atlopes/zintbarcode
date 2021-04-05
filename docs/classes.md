# zintBarcode classes
## Overview

**zintBarcode** comprises a functional class (named **ZintBarcode**) and two support classes (**ZintLibrary** and **ZintEnumerations**).

**ZintLibrary** loads the required **Zint** and **VFP2C32** libraries into VFP. It's instantiated in the preamble code of `zintbarcode.prg`.

**ZintEnumerations** holds the different enumerations used by **Zint**, and may be used to make the code easier to read.

That is:

```foxpro
m.ZS.SetSymbology(m.ZE.BARCODE_DATAMATRIX)
m.ZS.SetOption(3, m.ZE.DM_SQUARE)
```
instead of 
```foxpro
m.ZS.SetSymbology(71)
m.ZS.SetOption(3, 100)
```
## ZintBarcode methods

The production of a barcode is a three-step process:

1. Configure the barcode (symbology, size, colors, and other Zint properties)
1. Encode the barcode
1. Save it to an image file

### Functional methods

In alphabetical order:


----------

#### Encode (InputData AS String[, Filename AS String]) AS Integer

Encodes a barcode according to some data (text or binary). If a filename is given, it sets the `Outfile` Zint property.

Returns an error condition (0 = no error).

----------

#### EncodeSave (InputData AS String[, Filename AS String[, Angle AS Integer]]) AS Integer

Encodes a barcode according to some data, and saves it to a file (if no filename is given, the value of `Outfile` Zint property is used).

The barcode can be rotated at a given angle (at 0, 90, 180, or 270 degrees).

Returns an error condition (0 = no error).

----------

#### ImageFile (InputData AS String[, ImageFormat AS String[, Angle AS Integer]]) AS String

Encodes and saves a barcode to a temporary file, managed by the ZintBarcode class. Upon successful release of the ZintBarcode object, all temporary files are deleted.

`m.ImageFormat` is a graphic file extension (defaults to `"gif"`), and the angle can be set at 0, 90, 180, and 270 degrees.

Returns a full-path filename, or an empty string in case of error (more information given by the `.GetErrorText()` method).

----------

#### IsSupported (Symbology AS Integer) AS Logical

Checks if a given symbology identifier is supported by the library.

Returns logical.

----------

#### Reset ()

Clears and resets the Zint properties to their initial value.

----------

#### Save ([Angle AS Integer]) AS Integer

Saves an encoded barcode to a file, at a given angle (0, 90, 180, or 270 degrees).

The name of the file is the one stored in the `Outfile` Zint property.

Returns an error condition (0 = no error).

### Configuration methods

In alphabetical order. All properties have a Get method (for instance, `GetWhitespaceWidth()`). The input properties also have Set methods (for instance, `SetOption()`). Additional properties - that is, not Zint properties - are italicized.

All Set methods have a single parameter of the indicated type, except the `SetOption()` method.

| Property | Set | Get | Type | Obs |
|--|--|--|--|--|
| AlphamapPointer |  | • | I |  |
| BGColour | • | • | I | Translated as VFP color values. |
| BitmapByteLength |  | • | I |  |
| BitmapHeight |  | • | I |  |
| BitmapPointer |  | • | I |  |
| BitmapWidth |  | • | I |  |
| BorderWidth | • | • | I |  |
| Debug | • | • | I |  |
| DotSize |  | • | N |  |
| ECI | • | • | I |  |
| EncodedData |  | • | C |  |
| ErrorText |  | • | C |  |
| FGColour | • | • | I | Translated as VFP color values. |
| FontSize | • | • | I |  |
| Height | • | • | I |  |
| InputMode | • | • | I |  |
| Option | • | • | I | Index of option (1-3) is indicated in the first parameter. |
| OutputOptions | • | • | I |  |
| Outfile | • | • | C | Max. 254 length. |
| *Overlay* | • | • | C/O | Overlay image. A filename, or an Image object. |
| *OverlayHeight* | • | • | I | In pixels. When the height and the width of an overlay area are set, the overlay image is resized to fit. |
| *OverlayIsometric* | • | • | L | When `.T.`, a resized overlay image retains its proportions. Otherwise, the image resizes to the overlay width and height. |
| *OverlayMargin* | • | • | I | Margin around an overlay image. Only for a resized overlay image. |
| *OverlayPosition* | • | • | C | Position of the overlay image: C, TL, TR, BL, BR (Center, Top, Bottom, Right, Left). |
| *OverlayWidth* | • | • | I | In pixels. When the width and the height of an overlay area are set, the overlay image is resized to fit. |
| Primary |  | • | C |  |
| RowHeight |  | • | C | A binary string. |
| Rows |  | • | I |  |
| Scale | • | • | N |  |
| *SingleFile* | • | • | L | Used to indicate if a single temporary file is sufficient to store the barcodes required by the application. |
| ShowHumanReadableText | • | • | L |  |
| Symbology | • | • | I |  |
| Text | • | • | C | The class encodes the text as UTF-8. Max. 127 length (after encoding).  |
| VectorPointer |  | • | I |  |
| WarnLevel | • | • | I |  |
| WhitespaceWidth | • | • | I |  |
| Width |  | • | I |  |
