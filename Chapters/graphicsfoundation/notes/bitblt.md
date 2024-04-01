## Notes about BitBlt

This document contains some notes collected from diverse sources about BitBlt.

### Introduction

A basic operation on *Forms*, referred to as `BitBlt`, supports a wide range of
representations. This class takes its name from the concept of a bit block
transfer and is usually pronounced "bit-blit" by experienced Smalltalk
programmers.

The name derives from the BitBLT routine for the Xerox Alto computer, standing
for bit-boundary block transfer. Dan Ingalls, Larry Tesler, Bob Sproull, and
Diana Merry programmed this operation at Xerox PARC in November 1975 for the
Smalltalk-72 system. Dan Ingalls later implemented a redesigned version in
microcode.

Bitblt (which stands for bit block transfer) is a data operation commonly used
in computer graphics in which several bitmaps are combined into one using a
Boolean function.

The operation involves at least two bitmaps: a "source" (or "foreground") and a
"destination" (or "background"), and possibly a third that is often called the
"mask". The result may be written to a fourth bitmap, though often it replaces
the destination. The pixels of each are combined bitwise according to the
specified raster operation (ROP) and the result is then written to the
destination. The ROP is essentially a boolean formula. The most obvious ROP
overwrites the destination with the source. Other ROPs may involve AND, OR, XOR,
and NOT operations.

Modern graphics software has almost completely replaced bitwise operations with
more general mathematical operations used for effects such as alpha compositing.
This is because bitwise operations on color displays do not usually produce
results that resemble the physical combination of lights or inks. However, this
solution is still present in Pharo, and can still be the basis of Forms
manipulation

### Color support
It supports a wide range of color depths, namely: 1-, 2-, 4-, and 8-bit
table-based color, as well as 16- and 32-bit direct RGB color (with 5 and 8 bits
per color component respectively).

BitBlt handles multiple pixel sizes as long as source and destination bit maps
are of the same depth. To handle operations between images of different depths,
we provided a default conversion and added an optional color map parameter to
BitBlt to provide more control when appropriate. The default behavior is simply
to extend smaller source pixels to a larger destination size by padding with
zeros, and to truncate larger source pixels to a smaller destination pixel size.
This approach works very well among the table-based colors because the color set
for each depth includes the next smaller depth's color set as a subset. In the
case of RGB colors, BitBlt performs the zero-fill or truncation independently on
each color component.

The real challenge, however, involves operations between RGB and table-based
color depths. In such cases, or when wanting more control over the color
conversion, the client can supply BitBlt with a color map. This map is sized so
that there is one entry for each of the source colors, and each entry contains a
pixel in the format expected by the destination. It is obvious how to work with
this for source pixel sizes of 8 bits or less (map sizes of 256 or less). But it
would seem to require a map of 65536 entries for 16 bits or 4294967296 entries
for 32-bit color! However, for these cases, Squeak's BitBlt accepts color maps
of 512, 4096, or 32768 entries, corresponding to 3, 4, and 5 bits per color
component, and BitBlt truncates the source pixel's color components to the
appropriate number of bits before looking up the pixel in the color map.

### WarpBlt

As we began doing more with general rotation and scaling of images, we found
ourselves dissatisfied with the slow speed of non-integer scaling and image
rotations by angles other than multiples of 90 degrees. To address this problem
simply, we added a "warp drive" to BitBlt. WarpBlt takes as input a
quadrilateral specifying the traversal of the source image corresponding to
BitBlt's normal rectangular destination. If the quadrilateral is larger than the
destination rectangle, sampling occurs and the image is reduced. If the
quadrilateral is smaller than the destination, then interpolation occurs and the
image is expanded. If the quadrilateral is a rotated rectangle, then the image
is correspondingly rotated. If the source quadrilateral is not rectangular, then
the transformation will be correspondingly distorted.

Once we started playing with arbitrarily rotated and scaled images, we began to
wish that the results of this crude warp were not so jagged. This led to support
for over sampling and smoothing in the warp drive, which does a reasonable job
of anti-aliasing in many cases. The approach is to average a number of pixels
around a given source coordinate. Averaging colors is not a simple matter with
the table-based colors of 8 bits or less. The approach we used is to map from
the source color space to RGB colors, average the samples in RGB space, and map
the final result back to the nearest indexed color via the normal depth-reducing
color map.

warp-drive" variant will scale, rotate, and otherwise deform bitmaps in a single
pass. The warp drive is also capable of limited anti-aliasing.

###  Combination rules used:

- 1 (Form and)
- 3 (Form over - store)
- 4 (Form erase)
- 6 (Form reverse - XOR).
- 7 (Form under - bitOr:with:)
- 16 (Form oldPaint)
- 17 (Form oldErase1bitShape)
- 20 (rgbAdd 
- 24 (Form blend - alphaBlend: sourceWord with: destinationWord.  32-bit source and dest only)
- 25 (Form paint - pixPaint: sourceWord with: destinationWord.  Wherever the sourceForm is non-zero, it replaces the destination.  Can be used with a 1-bit source color mapped to (0, FFFFFFFF), and a fillColor to fill the dest with that color wherever the source is 1.)
- 26 (Form erase1bitShape)
- 30 (Form blendAlpha)
- 31 (Form paintAlpha)
- 32 (rgbDiff: sourceWord with: destinationWord.  Sum of abs of differences in components)
- 33 (tallyIntoMap: destinationWord.  Tallies pixValues into a colorMap (CRtallyIntoMap)
- 34 (alphaBlendScaled: srcWord with: dstWord. Alpha blend of scaled srcWord and destWord)
- 37 (CRrgbMul -  Multiply RGB or RGBA components of the pixel)
- 40 (fixAlpha:with: - CRfixAlpha - For any non-zero pixel value in destinationWord with zero alpha channel take the alpha from sourceWord and fill it in. Intended for fixing alpha 	channels left at zero during 16->32 bpp conversions.)
- 41 (CR_rgbComponentAlpha componentAlphaModeColor is the color, sourceWord contains an alpha value for each component of RGB, each of which is encoded as0 meaning 0.0 and 255 meaning 1.0 . the rule is...
```
color = componentAlphaModeColor.
colorAlpha = componentAlphaModeAlpha.
mask = sourceWord.
dst.A = colorAlpha + (1 - colorAlpha) * dst.A
dst.R = color.R * mask.R * colorAlpha + (1 - (mask.R * colorAlpha)) *
dst.R dst.G = color.G * mask.G * colorAlpha + (1 - (mask.G* colorAlpha)) *
dst.G dst.B = color.B * mask.B * colorAlpha + (1 - (mask.B* colorAlpha)) *
dst.B)
```

### Sources

Smalltalk 80 blue book - p332 and later.

- https://en.wikipedia.org/wiki/Blitter
- https://fmfi-uk.hq.sk/Informatika/Smalltalk/Online%20Book/english/sqk/sqk00078.htm
- https://fmfi-uk.hq.sk/Informatika/Smalltalk/Online%20Book/english/sqk/sqk00066.htm
- https://fmfi-uk.hq.sk/Informatika/Smalltalk/Online%20Book/english/sqk/sqk00069.htm
