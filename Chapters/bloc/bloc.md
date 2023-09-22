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


## element custom Painting

BlElement >> aeFullDrawOn: aCanvas
	"Main entry point to draw myself and my children on an Alexandrie canvas."

	self aeDrawInSameLayerOn: aCanvas.

	self aeCompositionLayersSortedByElevationDo: [ :each |
		each paintOn: aCanvas ].
		
Element geometry is taken care by:
BlElement >> aeDrawGeometryOn: aeCanvas
Painting is done on an Alexandrie Canvas, then rendered on the host:
BARenderer (BlHostRenderer) >> render: aHostSpace, display on a AeCairoImageSurface

1. aeDrawChildrenOn:
 2. aeDrawOn:
  3. aeDrawGeometryOn:
  
  
## Event handling & shortcut management.


## child Element
Element can be inspected, but for your application, it'll probably be integrated
in another element, or in a *space*.

BlUniverse host multiple BLSpace, managed by a BlSpaceManager.


BlOSpace and BlSpace is the new "World" for Bloc.
=> logical representation of a window in Bloc regardless of the current Host in use

rootElement := self defaultRoot return a BlElement
-> we're working on a graph of BlElement.

In the Initialize method:
host := BlHost pickHost.
session := Smalltalk session.