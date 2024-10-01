## BlElement

**Bloc** distinguishes itself by prioritizing object composition over
inheritance as its core design principle. This means that instead of relying
heavily on complex inheritance hierarchies, **Bloc** encourages building user
interface components by combining and customizing basic building blocks.

Note that Toplo is a new skinnable widget library built on top of Bloc.

### BlElement: The foundation of Bloc components

Every visual element within **Bloc** stems from the fundamental class
`BlElement`. This versatile class serves as the foundation upon which you can
construct more intricate components. By directly customizing and combining
`BlElement` instances, you gain granular control over the appearance and
behavior of your UI elements.

#### Navigating Bloc's spatial landscape

**Bloc** introduces two key concepts for managing the visual environment: 
`BlUniverse` and `BlSpace`. Imagine `BlUniverse` as a container housing a
collection of individual `BlSpace` instances. Each `BlSpace` represents a
distinct operating system window where your Pharo application unfolds. If you
have multiple windows open simultaneously, they'll be neatly organized within
the `BlUniverse`, providing a clear overview of your active spaces.

#### Ready to Build: Creating Your First Bloc Component

```smalltalk
blueRectangle := BlElement new
	geometry: BlRectangleGeometry  new;
	size: 200 @ 100;
	background: Color blue;
	yourself.
blueRectangle openInNewSpace
```

![Creating a basic element.](figures/basicElement.png width=40)

1. **Start with a blank canvas:** Begin by creating a new `BlElement`. 
This serves as the foundation for your user interface element, initially appearing
invisible.
2. **Define its shape:** In Bloc, the element's visual representation is
determined by its geometry. 
In this example, we'll use a simple rectangle, but more complex shapes are also possible (explored in further detail later).
3. **Set its dimensions and appearance:** 
Specify the element's size and color to customize its visual characteristics.
4. **Bring it to life:** Finally, open the element in a new space, making it visible on the screen.


In our example, we can observe the state of your element by inspecting the `blueRectangle` variable. We can observe a graphical overview of the element, as well as its state:

![Creating a basic element.](figures/basicElementInspection.png width=80)

Elements are organized in trees. 
To compose tree of elements, we select a root element and we add children.

```smalltalk
redRectangle := BlElement new
	geometry: BlRectangleGeometry  new;
	size: 50 @ 50;
	background: Color red; 
	yourself.
blueRectangle addChild: redRectangle
```

1. **Start with a root element of your choice:** in our example, we reuse the `blueRectangle` element.
2. **Define the new element:** This is done like any other element, such as the `blueRectangle` element.
In this example, we will use a red rectangle, but smaller than the blue one.
3. **Add the new element as a child of the root element:** 
The `addChild:` api adds leaf elements to a root.
4. **Bring it to life:** If the `blueRectangle` is still open, it automatically updates with the `redRectangle`. Else, re-execute all the code to open the root in a new space, making it visible on the screen.

![Composing elements.](figures/composedElements.png width=40)

The red element is placed on the top left corner of its parent, the blue element.
By default, the position of `BlElement` instances is `0@0`.
The position of elements is configured by using the `position:` api, such as in the following:

```Smalltalk
redRectangle position: 75@25. 
```

![Changing elements positions.](figures/basicElementPosition.png width=40)

Notice that if you did not close the original space opened for the `blueRectangle` element, the display automatically updates when the `redRectangle` position changes.

### Spaces: where elements are displayed

Spaces represent windows in which elements are displayed.
They are explicitely controlled by instantiating `BlSpace` objects.
A space has a root element, to which other elements are attached using the `addChild:` api.
In the following example, we create a new space in which we add our two rectangles:

```Smalltalk
space := BlSpace new.
space root addChild: blueRectangle.
space root addChild: redRectangle.
space show
```
An element can only be the child of a single other element.
If an element is already added as a child in a space, trying to add that element to a new space will raise an exception. 
One solution is to create new instances of that element to add it to another space.

### Exercise 1: color wall

Create a $10\times10$ grid of squares, each with a random color, and display it in a space (Figure *@fig:jointype@*).
 
![Creating a wall of colors.](figures/colorWall.png label=fig:colorWall width=80)


### Geometry of BlElement

In Bloc, the visual form and boundaries of your UI elements are determined by their geometry. 
Each element can only possess a single geometry, essentially acting as a blueprint for its shape and size.
You can visualize an element as a specific geometry encapsulated within an invisible rectangular container, representing its overall *bounds*.

Bloc provides a diverse range of pre-defined geometry shapes accessible through `BlElementGeometry allSubclasses`. 
This comprehensive library empowers you to construct elements of varying complexities, from basic rectangles and circles to more intricate forms.

Bloc excels in facilitating the creation of custom components with advanced layout possibilities. 
Imagine building complex layouts by strategically arranging various elements, each defined by its unique geometry, to form a cohesive whole.

While the Alexandrie canvas provides a foundational set of building drawing primitives, Bloc offers a richer library of pre-defined shapes and the flexibility to construct even more intricate geometries.

![Base geometries.](figures/allGeometry.png width=80)

* **Annulus**: `BlAnnulusSectorGeometry new startAngle: 225; endAngle: 360;   innerRadius: 0.3; outerRadius: 0.9);`
* **Bezier**: `BlBezierCurveGeometry controlPoints: { 5@0. 25@80. 75@30. 95@100 }`
* **Circle**: `BlCircleGeometry new matchExtent: 100 @ 50`
* **Ellipse**: `BlEllipseGeometry new matchExtent: 100 @ 50)`
* **Line**: `BlLineGeometry from: 10@10 to: 90@90`
* **Polygon** : `BlPolygonGeometry vertices: {(10 @ 10). (10 @ 90). (50 @ 50). (90 @ 90). (90 @ 10)}`
* **Polyline**: `BlPolylineGeometry vertices: {(10 @ 10). (10 @ 90). (50 @ 50).(90 @ 90). (90 @ 10) }`
* **Rectangle** : `BlRectangleGeometry  new`
* **Rounded rectangle**: `BlRoundedRectangleGeometry cornerRadius: 20`
* **Square**: `BlSquareGeometry new matchExtent: 70 @ 70`
* **Triangle**: `BlTriangleGeometry new matchExtent: 50 @ 100; beLeft`

### Element border

The geometry is like an invisible line on which your border is painted. The
painting is a subclass of `BlPaint`, and one of the three:

- solid color
- linear gradient color
- radial gradient color

![Border color type.](figures/bordercolortype.png width=80)

Your border opacity can be specified as well: `opacity: 0.5;`

By default, your border will be a full line, but it can also be dashed, with
**dash array** and **dash offset**. Dash arrays define the number of element, and
dash offset, the space between elements.

You also have a pre-defined option, available in a single call:

- **dashed**
- **dashed small**

![Border dash.](figures/multipletriangledash.png label=fig:borderdash width=80)

If the path is not closed, The style extent of your border can be defined with

- **cap square**
- **cap round**
- **cap butt**

Last, when the lines of your border cross each other, you can define the style of
the join as shown in Figure *@fig:jointype@*:

- **round join**
- **bevel join**
- **mitter join**

![Border join type.](figures/borderjointype.png label=fig:jointype width=80)

You have two options to define your border:

* short call: `element border: (BlBorder paint: Color orange width: 5)`
* with a builder:`element border: (BlBorder builder dashed; paint: Color red; width: 3; build)`

The first one is very helpful for solid line definition. The builder lets use
customize all the details of your border.

### Element bounds and outskirts

Let's look at the different possible bounds of your element.

**Layout bounds** can be defined explicitly using `size:` method or dynamically
Layout bounds are considered by layout algorithms to define mutual locations
for all considered elements. You'll know more about layout later.

**Geometry bounds** area is defined by minimum and maximum values of polygon
vertices. This does not take in account the border width

**Visual bounds** is an exact area occupied by an element. it takes strokes
and rendering into account.

The geometry is like an invisible line on which your border is represented.
The border drawing can happen outside (adding its border size to the size of
your element), centered, or inside the geometry of the element. The final size
(geometry + border width) will define the **bounds** of your element.

In Figure *@fig:outskirts@*, the same exact star is drawn 3 times. The only difference is
the outskirts definition between those 3.

![Outskirts.](figures/multipletriangleoutskirts.png label=fig:outskirts width=80)

If we specify outskirts inside, visual bound and geometry bounds will be the
same. But if the outskirts is outside, then visual bounds are larger than
geometry bounds to take border width into its calculation.

### Element background

quick set-up: `background: (Color red alpha: 0.8);`

using rgb color

```smalltalk
background: (Color r: 63 g: 81 b: 181 range: 255);
```

using linear gradient

```smalltalk
background: ((BlLinearGradientPaint direction: 1 @ 1) from: Color red to: Color blue).
```

using radial gradient

```smalltalk
background: (BlRadialGradientPaint new
stops: { 0 -> Color blue. 1 -> Color red };
center: largeExtent // 2;
radius: largeExtent min;
yourself);
```

Using dedicated `BlPaintBackground` object.

```smalltalk
BlElement new 
	background: ((BlPaintBackground paint: Color red  asBlPaint) opacity: 0.75; yourself);
	openInSpace
```

![Background color.](figures/backgroundcolortype.png width=80)

### Element effect

You can get the list of all the effects available by executing: `BlElementEffect allSubclasses`

#### Simple shadow. 

```origin=BlocExamples>>shadow
BlElement new
	size: 200 @ 100;
	geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
	background: (Color red alpha: 0.2);
	border: (BlBorder paint: Color yellow width: 1);
	outskirts: BlOutskirts centered;
	effect:
	    (BlSimpleShadowEffect color: Color orange offset: -10 @ -20)
```

![Simple shadow.](figures/simpleshadow.png width=80)

Try the following variation.

```
effect: (BlSimpleShadowEffect
	color: (Color orange alpha: shadowAlpha)
	offset: shadowOffset);
```

#### Gaussian shadow.
The following produces the result shown in Figure *@fig:gaussian@*.

```smalltalk
BlElement new
	size: 300 @ 150;
	geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
	background: (Color blue alpha: 0.5);
	border: (BlBorder paint: Color red width: 10);
	effect: (BlGaussianShadowEffect color: Color yellow offset: 10@20 width: 5)
```

![Gaussian shadow.](figures/gaussianshadow.png label=fig:gaussian width=80)

### Element opacity

The element opacity is a value between 0 and 1, 0 meaning completely transparent.
You can apply opacity to a background, a border, or to your whole element.

![Element opacity.](figures/elementwitopacity.png width=80)

### Element transformation

You can apply transformations to a `BlElement`:

- rotation
- translation
- scaling
- reflection
- etc...

Transformation are affine transformation. For more detail, you can search on the internet, there are countless references to it. To simplify it, I'll say we apply  a transformation matrix (*BlMatrix2D*) to all point of our figure path, each point represented as *BlVector*. 

You have 3 type of tranformation available in Bloc:
- **BlElementLocalTransformation**: This transformation combine an affine transformation (*BlAffineTransformation* subclasses), with a point of origin (*BlAffineTransformationOrigin* subclasses). By default, origin is the center of your element, BlAffineTransformationCenterOrigin.
- **BlElementAbsoluteTransformation**: This transformation apply a transformation matrix to your shape, without point of origin. Its  result is similar to *BlElementLocalTransformation*, with origin set to *BlAffineTransformationTopLeftOrigin*
- **BlElementCompositeTransformation** which are combination of *BlElementLocalTransformation* and/or *BlElementAbsoluteTransformation*

Most of the time, you won't have to deal with matrix definition. You'll use the 
helper method `transformDo`, and define your transformation using *BlTransformationBuilder*.

When you're defining a transformation using `transformDo:` , you'll, by default, 
use *BlAffineCompositeTransformation*. All transformation move added subsequently will be composed together.
The origin will be set to *BlAffineTransformationCenterOrigin*.

Those two transformation below are strictly equivalent, and rotate your element by 45 degree. 
One use the underlying object, while the other use the helper methods:

```smalltalk
elt transformation: (BlElementLocalTransformation 
	newWith: ((BlRotationTransformation new angle: 45) 
	origin: (BlAffineTransformationCenterOrigin defaultInstance ) )).
```

```smalltalk
elt transformDo: [ :t | t rotateBy: 45 ].
```

A transformation is applied in the scope of the message `transformDo:` as shown below.
```
element transformDo: [ :b | b scaleBy: 0.2; translateBy: -25 @ -15 ];
```
The following script produces *@fig:transform@*.

```smalltalk
aContainer := BlElement new
		layout: BlFrameLayout new;
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ];
		padding: (BlInsets all: 20);
		background: (Color gray alpha: 0.2).

node := BlElement new
	geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
	border: (BlBorder paint: Color black width: 2);
	background: Color white;
	constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignBottom ];
	size: 20 @ 20.

aContainer transformDo: [ :t |
	t
		scaleBy: 2.0;
		rotateBy: 69;
		translateBy: 50 @ 50 ].
		
aContainer addChild: node.
aContainer forceLayout.
```

![Transform example.](figures/transformexample.png width=40&label=fig:transform)

transform is something extra that is applied on top of position. For example if
you want to have a short of animation, you would use transform as it is not 
taken into account by layouts

#### Transform catches

The message `transformDo:` can be applied at any moment during the life of an object.
You can use any static or pre-computed properties with `transformDo:` as in the following snippet.
Here ` -25 asPoint` does not depend on the child or parent size.

```
| child parent |
child := BlElement new 
	background: Color lightBlue; 
	geometry: BlCircleGeometry new;
	yourself.
 
child position: 100@100.
child  transformDo: [ :t | t translateBy: -25 asPoint ].

parent := BlElement new 
	size: 200 asPoint; 
	addChild: child;
	background: Color lightRed.

parent openInSpace.
```

**Important.**
if you want to use dynamic layout properties (such as `size`) with `transformDo:`, you need to wait for layout phase to be completed using `whenLayoutedDoOnce:`.
Compare the two examples below:

```
| child parent |
child := BlElement new 
	background: Color lightBlue; 
	geometry: BlCircleGeometry new;
	yourself.
 
child position: 100@100.
child transformDo: [ :t | t translateBy: child size negated / 2 ];

parent := BlElement new 
	size: 200 asPoint; 
	addChild: child;
	background: Color lightRed.

parent openInSpace.
```



```
| child parent |
child := BlElement new 
	background: Color lightBlue; 
	geometry: BlCircleGeometry new;
	yourself.
 
child position: 100@100.

parent := BlElement new 
	size: 200 asPoint; 
	addChild: child;
	background: Color lightRed.

parent whenLayoutedDoOnce: [ 
	child  transformDo: [ :t | t translateBy: (child size negated / 2) ]  ].

parent openInSpace.
```` 


### Element custom painting (more here)

Bloc favors `BlElement` composition to create your graphical interface. 
Most of the time, you will not have to create a custom painting of your element widget. 
You can already do a lot with existing geometry.

Ultimately, you can define drawing methods on a canvas, but once drawn, a canvas cannot be easily inspected
for its elements. 
However, Bloc element composition creates a tree of elements, that can be inspected, and shaped dynamically.

Creating and drawing your element
- subclass `BlElement`
- custom drawing is done with `aeFullDrawOn:` method. Note that 'ae' stands for the Alexandrie canvas.

You can see the `aeFullDrawOn:`
```
BlElement >> aeFullDrawOn: aCanvas
	"Main entry point to draw myself and my children on an Alexandrie canvas."

	self aeDrawInSameLayerOn: aCanvas.
	self aeCompositionLayersSortedByElevationDo: [ :each | each paintOn: aCanvas ].
```

Element geometry is taken care by the method `aeDrawGeometryOn: aeCanvas`.
Painting is done on an Alexandrie canvas, then rendered on the host
by the method `BARenderer (BlHostRenderer) >> render: aHostSpace` which displays it on a `AeCairoImageSurface`.

Drawing is done through method 'xxx', which receives an Alexandrie
(vector) canvas as an argument.

1. `aeDrawChildrenOn:`
2. `aeDrawOn:`
3. `aeDrawGeometryOn:`

Drawing example -  draw hour tick around a circle 
```
aeDrawOn: aeCanvas
	"draw clock tick on frame"

	super aeDrawOn: aeCanvas.

	aeCanvas setOutskirtsCentered.

	0 to: 11 do: [ :items |
		| target |
		target := (items * Float pi / 6) cos @ (items * Float pi / 6) sin.

		items % 3 == 0
			ifTrue: [
				aeCanvas pathFactory: [ :cairoContext |
					cairoContext
						moveTo: center;
						relativeMoveTo: target * 115;
						relativeLineTo: target * 35;
						closePath ].

				aeCanvas setBorderBlock: [
					aeCanvas
						setSourceColor: Color black;
						setBorderWidth: 8 ] ]
			ifFalse: [
				aeCanvas pathFactory: [ :cairoContext |
					cairoContext
						moveTo: center;
						relativeMoveTo: target * 125;
						relativeLineTo: target * 25;
						closePath ].

				aeCanvas setBorderBlock: [
					aeCanvas
						setSourceColor: Color black;
						setBorderWidth: 6 ] ].
		aeCanvas drawFigure ]
```

### Exercise: lights wall
Transform your color grid from Figure*@fig:colorWall@* to a wall of lights such as in Figure *@fig:lightsWall@*:
- compose elements to add circles to the squares
- build and add glowing effects to the circles

Do not hesitate to explore the various effects and their configuration!

![Creating a wall of lights.](figures/lightsWall.png label=fig:lightsWall width=80)

### Conclusion

`BlElement` is defining a large spectrum of element functionalities. 
The following chapters will cover layout, event handling, animations and more. 
