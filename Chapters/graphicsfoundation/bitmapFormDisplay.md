## Bitmap graphics, forms and display color

### Introduction

A raster graphic represents a two-dimensional picture as a rectangular matrix or grid of square pixels, viewable via a computer display, paper, or other display medium. A raster is technically characterized by the **width** and **height** of the image in **pixels** and by the **number of bits per pixel**.

![Bitmap fish.](figures/fishInPixels.png width=50)

Many raster manipulations map directly onto the mathematical formalisms of linear algebra, where mathematical objects of matrix structure are of central concern.

A bitmap image is a raster image (containing pixel data as opposed to vector images) format. Each pixel of a bitmap image is defined by a single bit or a group of bits. Hence, it is called the bitmap or a map of bits and pixels. A Bitmap image is an uncompressed file format which means, every pixel of an image has its own bit (or group of bits) in the file.

### Form

In Pharo, a `Form` is a rectangular array of pixels, used for holding images.  All pictures, including character images are Forms.

Creation of a Form:

```smalltalk
Form extent: extentPoint depth: bitsPerPixel fromArray: anArray offset: offsetPoint
```
with 

- extent: "the number of point composing the form."
- depth: "the color depth of the form"
- array: "data of the form"
- offset: "Specify an offset to move the form from coordinate 0@0 when combining form."

- The offset of a form is the amount by which the form should be offset when it is displayed or when its position is tested. Every form has an assumed origin at the top-left corner of the image. 

The coordinates of a Form start from the top-left corner much like most graphic systems out there (why ? Because Western languages are mostly written left to right, top to bottom, and initial text display follow this convention, instead of classic cartesian coordinates). 
Forms are indexed starting at 0 instead of 1; thus, the top-left pixel of a Form has coordinates 0@0.

The actual bits are held in a Bitmap, whose internal structure is different at each depth.
The supported color depths (in bits) are 1, 2, 4, 8, 16, and 32.

- If the depth is 32 bits, each element in the bitmap will represent one point.
- If you're only using 1 bits for color depth (2 possible colors), you can store up to 32 points for each bitmap elements. However, if you want to draw a single pixel, and its value depends of the higher bit, you must add enough 0 to pad on 32 bits.

This example will display a single pixel. However, its value in the bitmap needs to be encoded in 32 bits.

```smalltalk
| pict map bitmap|
pict := ColorForm extent: 1 @ 1 depth: 1.

map := { Color black . Color white }.
bitmap := Bitmap newFrom: #( 2r10000000000000000000000000000000 ).
pict colors: map.
pict initFromArray: bitmap.
```

This will display 32 pixels. The definition of the bitmap doesn´t change.
The form, however, is defined to use 32 pixels on one line.

```smalltalk
| pict map bitmap|
pict := ColorForm extent: 32 @ 1 depth: 1.

map := { Color black . Color white }.
bitmap := Bitmap newFrom: #( 2r10000000000000000000000000000000 ).
pict colors: map.
pict initFromArray: bitmap.
```

### Fun script

We should revise it. 
```
| newImgName imgFullName rotationFactor scaleFactor fFactor form |
imgFullName := (FileSystem workingDirectory / '9DB.png') fullName.
form := (Form fromFileNamed: imgFullName).
rotationFactor := 10.
scaleFactor := 10.
fFactor := 0.1.
newImgName := (imgFullName copyUpTo: $.) , '_'.

10 to: 30 by: scaleFactor do: [ : i |
	(form copy scaledToSize: i @ i) writePNGFileNamed: newImgName , 'scaledToSize_' , i asString , '.png'.
		(form copy magnifyBy: i) writePNGFileNamed: newImgName , 'magnifiedTo_' , i asString , '.png'. ].

{ #flipHorizontally . " #reverse ." #colorReduced . #fixAlpha . #asGrayScale . #asGrayScaleWithAlpha } 
	do: [ : sym | (form copy perform: sym) writePNGFileNamed: newImgName , sym asString , '.png' ].

1 to: 90 by: rotationFactor 
	do: [ : i | (form copy rotateBy: i) writePNGFileNamed: newImgName , 'rotateBy_' , i asString , '.png' ].


0 to: 1 by: fFactor do: [ : i | 
	(form copy darker: i) writePNGFileNamed: newImgName , 'darkFactor_' , i asString , '.png'.
	(form copy  dimmed: i) writePNGFileNamed: newImgName , 'dimmedFactor_' , i asString , '.png'.
	(form copy  lighter: i) writePNGFileNamed: newImgName , 'lightFactor_' , i asString , '.png'.
	(form copy  magnifyBy: i) writePNGFileNamed: newImgName , 'magnifiedTo_' , i asString , '.png' ].
	(form copy  mapColor: Color black to: Color white) writePNGFileNamed: newImgName , 'colorMap_' , i asString , '.png'.
```
