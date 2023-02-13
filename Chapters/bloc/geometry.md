# geometry of BlElement

Geometry define the shape of your BlElement. You already have many possibilities
defined as subclasses of **BlElementGeometry**

*BlElementGeometry allSubclasses* shows: 
BlElementVectorGeometry BlEmptyGeometry BlRectangleGeometry
BlAnnulusSectorGeometry BlBezierCurveGeometry BlCircleGeometry BlEllipseGeometry
BlHistogramGeometry BlLineGeometry BlMultiPolygonGeometry
BlMultiPolylineGeometry BlNormalizedPolygonGeometry BlNormalizedPolylineGeometry
BlPolygonGeometry BlPolylineGeometry BlRoundedRectangleGeometry
BlSigmoidGeometry BlSquareGeometry BlStadiumGeometry BlTriangleGeometry
BlAnnulusSector BlBezierCurve BlCircle BlEllipse BlHistogram BlLine
BlMultiPolygon BlMultiPolyline BlNormalizedPolygon BlNormalizedPolyline
BlPolygon BlPolyline BlRectangle BlSigmoid BlSquare BlStadium

As you can see, you already have a lot of geometry possibilities. If you were
used to the Morphic way of doing things, you'll notice a big difference here.

Bloc really favor BlElement composition to create your interface. Most of the 
time, you will not have to create a custom painting of your element widget. You
can already do a lot with existing geometry. Ultimately, you can define 
drawing methods on a canvas **seems to be missing in my current version 
20230212**, but once drawn, a canvas cannot be easily inspected for its elements.
However, Bloc element composition create a tree of elements, that can be 
inspected, and shaped dynamically. 

Morphic was already capable of doing such things, but it was clearly an 
afterthough of its creation. It was quite troublesome to define the layout of 
different element together, especially when you have to manage resizing of your
element. Bloc offer a very nice way of creating custom component, and advanced
layout possibilities to mix all together.

When drawing with Athens or another vector canvas. you already noticed the
few primitives that we where using: lines, curves and bezier curves. Let's look
at associted geometry in detail to see how you can use them

## Basic geometry: lines, circle and bezier curves.

## other geometry: rectangle, square, triangle

### rectangle geometry
```smalltalk
BlElement new
geometry: (BlRoundedRectangleGeometry cornerRadius: 20);
background: Color orange;
size: 100@100.
```
#### square geometry


### triangle geometry

```smalltalk
BlElement new
geometry: (BlTriangleGeometry new matchExtent: 50@100; beTop  );
background: Color orange;
size: 100@100; openInNewSpace
```
