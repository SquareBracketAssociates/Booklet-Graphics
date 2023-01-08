# bloc examples

## animatedIcon

```smalltalk
|icon e|
icon := BrGlamorousVectorIcons transcript asElement.
icon constraintsDo: [ :c | c accountTransformation ].

e := BlElement new
    background: Color white;
    border: (BlBorder paint: Color gray width: 1);
    geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
    padding: (BlInsets top: 5 left: 10 bottom: 5 right: 10);
    layout: (BlZoomableLayout new addLayout: BlFrameLayout new; defaultScale: 2; animationDuration: 1 second);
    constraintsDo: [ :c |
        c vertical fitContent.
        c horizontal fitContent ];
    addChild: icon;
    yourself.
 ^e
```

## bigAdaptableText

```smalltalk
^(BlTextElement new text: 'hello' asRopedText) asScalableElement.
```

## iconScaleToFitElement

```smalltalk
|icon scaledIcon e|
icon := BrGlamorousVectorIcons transcript asElement.
scaledIcon := icon asScalableElement
    scaleStrategy: (BlScalableFixedStrategy zoom: 2);
    constraintsDo: [ :c |
        c horizontal fitContent.
        c vertical fitContent ].
    
e := BlElement new
    background: Color white;
    border: (BlBorder paint: Color gray width: 1);
    geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
    padding: (BlInsets top: 5 left: 10 bottom: 5 right: 10);
    layout: BlFrameLayout new;
    constraintsDo: [ :c |
        c vertical fitContent.
        c horizontal fitContent ];
    addChild: scaledIcon;
    yourself.
    
^e
```

## squareSurroundedByNumbers

```smalltalk
^BlElement new
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
