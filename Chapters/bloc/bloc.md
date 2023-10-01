# Bloc & BlElement

## introduction

Element are stored in a tree-like structure. Each element is an instance of *BlElement*
the root element of Bloc.

## element shape & color

* geometry (bounds)
* border & outSkirts (outside, centered, inside)
* background

You can see each element as a *geometry* encasulated inside a hidden
rectangle (its bounds). The geometry is like a an invisible line on which
your drawing is represented. This drawing can happen outside (adding its border
size to the size of your element), centered, or inside.

### element geometry

Geometry will define the shape and the bounds of your element. Each element can
have only one geometry. There are several geometry figures available:
`BlElementGeometry allSubclasses`

Exemple of a polygon geometry, showing a star with 5 branches.

```Smalltalk
 geometry: (BlPolygonGeometry vertices: {
(50 @ 0).
(65 @ 40).
(100 @ 40).
(75 @ 60).
(85 @ 100).
(50 @ 80).
(15 @ 100).
(25 @ 60).
(0 @ 40).
(35 @ 40) });
```

### element border

Short call: `border: (BlBorder paint: Color orange width: 5)`

Long call `BlBorder builder dashed; paint: Color red; width: 3; build`
`BlBorder builder paint: Color black;width: 10; dashArray: #(10 20);capSquare;build`

(BlBorder paint:((BlLinearGradientPaint direction: 1 @ 1)
matchExtent: 100 @ 75; from: Color blue to: Color red)
width: 5).
border: (BlBorder builder
paint: (borderColor alpha: 0.75) asBlPaint;
width: 10;
opacity: 0.5;
build);

### element background

quick set-up: `background: (Color red alpha: 0.8);`

background: (Color r: 63 g: 81           b: 181     range: 255);
background: ((BlLinearGradientPaint direction: 1 @ 1) from: Color red to: Color blue).

background: (BlRadialGradientPaint new
stops: { 0 -> Color blue. 1 -> Color red };
center: largeExtent // 2;
radius: largeExtent min;
yourself);

background: ((BlPaintBackground paint: fillColor asBlPaint) opacity: 0.75; yourself);

### element effect

`BlElementEffect allSubclasses`

Exemple: `effect: BlGaussianShadowEffect color: (Color black alpha: 0.5) width: 7 offset: 2@2;`

effect: (BlSimpleShadowEffect
color: (Color orange alpha: shadowAlpha)
offset: shadowOffset);

### element oppacity

`element opacity:`, value between 0 and 1, 0 meaning completely transparent
You can apply opacity to background, border, or to your hole element.

## element custom Painting

BlElement >> aeFullDrawOn: aCanvas
"Main entry point to draw myself and my children on an Alexandrie canvas."

self aeDrawInSameLayerOn: aCanvas.

self aeCompositionLayersSortedByElevationDo: [ :each | each paintOn: aCanvas ].

Element geometry is taken care by:
BlElement >> aeDrawGeometryOn: aeCanvas
Painting is done on an Alexandrie Canvas, then rendered on the host:
BARenderer (BlHostRenderer) >> render: aHostSpace, display on a AeCairoImageSurface

1. aeDrawChildrenOn:
2. aeDrawOn:
3. aeDrawGeometryOn:
  
## transformation

transformDo: [ :b | b scaleBy: 0.2; translateBy: -25 @ -15 ];

## UI Building

<https://github.com/OpenSmock/Pyramid/tree/main>
