# bitmap graphics, Forms and display color

- A raster graphic represents a two-dimensional picture as a rectangular matrix or grid of square pixels, viewable via a computer display, paper, or other display medium. A raster is technically characterized by the **width** and **height** of the image in **pixels** and by the **number of bits per pixel**.

![bitmap fish](Raster_graphic_fish_20x23squares_sdtv-example.png)

- Many raster manipulations map directly onto the mathematical formalisms of linear algebra, where mathematical objects of matrix structure are of central concern.
- A bitmap image is a raster image (containing pixel data as opposed to vector i images) format. Each pixel of a bitmap image is defined by a single bit or a group of bits. Hence, it is called the bitmap or a map of bits and pixels. A Bitmap image is an uncompressed file format which means, every pixel of an image has its own bit (or group of bits) in the file.
- In Pharo, a **Form** is a rectangular array of pixels, used for holding images.  All pictures, including character images are Forms.
Creation of a Form:
- ```smalltalk

Form extent: extentPoint depth: bitsPerPixel fromArray: anArray offset: offsetPoint

extent: "the number of point composing the form."
depth: "the color depth of the form"
array: "data of the form"
offset: "Specify an offset to move the form from coordinate 0@0 when combining form."

```smalltalk
- The offset of a form is the amount by which the form should be offset when it is displayed or when its position is tested. Every form has an assumed origin at the top lefthand comer of the image. When a form is sent a message to display itself, for example,

```smalltalk
bug displayAt: 150@150
```

the form is displayed with its origin at the specified point plus the offset; i.e., 150@150. The bug is therefore displayed so that its center is located at the point ISO@IS0. The ability to specify an offset is particularly useful when defining cursors that have logical origins or "hot spots." For example, the logical origin of the crosshairs cursor is at the center of the crosshairs.

The coordinates of a Form start from the top-left corner much like most graphic system out there (why ? Because Western language are mostly written left to right, top to bottom, and initial text display follow this convention, instead of classic cartesian coordinate). Forms are indexed starting at 0 instead of 1; thus, the top-left pixel of a Form has coordinates 0@0.

The actual bits are held in a Bitmap, whose internal structure is different at each depth.
The supported color depths (in bits) are 1, 2, 4, 8, 16, and 32.

If the depth is 32 bits, each element in the bitmap will represent one point
If you're only using 1 bits for color depth (2 possible colors), you can store
up to 32 points for each bitmap elements. However, if you want to draw a single
pixel, and its value depend of the higher bit, you must add enough 0 to pad on
32 bits.

This example will display a single pixel. However, its value in the bitmap needs
to be encoded in 32 bits.

```smalltalk
    | pict map bitmap|
    pict := ColorForm extent: 1 @ 1 depth: 1.

    map := { Color black . Color white }.
    bitmap := Bitmap newFrom: #( 2r10000000000000000000000000000000 ).
    pict colors: map.
    pict initFromArray: bitmap.
```

This will display 32 pixel. The definition of the bitmap doesn´t change.
The form, however, is defined to use 32 pixel on one line.

```smalltalk
    | pict map bitmap|
    pict := ColorForm extent: 32 @ 1 depth: 1.

    map := { Color black . Color white }.
    bitmap := Bitmap newFrom: #( 2r10000000000000000000000000000000 ).
    pict colors: map.
    pict initFromArray: bitmap.
```
