# Layout

define the visual structure of that bloc element. Typically this includes the 
position of child elements within the parent, or the size of the parent element.

BlElement can be combined in a tree-like structure. How all these will end up
showing depend of the graphical statement of each element, and how all of them
are layout together.

## Example
```smalltalk
	BlElement new
	layout: BlLinearLayout horizontal alignCenter;
	constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
```			

## space around elements:
* padding
* margin

Margin: space between the element and its parent
Padding: space between the element and its children.

```
BlElement new
	 margin: (BlInsets all: 3);
	 padding: (BlInsets all: 3);
```				 

## Layout
Layout define the way children appear inside their parent element. A small list
of layout included in Pharo Image. 

 * BlLinearLayout
 * BlGridLayout
 * BlFlowLayout
 * BlProportionalLayout

List of all layout available: `BlLayout allSubclasses`

It's defined in the parent element and will determined who children are position
when they are added to it.

If you don't define a layout, it'll default to *BlBasicLayout*

### forcing position
If your parent don't define any specific layout, it will default to *BlBasicLayout*.
Using this layout, children can position themselves at arbitrary position within
the parent coordinate space using *position:*

`BlElement new position: 50@50.`

## constraints

### introduction
Position of an element is defined by its constraint. You can add contraints to
your element using the *constraintsDo:* message.
```smalltalk
constraintsDo: [ :c |
			        c horizontal matchParent.
			        c vertical matchParent ];
```

"I support a set of attributes (refered to as constraints in Bloc) which define 
the visual properties of the layout. A small set of constraints, like padding, 
margin or minimal and maximum dimensions, are common among all the layouts. Each 
layout has a dedicated constraint object, an instance of 
*BlLayoutCommonConstraints*, that contains these universal constraints."
 
Each type of layout can further define its own specific constraints by creating 
a subclass of gtClass:BlLayoutConstraints.


As your element will always be the child of another element (including space root),
layout constraint can always be defined. 

Constraints allows you to clearly defined the size and the position of your
element withing its parent.


Constraints are associated with the layout used by parent and follow by default
*BlLayoutCommonConstraints*.

Ex: Parent define *BlLinearLayout*, children constraints are defined by *BlLayoutConstraints*

### static or dynamic size
Size can be determined **statically** or **dynamically**

If you use *exact:*, the size of the element will be static. *size: aPoint* is a synonym
for `c horizontal exact: aPoint x. c vertical exact: aPoint y`

If you use *matchParent* or *fitContent*, the size of the element will be computed
dynamically, dependent of its parent or child space.

**Attention**, if you define your element using a geometry, you should define as 
well its *size*. The overall bounds of the element is not deduced from its geometry,
and its default will be 50@50, which will certainly be different from your element.

### overriding parent layout.
You can ignore the layout define by the parent using *ignoreLayout* or override 
it using *flow*, *frame*, *grid*, *linear* or *relative* message.