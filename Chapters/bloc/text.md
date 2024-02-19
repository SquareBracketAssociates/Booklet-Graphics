# introduction

Bloc comes with a full API to deal with text. Not only you can deal with
raw text, but you can apply styles as well.

Here is a short example to see what is possible

```smalltalk
labelText := 'hello from bloc' asRopedText
foreground: Color orange;
fontSize: 16;
fontName: 'Helvetica';
thin.

label := BlTextElement new.
label text: labelText.

label openInNewSpace
```

Before being displayed, you define your text as an instance of **BlRopedText**,
which you can then style with **attributes** like:

- font name
- font size
- font foreground and background color
- font style (normal, italic, bold).

Text can after be rendered as **BlTextElement**, which will take care of
displaying properly the text with all properties defined on it.
Once you have a **BlTextElement**, all properties of **BlElement** apply. You
can add your element to any existing **BlElement**, and integrate it easily in
your graphical interface.

## Text handling

(BlTextElement new text: 'hello' asRopedText)

```smalltalk
BlTextElement new
        position: 5 @ 5;
        text: ('Rainbow!' asRopedText attributes:
        { (BlTextForegroundAttribute paint: Color black)

```
################################################################

## nomenclature (for horizontal text layout)

**width**
:  This is the width of the glyph image's bounding box.

**height**
: This is the height of the glyph image's bounding box.

**Advance**
:  Distance to increment the pen position when the glyph is drawn as part of a string of text.

**BearingX**
:  Distance from the current cursor position to the leftmost border of the glyph image's bounding box.

**BearingY**
: Distance from the current cursor position (on the baseline) to the topmost border of the glyph image's bounding box.

![glyph figure](figures/glyph-metrics-3.png)

**ascender**
:    portion of letter that extends above the mean line of a font.

**descender**
:    portion of a letter that extends below the baseline of a font.

**baseline**
:    line upon which most letters sit and below which descenders extend.

![typograpy figure](figures/2880px-Typography_Line_Terms.svg.png)

Reference:

- [wikipedia](https://en.wikipedia.org/wiki/Ascender_(typography))
- [freetype](https://freetype.org/freetype2/docs/tutorial/step2.html)

Measure get specified by BlMeasurementSpec

BlTextElement will instanciate a BlTextParagraph, with measurement
strategy. On instanciation, BlTextParagraph will create a BlTextParagraphLine. A line is a collection of spans
A span is an homogeneous styled piece of text where every character has the same set of attributes.

Measure is done in BATextParagraphSpan >> measure
	"Without Harfbuzz:"
	cairoGlyphsArray := cairoScaledFont glyphArrayForString: usedSpan.

	"With Harfbuzz:"
	"cairoGlyphsArray := AeHbBuffer defaultCairoGlyphArrayFor: usedSpan face: face size: fontSize."

	metrics := canvas metricsFor: cairoGlyphsArray font: cairoScaledFont.
	baseline := 0 @ 0.
	ascent := metrics ascent.
	descent := metrics descent.
	left := metrics bearingX.
	top := metrics bearingY.
	height := metrics height.
	self span isTabulation
		ifTrue: [ 
			advance := self tabStopWidth.
			width := self tabStopWidth ]
		ifFalse: [ 
			advance := metrics advanceX.
			width := metrics width ]


tight Measurement
        aMeasuredWidth  := aParagraph width.
        aMeasuredHeight := aParagraph height.

editor measurement
        aMeasuredWidth  := aParagraph advance.
        aMeasuredHeight := (aParagraph ascent abs + aParagraph descent).

label measurement.
        aMeasuredWidth  := aParagraph width.
        aMeasuredHeight := (aParagraph ascent abs + aParagraph descent).
