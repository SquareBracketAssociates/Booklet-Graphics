## PNG file description

Image could be saved a raw bitmap, but this would consume a lot of space.
Image are usually stored in a compressed format, jpeg or png are one of most
well known. Let's  study the detail of a PNG file. Pharo is already fully
equiped to encode and decode PNG file, though the class *PNGReadWriter*.
However, it's interesting to understand how PNG file are structured.

This chapter is heavily inspired by this
[article](https://evanhahn.com/worlds-smallest-png/), from Evan Hahn.

Refefence: [PNG specification](https://www.w3.org/TR/png-3/)

We'll be creating a PNG with a single pixel. The final form we will look like:

white pixel:

```smalltalk
    | pict map bitmap|
    pict := ColorForm extent: 1 @ 1 depth: 1.

    map := { Color black . Color white }.
    bitmap := Bitmap newFrom: #( 2r10000000000000000000000000000000 ).
    pict colors: map.
    pict initFromArray: bitmap.
```

Black pixel:

```smalltalk
    | pict map bitmap|
    pict := ColorForm extent: 1 @ 1 depth: 1.

    map := { Color black . Color white }.
    bitmap := Bitmap newFrom: #( 2r00000000000000000000000000000000 ).
    pict colors: map.
    pict initFromArray: bitmap.
```

### file description

In this chapter, we'll draw a single black pixel, stored as PNG.

PNG file has four sections:

1. The PNG signature, the same for every PNG: 8 bytes
2. The image’s metadata, which includes its dimensions: 25 bytes
3. The image’s pixel data: 22 bytes
4. An “end of image” marker: 12 bytes

### The PNG signature

Every single PNG, starts with the same 8 bytes. Encoded in hex, those bytes are:
`89 50 4E 47 0D 0A 1A 0A`

This is called the PNG signature. Try doing a hex dump on any PNG and you’ll see
that it starts with these bytes.

PNG decoders use the signature to ensure that they’re reading a PNG image.
Typically, they reject the file if it doesn’t start with the signature. Data can
get corrupted in various ways (ever had a file with the wrong extension?) and
this helps address that.

Fun fact: if you decode these bytes as ASCII, you’ll see the letters “PNG” in
there: `.PNG....`

### Image metadata

The next part of the PNG is the image metadata, which is one of several chunks.
What’s a chunk?

#### Quick intro to chunks

Other than the PNG signature at the start, PNGs are made up of chunks.

Chunks have two logical pieces: a **type** and some **data bytes**. Types are
things like *"image header"* or *"text metadata"*. The data depends on the
type—the text metadata chunk is encoded differently from the image header chunk.

These logical pieces are encoded with four fields. These fields are always in
the same order for every chunk. They are:

1. **Length:** the number of bytes in the chunk’s data field (field #3 below).
Encoded as a 4-byte integer.
2. **Chunk type:** the type of chunk this is. There are lots of different chunk
types. Encoded as a 4-byte ASCII string, such as *"IHDR"* for *"image header"*
or *"tEXt"* for *"text metadata"*.
3. **Data:** the data for the chunk. See the *"length"* field for how many bytes
there will be. Varies based on the chunk type. For example, the IHDR chunk
encodes the image’s dimensions. May be empty, but usually isn’t.
4. **Checksum:** a checksum for the rest of the chunk, to make sure no data was
corrupted. 4 bytes. It include chunk tupe, data, but exclude length.

As you can see, each chunk is a minimum of 12 bytes long (4 for the length,
4 for the type, and 4 for the checksum).

Note that the *"length"* field is the size of the *"data"* field, not the
entire chunk. If you want to know the whole size of the chunk, just add 12—4
bytes for the length, 4 bytes for the type, and 4 bytes for the checksum.

You have some wiggle room but chunks have a specific order. For example, the
image metadata chunk has to appear before the pixel data chunk. Once you reach
the “image is done” chunk, the PNG is done.

Our tiny PNG will have just three of these chunks.

#### Image header chunk

The first chunk of every PNG, including ours, is of type IHDR, short for
*"image header"*.

Each chunk starts with the length of the data in that chunk.

The IHDR chunk always has 13 bytes of associated data, as we’ll see in a moment.
13 is 0D in hex, which gets encoded like this: `00 00 00 0D`

The **chunk type** is next. This is another four bytes. *"IHDR"* is encoded as:
`49 48 44 52`. This is just ASCII encoding. Chunk types are made up of ASCII
letters. The capitalization of each letter is significant. For example, the
first letter is capitalized which means it’s a required chunk.

Next, the chunk’s **data**. IHDR’s data happens to be 13 total bytes, arranged
as follows:

- The first eight bytes encode the image’s width and height. Because this is a
1×1 image, that’s encoded as 00 00 00 01 00 00 00 01.

- The next two bytes are the bit depth and color type.

These values are probably the most confusing part of this PNG.

There are five possible color types. Our image is black-and-white so we use the
*"greyscale"* color type (encoded as `00`). If our image had color, we might use
the *"truecolor"* type (encoded with `02`). There are three other color types
which we don’t need today, but you can read more about them in the PNG
specification.

Once you’ve picked a color type, you need to pick a bit depth. The bit depth
depends on the color type, but usually means the number of bits per color
channel in an image. For example, hex colors like #FE9802 have a bit depth of
eight—eight bits for red, eight bits for green, and eight bits for blue.
Our all-black image doesn’t need all that…we only need one bit! The pixel is
either completely black (`0`) or completely white (`1`)—in our case, it’s
completely black.

If we picked a more *"expressive"* color type and bit depth, we could make the
same 1×1 image visually, but the file could be bigger because there could be
more bits per pixel that we don’t actually need. For example, if we used the
*"truecolor"* type and 16 bits per channel, each pixel would require 48 bits
instead of just one—not necessary to encode *"completely black"*.

With bit depth of 1 and a color type of 0, we encode these two values with
`00 01`.

The next byte is the compression method. All PNGs set this to `00` for now. This
is here just in case they want to add another compression method later. As far
as I know, nobody has.

Same story for the filter method. It’s always `00`.

The last part of the chunk’s data is the interlace method. PNGs support
progressive decoding which allows images to be partly rendered as they download.
We aren’t going to use that feature so we set this to `00`.

Finally, every chunk ends with a four-byte checksum. It uses a common checksum
function called CRC32 that is available in default Pharo image, and uses the
rest of the chunk as an input. Checksum gives us the following bytes:
`37 6E F9 24` computed as

```smalltalk
CRC crc32FromCollection: (ByteArray readHexFrom:  
"00 00 00 0D length in not part of CRC32 calculation"
'49484452',  "chunk type"
'00000001', "width"
'00000001', "height"
'01', "bit depth"
'00', "color type"
'00', "compression method"
'00', "filter method"
'00' "interlace method")
```

### pixel data chunk

Our next chunk is **IDAT**, short for *"image data"*. This is where the actual
pixels are encoded…or just one pixel, in our case.

Remember that each chunk has four parts: the data’s *length*, the chunk *type*,
the *data*, and a *checksum*.

This chunk will have 10 bytes of data. We’ll talk about what that data is
shortly, but I promise it’s 10 bytes. Let’s encode that length: `00 00 00 0A`

Next, let’s encode *"IDAT"* for the chunk type: `49 44 41 54`

Again, this is just ASCII, and I’m showing the hex-encoded values.

Now for the interesting part: the image data.

#### First step: uncompressed pixels

Image data is encoded in a series of *"scanlines"*, and then compressed.

A scanline represents a horizontal line of pixels. For example, a 123×456 image
has 456 scanlines. In our case, we have just one scanline, because our image is
just one pixel tall.

Scanlines start with something called a *filter type* which can improve
compression, depending on your image. Our image is so small that this is
irrelevant, so we use filter type `0`, or *"None"*.

After the filter type, each pixel is encoded with one or more bits, depending
on the bit depth. In our case, we just need one bit per pixel—recall that we
have a bit depth of 1; all black or all white.

If your pixel data doesn’t line up with a byte boundary—in other words, if it’s
not a multiple of 8 bits—you pad the end of your scanline with zeroes. That’s
true in our case, so we add seven padding bits to fill out a byte.

Putting that together (a zero byte to start the scanline, the single zero bit,
and seven zero padding bits), our single scanline is: `00 00`
Now it’s time to *"compress"* the data.

#### Second step: *"compression"*

Next, we compress the scanline data…well, not quite.

More accurately, we run it through a compression algorithm. Most of the time,
compression algorithms produce smaller outputs—that’s the whole point! But
sometimes, *"compressing"* tiny inputs actually produces *bigger* outputs
because of some small overhead. Unfortunately for us, that’s what happens here.
But the PNG file format makes us do it.

PNG image data is encoded in the
[zlib format](https://www.rfc-editor.org/rfc/rfc1950) using the
[DEFLATE compression algorithm](https://zlib.net/feldspar.html).
DEFLATE is also used with gzip and ZIP, two very popular compression formats.

I won’t go in depth on DEFLATE here (in part because I am not an expert4), but
here’s what our chunk’s data contains:

1. The zlib header: 2 bytes
2. One compressed DEFLATE block that encodes two literal zeroes5: 4 bytes
3. The zlib checksum (this is separate from the PNG chunk checksum!): 4 bytes

For more on how DEFLATE works, check out
*"[An Explanation of the DEFLATE Algorithm](https://zlib.net/feldspar.html)"*.
I also recommend [infgen](https://github.com/madler/infgen/), a useful tool for
inspecting DEFLATE streams.

All together, here are the ten data bytes: `78 5E 63 60 00 00 00 02 00 01`

Pharo can give us this compression:

```smalltalk
ByteArray streamContents: [ :out |
    (ZLibWriteStream  on: out) nextPutAll: #[ 00 00 ]; close ]
```

For a white pixel, you would do:

```smalltalk
ByteArray streamContents: [ :out |
    (ZLibWriteStream  on: out) nextPutAll: #[ 00 2r10000000 ]; close ]
```

Again, unfortunate that we had to run our two-byte scanline through an algorithm
that made it five times bigger, but PNG makes us do it!

With that, we can compute the PNG’s checksum field and finish off the chunk.

```smalltalk
CRC crc32FromCollection: (ByteArray readHexFrom:  
"00 00 00 0A length in not part of CRC32 calculation"
'49444154',  "chunk type"
'785E', "Zlib header"
'63600000', "Compressed DEFLATE block"
'00020001' "Zlib Checksum"
)
```

IDAT chunk checksum, in our case is `DE 9E 8F BF`

Just one more chunk to go!

### The end

Poetically, PNGs end like they begin: with a small number of constant bytes.

**IEND** is the final chunk, short for “image trailer”.

The zero length is encoded with 4 zeroes: `00 00 00 00`
*"IEND"*  is then encoded: `49 45 4E 44`

There’s no data in IEND chunks, so we just move onto the checksum. Because
everything else in the chunk is constant, this checksum is always the same:

```smalltalk
CRC crc32FromCollection: (16r0000000049454E44)
```

result: `AE 42 60 82`

And our PNG is done!

If you want to know more how Pharo decode PNG file, take a look at the class
**PNGReadWriter**

### full image code

```smalltalk
|png| 

png := (ByteArray readHexFrom: 
'89504E470D0A1A0A', "PNG Signature"
"header"
'0000000D', "chunk data length"
'49484452', "chunk type"
'00000001', "width"
'00000001', "height"
'01', "bit depth"
'00', "color type"
'00', "compression method"
'00', "filter method"
'00', "interlace method"
'376EF924', "checksum"
"data"
'0000000A', "chunk data length"
'49444154', "chunk type"
'785E', "zlib header"
'63600000', "compressed deflate block"
'00020001', "zlib checksum"
'DE9E8FBF', "chunk checksum"
"end"
'00000000', "chunk data length"
'49454E44', "chunk type"
'AE426082' "checksum").


(PNGReadWriter formFromStream: png readStream) magnifyBy: 200.
```

![first png](figures/png1.png)

We can now play with our image, like:

- take a width of 8 pixel
- alternate color, so our is 2r10101010, or 170 in decimal.

```smalltalk
|png| 

png := (ByteArray readHexFrom: 
'89504E470D0A1A0A', "PNG Signature"
"header"
'0000000D', "chunk data length"
'49484452', "chunk type"
'00000008', "width"
'00000001', "height"
'01', "bit depth"
'00', "color type"
'00', "compression method"
'00', "filter method"
'00', "interlace method"
'CB7BD2EE', "checksum"
"data"
'0000000A', "chunk data length"
'49444154', "chunk type"
'785E', "zlib header"
'63580500', "compressed deflate block"
'00AC00AB', "zlib checksum"
'F03ACFA5', "chunk checksum"
"end"
'00000000', "chunk data length"
'49454E44', "chunk type"
'AE426082' "checksum").


(PNGReadWriter formFromStream: png readStream) magnifyBy: 100.
```

![second png](figures/png2.png)
