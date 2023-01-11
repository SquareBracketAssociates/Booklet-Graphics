# initialisation

To draw, you first need a surface:

```smalltalk
AthensCairoSurface extent: 100@100.
```

You can specify the state of the surface

```smalltalk
 surf markDirty. 
```

|surface|
surface := AthensCairoSurface extent: 400@400.

surface drawDuring: [ :canvas |

        canvas setPaint: (

(LinearGradientPaint
from: 0@0  to: 400@400)
colorRamp: {  
0 -> Color red.
0.166 -> Color orange.
0.332 -> Color yellow.
0.5 -> Color green.
0.664 -> Color blue.
0.83 -> Color magenta.
1 -> Color purple.
}).
        canvas drawShape: (0@0 extent: 400@400). ].

surface asForm

## canvas paint

### fill paint

canvas setPaint -> canvas fill -> fill the path with color

### Stroke paint

canvas setStrokePaint -> canvas stroke -> follow the path with a pen.
canvas setStrokePaint:  Color red.

#### stroke paint customization

canvas paint dashes: #( "fill" 20  "gap" 10 "fill" 35 "gap" 30) offset: 0.
 canvas paint capSquare.
 canvas paint width: 10.

### paint definition

Paint can be:

- a single color:
- ((RadialGradientPaint new focalPoint: 10@10; center: 20@20;  radius: 20) colorRamp: {  0 -> Color white. 1 -> Color green })
- ((LinearGradientPaint from: 0@0  to: 20@20) colorRamp: {  0 -> Color white. 1 -> Color blue }).
- a picture (paint := PolymorphSystemSettings pharoLogoForm asAthensPaintOn: aCanvas )

## paint transformation

canvas paintTransform

### canvas shape

## canvas effective drawing

canvas drawShape: (0@0 extent: 400@400)
can draw.

## Canvas path

Path can be defined:
can setShape: (-20@ -20 corner: 20@ 20).

ellipsePath := aCanvas createPath: [ :builder |
  builder
   moveTo: 0@200;
   cwArcTo:  240@0 angle: Float pi;
   cwArcTo: -240@0 angle: Float pi ].

circle := surface createPath: [:builder |
  builder
   absolute;
   moveTo: -1 @ 0 ;
   ccwArcTo: 0@ 1 angle: 90 degreesToRadians ;
   ccwArcTo: 1@0 angle: 90 degreesToRadians ;
   ccwArcTo: 0@ -1 angle: 90 degreesToRadians ;
   ccwArcTo: -1@0 angle:  90 degreesToRadians
 ].

 spike := surface createPath: [:builder |
  
  builder
   absolute;
   moveTo:  -0.1 @ 0;
   lineTo: -0.05 @ 1;
   lineTo: 0.05 @ 1;
   lineTo: 0.1 @ 0  
  ].

It can be build, builder being *AthensCairoPathBuilder* , a subclass of *AthensPathBuilder*.

### Vocabulary

- relative -> position relative to previous point coordinate.
- absolute -> position relative to canvas coordinate.

#### moving

- moveTo: -> move path to a specific point to initiate drawing.

#### straight line

- lineTo: line path from previous point to target point.

#### arcs

- ccwArcTo: endPt angle: rot -> "Add a counter-clockwise arc segment, starting from current path endpoint and ending at andPt. Angle should be specified in radians "
- cwArcTo: endPt angle: rot ->  "Add a clockwise arc segment, starting from current path endpoint and ending at andPt. Angle should be specified in radians "

#### curves

- curveVia: cp1 and: cp2 to: aPoint ->  "Add a cubic bezier curve starting from current path endpoint, using control points cp1, cp2 and ending at aPoint "
- curveVia: cp1 to: aPoint -> "Add a quadric bezier curve, starting from current path endpoint, using control point cp1, and ending at aPoint "
- reflectedCurveVia: cp2 to: aPoint ->  "Add a reflected cubic bezier curve, starting from current path endpoint and ending at aPoint. The first control point is calculated as a reflection from the current point, if the last command was also a cubic bezier curve.Otherwise, the first control point is the current point. The second control point is cp2."

#### close the path

- close -> Close the path countour, between initial point, and last reached point.

## path transformation

Path can be transformed:

can pathTransform loadIdentity.
can pathTransform translateX: 30 Y: 30.
can pathTransform rotateByDegrees: 30.
can pathTransform scaleBy: 1.2.

## Mask

|surface|
surface := AthensCairoSurface   extent: 400@400.

surface drawDuring: [ :canvas | |paint font|

paint := (PolymorphSystemSettings pharoLogoForm) asAthensPaintOn: canvas.

canvas setPaint: paint.
 
canvas setPaint: (
 (LinearGradientPaint from: 0@0  to: 400@400)
 colorRamp: {  
  0 -> (Color red alpha: 0.8).
  0.166 -> (Color orange alpha: 0.8).
  0.332 -> (Color yellow alpha: 0.8).
  0.5 -> (Color green alpha: 0.8).
  0.664 -> (Color blue alpha: 0.8).
  0.83 -> (Color magenta alpha: 0.8).
  1 -> (Color purple alpha: 0.8).
 }).

canvas drawShape: (0@0 extent: 400@400).
paint maskOn: canvas.
 
font := LogicalFont familyName: 'Source Sans Pro' pointSize: 30.
canvas setFont: font.
canvas setPaint:(  (LinearGradientPaint from: 0@0  to: 100@150)
 colorRamp: {  
  0 -> (Color white alpha: 0.7).
  1 -> (Color black alpha: 0.7).}).
canvas pathTransform translateX: 20 Y: 180 + (font getPreciseAscent); scaleBy: 1.1; rotateByDegrees: 25.

canvas drawString: 'Hello Athens in Pharo'

"canvas draw."

].

surface asForm

## drawing text

font := LogicalFont familyName: 'Arial' pointSize: 10.
canvas setFont: font.
canvas setPaint: Color pink.
canvas pathTransform translateX: 20 Y: 20 + (font getPreciseAscent); scaleBy: 2; rotateByDegrees: 25.
canvas drawString: 'Hello Athens in Pharo'

## mix Athen and FormCanvas

surf asForm getCanvas
