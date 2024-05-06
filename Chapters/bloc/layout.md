## Layouts in Bloc

### Introduction

Widgets aren't just simple components; they're complex assemblies of various
elements. To create more intricate Bloc elements, you'll need to blend them
together seamlessly. Each element can be developed and examined independently,
which is advantageous during the development phase.  However, to construct a
complete graphical interface, you'll need to seamlessly integrate these elements
with each other or, at the very least, place them within a Bloc *space*.

Element in a Bloc scene are added to each other, ending in a tree-like structure
where parents and children can identify each other, and each element is an
instance of `BlElement`, the root element of Bloc. Each element has its own
visual properties, like background, border, geometry, etc. The final appearance
depends on the graphical properties of each element and how they're arranged
together in the layout.

![Multiple elements.](figures/multipleElements.png width=70)


### Parent children

Elements can be added in the element tree of an element with the `addChild:` method. You can add multiple elements at once 
with `addChildren:`. You can of course remove sub-element with `removeChild:` and `removeChildren:` methods.

Browse `BlElement` to find all the available methods
to manage the addition and removal of the elements composing your element.

![Element tree.](figures/blelementtreestructure.png width=80)



Layouts constitute a fundamental aspect of *Bloc*. Rather than constructing your
entire widget within a single *drawing* method, it advocates for the creation of
small elements with distinct geometries and visual attributes, which are then
integrated using diverse layout strategies. The layout property determines the
visual arrangement of the element and its descendants, specifying their
positions and sizes within the parent container. Moreover, it may influence the
dimensions of the parent element itself.

When defining layout, two parts must be combined to play together: *parent* and *children* elements.

- Parents define which layout strategy to apply to their children.
- Children specify which constraints they will follow, which could impact their position and size.

Layouts are defined by their *type* and their *constraints*. Types are usually
defined at the parent level with the `layout` method, while you can specify
constraints to your child element using the `constraintsDo:` message, which
supports a set of attributes that define the visual properties of the layout. A
small set of constraints, like padding, margin or minimal and maximum
dimensions, are common among all the layouts. Constraints allow you to clearly
define the size and the position of your element within its parent.

When you change the position or the size of an element, a `requestLayout` is sent
but the effect on the element’s bounds is actually visible only after the layout
is computed. In Bloc, the layout is computed from a dedicated space Phase,
applied on each pulse. Have a look at `BlSpaceFrame` and `BlSpaceFramePhase` and its
subclasses.

To ease this kind of script one can use `whenLayoutedDoOnce:` which arms a one
shot event handler that reacts to the `BlElementLayoutComputedEvent` event.





### Space around elements

Before jumping on the definition of the position of each element, you can already
define how close your elements will be from each other, with those 2 properties

- `padding:` space between the element and its children.
- `margin:` space between the element and its parent

Constraints can apply to margin and padding as well.
Here is a typical constraint expression: 

```
element constraintsDo: [ :c | c margin: (BlInsets all: 10) ]
```

```smalltalk
container := BlElement new
	"no dynamic constraints, we specify element size"
	size: 400 @ 400;
	border: (BlBorder paint: Color red width: 1);
	background: (Color red alpha: 0.2);
	layout: BlFlowLayout horizontal alignCenter.

element := BlElement new
	border: (BlBorder paint: Color blue width: 1);
	background: (Color blue alpha: 0.2);
	margin: (BlInsets all: 15);
	padding: (BlInsets all: 35);
	"element has a child, specify its layoutSpec: "
	layout: BlFlowLayout horizontal alignCenter;
	"dynamic size computed relatively to its parent"
	constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
container addChild: element.

child := BlElement new
	border: (BlBorder paint: Color yellow width: 1);
	background: (Color yellow alpha: 0.2);
	"dynamic size computed relatively to its parent"
	constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
element addChild: child.
```

In Figure *@padding1@*, we have 3 elements on top of each other. The purple one
has a margin of 15 pixels with the red one and a padding of 35 pixels with the
yellow one.

![Margin and padding example.](figures/marginAndPadding.png width=25&label=padding1)

Margin and padding can be applied to all insets for your figures, but need to
be adapted to your element geometry. The same example but using triangle
geometry shows you the difference (See Figure *@padding2@*).

![Margin and padding example 2.](figures/marginAndPaddingwithtriangle.png width=25&label=padding2)

### Element size

Size can be determined **statically** or **dynamically**.
Attention, if you don't use dynamic size, you **must** define it using the message `size:`. 

The overall bounds of an element are not deduced from its geometry, and its default size
will be `50@50`, which will certainly be different from *your* own element.

#### Statically.
If you use the message `size:`, the size of the element will be static.
Note that the expression `element size: aPoint` is a synonym for

```smalltalk
constraintsDo: [ :c |
	c horizontal exact: aPoint x.
	c vertical exact: aPoint y ];
```

#### Dynamically.
If you use the constraints `matchParent` or `fitContent` in a child definition, the size of the element will be computed dynamically, dependent on its parent constraints and child space.

- `matchParent` -- child size will fill the space left available in parent element.
- `fitContent` --  parent size will depend on the space used by its children.

```smalltalk
constraintsDo: [ :c |
	c horizontal matchParent.
	c vertical fitContent ];
```

**Beware to not mix those properties** between parent and child.
If your child tries to match its parent, while its parent tries to fit its child's
content, the size will be 0 plus the border width.

When the parent uses "fit content" and the child uses "match parent", there is
no way to determine the size. In such cases, the size of both the parent and
the child will be 0@0.


### Layout strategy and constraints

A layout defines the way children are positioned inside their parent element. This
position is deduced from the layout strategy used. If you don't specify which
layout your parent element will use, it'll default to `BlBasicLayout` strategy.

You can add an element with `addChild:` and it will be placed according to the
the specified layout .

Here is the list of layouts available by default

* `BlBasicLayout`
* `BlLinearLayout`
* `BlFlowLayout`
* `BlGridLayout`
* `BlFrameLayout`
* `BlZoomLayout`
* `BlProportionalLayout`

The list of all layouts available: `BlLayout allSubclasses`

Each layout has a dedicated constraint object, an instance of
`BlLayoutCommonConstraints` which contains layout universal constraints.
Constraints are associated with the layout defined by the parent element.
Each type of layout can further define its own specific constraints by creating
a subclass of `BlLayoutConstraints`.

For example
- when a parent element uses the layout type `BlLinearLayout`
- its children constraints are detailed by `BlLinearLayoutConstraints`.

#### Defining constraints. 

You can define constraints at the parent element level when specifying layout
type. For example`layout: BlLinearLayout horizontal alignCenter;`

or you can refine its constraints in its children
`constraintsDo: [ :c | c linear horizontal alignCenter. ]`

The first option lets you define position constraints that apply to all children,
and is a good fit for *flow layout* or *linear layout*. For layouts that have a
limited number of children, such as *frame layout*, it's better to let the children decide
their position constraints. You'll find some example below.

### Ignoring or interacting with parent layout

You can ignore the layout defined by the parent using `ignoreLayout`. When you
use this constraint, your element will be removed from parent layout rules,
and follow *BlBasicLayout* instead, meaning you can place your element at
arbitrary position within your parent element.

```smalltalk
	constraintsDo: [ :c | c ignoreByLayout ].
```

You can also interact with parent layout constraint using `flow`, `frame`,
`grid`, `linear`, or `relative` messages. 

In the example below, the second element will use all the space of its parent, and manage the position of its children
using `BlFrameLayout` strategy. The first element, which could act as a
container for other sub-elements, apply `BlLinearLayout` strategy, but positions
itself on its parent using the *frame* constraint.

```smalltalk
first := BlElement new	layout: BlLinearLayout horizontal alignCenter;	background:  Color red;	constraintsDo: [ :c |		c vertical fitContent.		c horizontal fitContent.		c frame horizontal alignCenter.		c frame vertical alignCenter ].second := BlElement new	background:  Color blue;	layout: BlFrameLayout new;	constraintsDo: [ :c |		c vertical matchParent.		c horizontal matchParent ];	addChild: first.second openInSpace
```
SD: I do not see it. 



### Example

This define sa new element, where children will be positioned using linear
layout strategy, and whose side will match space available in parent element.
(see Figure *@matchplinear@*).

```smalltalk
e := BlElement new.e	layout: BlLinearLayout horizontal alignCenter;	background: Color green;	constraintsDo: [ :c |		c horizontal matchParent.		c vertical matchParent ].e2 := BlElement new.e2 background: Color red.e addChild: e2.e3 := BlElement new.e3 background: Color white.e addChild: e3.e openInSpace
```

![A parent matching its parent and its children managed linearly.](figures/matchplinear.png width=40&label=matchplinear)

### Default layout: basicLayout

If your parent doesn't define any specific layout, it will default to `BlBasicLayout`.
Using this layout, children can position themselves at arbitrary positions within
the parent coordinate space using the message `position:`.

```
BlElement new position: 50@50.
```

`BlBasicLayout` lets you position your children at the position you want them to
be. Layout constraints are irrelevant for this layout, you should specify the size
of each child element to be added. Those children can them implement their own
layout strategy.

#### Example
The following example shows how you can position children at given positions (see Figure *@defaultlayout@*).

```smalltalk
root := BlElement new
	border: (BlBorder paint: Color red width: 1);
	background: (Color red alpha: 0.2);
	"not necessary, except as reminder, this is the default layout"
	  "layout: BlBasicLayout new;"
	constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

elt1 := BlElement new
	border: (BlBorder paint: Color blue width: 1);
	size: 40 @ 80;
	background: (Color blue alpha: 0.2);
	position: 50 @ 40.
elt2 := BlElement new
	border: (BlBorder paint: Color yellow width: 1);
	size: 40 @ 80;
	background: (Color yellow alpha: 0.2);
	position: 60 @ 60.

	root addChildren: { elt1 . elt2 }
```

![Basic layout.](figures/basiclayout.png width=40&label=defaultlayout)


Stef should continue down here.


### Linear layout - BlLinearLayout

Children can use dynamic size with constraints. The number of element will then fit
its parents available space.	 If you specify their size, and the total is
over its parents, they will be hidden. need to specify their size. If they use
constraint, the last one will hide previous one. They will fit available space +
move to next line if necessary

#### Parent definition

- horizontal
- vertical

#### Child constraints

- horizontal
- alignCenter
- alignLeft
- alignRight
- vertical
- alignBottom
- alignCenter
- alignTop

#### Example

```smalltalk
root := BlElement new
	border: (BlBorder paint: Color red width: 1);
	background: (Color red alpha: 0.2);
	layout: BlLinearLayout horizontal ;
	  constraintsDo: [ :c |
		c horizontal fitContent.
		c vertical fitContent ].
	
	50 timesRepeat:  [  |elt| elt := BlElement new border: (BlBorder paint: Color blue width: 1);
		size: 40@80;
	   background: (Color blue alpha: 0.2);
	   margin: (BlInsets all: 5);
	   padding: (BlInsets all: 5).

			root addChild: elt. ].
```

![Linear layout.](figures/linearlayout.png width=70)

### Flow layout - BlFlowLayout

Children need to specify their size. If they use constraint, the last one will hide
previous one. They will fit available space + move to next line if necessary.
Flow will fill all available space in its parent, and parent can be resized to
match the space needed to display all its children.

#### Parent definition

- horizontal
- vertical

#### Child constraints

- horizontal
- alignCenter
- alignLeft
- alignRight
- vertical
- alignBottom
- alignCenter
- alignTop

#### Example

```smalltalk
root := BlElement new
	border: (BlBorder paint: Color red width: 1);
	background: (Color red alpha: 0.2);
	layout: BlFlowLayout horizontal;
	constraintsDo: [ :c |
		c horizontal matchParent .
		c vertical fitContent  ].

50 timesRepeat: [
	| elt |
	elt := BlElement new
	size: 40 @ 80;
	border: (BlBorder paint: Color blue width: 1);
	background: (Color blue alpha: 0.2);
	margin: (BlInsets all: 5).
	root addChild: elt ].
```

![Flow layout.](figures/flowlayout.png width=70)

### Grid layout - BlGridLayout

Elements are disposed in a grid. An element can span over multiple rows or columns.

All children of an element with GridLayout must use GridConstraints that allows
users to configure how children are located within grid independently.

A grid consists of cells that are separated by invisible lines. Each line is
assigned to an index, meaning that a grid with N columns would have N+1 line.
Indices lie in closed interval [ 1, N + 1 ].

Grid Layout supports fitContent, matchParent and exact resizing mode of the
owner. Children are allowed to have fitContent and exact resizing modes. Because
child's matchParent does not make sense in case of grid users should use #fill
to declare that child should take all available cell's space.

By default grid layout does not specify how many columns and rows exist, instead
it tries to compute necessary amount of columns or rows depending on amount of
children. User can specify amount of columns or rows by sending `columnCount:` or
`rowCount:` to an instance of grid layout.

Grid Layout supports spacing between cells which can be set sending `cellSpacing:`
message.

##### Public API and Key Messages
 
* `columnCount: aNumber` specifies the amount of columns.
* `rowCount:** aNumber` specifies the amount of rows.
* `cellSpacing: aNumber` to specifies spacing between cells.
* `alignMargins` bounds of each element are extended outwards, according to their margins, before the edges of the resulting rectangle are aligned.
* `alignBounds`  alignment is made between the edges of each component's raw bounds.

##### Example

```smalltalk
	e1 := BlElement new
	constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ];
	 background: (Color red alpha: 0.2);
	 border: (BlBorder paint: Color red width: 1).

	e2 := BlElement new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ];
	 background: (Color yellow alpha: 0.2);
	 border: (BlBorder paint: Color yellow width: 1).
	e3 := BlElement new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ];
		background: (Color blue alpha: 0.2);
		border: (BlBorder paint: Color blue width: 1).

	e4 := BlElement new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ];
		background: (Color green alpha: 0.2);
		margin: (BlInsets all: 5);
		border: (BlBorder paint: Color green width: 1).

	e5 := BlElement new
		constraintsDo: [ :c |
		c horizontal matchParent.
			c vertical matchParent.
			c grid horizontal span: 4 ];
		background: (Color purple alpha: 0.2);
		border: (BlBorder paint: Color purple width: 1).

	container := BlElement new
		layout: (BlGridLayout new
			columnCount: 4;
			cellSpacing: 10);
		background: Color veryLightGray;
		border: (BlBorder paint: Color gray width: 3);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ];
		 addChildren: {e1 . e2 . e3 . e4 . e5 };
		 yourself.
```

![Grid layout.](figures/gridlayout.png width=70)


### Grid span 

Inside a GridLayout, children do not especially share the same size but they all by default share the same span which means they occupy a single cell of the layout (ie horizontal span = vertical span = 1).

You can change this parameter so your element takes a certain amount of cells.

It is possible to add a child with a larger span and still add smaller elements into the grid layout and fill the space the bigger child left. 

```st
grid := BlElement new 
	size: 400 asPoint; 
	layout: (BlGridLayout horizontal columnCount: 4).

children := (1 to: 12) collect: [ :i | BlElement new background: Color lightGreen; border: (BlBorder paint: Color black width: 1) ].

square := BlElement new 
	background: Color purple; 
	size: 100 asPoint.
square constraintsDo: [ :c | 
	c grid horizontal span: 2. 
	c grid vertical span: 2 ].
	
1 to: 5 do: [ :i | grid addChild: (children at: i) ].
grid addChild: square.
6 to: 12 do: [ :i | grid addChild: (children at: i) ].

grid openInSpace.
```

![Grid Layout span example.](figures/gridLayout_SpanExample.png width=35&label=gridspan1)

This snippet creates a 4x4 grid and adds a 2x2 purple square in the middle (See Figure *@gridspan1@*). 

We can see that after adding the first five green squares, we add the purple square but we can wonder how the grid layout will display other children added afterwards, here we can see that it fills the blank space as if the grid cells were taken by the purple square didn't exist.

On the example, we can add the notion of visibility on children.

In Bloc, the visibility is an attribute that lets us display or not an element. However, when hiding an element, we have two options : `BlVisibilityHidden` and `BlVisibilityGone`.

Let's start with BlVisibilityGone, it simply removes the element from the drawing phase but it also makes the element ignored in the layouting phase. In this example if we apply a BlVisibilityGone to the first little green square, the purple square gets moved to the left and every element gets a new place (see Figure *@gone@*).

```st
removed := children first.
removed visibility: BlVisibilityGone new
```

![Grid Layout span example - visibility gone](figures/gridLayout_SpanExampleGone.png width=35&label=gone)

`BlVisibilityHidden` just hides the element and doesn't display it with the new drawing phase, but the element is still present and can interact. With this visibility, we see the blank space left by the element and we can inspect it when clicking on this blank space when adding an event handler (see Figure *@hidden@*).

```st
removed addEventHandlerOn: BlClickEvent do: [ removed inspect ].
removed visibility: BlVisibilityHidden new.
```

![Grid Layout span example - visibility hidden](figures/gridLayout_SpanExampleHidden.png width=35&label=hidden)

Note: we can make the element disappear with BlVisibilityGone and then apply a hidden visibility and the element will get its layouting properties back because the element was not "removed from existence", just gone from layouting phase.

### Frame Layout

Frame layout preferred usage contains only one child. It gives more dynamic
control than `BlBasicLayout` which only allows fixed position. It can however
contain multiple children.

The alignment attribute controls the position of children within a FrameLayout.
Children can be aligned both vertically and horizontally as follows:

- horizontally children can be aligned to the left, center, or right;
- vertically children can be aligned to the top, center, or bottom.

Alignment is a constraint specific to frame layouts, as it's not relevant to
all layouts. To access frame-specific constraints, we send *frame* to the current
constraint object, which returns an instance of `BlFrameLayoutConstraints` that
we can use to set the desired alignment. Other constraints like the size of an
element are common to all layouts and can be set directly without requesting a
specific constraint object.

When using multiple children, if we do not specify any alignment they will be
placed in the top-left corner in the order in which they were added to the
parent and they will overlap each other.

#### Parent definition

`BlFrameLayout new`

- align:horizontal
- align:vertical

*TODO* Check class `BlElementAlignment` and `weight:` message

#### Children constraints

- horizontal
- alignCenter
- alignLeft
- alignRight
- alignCenterAt:
- alignLeftAt:
- alignRightAt:
- alignNone

- vertical
- alignBottom
- alignCenter
- alignTop
- alignBottomAt:
- alignCenterAt:
- alignTopAt:
- alignNone

#### Example: One children

```smalltalk
container := BlElement new
		 background: (Color red alpha: 0.2);
		 border: (BlBorder paint: Color red width: 1);
		 layout: BlFrameLayout new;
		 constraintsDo: [ :c |
			 c horizontal matchParent.
			 c vertical matchParent ].

child := BlElement new
	 size: 400 @ 400;
	 clipChildren: false;
	 background: (Color blue alpha: 0.2);
	 border: (BlBorder paint: Color blue width: 1);
	 constraintsDo: [ :c |
		 c frame horizontal alignCenter.
		 c frame vertical alignCenter ].

container addChild: child.
```

![Frame layout.](figures/framelayout.png width=50)

#### Example: multiple children

A frame can also accept multiple children.

Multiple children are positioned with size defined by weight. In this case, children
that match their parents can also be configured to occupy only a fraction of
the parent's size using the weight attribute. A child can match its parent both
horizontally and vertically. If no padding or margin is used, the child will
overlap the parent completely.

```smalltalk
| root elt1 elt2 elt3 elt4 elt5 elt6 elt7 elt8 elt9 |
root := BlElement new
	border: (BlBorder paint: Color red width: 1);
	background: (Color red alpha: 0.2);
	layout: BlFrameLayout new;
	constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

"weight can only be used if the size, or if fitContent are not specified"
elt1 := BlElement new
	border: (BlBorder paint: Color blue width: 1);
	background: Color random;
	margin: (BlInsets all: 5);
	constraintsDo: [ :c |
		c frame horizontal alignLeft weight: 0.2.
		c frame vertical alignTop weight: 0.2.
	c horizontal matchParent.
	c vertical matchParent ];
	addChild: (BlTextElement new text: 'left top' asRopedText).
root addChild: elt1.

"...code continue for the 8 other children"
```

![Frame layout.](figures/MultipleElementFrameWithWeight.png width=80)

#### Example: multiple children
Multiple children positioned with fixed size.

```smalltalk
| root elt1 elt2 elt3 elt4 elt5 elt6 elt7 elt8 elt9 |
root := BlElement new
	border: (BlBorder paint: Color red width: 1);
	background: (Color red alpha: 0.2);
	layout: BlFrameLayout new;
	constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

elt1 := BlElement new
		size: 80 @ 80;
		border: (BlBorder paint: Color blue width: 1);
		background: Color random;
		margin: (BlInsets all: 5);
		constraintsDo: [ :c |
			c frame horizontal alignLeft.
			c frame vertical alignTop ];
		addChild: (BlTextElement new text: 'left top' asRopedText).
root addChild: elt1.

"...code continue for the 8 other children"
```

![Frame layout](figures/MultipleElementFrameWithFixedSize.png)

### Zoom layout

A layout where child elements can be zoomed into their parent.

#### Example

```Smalltalk
| elt zoom |
elt := BlSvgIcons settingsIcon.
elt
	border: (BlBorder paint: Color red width: 2);
	background: Color yellow;
	size: 24@24;
	transformDo: [ :t | t scaleBy: 2 ];
	constraintsDo: [ :c |
		c accountTransformation ].

zoom := BlElement new
	background: Color white;
	border: (BlBorder paint: Color gray width: 10);
	geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
	padding: (BlInsets all: 10);
	layout: (BlZoomableLayout new
		addLayout: BlFrameLayout new;
		defaultScale: 5;
		animationDuration: 2 second);
	constraintsDo: [ :c |
		c vertical fitContent.
		c horizontal fitContent ];
	addChild: elt;
	yourself.
zoom openInNewSpace 
```

#### Example

```smalltalk
elt := BlElement new
	size: 200@200;
	  background: (Color blue alpha: 0.2);
	  border: (BlBorder paint: Color blue width: 1);
		constraintsDo: [ :c | c accountTransformation ].

container := BlElement new
	 background: Color white;
	 border: (BlBorder paint: Color gray width: 1);
	 geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
	 padding: (BlInsets
		 top: 10
		 left: 10
		 bottom: 10
		 right: 10);
	layout: (BlZoomableLayout new
		 addLayout: BlFrameLayout new;
		 defaultScale: 2;
		 animationDuration: 1 second);
	 constraintsDo: [ :c |
		c vertical fitContent.
		c horizontal fitContent ];
		addChild: elt;
		yourself.
```

As this example is dynamic, it's better if you look at the example or try this
code directly into Pharo. As a screenshot couldn't render it properly.

### Proportional layout

layout that determines the position and extent of each child of an element by
taking into account fractions defined in the constraints.

#### parent definition

`BlProportionalLayout new`

#### children constraints

* horizontal
- left
- right

* vertical
- bottom
- top

#### example

```smalltalk
| aContainer childA childB |
childA := BlElement new
	id: #childA;
	background: Color red;
	constraintsDo: [ :c |
		c proportional horizontal rightFraction: 0.5 ];
	yourself.

childB := BlElement new
	id: #childB;
	background: Color green;
	constraintsDo: [ :c |
		c proportional horizontal leftFraction: 0.5 ];
	yourself.

aContainer := BlElement new
	id: #container;
	background: Color blue;
	layout: BlProportionalLayout new;
	size: 100 @ 100;
	addChild: childA;
	addChild: childB;
	constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ];
	padding: (BlInsets all: 5);
	yourself.

aContainer openInNewSpace.
```
