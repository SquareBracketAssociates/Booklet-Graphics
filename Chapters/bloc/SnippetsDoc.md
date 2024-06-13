# Interesting snippets of Bloc 

This document aims to share small interesting snippets that highlight some particularities of Bloc

## Star shape using Bloc Geometry

Here, we can make a star with N branches using this code
outerSize is for the length of the branches, innerSize for the width of the branches bases
We could maybe use this implementation to define a new star geometry that could be configured with those 3 parameters

```smalltalk
outerSize := 100.
innerSize := 40.
numberOfPoints := N.
angleStep := 360.0 / numberOfPoints.

vertices := OrderedCollection new.
0 to: 360 by: angleStep do: [ :angle |
    vertices
        add: (0@innerSize rotateBy: (angle - (angleStep * 0.5)) degreesToRadians about: 0 asPoint);
        add: (0@outerSize rotateBy: angle degreesToRadians about: 0 asPoint);
        add: (0@innerSize rotateBy: (angle + (angleStep * 0.5)) degreesToRadians about: 0 asPoint) ].

starElement := BlElement new
        geometry: (BlPolygonGeometry vertices: vertices);
        background: Color black;
        position: 200 @ 150;
        yourself.

space := BlSpace new.
space root addChild: starElement.
space show.
```

## Explosion animation 

We create an explosion animation by creating some BlElements and making them translate along a rotating line starting from a center point

Here we also add a rotation on the BlElements themselves with random color

```smalltalk
space := BlSpace new.
explosionCenter := 400 @ 300.

0 to: 359 by: 12 do: [ :angle |
    | anElement relativeFinalPosition |
    relativeFinalPosition := 0@400 rotateBy: angle degreesToRadians about: 0@0.

    anElement := BlElement new
        background: Color random;
        position: explosionCenter;
        addAnimation: (BlTransformAnimation new
            duration: 1200 milliSeconds;
            transformDo: [ :t |
                t translateBy: relativeFinalPosition.
                t rotateBy: 180 ];
            onFinishedDo: [ anElement removeFromParent ];
          yourself);
        yourself.

    space root addChild: anElement ].
space show.

```

## Square Layout 

This example shows how the squareLayout works when applied to an element, in fact here we give constraints to match parent horizontally and vertically but the squareLayout forces our element to be of square shape meaning that this will draw the biggest square in the available space?

```smalltalk
anElement := 
        BlElement new
                background: Color blue;
                geometry: (BlRoundedRectangleGeometry cornerRadius: 25);
                margin: (BlInsets all: 5);
                constraintsDo: [ :c |
                        c horizontal matchParent.
                        c vertical matchParent ];
                yourself.

squarifierElement :=
        BlElement new
                layout: ((BlSquaredLayout on: BlLinearLayout vertical alignCenter) beTight; yourself);
                addChild: anElement;
                constraintsDo: [ :c |
                        c horizontal matchParent.
                        c vertical matchParent ];
                yourself.
        
space := BlSpace new.
space root addChild: squarifierElement.
space
        extent: 200 @ 250;
        show
```
Something interesting I found using a SquareLayout: If you use a gridLayout and want its elements contained to matchParent and stay as square while resizing the gridLayout, you can encapsulate the gridLayout into a squareLayout so the contained elements will matchParent with a square shape


## Space extent following its child extent 

```smalltalk
space := BlSpace new.
space show.

rootUniqueChild := BlElement new
	geometry: BlEllipseGeometry new;
	background: Color blue;
	"Transfer the new extent to the space"
	addEventHandlerOn: BlElementExtentChangedEvent
		do: [ :evt | space extent: evt target extent ]; 
	yourself.
space addChild: rootUniqueChild.

"Gradually expand element in a background process"
[ 	50 to: 400 by: 50 do: [ :sideLength |
		rootUniqueChild size: (sideLength*2) @ sideLength.
		500 milliSeconds wait ].
	space close ] fork
```

Here, space extent is redefined whenever the extent of its child changes using a basic eventHandler

## Dynamically change fontSize of a TextElement

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

## Center a space

```smalltalk
space := BlSpace new.
space root background: Color lightGreen.

space enqueueTask:
   (BlTaskAction new
      action: [ space center ];
      yourself).

space show
```

Spaces are by default opened with their origin on the top left or the screen, but we can change this by sending the message `BlSpace>>center`.
However you might wonder why in this example we send it as a task that we enqueue, the reason behind it is that (apparently) the space needs to be rendered to be centered and executing something like the following snippet doesn't work

```st
space show; center
```

## RequestFocus for KeyboardEvent

To deal with keyboard events, we need to specify our element to request the focus

```smalltalk

elt := BlElement new background: Color purple;
    addEventHandlerOn: BlKeyboardEvent  do: [ :anEvent | anEvent inspect ];
    constraintsDo: [ :c | c horizontal matchParent. c vertical matchParent ];
requestFocus.
    
elt openInSpace
```

You can see with this example that the background of the element might change twice quickly, it's simply explained by the fact there is an event sent when a key is pressed and another when it is released so there's two events sent when quickly pressing a key.

## Reset a transformation

When applying a transformation to an object, its position doesn't change even if we translate it so the element might be displayed elsewhere than where it 'actually is', we can reset its transformation with this message `transformation: BlElementIdentityTransformation uniqueInstance` just like in this snippet:

```smalltalk
space := BlSpace new.
elt := BlElement new background: Color purple.

space root addChild: elt.
space show.

animation := (BlTransformAnimation translate: 250@250) duration: 2 seconds. 
elt addAnimation: (animation onFinishedDo: [ elt transformation: BlElementIdentityTransformation uniqueInstance ])
```

### To go further with animations

The most common animations are translations and rotations but as explained above, whenever we translate or rotate an object, its position doesn't change even if it does visually.

But this doesn't mean that nothing changes, in fact the origin of the "transform axis" moves with the transformation, meaning that if we apply a horizontal translation to an element that was previously rotated for example 90 degrees, then the element will visually translate vertically like in this example.

```st
elt := BlElement new background: Color purple.

t1 := (BlTransformAnimation translate: 150@0) duration: 2 seconds. 
t2 := (BlTransformAnimation translate: 150@0) duration: 2 seconds.
rotateAnimation := (BlTransformAnimation rotate: 90) duration: 2 seconds.

elt addAnimation: (t1 onFinishedDo: [ elt addAnimation: (rotateAnimation onFinishedDo: [ elt addAnimation: (t2 onFinishedDo: [ elt position inspect ]) ]) ]).

elt openInSpace.
```

And you will see that the position of the element hasn't changed and still is 0@0, but you can ask for `BlElement>>transformedBounds` to have the bounds of your element after its transformations if you need to exploit this visual position.

## Scale an image according to its parent extent 

This snippet shows how to deal with extent constraints when having a form as a background, here only in the case of matching parent both horizontally and vertically but this could be interesting to see when applying only one direction

```smalltalk
aForm := Smalltalk ui icons iconNamed: #pharoBig.
image := BlElement new
    background: aForm;
    size: aForm extent;
    yourself.
imageWrapper := BlElement new
    addChild: image;
    layout: BlLinearLayout horizontal;
    border: (BlBorder paint: Color green width: 3);
    constraintsDo: [ :c |
        c horizontal matchParent.
        c vertical matchParent ];
    addEventHandlerOn: BlElementExtentChangedEvent do: [ :evt |
        "Scale the wrapped element to "
        image transformDo: [ :builder |
            builder
                topLeftOrigin;
                scaleBy: evt target extent / aForm extent ] ];
    yourself.

imageWrapper openInSpace
```

"What could be interesting is look if we can apply this transformation directly to the background instead of adding a child with the image."

When trying the idea above we manage to do it using `Form>>scaledIntoFormOfSize:` but we can observe the form kept its aspect ratio, not giving the exact result as the previous snippet.

```st
aForm := Smalltalk ui icons iconNamed: #pharoBig.

imageWrapper := BlElement new
    background: aForm;
    layout: BlLinearLayout horizontal;
    border: (BlBorder paint: Color green width: 3);
    constraintsDo: [ :c |
        c horizontal matchParent.
        c vertical matchParent ];
    addEventHandlerOn: BlElementExtentChangedEvent do: [ :evt |
        imageWrapper background: (aForm scaledIntoFormOfSize: evt currentTarget extent) ];
    yourself.

imageWrapper openInSpace
```

## Enqueue tasks 

```smalltalk
a := BlElement new
    position: 50 @ 100;
    size: 100 asPoint;
    background: Color green;
    yourself.

a addAnimation: 
    (BlNumberTransition new
        from: 0;
        to: Float twoPi;
        duration: 5 seconds;
        onStepDo: [ :t |
            | offset |
            offset := (t cos * 50) @ (t sin * 50).
            a effect:
                (BlSimpleShadowEffect
                    color: Color blue
                    offset: offset) ];
        onFinishedDo: [
                | removeAction |
                removeAction :=
                    BlDelayedTaskAction new
                        delay: 2 seconds;
                        action: [ a removeFromParent ];
                        yourself.
                a enqueueTask: removeAction ];
        yourself).

a openInSpace
```

This snippet is an example of how to enqueue tasks and delay the time of the next instruction. This is also an example of a circular animation using an offset on a shadow effect

## Root Element is special

```smalltalk
a := BlElement new.
aSpace := BlSpace new.
aSpace root addChild: a.
aSpace root background: Color transparent.
aSpace extent: 200 asPoint; show.
	
wheel := Color wheel: 20.
[ 	wheel do: [ :eachColor |
		0.25 seconds wait.
		a position: (a position + 5 asPoint).
		a background: eachColor ] ] fork
```

When you set Color transparent as root's background, nothing clears the space

```smalltalk
a := BlElement new.
aSpace := BlSpace new.
aSpace root addChild: a.
aSpace root background: Color blue.
aSpace root size: 100 asPoint.
aSpace extent: 150 asPoint; show.
	
wheel := Color wheel: 20.
[ 	wheel do: [ :eachColor |
		0.25 seconds wait.
		a position: (a position + 5 asPoint).
		a background: eachColor ] ] fork.
```

"When you set an exact root size, only a portion of the space might be cleared between frames"

[Enzo] I keep this note here but I don't see any changes personally


## [TOPLO] Placing buttons inside a Notebook page 



```smalltalk
|book page|

book := ToNotebook new background: Color lightGreen.

page := book addPageTitle: 'page 1' bodyFactory: [ 
	|container|
	container := BlElement new layout: (BlGridLayout horizontal columnCount: 5; cellSpacing: 10).
	
	1 to: 10 do: [ :i |
		|stream|
		stream := String streamContents: [ :out | out nextPutAll: 'Button '; print: i ].
		container addChild: (ToButton new labelText: stream; constraintsDo: [ :c | c horizontal matchParent. c vertical matchParent ])
		 ].
	container ].

book openInSpace
```
To make our buttons take the whole space, we have to apply the matchParent constraint to each button and not to the container layout

## [TOPLO] Cool color gradient displayed in notebook

```smalltalk
notebook := ToNotebook new.

500 to: 3000 by: 500 do: [ :numberOfElements |
    | container grid scrollableGrid vscrollBar |
    container := BlElement new
        constraintsDo:[ :c | 
          c horizontal matchParent. 
          c vertical matchParent ];
        yourself.    

    grid := BlElement new 
      layout: 
        (BlGridLayout horizontal 
          columnCount: 10; 
          cellSpacing: 10); 
      constraintsDo: [ :c | 
        c horizontal fitContent. 
        c vertical fitContent ]; 
      yourself .

    (Color wheel: numberOfElements) do: [ :eachColor | 
      grid addChild: (BlElement new background: eachColor; yourself) ].
    scrollableGrid := grid asScrollableElement.
    vscrollBar := BlVerticalScrollbarElement new.
    vscrollBar constraintsDo: [ :c |
            c ignoreByLayout.
            c padding: (BlInsets right: 2).
            c ignored horizontal alignRight.
            c ignored vertical alignBottom ].
    vscrollBar attachTo: scrollableGrid .
    container addChildren: { scrollableGrid. vscrollBar }. 

    notebook addPageTitle: numberOfElements asString, ' elements' body: container ].

    
space := BlSpace new.
space root addChild: notebook.
space show
```

## Rotate a textElement in a parent

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

## Using a PullHandler to stay in bounds 

When dealing with drag and drop events you can use a PullHandler that does the work, you can even select the behavior to keep the child inside its parent's bounds with `BlPullHandler>>disallowOutOfBounds`

```smalltalk
hero := BlElement new
    geometry: BlCircleGeometry new;
    background: Color purple; 
    addEventHandler: (BlPullHandler new disallowOutOfBounds; yourself);
    yourself.

hero openInSpace.
```

## transform a Form into ByteString and vice versa

Starting from a ByteString (self), we can have a Form using this code:

```st
Form fromBinaryStream:
			  self base64Decoded asByteArray readStream
```

and starting from a Form, we can translate it into a ByteString using this code: 

```st
byteString := (ByteArray streamContents: [ :out |
	PNGReadWriter putForm: form onStream: out ]) base64Encoded.
```

It seems that doing the translation ByteString -> Form -> ByteString doesn't give the same ByteString between input/output but Form -> ByteString -> Form seems to work correctly (except maybe small changes invisible to the human eye).

Also here we use `PNGReadWriter` but other subclasses of `ImageReadWriter` can be used depending on the format you want to save

try this:

```st
String streamContents: [:s | self storeOn: s]
```

```st
OpalCompiler new
	source: self;
	evaluate 
```
```st
Object readFrom: byteString
```

## need to define outskirts to have round cap/join border 

```st
elt := BlElement new background: Color lightGray; size: 100 asPoint; position: 50 asPoint.
	
elt geometry: BlTriangleGeometry new.
	
elt border: (BlBorder builder paint: Color black; width: 10; capRound; joinRound ; build).

elt outskirts: BlOutskirts centered.

elt openInSpace
```

In this example the border does not have cap/join round if the `outskirts:` message is commented.

[Enzo] I don't know the meaning of the outskirts but it is weird sending `capRound`, `joinRound` to the border is not enough

## Example of curved arrow 

This arrow is created using an annulus sector and a polyline geometry. This polyline geometry is used (instead of a polygon geometry) to give the impression of a single element when applying a border.

This polyline geometry displays the background of the element in between the lines but when adding a click event handler, only clicking the lines work as if the element is "empty".

For this examples, the polyline geometry is placed and rotated manually which isn't really pretty for the code but we get the result expected.

Note that you can flip the arrow by applying `flipX` and `flipY` to the container transform.

```st
	| annulus arrow border container |
	border := BlBorder paint: Color lightGray width: 2.
	annulus := BlElement new
		           background: Color lightGreen;
		           size: 100 asPoint;
		           geometry: (BlAnnulusSectorGeometry new
				            startAngle: 45;
				            endAngle: 135;
				            innerRadius: 0.6;
				            outerRadius: 0.95);
		           border: border.

	arrow := BlElement new
		         background: Color lightGreen;
		         geometry: (BlPolylineGeometry vertices: {
						          (12 @ 20).
						          (0 @ 20).
						          (20 @ 0).
						          (40 @ 20).
						          (28 @ 20) });
		         border: border.

	arrow position: 50 @ 62.
	arrow transformDo: [ :t | t rotateBy: 45 ].


	container := BlElement new size: 100 asPoint.

	container addChild: annulus.
	container addChild: arrow.

	container childrenDo: [ :each |
		each addEventHandlerOn: BlClickEvent do: [ each inspect ] ].

	container openInSpace.
	^ container
```

## Show trajectories of corner with rotation animation 

This snippet was written to prove the rotation animation didn't have the right feeling, by showing the trajectories of each corner of a totating square. By default, people expect each corner to draw a circle when the square is fully rotated but here we can see it is not the case.

This might be an issue with the calcutation of the transform matrix when the rotation is applied

```smalltalk
container := BlElement new background: Color veryVeryLightGray; size: 500 asPoint.

parent := BlElement new background: Color veryLightGray; size: 100 asPoint; position: 200 asPoint.

elt1 := BlElement new background: Color red; size: 1 asPoint.
elt2 := BlElement new background: Color blue; size: 1 asPoint; position: 99 @ 0.
elt3 := BlElement new background: Color green; size: 1 asPoint; position: 0 @ 99.
elt4 := BlElement new background: Color yellow; size: 1 asPoint; position: 99 @ 99.

parent addChildren: { elt1. elt2. elt3. elt4 }.

container addChild: parent.

elt1Trajectory := OrderedCollection new add: 200 @ 200; yourself.
elt2Trajectory := OrderedCollection new add: 299 @ 200; yourself.
elt3Trajectory := OrderedCollection new add: 200 @ 299; yourself.
elt4Trajectory := OrderedCollection new add: 299 @ 299; yourself.

anim := (BlTransformAnimation rotate: 90) duration: 2 seconds.
anim addEventHandlerOn: BlAnimationStepEvent do: [ elt1Trajectory add: elt1 positionInSpace. 
	elt2Trajectory add: elt2 positionInSpace.
	elt3Trajectory add: elt3 positionInSpace.
	elt4Trajectory add: elt4 positionInSpace.].

parent addEventHandlerOn: BlClickEvent do: [ parent addAnimation: anim copy. ].

container openInSpace.

elt1TrajectoryElt := BlElement new background: Color transparent; geometry: (BlPolylineGeometry vertices: elt1Trajectory); border: (BlBorder paint: Color red width: 5) .
elt2TrajectoryElt := BlElement new background: Color transparent; geometry: (BlPolylineGeometry vertices: elt2Trajectory); border: (BlBorder paint: Color blue width: 5).
elt3TrajectoryElt := BlElement new background: Color transparent; geometry: (BlPolylineGeometry vertices: elt3Trajectory); border: (BlBorder paint: Color green width: 5).
elt4TrajectoryElt := BlElement new background: Color transparent; geometry: (BlPolylineGeometry vertices: elt4Trajectory); border: (BlBorder paint: Color yellow width: 5).

container addChildren: { elt1TrajectoryElt. elt2TrajectoryElt.elt3TrajectoryElt.elt4TrajectoryElt.}.
```