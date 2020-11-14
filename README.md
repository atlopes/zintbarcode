# zintBarcode
## Introduction
ZintBarcode provides a VFP connector to the [Zint Barcode Generator](http://www.zint.org.uk/ "Zint Home") library.

Zint is an open source project that implements 1D and 2D barcode symbologies. The VFP connector uses the `zint.dll` library to access the Zint API.

Developers should refer to the Zint documentation for a presentation on the library (also in full at the [code repository](https://sourceforge.net/p/zint/code/ci/master/tree/docs/manual.txt "Full manual").

In particular, ZintBarcode implements the following Zint API methods:

| Zint API | ZintBarcode connector  | Feature |
|--|--|--|
| ZBarcode_Encode_And_Print | EncodeSave | Generates a barcode and saves it to a file |
| ZBarcode_Encode | Encode | Generates a barcode |
| ZBarcode_Print | Save | Saves a generated barcode to a file |

ZintBarcode also implements getters and setters for all input properties of the Zint Symbol structure (and getters for the others).

The Zint API is discussed in the [Section 5](http://www.zint.org.uk/Manual.aspx?type=p&page=5 "Using the API") of the manual. The settings that control the generation process are described in point 5.5.

A description of the available symbologies and specific settings for them are presented in [Section 6](http://www.zint.org.uk/Manual.aspx?type=p&page=6 "Using the API").

Additionally, ZintBarcode implements a high-level method that returns the name of a barcode image file. The name can be used as a Picture or Control Source in Report and Forms. See the demo section, below, for an example of both scenarios.

## Setup

Zint Barcode comes as a [single program file](src/zintbarcode.prg "ZintBarcode"), but depends on the Zlib Dynamic Link Library, as well as on the VFP2C32 Fox Link Library.

Both should be downloaded from their sites ([Zint](https://sourceforge.net/projects/zint/ "Zint") project; [VFP2C32](https://github.com/ChristianEhlscheid/vfp2c32 "VFP2C32") project). For convenience, a binary copy is stored in this repository.

Zint Barcode is implemented as a class, and to put its definition in scope the command

```foxpro
DO zintbarcode.prg
```

should be issued. Afterward,

```foxpro
LOCAL ZB AS ZintBarcode

m.ZB = CREATEOBJECT("ZintBarcode")
```

will instantiate an object.

## Quick demo

In this demo, a QR code is produced and visualized in the VFP's main screen.

**Install the library and its dependencies:**

```foxpro
DO LOCFILE("zintbarcode.prg")
```

**Instantiate a ZintBarcode object:**

```foxpro
m.ZB = CREATEOBJECT("ZintBarcode")
```

**Encode a QR barcode:**

```foxpro
m.ZB.SetSymbology(58)
m.ImgFilename = m.ZB.ImageFile("https://vfpx.github.io", "gif")
```

**Create an image object in the VFP _Screen:**

```foxpro
_Screen.AddObject("qr", "Image")
```

**Load the barcode into the image:**

```foxpro
_Screen.qr.Picture = m.ImgFilename
```

**Display the image**

```foxpro
_Screen.qr.Visible = .T.
```

## Demos

![Code 128 Generator](docs/c128.png "A simple Code 128 generator")

A simple Code 128 generator form. The barcode is regenerated as the user types new text. To run the demo:

```foxpro
DO FORM demo\code128generator
```

![VFPX projects](docs/qr.png "VFPX projects")

A report of current VFPX projects. A program fetches the data from the VFPX website, including the URL of the projects, and builds a report for the resulting cursor. The URLs are represented as QR codes (their colors depending on the project status).

To run the demo:

```foxpro
DO demo\vfpxprojects.prg
```

## Licensing and aknowledgements

[Unlicensed](UNLICENSE.md "Unlicense").

**Zint** is Copyright © 2020 Robin Stuart, distributed under a BSD license.

**VFP2C32** by Christian Ehlscheid with collaboration of Eric Selje.

## Status

In development.