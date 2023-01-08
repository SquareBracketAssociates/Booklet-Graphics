# Morphic animation

## First basic example

Morphic has a basic animation framework builtin, where you mainly have to overwrite ``Morph>>step`` and ``gtMethod:name=Morph>>stepTime``

Here is a concrete and complete example.  It shows a F and a E letter, and an inverse F letter, all defined in a Form. Each letter has a size of 4@6 pixel, magnified by 25, so 100@150 pixels.
The Form itself has been defined with only 1 color depth, to ease its understanding.

Every 500ms, the canvas is redisplayed, and a new section of the Form is displayed.

### 1. First, declare a new Morph

```smalltalk
Morph subclass: #RdvBasicMorphAnimation
 instanceVariableNames: 'sprite position'
 classVariableNames: ''
 package: 'RdvMorph'


- Initialize the Form:

```smalltalk
initialize
 super initialize.
 sprite := (Form
   extent: 32 @ 6
   depth: 1
   fromArray: #(2r11111111111111111111111111111111 2r10000001100000011000000110000001 2r11100111111001111110011111100111 2r10000001100000011000000110000001 2r10000001100000011000000110000001 2r10000001111111111000000110000001)
   offset: 0 @ 0) magnifyBy: 25.
 position := 0.
 self extent: 100 @ 150
```

### 2. don´t forget the drawing method

```smalltalk
drawOn: aCanvas
 aCanvas
  drawImage: sprite
  at: self topLeft
  sourceRect: (Rectangle origin: position @ 0 corner: (position + 100) @ 150)
```

### 3. and the implement the different methods for the animation

```smalltalk
step
 position := position + 100.
 position > 700 ifTrue: [ position := 0 ].
 self changed
```

```smalltalk
stepTime
 ^ 500
```

### 4. and a helper method

```smalltalk
open
 <script: 'self new openInWindow'>
```

## Full examples

This example will download a sprite map, and display a running man at different size. I only give the method, class definition should be quite straightforward.

```smalltalk
initialize
 super initialize.
 sprite := ZnEasy
  getPng: 'https://opengameart.org/sites/default/files/spritesheet_caveman.png'.

 self initSpritePosition.
 self extent: (32 * self magnifyFactor) @ (32 * self magnifyFactor)
```

```smalltalk
drawOn: aCanvas
  aCanvas fillColor: Color green.
 self drawMagnifiedSpriteOn: aCanvas.
 self drawMiniSpriteOn: aCanvas 
```

```smalltalk
drawMagnifiedSpriteOn: aCanvas
 aCanvas
  paintImage:
   ((sprite contentsOfArea:
      (Rectangle point: topLeft point: bottomRight)) magnifyBy:
     self magnifyFactor)
  at: self topLeft
```

```smalltalk
drawMiniSpriteOn: aCanvas
 self drawMiniSpriteOn: aCanvas at: (self topRight translateBy: -32 @ 0).
 self drawMiniSpriteOn: aCanvas at:(self rightCenter translateBy: -32 @ -16).
 self drawMiniSpriteOn: aCanvas at: (self bottomRight translateBy: -32 @ -32).
 self drawMiniSpriteOn: aCanvas at: (self bottomCenter translateBy: -16 @ -32).
 self drawMiniSpriteOn: aCanvas at: (self bottomLeft translateBy: 0 @ -32).
 self drawMiniSpriteOn: aCanvas at: (self leftCenter translateBy: 0 @ -16).
 self drawMiniSpriteOn: aCanvas at: self topLeft.
 self drawMiniSpriteOn: aCanvas at: (self topCenter translateBy: -16 @ 0).
 self drawMiniSpriteOn: aCanvas at: (self center translateBy: -16 @ -16).
```

```smalltalk
initSpritePosition
 topLeft := 0 @ 0.
 bottomRight := 32 @ 32.
```

```smalltalk
magnifyFactor
 ^ 5
```

```smalltalk
step
 self computeNewSpriteBounds.
 self changed.
```

```smalltalk
stepTime
 ^ 100
```

```smalltalk
computeNewSpriteBounds
 "coordinate of next sprite, 32 pixels on the left"

 topLeft := topLeft translateBy: 32 @ 0.
 bottomRight := bottomRight translateBy: 32 @ 0.

 "we move to the next sprite. If we reach the end of one line"
 bottomRight x > 128
  ifTrue: [ bottomRight := 32 @ (bottomRight y + 32).
   topLeft := 0 @ (topLeft y + 32) ].
 "we reach the end of the grid, restart from 0"
 bottomRight y > 128
  ifTrue: [ self initSpritePosition ]
```

```smalltalk
open
 <script: 'self new openInWindow'>
```
