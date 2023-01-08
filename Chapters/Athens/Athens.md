
# Vector graphics in Athens

There are two different computer graphics: vector and raster graphics.
Raster graphics represents images as a collection of pixels. Vector graphics
is the use of geometric primitives such as points, lines, curves, or polygons
to represent images. These primitives are created using mathematical equations.

Both types of computer graphics have advantages and disadvantages.
The advantages of vector graphics over raster are:

- smaller size,
- ability to zoom indefinitely,
- moving, scaling, filling, and rotating do not degrade the quality of an image.

Ultimately, picture on a computer are displayed on a screen with a specific
display dimension. However, while raster graphic doesn't scale very well when
the resolution differ too much from the picture resolution, vector graphics
are rasterized to fit the display they will appear on. Rasterization is the
technique of taking an image described in a vector graphics format and
transform it into a set of pixels for output on a screen.

Morphic is the way to do graphics with Pharo.
However, most existing canvas are pixel based, and not vector based.
This can be an issue with current IT ecosystems, where the resolution can differ from machine to machine (desktop, tablet, phones, etc...)

Enter Athens, a vector based graphic API. Under the scene, it can either use
balloon Canvas, or the cairo graphic library for the rasterization phase.

## Example

Here it would be nice to have an example

<<<<<<< HEAD
### Practicing Athens drawing.

To help you practice your Athens drawing, you can use Athens sketch, migrated from SmalltalkHub that is available at 
[Athens Sketch: https://github.com/rvillemeur/AthensSketch](https://github.com/rvillemeur/AthensSketch)

=======
```smalltalk
|surface|
>>>>>>> d70144378e5805e322f20eddfd78261937e8497c

surface := AthensCairoSurface extent: 400@400.

surface drawDuring: [ :canvas | |font|
font := LogicalFont familyName: 'Arial' pointSize: 10.
        canvas setPaint: ((LinearGradientPaint from: 0@0  to: 400@400) colorRamp: {  0 -> Color white. 1 -> Color black }).
        canvas drawShape: (0@0 extent: 400@400). 
        canvas setFont: font.
        canvas setPaint: Color pink.
        canvas pathTransform translateX: 20 Y: 20 + (font getPreciseAscent); scaleBy: 2; rotateByDegrees: 25.
        canvas drawString: 'Hello Athens in Pharo'].

surface asForm
```

## Athens details

<<<<<<< HEAD
`AthensSurface` and its subclass `AthensCairoSurface` instances represent a surface.
A surface is the area in pixel where your drawing will be rendered. 
You  never draw directly on the surface. 
Instead, you specify what you want to display on the canvas, and Athens will render it on the area specified by the surface. 

The class `AthensCanvas` is the central object used to perform drawing on an `AthensSurface`
A canvas is not directly instanciated but used through a message such as: 
=======
`AthensSurface` and its subclass `AthensCairoSurface` will initialize a new surface.
The surface represent the area in pixel where your drawing will be rendered. You
never draw directly on the surface. Instead, you specify what you want to display
 on the canvas, and Athens will render your it on the area specified by the surface.

The class `AthensCanvas` is the central object used to perform drawing on an `AthensSurface`
A canvas is not directly instanciated but used through a call like
>>>>>>> d70144378e5805e322f20eddfd78261937e8497c
`surface drawDuring: [:canvas | .... ]`

The Athens drawing model relies on a three layer model. Any drawing process
takes place in three steps:

- First a `path` is created, which includes one or more vector primitives , i.e., circles, lines, TrueType fonts, Bézier curves, etc...
- Then painting must be defined, which may be a color, a color gradient, a bitmap or some vector graphics
- Finally the result is drawn to the Athens surface, which is provided by the back-end for the output.

### Path

<<<<<<< HEAD
Athens has always an active path. 
Use `AthensPathBuilder` or `AthensSimplePathBuilder` to build a path.
They will assemble path segments for you.
=======
Athens always has an active path.

Use `AthensPathBuilder` or `AthensSimplePathBuilder` to build a path
They will assemble segment for you
>>>>>>> d70144378e5805e322f20eddfd78261937e8497c

The method `createPath:` exists in all important Athens class: `AthensCanvas`,
`AthensSurface`, and  `AthensPathBuilder`.
The message `createPath: aPath`

Using it returns a new path:

```language=smalltalk
<<<<<<< HEAD
surface createPath: [ :builder |
	builder
		absolute;
		moveTo: 100@100;
		lineTo: 100@300;
		lineTo: 300@300;
		lineTo: 300@100;
		close ].
=======
surface createPath: [:builder |
  builder
   absolute;
   moveTo: 100@100;
   lineTo: 100@300;
   lineTo: 300@300;
   lineTo: 300@100;
   close ].
>>>>>>> d70144378e5805e322f20eddfd78261937e8497c
```

Here are some helper messages in `AthensSimplePathBuilder`:

- `pathStart`
- `pathBounds` gives the limit of the bounds associated to the path

If you want to build path using only straight line, you can use the class `AthensPolygon`.

<<<<<<< HEAD
| path builder Messages | Object Segment | comment |
=======
|path builder Messages  |Object Segment     |comment                     |
|~~~~~~~~~~~-|~~~~~~~~~-|~~~~~~~~~~~~~~|
>>>>>>> d70144378e5805e322f20eddfd78261937e8497c
|ccwArcTo: angle:       |AthensCCWArcSegment|counter clock wise segment  |
|cwArcTo:angle:         |AthensCWArcSegment |clock wise segment          |
|lineTo:                |AthensLineSegment  |straight line               |
|moveTo:                |AthensMoveSegment  |start a new contour         |
|curveVia: to:          |AthensQuadSegment  |quadric bezier curve        |
|curveVia: and: to:     |AthensCubicSegment |Cubic bezier curve          |
|reflectedCurveVia: to: |AthensCubicSegment |Reflected cubic bezier curve|
|string: font:          |                   |specific to cairo           |
|close                  |AthensCloseSegment |close the current contour   |

<<<<<<< HEAD

### Absolute or relative coordinates
Athens supports two kinds of coordinates: 
=======
### Coordinate class: **Absolute** or **Relative**
>>>>>>> d70144378e5805e322f20eddfd78261937e8497c

###### Absolute: absolute coordinate from surface coordinate.
This will draw a square in a surface which extent is 400@400 using absolute move.

```language=smalltalk
builder absolute;
<<<<<<< HEAD
	moveTo: 100@100;
	lineTo: 100@300;
	lineTo: 300@300;
	lineTo: 300@100;
	close
```


##### Relative: each new move is relative to the previous one.
This will draw a square in a surface which extent is 400@400 using relative move.

```language=smalltalk
	builder relative ;
		moveTo: 100@100;
		lineTo: 200@0;
		lineTo: 0@200;
		lineTo: -200@0;
		close
```

The messages `cwArcTo:angle:` and `ccwArcTo: angle:` draw circular arc, connecting  
previous segment endpoint and current endpoint of given angle, passing in 
=======
   moveTo: 100@100;
   lineTo: 100@300;
   lineTo: 300@300;
   lineTo: 300@100;
   close
]]]

relative: each new move is relative to the previous one.
This will draw a square in a surface which extent is 400@400 using relative move.
[[[language=smalltalk
 builder relative ;
  moveTo: 100@100;
  lineTo: 200@0;
  lineTo: 0@200;
  lineTo: -200@0;
  close
]]]

cwArcTo:angle: and ccwArcTo: angle: will draw circular arc, connecting  
previous segment endpoint and current endpoint of given angle, passing in
>>>>>>> d70144378e5805e322f20eddfd78261937e8497c
clockwise or counter clockwise direction. The angle must be specified in Radian.

Please remember that the circumference of a circle is equal to 2 Pi  R.
If R = 1, half of the circumference is equal to PI, which is the value of half a circle.

<<<<<<< HEAD
### Beziers
The two messages`curveVia:to:` and `curveVia:and:to:` are linked to bezier curves.
A Bézier curve consists of two or more control points, which define the size and shape of the line. The first and  last points mark the beginning and end of the path, while the intermediate
 points define the path's curvature.
 
 More detail on Bezier curve on available at: https://pomax.github.io/bezierinfo/
=======
#### curveVia: to: and |curveVia: and: to

This call is related to bezier curve. A Bézier curve consists of two or more
 control points, which define the size and shape of the line. The first and
 last points mark the beginning and end of the path, while the intermediate
 points define the path's curvature.

 More detail on Bezier curve on available at: <https://pomax.github.io/bezierinfo/>

#### path transformation
>>>>>>> d70144378e5805e322f20eddfd78261937e8497c

A path can be rotated, translated and scaled so you can adapt it to your need.
For example, you can define a path in your own coordinate system, and then
scale it to match the size of your surface extent.

### The different type of painting

Paints can be created either from the surface or directly from a class that will
do the call to the surface for you.

any object can be treated as paint:

- `athensFillPath: aPath on: aCanvas`
- `athensFillRectangle: aRectangle on: aCanvas`
- `asStrokePaint`

| surface message | comment |
| `createFormPaint:`| create paint from a Form |
|createLinearGradient: start: stop:               | linear gradient paint |
|createRadialGradient: center: radius:            | Radial gradient paint |
|createRadialGradient: center: radius: focalPoint:| Radial gradient paint |
|createShadowPaint:                               |???                     |
|createSolidColorPaint:                           |fill paint              |
|createStrokePaintFor:                            |stroke paint            |

a Canvas define its paint method we will see in detail below:
<<<<<<< HEAD
- setPaint:
- setStrokePaint:

### Stroke paint (a pen that goes around the path)
The `createStrokePaintFor:` operation takes a virtual pen along the path. It allows the source 
=======

- setPaint:
- setStrokePaint:

# Stroke paint (a pen that goes around the path)

The **createStrokePaintFor** operation takes a virtual pen along the path. It allows the source
>>>>>>> d70144378e5805e322f20eddfd78261937e8497c
to transfer through the mask in a thin \(or thick\) line around the path

`AthensStrokePaint` represents a stroke paint.

<<<<<<< HEAD


### Solid paint \(a pen that fill the path\)
The `createSolidColorPaint` operation instead uses the path like the lines of a coloring book, 
and allows the source through the mask within the hole whose boundaries are the 
path. For complex paths \(paths with multiple closed sub-paths—like a donut—or
paths that self-intersect\) this is influenced by the fill rule

SD: We need examples




### Gradient
=======
!!! Solid paint \(a pen that fill the path\)
The **createSolidColorPaint** operation instead uses the path like the lines of a coloring book,
and allows the source through the mask within the hole whose boundaries are the
path. For complex paths \(paths with multiple closed sub-paths—like a donut—or
paths that self-intersect\) this is influenced by the fill rule

!!! Gradient
>>>>>>> d70144378e5805e322f20eddfd78261937e8497c
Gradient will let you create gradient of color, either linear, or radial.

The color ramp is a collection of associations with keys - floating point values
between 0 and 1 and values with Colors, for example:
{0 -> Color blue . 0.5 -> Color white. 1 -> Color red}.

You can use either helper class or calling surface messages:

```language=smalltalk
surface createLinearGradient: {0 -> Color blue .0.5 -> Color white. 1 -> Color red} start:  0@0  stop: 200@100.
```

or

```language=smalltalk
????
```

Start and stop point are reference to the current shape being drawn.
Exemple:
Create a vertical gradient

```language=smalltalk
canvas
    setPaint:
        \(canvas surface
            createLinearGradient:
                {\(0 -> Color blue\).
                \(0.5 -> Color white\).
                \(1 -> Color red\)}
            start: 0@200
            stop: 0@400\). 
    canvas drawShape: \(0@200 extent: 300@400\).
```

<<<<<<< HEAD
The following creates a horizontal gradient:
=======
create a horizontal gradient:

>>>>>>> d70144378e5805e322f20eddfd78261937e8497c
```language=smalltalk
canvas
    setPaint:
        \(canvas surface
            createLinearGradient:
                {\(0 -> Color blue\).
                \(0.5 -> Color white\).
                \(1 -> Color red\)}
            start: 0@200
            stop: 300@200\). 
    canvas drawShape: \(0@200 extent: 300@400\).
```

create a diagonal gradient:

```language=smalltalk
canvas
    setPaint:
        \(canvas surface
            createLinearGradient:
                {\(0 -> Color blue\).
                \(0.5 -> Color white\).
                \(1 -> Color red\)}
            start: 0@200
            stop: 300@400\). 
    canvas drawShape: \(0@200 extent: 300@400\).
```

## drawing

<<<<<<< HEAD
### Drawing

Either you set the shape first and then you send the message `draw`, or you send the 
convenient message `drawShape:` directly with the path to draw as argument
=======
Either you set the shape first and then you call **draw**, or you call the
convenient method **drawShape:** directly with the path to draw as argument
>>>>>>> d70144378e5805e322f20eddfd78261937e8497c

### Some example

```language=smalltalk
<<<<<<< HEAD
	surface clear.
	canvas
		setPaint:	
		((LinearGradientPaint from: 0 @ 0 to: self extent)
			colorRamp:
				{(0 -> Color white).
				(1 -> Color black)}).
	canvas drawShape: (0 @ 0 extent: self extent).
	canvas
		setPaint:
			(canvas surface
				createLinearGradient:
					{(0 -> Color blue).
					(0.5 -> Color white).
					(1 -> Color red)}
				start: 0@200
				stop: 0@400). "change to 200 to get an horizontal gradient"
			canvas drawShape: (0@200 extent: 300@400).
			canvas setFont: font.
			canvas
				setPaint:
					(canvas surface
						createLinearGradient:
							{(0 -> Color blue).
							(0.5 -> Color white).
							(1 -> Color red)}
						start: 50@0
						stop: (37*5)@0). "number of caracter * 5"
			canvas pathTransform
				translateX: 45 Y: 45 + font getPreciseAscent;
				scaleBy: 2;
				rotateByDegrees: 28.
			canvas
				drawString: 'Hello Athens in Pharo/Morphic !!!!!!!'.
=======
"canvas pathTransform loadIdentity.  font1 getPreciseAscent. font getPreciseHeight"
   surface clear.
   canvas
    setPaint:
     ((LinearGradientPaint from: 0 @ 0 to: self extent)
      colorRamp:
       {(0 -> Color white).
       (1 -> Color black)}).
   canvas drawShape: (0 @ 0 extent: self extent).
   canvas
    setPaint:
     (canvas surface
      createLinearGradient:
       {(0 -> Color blue).
       (0.5 -> Color white).
       (1 -> Color red)}
      start: 0@200
      stop: 0@400). "change to 200 to get an horizontal gradient"
   canvas drawShape: (0@200 extent: 300@400).
   canvas setFont: font.
   canvas
    setPaint:
     (canvas surface
      createLinearGradient:
       {(0 -> Color blue).
       (0.5 -> Color white).
       (1 -> Color red)}
      start: 50@0
      stop: (37*5)@0). "number of caracter * 5"
   canvas pathTransform
    translateX: 45 Y: 45 + font getPreciseAscent;
    scaleBy: 2;
    rotateByDegrees: 28.
   canvas
    drawString: 'Hello Athens in Pharo/Morphic !!!!!!!'.
>>>>>>> d70144378e5805e322f20eddfd78261937e8497c
```

```language=smalltalk
renderAthens
 surface
  drawDuring: [ :canvas | 
   | stroke squarePath circlePath |
   squarePath := canvas
    createPath: [ :builder | 
     builder
      absolute;
      moveTo: 100 @ 100;
      lineTo: 100 @ 300;
      lineTo: 300 @ 300;
      lineTo: 300 @ 100;
      close ].
   circlePath := canvas
    createPath: [ :builder | 
     builder
      absolute;
      moveTo: 200 @ 100;
      cwArcTo: 200 @ 300 angle: 180 degreesToRadians;
      cwArcTo: 200 @ 100 angle: Float pi ].
   canvas setPaint: Color red.
   canvas drawShape: squarePath.
   stroke := canvas setStrokePaint: Color black.
   stroke
    width: 10;
    joinRound;
    capRound.
   canvas drawShape: squarePath.
   canvas drawShape: circlePath.
   circlePath := canvas
    createPath: [ :builder | 
     builder
      relative;
      moveTo: 175 @ 175;
      cwArcTo: 50 @ 50 angle: 180 degreesToRadians;
      cwArcTo: -50 @ -50 angle: Float pi ].
   canvas drawShape: circlePath ]
```

<<<<<<< HEAD
                
=======
### practicing Athens drawing

To help you practice your Athens drawing, you can use Athens sketch, migrated from SmalltalkHub that is available at
[Athens Sketch: https://github.com/rvillemeur/AthensSketch](https://github.com/rvillemeur/AthensSketch)
>>>>>>> d70144378e5805e322f20eddfd78261937e8497c
