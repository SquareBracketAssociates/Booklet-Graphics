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

### font selection code

```smalltalk
fontLibrary := AeFTLibrary newInitialized.
freetypeFace := AeCascadiaCodeDownloadedFont new
                    downloadDirectory:
                        AeFilesystemResources downloadedFontsDirectory;
                    ensureDownloaded;
                    firstFaceUsing: AeFTLibrary newInitialized.



fontOptions := AeCairoFontOptions new
                    antialias: AeCairoAntialias fast;
                    hintMetrics: AeCairoHintMetrics on;
                    hintStyle: AeCairoHintStyle slight;
                    subpixelOrder: AeCairoSubpixelOrder default.


scaledFont := AeCairoScaledFont
                    fontFace:
                    (AeCairoFreetypeFontFace newForFace: freetypeFace)
                    fontMatrix:
                    (AeCairoMatrix newScalingByX: fontHeight y: fontHeight)
                    userToDeviceMatrix: AeCairoMatrix newIdentity
                    options: fontOptions.
```

## harfbuzz
https://harfbuzz.github.io/

HarfBuzz is a text shaping library. Using the HarfBuzz library allows programs to convert a sequence of Unicode input into properly formatted and positioned glyph output—for any writing system and language. If you give HarfBuzz a font and a string containing a sequence of Unicode codepoints, HarfBuzz selects and positions the corresponding glyphs from the font, applying all of the necessary layout rules and font features. HarfBuzz then returns the string to you in the form that is correctly arranged for the language and writing system. 

 Text shaping is the process of translating a string of character codes (such as Unicode codepoints) into a properly arranged sequence of glyphs that can be rendered onto a screen or into final output form for inclusion in a document.

The shaping process is dependent on the input string, the active font, the script (or writing system) that the string is in, and the language that the string is in. 

### create harfbuzz buffer for your text

```smalltalk
buffer := AeHbBuffer new
            direction: AeHbDirection leftToRight;
            script: AeHbScript latin;
            language: AeHbLanguage en;
            clusterLevel: AeHbBufferClusterLevel recommended;
            flags: AeHbBufferFlags beginningOrEndingOfText;
            addString: text.
```


https://harfbuzz.github.io/what-harfbuzz-doesnt-do.html

## concept

1. Character set: maps numbers to abstract characters.
2. Character: An abstraction of the representation of a character in the given medium. Since we're talking graphic design, then usually we're talking about some kind of base image. In a different medium, such as audio, a character would have a sound.
3. Font Type: A specific set of visual conventions that are used for all related glyphs in the given font.
4. Font: Maps abstract characters to glyphs that adhere to the font type.
5. Glyph: A pictorial representation of a character.
So a font is usually a collection of glyphs

https://graphicdesign.stackexchange.com/questions/45162/what-is-the-difference-between-glyph-and-font

## global steps with Harfbuzz

This involve 3 differents tools that needs to work together:

- Freetype font, which provide the collection of representation for different characters. 
- Harfbuffer, which will provide shaped glyphs for text provided, according to selected font
- Cairo context which will render glyphs.

1. Create a Harfbuzz buffer with text and description of text option. This can be independent of font specification.
2. Select a font library and the face of the font
3. Specify font options
4. Scale font to desired display size, and make Cairo context aware of it.
5. Ask Harfbuzz to create the glyphs of your text, dependent of the font selected and their size.
6. Ask Cairo context to display the glyphs at specified location.

Example

```smalltalk
| surface context scaledFont fontHeight freetypeFace fontOptions text buffer fontLibrary text|
    fontHeight := 22.
    text := 'a := A->B->>C <= c|=>d~~>e.'.

    surface := AeCairoImageSurface
                extent: 1000 @ (fontHeight * 4)
                format: AeCairoSurfaceFormat argb32.
    context := surface newContext.

"font selection, option and scale"
    fontLibrary := AeFTLibrary newInitialized.
    freetypeFace := AeCascadiaCodeDownloadedFont new
                        downloadDirectory:
                            AeFilesystemResources downloadedFontsDirectory;
                        ensureDownloaded;
                        firstFaceUsing: AeFTLibrary newInitialized.
        
    fontOptions := AeCairoFontOptions new
                    antialias: AeCairoAntialias fast;
                    hintMetrics: AeCairoHintMetrics on;
                    hintStyle: AeCairoHintStyle slight;
                    subpixelOrder: AeCairoSubpixelOrder default.


    scaledFont := AeCairoScaledFont
                    fontFace:
                    (AeCairoFreetypeFontFace newForFace: freetypeFace)
                    fontMatrix:
                    (AeCairoMatrix newScalingByX: fontHeight y: fontHeight)
                    userToDeviceMatrix: AeCairoMatrix newIdentity
                    options: fontOptions.

"create harfbuzz buffer for your text"
    buffer := AeHbBuffer new
                direction: AeHbDirection leftToRight;
                script: AeHbScript latin;
                language: AeHbLanguage en;
                clusterLevel: AeHbBufferClusterLevel recommended;
                flags: AeHbBufferFlags beginningOrEndingOfText;
                addString: text.

"context set-up"
    context
        scaledFont: scaledFont;
        translateBy: fontHeight / 2 @ 0;
        sourceColor: Color white;
        paint.

"Draw text withOUT Harfbuzz:"
    context translateBy: 0 @ (fontHeight * 1.1).
    context sourceColor: Color red muchDarker.
    context showGlyphs: (scaledFont glyphArrayForString: text).

"draw text formatted by harfbuzz."
    context translateBy: 0 @ (fontHeight * 1.1).
    context sourceColor: Color green muchDarker.
    context showGlyphs: (buffer cairoGlyphArrayForFace: freetypeFace size: fontHeight).

surface asForm
```

## draw glyphs at once or append glyphs path

Help to differentiate between fill and stroke color

```smalltalk
| surface context scaledFont fontHeight freetypeFace fontOptions text fontLibrary  |
text := 'a := A->B->>C <= c|=>d~~>e.'.
fontHeight := 22.

surface := AeCairoImageSurface
                extent: 1000 @ (fontHeight * 4)
                format: AeCairoSurfaceFormat argb32.
context := surface newContext.

context
    sourceColor: Color white;
    paint.

fontLibrary := AeFTLibrary newInitialized.
freetypeFace := AeCascadiaCodeDownloadedFont new
                    downloadDirectory:
                        AeFilesystemResources downloadedFontsDirectory;
                    ensureDownloaded;
                    firstFaceUsing: AeFTLibrary newInitialized.



fontOptions := AeCairoFontOptions new
                    antialias: AeCairoAntialias fast;
                    hintMetrics: AeCairoHintMetrics on;
                    hintStyle: AeCairoHintStyle slight;
                    subpixelOrder: AeCairoSubpixelOrder default.


scaledFont := AeCairoScaledFont
                    fontFace:
                    (AeCairoFreetypeFontFace newForFace: freetypeFace)
                    fontMatrix:
                    (AeCairoMatrix newScalingByX: fontHeight y: fontHeight)
                    userToDeviceMatrix: AeCairoMatrix newIdentity
                    options: fontOptions.
context scaledFont: scaledFont.
"Margin"
context translateBy: fontHeight / 2 @ 0.

"full stroke and fill paint"
context translateBy: 0 @ (fontHeight * 1.1);
    sourceColor: Color red muchDarker;
    showGlyphs: (scaledFont glyphArrayForString: text).

"different paint between fill and stroke"
context
    translateBy: 0 @ (fontHeight * 1.5);
    appendGlyphsPath: (scaledFont glyphArrayForString: text);
    sourceColor: (Color blue   alpha: 0.7);
    strokePreserve;
    source: (AeCairoLinearGradientPattern
                from: 0 @ 0
                to: 100 @ 100
                addStopsFrom: {
                        (0 -> Color white).
                        (1 -> Color darkGray ) });
    fill.

^ surface asForm
```


### Show Text / Glyphs

The cairo_show_text() operation forms the mask from text. It may be easier to
think of cairo_show_text() as a shortcut for creating a path with
cairo_text_path()
and then using cairo_fill() to transfer it. Be aware cairo_show_text() caches
glyphs so is much more efficient if you work with a lot of text.

cairo_text_extents_t te;
cairo_set_source_rgb (cr, 0.0, 0.0, 0.0);
cairo_select_font_face (cr, "Georgia",
CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD);
cairo_set_font_size (cr, 1.2);
cairo_text_extents (cr, "a", &te);
cairo_move_to (cr, 0.5 - te.width / 2 - te.x_bearing,
0.5 - te.height / 2 - te.y_bearing);
cairo_show_text (cr, "a");

