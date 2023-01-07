# BitBlt

## introduction

A basic operation on *Forms*, referred to as **BitBlt**, support a wide range of representation.

The name derives from the BitBLT routine for the Xerox Alto computer, standing for bit-boundary block transfer. Dan Ingalls, Larry Tesler, Bob Sproull, and Diana Merry programmed this operation at Xerox PARC in November 1975 for the Smalltalk-72 system. Dan Ingalls later implemented a redesigned version in microcode.

  Bitblt (which stands for bit block transfer) is a data operation commonly used in computer graphics in which several bitmaps are combined into one using a boolean function.

The operation involves at least two bitmaps: a "source" (or "foreground") and a "destination" (or "background"), and possibly a third that is often called the "mask". The result may be written to a fourth bitmap, though often it replaces the destination. The pixels of each are combined bitwise according to the specified raster operation (ROP) and the result is then written to the destination. The ROP is essentially a boolean formula. The most obvious ROP overwrites the destination with the source. Other ROPs may involve AND, OR, XOR, and NOT operations.

Modern graphics software has almost completely replaced bitwise operations with more general mathematical operations used for effects such as alpha compositing. This is because bitwise operations on color displays do not usually produce results that resemble the physical combination of lights or inks. However, this solution is still present in Pharo, and can still be the basis of Forms manipulation

## source

Smalltalk 80 blue book - p332 and later.
[wikipedia](https://en.wikipedia.org/wiki/Blitter)
