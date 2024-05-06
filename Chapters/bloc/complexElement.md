## How to create an advanced element in Bloc

With Bloc, we have low-level tools to define custom graphical elements. This time,
we'll combine element together to create a more complex element that'll serve
as a base for a widget in Toplo

Defining our own widget is quite easy. We'll guide you steps by steps.

Inspiration taken from Gtk2 widget creation example with a clock
https://thegnomejournal.wordpress.com/2005/12/02/writing-a-widget-using-cairo-and-gtk2-8/
https://thegnomejournal.wordpress.com/2006/02/16/writing-a-widget-using-cairo-and-gtk2-8-part-2/

In the end, it'll look like:
![clock](figures/clockAction.png width=60&label=fig:clock)

### create your element

Your element is a `BlElement`, and as such, is defined as a subclass

```smalltalk
BlElement << #BlClock
	slots: { #hourNeedle . #minutesNeedle . #secondNeedle . #center . #radius . #hourNeedleSize . #minuteNeedleSize . #secondNeedleSize };
	tag: 'Clock';
	package: 'BookletGraphics'
```

You can already define its global appearance, like background, border, geometry.

Add those method to your newly created element.

```smalltalk
BlClock >> background
	^ BlBackground  paint: Color lightGray
```

```smalltalk
BlClock >> border
	^ BlBorder paint: Color black width: 4
```

```smalltalk
BlClock >> geometry
	^ BlCircleGeometry new matchExtent: self extent.
```

We'll give our clock a default size

```smalltalk
BlClock >> size: aPoint
	super size: aPoint.

	radius := aPoint x / 2.
	self initClock.
```

It should be nice if we can have small tick around the frame to display hour marks
```smalltalk
BlClock >> initClockFrame
	"draw small lines around clock frame"

	| quarterLength quarterWidth hourLength hourWidth |
	quarterLength := radius * 4.8 /20.
	quarterWidth := 8.
	hourLength := radius * 3.2 /20.
	hourWidth := 6.

	0 to: 11 do: [ :items |
		| coordinate angle |
		angle := items * Float pi / 6.
		coordinate := angle cos @ angle sin.

		items % 3 == 0
			ifTrue: [ "quarter mark"
				self addChild: (BlElement new
						 geometry: (BlLineGeometry
								  from: center + (coordinate * (radius - quarterLength))
								  to: center + (coordinate * radius));
						 outskirts: BlOutskirts centered;
						 border: (BlBorder paint: Color black width: quarterWidth)) ]
			ifFalse: [ "other hour marks"
				self addChild: (BlElement new
						 geometry: (BlLineGeometry
								  from: center + (coordinate * (radius - hourLength))
								  to: center + (coordinate * radius));
						 outskirts: BlOutskirts centered;
						 border: (BlBorder paint: Color black width: hourWidth)) ] ]
```

You'll also needs some needles to display the time

```smalltalk
BlClock >> initElements

	hourNeedle := BlElement new
		              id: #hourNeedle;
		              geometry: BlLineGeometry new;
		              outskirts: BlOutskirts centered;
		              border: (BlBorder paint: Color black width: 5).

	minutesNeedle := BlElement new
		                 id: #minuteNeedle;
		                 geometry: BlLineGeometry new;
		                 outskirts: BlOutskirts centered;
		                 border: (BlBorder paint: Color black width: 5).

	secondNeedle := BlElement new
		                id: #secondNeedle;
		                geometry: BlLineGeometry new;
		                outskirts: BlOutskirts centered;
		                border: (BlBorder paint: Color red width: 3).

	self addChildren: {
			hourNeedle.
			minutesNeedle.
			secondNeedle }
```

You will noticed that the size of the element is not specified. We'll come back
on this, but for now, you can already define the ratio between elements

```smalltalk
BlClock >> initConstant

	center := radius @ radius.
	hourNeedleSize := radius / 2.
	minuteNeedleSize := radius * 14.8 / 20.
	secondNeedleSize := radius * 16.8 / 20
```

### Define a model

This step may be optional, but since our widget will hold a state, we should
have one.

Model members:

- hour
- minute
- seconds  

Remember your trigonometry classroom ? Clock run, well, clockwise, and is
measured from the top while angle are usually measured counter-clockwise and
from the right. Here is how you can do the conversion for minutes and seconds.

![clock measure.](figures/clockMeasure.png width=60&label=fig:clock measure)

Given a specific time, the coordinates are computed as:

```smalltalk
BlClock >> hourCoordinate: time

	| angleHours y angleTime  angleMinutes x |
	angleHours := Float pi / 6 * time hours.
	angleMinutes := Float pi / 360 * time minutes.
	angleTime := angleHours + angleMinutes.

	x := angleTime sin.
	y := angleTime cos * -1.

	^ 	x @ y.
```

```smalltalk
BlClock >> minuteCoordinate: minutes

	| x y angle |
	angle := Float pi / 30 * minutes.
	x := angle sin.
	y := angle cos * -1.
	^ x @ y.
```

```smalltalk
BlClock >> secondCoordinate: seconds

	| x y angle  |
	angle := Float pi / 30 * seconds.
	x := angle sin.
	y := angle cos * -1.
	^ x @ y.
```

### Positioning our element

For a given time, once we have the coordinates, we can display our needles

```smalltalk
BlClock >> updateNeedlesPosition: time

	self updateHourNeedlePosition: time.
	self updateMinuteNeedlePosition: time minutes.
	self updateSecondNeedlePosition: time seconds.
```

Here is the detail for each needle

```smalltalk
BlClock >> updateHourNeedlePosition: time
	| coordinate |
	coordinate := self hourCoordinate: time.
	hourNeedle geometry from: center to: center + (coordinate * hourNeedleSize).
```

```smalltalk
BlClock >> updateMinuteNeedlePosition: minutes
	| coordinate |
	coordinate := self minuteCoordinate: minutes.
	minutesNeedle geometry from: center to: center + (coordinate * minuteNeedleSize)
```

```smalltalk
BlClock >> updateSecondNeedlePosition: seconds
	| coordinate |
	coordinate := self secondCoordinate: seconds.
	secondNeedle geometry
		from: center
		to: center + (coordinate * secondNeedleSize)
```

### Handling animation and resize

Remember from layout chapter, size can be fixed, or dynamic, dependent of its 
parent. We want our clock to manage both case.

If the `extent` of our element change, we can to get informed through an event.
We can then decide to resize our element.

```smalltalk
BlClock >> initialize

	super initialize.
	self
		addEventHandlerOn: BlElementExtentChangedEvent
		do: [ :e | self resize ]
```

The resize method will then ensure we still have the correct value for our clock

```smalltalk
BlClock >> resize
	radius := self extent min / 2.0.
	self initClock
```

initClock is defined as

```smalltalk
BlClock >> initClock
	self removeChildren.

	self initConstant.
	self initClockFrame.
	self initElements.
	self initAnimation
```

You'll notice the call to removeChildren. The clock frame is itself defined
as a collection of BlElement. In our case, it's easier to remove and recreate them
than handling each element one by one. 

Our clock is still static. We need to update it so it reflect the current time.
This is done through

```smalltalk
BlClock >> initAnimation
	| animation |
	animation := BlAnimation new
		             beInfinite;
		             duration: 0.5 seconds.

	animation addEventHandler: (BlEventHandler
			 on: BlAnimationLoopDoneEvent
			 do: [ :anEvent |
				 self updateNeedlesPosition: Time now.
				 self invalidate ]).

	self addAnimation: animation
```

### open and display your clock

Your clock is now ready to show up in space. You can either specify it size
statically, or let it depend of its parent element.

#### fixed size

```smalltalk
	| clock container |
	container := BlElement new
		             border: (BlBorder paint: Color red width: 1);
		             background: Color white;
		             layout: BlFrameLayout new;
		             constraintsDo: [ :c |
			             c horizontal fitContent.
			             c vertical fitContent ].

	clock := self new size: 300 @ 300.
	container addChild: clock.
	container openInNewSpace.
```

#### dynamic layout

```smalltalk
	| clock space |
	space := BlSpace new.

	space root
		border: (BlBorder paint: Color red width: 1);
		background: Color white;
		layout: BlFlowLayout horizontal.

	clock := self new constraintsDo: [ :c |
		         c horizontal matchParent.
		         c vertical matchParent ].

	space root addChild: clock.
	space show.
```