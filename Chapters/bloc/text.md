## About text 

### Introduction

Bloc comes with a full API to deal with text. Not only you can deal with
raw text, but you can apply styles as well.

Text is reprensented by abstract class *BlText* which serve a model for the UI 
component. Before being displayed, you define your text as an instance of 
`BlRopedText`, which you can then style with **attributes** such as:

- font name
- font size
- font foreground and background color
- font style (normal, italic, bold).

Text can after be rendered as `BlTextElement`, which will take care of
displaying properly the text with all properties defined on it.

Once you have a `BlTextElement`, all properties of `BlElement` apply. 
You can add your element to any existing `BlElement`, and integrate it easily in
your graphical interface; it'll follow the same layout rules.
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

Another way to define attributes is to pass them as a collection:

```smalltalk
BlTextElement new
        position: 5 @ 5;
        text: ('Rainbow!' asRopedText attributes:
        { (BlTextForegroundAttribute paint: Color black)})
```

Take a look at `BlText` method for a full list of available text attributes.


text is like a collection, and you can apply different attributes to different
part of your text:

```smalltalk
    labelText := 'a := A->B->>C <= c|=>d~~>e.' asRopedText
                        background: Color orange;
                        fontSize: 25;
                        fontName: 'Cascadia Code';
                            underline;
                            underlineColor: Color red.

    (labelText from: 1 to: 5) foreground: Color blue.
    (labelText from: 7 to: 11) foreground: Color white.
    (labelText from: 12 to: 15) foreground: Color red.

    label := (BlTextElement text: labelText)
                    position: 50 @ 10;
                    background: Color yellow;
                    margin: (BlInsets all: 10);
                    padding: (BlInsets all: 5);
                    outskirts: BlOutskirts centered;
                    border: (BlBorder paint: Color red width: 5).
    label tightMeasurement.
```

![Multiple attributes.](figures/multipleTextAttributes.png width=60)

### BlText vs. BlTextElement

You have 2 different levels to manage text in Bloc.
- `BlText` and its subclass `BlRopedText` create a text model where you can specify its attributes and style.
- `BlTextElement` and its subclasses will properly display the text inside a Bloc element.

A small example. You can notice that `BlText` background is different from `BlTextElement` background. 

```smalltalk
| labelText label |
labelText := 'hello from bloc' asRopedText
             background: Color orange ;
             fontSize: 75;
             fontName: 'Source Code Pro';
             italic;
             underline;
             underlineColor: Color red;
             vertical.

(labelText from: 1 to: 5) foreground: Color blue.
(labelText from: 7 to: 11) foreground: Color white.
(labelText from: 12 to: 15) foreground: Color red.

label := (BlTextElement text: labelText) position: 50 @ 10; background: Color yellow.
```

you can define the style of your text through BlTextAttributesStyler

````smalltalk
text := 'Hi John' asRopedText.

styler := BlTextAttributesStyler on: (text from: 3 to: 7).
styler
bold;
italic;
fontSize: 30;
fontName: 'Roboto';
monospace;
foreground: Color green.
styler style.
```

or using a fluent API

````smalltalk
text := 'Hi John' asRopedText.
(text from: 3 to: 7) stylerDo: [ :aStyler | aStyler bold italic foreground: Color red ].
````

As you may have noticed, this gives you a very fine-grained control over the style of your text.
You also need to re-specify attributes when your text changes.
If you want all your text to use the same attribute, you can then use `BlAttributedTextElement`. 
You can then change your text, `BlAttributedTextElement` will reuse its attributes.


```smalltalk
text := 'Hi John' asRopedText.

element := BlAttributedTextElement new.
attributes := element attributesBuilder
              foreground: Color green;
              monospace;
              bold;
              italic;
              fontSize: 30;
              fontName: 'Roboto';
              monospace.

label := (element text: text)
         position: 50 @ 10;
         background: Color yellow;
         margin: (BlInsets all: 2);
         padding: (BlInsets all: 2);
         outskirts: BlOutskirts centered;
         border: (BlBorder paint: Color red width: 2).

element text: 'hello world' asRopedText.
label.
```



### Text size

Fonts are managed directly by Alexandrie. To get the list of available fonts,
take a look at the result of `AeFontManager globalInstance familyNames`

The size of your text will depend on the font you have selected. This font will
constrain aspect of the size of letters, words, and text. 
Let's familiarize ourselves with those basic measures. 

Figure *@MulAttri@* describes the information listed below: 

**width**
:  This is the width of the glyph image's bounding box.

**height**
: This is the height of the glyph image's bounding box.

**advance**
:  Distance to increment the pen position when the glyph is drawn as part of a string of text.

**bearingX**
:  Distance from the current cursor position to the leftmost border of the glyph image's bounding box.

**bearingY**
: Distance from the current cursor position (on the baseline) to the topmost border of the glyph image's bounding box.

![Describing various font elements.](figures/glyph-metrics-3.png width=40&label=MulAttri)

**ascent**
:    portion of letter that extends above the mean line of a font.

**descent**
:    portion of a letter that extends below the baseline of a font.

**baseline**
:    line upon which most letters sit and below which descenders extend.

![Typograpy.](figures/2880px-TypographyLineTerms.pdf width=60)

References:

- [wikipedia](https://en.wikipedia.org/wiki/Ascender_(typography))
- [freetype](https://freetype.org/freetype2/docs/tutorial/step2.html)

Internally, your text will be split into a collection of *spans*. 
A span is a homogeneous styled piece of text where every character has the same set of
attributes.

### Advanced used of BlTextElement - Text bounds


You can define very precicely how your text is place in your BlTextElement.
During Bloc rendering phase, element return their measure to be layedout 
properly. This happen in the `onMeasure:` message. you can customize the rule 
used for text measurement to make it fit to your Bloc scene. By default, 
BlTextElement use the *tightMeasurement* strategy. You can change it with the 
right message. For example, to use the editor measurement, simply state:
`yourElement editorMeasurement`

`BlTextElement` has 3 available measures by default that determine its bounds.

- tight measurement: Exact width and height of the used glyphs.
- label measurement: Same width that tight measurement. The height will add to itself the *ascent* and *descent* of the glyph.
- editor measurement. Same height as label measurement. The width will add to itself the *advance* of the glyph.

![Text measures.](figures/textMeasure.png width=80)

You can develop your own strategy and customize text measure at two levels:
1. Text is first converted to `BlTextParagraph`, which will receive a subclass 
   of `BlTextParagraphBaselineMeasurer` as a baseline measure strategy
1. Paragraph measure is then used by a subclass of 
   `BlTextElementMeasurementStrategy` to specify the *BlBounds* of 
   BlTextElement.

you can then add a new method do *BlTextElement* with your new strategy, like
```
BlTextElement >> tightMeasurement
	self measurement: BlTextElementTightMeasurementStrategy uniqueInstance.
	self baselineMeasurer: BlBoundsBaselineMeasurer uniqueInstance
```

### Examples

Rectangle surrounded by number:

```smalltalk
BlElement new
    layout: (BlGridLayout horizontal columnCount: 3);
    constraintsDo: [ :c |
        c horizontal matchParent.
        c vertical matchParent ];
    addChildren: {
        "top row"
        (BlTextElement new text: '5,0' asRopedText).
        (BlElement new size: 0@0).
        (BlTextElement new text: '13,0' asRopedText).
        
        "middle row"
        (BlElement new size: 0@0).
        (BlElement new
            constraintsDo: [ :c |
                c horizontal matchParent.
                c vertical matchParent ];
            border: (BlBorder paint: Color gray width: 1)).
        (BlElement new size: 0@0).
        
        "bottom row"
        (BlTextElement new text: '5,25' asRopedText).
        (BlElement new size: 0@0).
        (BlTextElement new text: '13,25' asRopedText). }.

```

whose result is shown in Figure *@rect@*.

![Rectangle with numbers.](figures/rectangleWithNumbers.png width=60&label=rect)





### upload a font to bloc

you can load a directory with fonts (e.g. .ttf and .otf files) this way: 
`AeFontManager globalInstance scanDirectory: '../../fonts' asFileReference`

There is also 
`AeFontManager globalInstance scanDefaultDirectories`
which takes a second to find font files in the typical font directories in current platform (OS)

For example, say you have a font called "Minecraft" in a relative directory. 
This font has only "Medium" type (this is important, too):

```smalltalk 
AeFontManager globalInstance scanDirectory: '../../fonts' asFileReference.

BlTextElement new
    text: ('Hola, Bonjour, Hello!' asRopedText
            fontName: 'Minecraft' "<--- family name";
            medium; "<--- weight"
            fontSize: 50;
            yourself);
    openInNewSpace.
```

This can be tricky: You must set carefully not only the "family name", but also
3 font properties: "slant" (e.g.  normal/italic), "weight" (e.g. regular, bold,
light) and "stretch". In my example, when I set the Minecraft family name but
don't set the medium weight, then by default it will lookup for a Minecraft
regular weight font, it won't find it (the TTF only comes with a Medium weight
face), and then will use the default font.

### Dynamically change fontSize of a TextElement

For now in Bloc, we can't change the fontSize of a text after its first definition. 
To change it dynamically we'll have to create a new text which is a copy of the former text and define the new fontSize

Don't forget to remove the former textElement from children of your element and replace it with the new textElement

```smalltalk
textElement := BlTextElement new.
textElement text fontName: 'Source Sans Pro'.
textElement text fontSize: 50.
textElement text: 'A' asRopedText .

container := BlElement new.
container geometry: (BlRoundedRectangleGeometry cornerRadius: 50);
	background: Color lightBlue;
	constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent  ].

container addEventHandlerOn: BlElementExtentChangedEvent do: [ :evt | | newText fontSize| 
	fontSize:= evt currentTarget size x // 2.
	newText := BlTextElement new.
	newText text: textElement text.
	newText text fontSize: fontSize.
	container removeChildNamed: 'text';
	    addChild: newText as: 'text' ].

container addChild: textElement as: 'text'.

container openInNewSpace 
```

**Improvement**

The former paragraph was notes written at a time we didn't know about this improvement.

Apparently it seems, we can change the fontSize dynamically BUT it's the UI of the text that won't change... unless we tell it to !

So we can basically just use announcements that are already implemented in Bloc and those will call `BlTextElement>>textChanged` that will change the UI.
Here's the same example with this improved implementation: 

```smalltalk
textElement := BlTextElement new.
textElement text fontName: 'Source Sans Pro'.
textElement text fontSize: 50.
textElement text: 'A' asRopedText .
textElement text
    when: BlTextStringsInserted send: #textChanged to: textElement;
    when: BlTextsDeleted send: #textChanged to: textElement;
    when: BlTextAttributeAdded send: #textChanged to: textElement;
    when: BlTextAttributesRemoved send: #textChanged to: textElement.

container := BlElement new.
container geometry: (BlRoundedRectangleGeometry cornerRadius: 50);
	background: Color lightBlue;
	constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent  ].

container addEventHandlerOn: BlElementExtentChangedEvent do: [ | fontSize| 
	fontSize:= (container extent x min: container extent y) // 2.
	textElement text fontSize: fontSize.
	].

container addChild: textElement as: 'text'.

container openInNewSpace
```

### Rotate a textElement in a parent

```smalltalk
label := BlTextElement text: ('HelloHiHolaBonjour' asRopedText fontSize: 40; yourself).

handle := BlElement new.
handle addChild: label.
handle background: Color orange.
handle padding: (BlInsets all: 10).
handle geometry: (BlRoundedRectangleGeometry cornerRadii:
			(BlCornerRadii new
				topLeft: 0;
				topRight: 15;
				bottomLeft: 0;
				bottomRight: 15;
				yourself)).
handle layout: BlLinearLayout horizontal.
handle constraintsDo: [ :c |
	c frame vertical alignCenter.
	c vertical fitContent.
	c horizontal fitContent ].

space := handle openInNewSpace.
space root layout: BlFrameLayout new.

label forceLayout.
textSize := label size.

label transformDo: [ :t |
	t translateBy: 0 @ textSize y negated.
	t topLeftOrigin.
	t rotateBy: 90 ].

label size: label transformedBounds extent.
```

In this snippet we rotate the element containing the text (but not the textElement) using `TBlTransformable>>tranformDo:` but for that we need to force its layout and just like in the earlier example, the transformation didn't change the position nor the bounds hence the last line.
