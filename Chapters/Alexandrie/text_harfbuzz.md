# text, font, unicode and harfbuzz.

## unicode

https://tonsky.me/blog/unicode/

Unicode is a standard that aims to unify all human languages, both past and present, and make them work with computers.

In practice, Unicode is a table that assigns unique numbers to different characters. Unicode refers to these numbers as code points.

What does U+1F4A9 mean?

It’s a convention for how to write code point values. The prefix U+ means, well, Unicode, and 1F4A9 is a code point number in hexadecimal.

A code point is not a unit of writing; one code point is not always a single character. What you should be iterating on is called graphemes for short.

A grapheme is a minimally distinctive unit of writing in the context of a particular writing system. ö is one grapheme. é is one too. And 각. Basically, grapheme is what the user thinks of as a single character. The problem is, in Unicode, some graphemes are encoded with multiple code points!

For example, é (a single grapheme) is encoded in Unicode as e (U+0065 Latin Small Letter E) + ´ (U+0301 Combining Acute Accent). Two code points!

# example of fonts.

Font page: https://github.com/microsoft/cascadia-code

you can have emoji font: https://github.com/googlefonts/noto-emoji/raw/v2018-08-10-unicode11/fonts/


Font ligagure
https://github.com/microsoft/cascadia-code/blob/main/images/ligatures.png

arrow support
https://github.com/microsoft/cascadia-code/blob/main/images/arrow_support.png

## freetype
https://freetype.org/

FreeType is a freely available software library to render fonts. It is a software library that can be used by all kinds of applications to access the contents of font files. Most notably, it supports the following features.

    It provides a uniform interface to access font files. It supports both bitmap and scalable formats, including TrueType, OpenType, Type1, CID, CFF, Windows FON/FNT, X11 PCF, and others.

    It supports high-speed, anti-aliased glyph bitmap generation with 256 gray levels.


harfbuzz tells programs what glyphs to put where, freetype rasterizes glyphs 
Freetype and harfbuzz don't draw text. Freetype reads font files and gives you individual glyphs, and harfbuzz does "shaping"

Used together, HarfBuzz can perform shaping on Unicode text segments, outputting the glyph IDs that FreeType should rasterize from the active font as well as the positions at which those glyphs should be drawn. 


FreeType is a very low-level rendering engine. All it knows how to do is render individual glyphs and return metrics for them.

Arranging glyphs into words and lines is best left to a 2D graphics rendering library like Cairo. Cairo is able to do some primitive typesetting, including very basic translation of Unicode character codes to glyphs; for a more general solution, Pharo can use HarfBuzz to implement the full OpenType rules for glyph substitution and placement (Cairo still handles the actual text drawing).

## harfbuzz
https://harfbuzz.github.io/

HarfBuzz is a text shaping library. Using the HarfBuzz library allows programs to convert a sequence of Unicode input into properly formatted and positioned glyph output—for any writing system and language. If you give HarfBuzz a font and a string containing a sequence of Unicode codepoints, HarfBuzz selects and positions the corresponding glyphs from the font, applying all of the necessary layout rules and font features. HarfBuzz then returns the string to you in the form that is correctly arranged for the language and writing system. 

 Text shaping is the process of translating a string of character codes (such as Unicode codepoints) into a properly arranged sequence of glyphs that can be rendered onto a screen or into final output form for inclusion in a document.

The shaping process is dependent on the input string, the active font, the script (or writing system) that the string is in, and the language that the string is in. 

https://harfbuzz.github.io/what-harfbuzz-doesnt-do.html



