# bounds

- *Layout* bounds are drawn with gray dashed rectangles in the figure above. They are of this size in this particular example, because each element defines its size explicitly using **size:** method. Layout bounds are considered by layout algorithms to define mutual locations for all considered elements.

"Geometry" bounds are drawn with red dashed rectangles . The area is defined by minimum and maximum values of a polygon vertices. This does not take in account the border width, for example.

"Visual" bounds are drawn with blue rectangles in the figure above. It is an exact area occupied by an element. Computing visual bounds is the most expensive computation as it takes strokes and rendering into account.

If we specify BlOutskirts inside, visual bound and geometry bounds will be the same. But if BlOutskirts is outside, then visual bounds are larger than geometry bounds to take border width into its calculation.

see {{gtClass:BlGeometryVisualAndLayoutBoundsExamples}}

- BlDevElement new size:200@200;
geometry:( BlPolygon
  vertices:
   {(100 @ 50).
   (115 @ 90).
   (150 @ 90).
   (125 @ 110).
   (135 @ 150).
   (100 @ 130).
   (65 @ 150).
   (75 @ 110).
   (50 @ 90).
   (85 @ 90)});
background: (Color pink alpha:0.2);
border: (BlBorder paint: Color black width: 5);
outskirts: BlOutskirts outside"replace with inside to see the difference".
