# Morph events

- ## Morphic Event Loop

World is ultimately a Form that is displayed on your desktop using SDL2.
There are several steps to display your morph and your widget on the screen

draw with bitmap canvas and Morphic.

Using drawOn: a Canvas method,
aCanvas is of type a FormCanvas on: Form(1536x934x32)
So you're drawing on a form that is the Whole smalltalk Word
You can check it by inspecting the Form the canvas is drawing on.

*Smalltalk currentWorld extent* = 1536x934x32

this is because of the recursive aspect of Morphic.
In the end, everything is displayed on a single Form that represent the world.

In MorphicUIManager: **MorphicRenderLoop new doOneCycleWhile: [ true ]**
which will calls WorldMorph class >> doOneCycle
WorldMorph displayWorld ->  worldState displayWorld: self

Which will recursively draw all submorph of the world.

When you invoke the method "openInWorld", you add your morph to the global World morph
as this code indicate:

```smalltalk
doOpenInWorld: aWorld

 aWorld addMorph: self
```

Because it simply do addMorph, your morph will appear in the top left corner, unless
you specify its position.

If you open your morph in a window, it'll be embeded in a SystemWindow. When you open it,
it will use the strategy "cascadeFor:initialExtent:world:" which say:

```smalltalk
position := aWorld currentWindow isMorph 
  ifFalse: [ aWorld center - (initialExtent / 2)]
  ifTrue: [ aWorld currentWindow position + 20].
        
```

## world definition

Morph >> BorderedMorph >> PasteUpMorph >> WorldMorph >> OSWindowWorldMorph

### shutdown

OSWindowDriver class shutdown:

```smalltalk
 "clean OSWindow worlds"
 WorldMorph extraWorldList copy 
  select: [ :each | each isKindOf: OSWindowWorldMorph ]
  thenDo: [ :each | WorldMorph removeExtraWorld: each ].
 "Clean also active world"
 (ActiveWorld isKindOf: OSWindowWorldMorph)
  ifTrue: [ ActiveWorld := nil ]
```

### startup

PharoBootstrapInitialization >> initializeCommandLineHandlerAndErrorHandling

```smalltalk
 UIManager default: NonInteractiveUIManager new. 
```

## OSWindow

OSWindow and its sub-package define the API used by Pharo for creating and
controlling an operating system window. It defines *renderer* used to display
the morphic world, the *Events* used to response to user interaction (mouse click
window move, etc...)

AbstractWorldRenderer >> OSWorldRenderer

OSWorldRenderer is called in OSWindowWorldMorph >> open

OSWindow driver by default is OSSDL2Driver, which is defined in Pharo Settings
*OSWindowDriver >> OSSDL2Driver createWindowWithAttributes: attributes osWindow: osWindow*

## SDL2

SDL is the low level library that is used to interact with the underlying operating system
Contrary to old way of doing in previous Pharo VM, The whole interface is now mapped
using UFFI (Universal Foreign Function Interface), and so the full code is available
in the Pharo. You can look at the package **OSWindow-SDL2** and its sub-packages.

OSWindowRenderer >> OSWindowFormRenderer >> OSSDL2FormRenderer

The package contains both the code to interact with SDL2 library, as well as
concrete implementation of class used to render the Morphic World on a concrete
desktop window.

Platform abstration is defined in **OSPlatform** and its subclasses

## Event Handling
