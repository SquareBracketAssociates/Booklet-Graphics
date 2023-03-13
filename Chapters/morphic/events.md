# Morph events

## Morphic Event Loop

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
Event handling is done in morphic in different way. Due to its hierarchical
structure. A morph do not directly answer to events. Instead, a morph uses an
event listener chain.  There are 5 mains ways to handle events in Morphic.

Single click, double click are processed throug **MouseClickState**

1. The first, and most common/best AFAIK, is to use the pattern:
**on: eventName send: selector to: recipient**
As in: **myMorph on: #mouseDown send: #clicked to: self.**

mouseDown being a method, in the "event handling" protocol
Look at: *click*, *
A list of recognized event names are in **MorphicEventHandler**

This is flexible, and allows you to send events to arbitrary objects. You don't
have to subclass the Morph. There are also other variations like
**on:send:to:withValue:.**

if you wants to change or add an event management dynamically or without
implementing specific methods (mouseDown:), then you can use the event handler
and its protocol ( on:send:to: , limited to user interaction events though)


2. The second way involves working with a Morph subclass. see How to add a
mouse-up action in your own subclass of Morph. This method isn't as flexible,
and doesn't support as many events, but may be better in some circumstances.

if you create your own morph class, then you implement mouseDown:, mouseUp: etc
according to the event hierarchy.  To allow a morph to manage an event, you have
also to declare that the event is of interest. This is done by redefining the
handlesXXX: methods.  as an example, if you wants to redefine
mouseDown:/mouseUp: you redefine handlesMouseDown: to return true.  the event is
passed as argument, you can decide to return true or false according to the
state of your morph and the event argument.

**Note:**
you have also the handleXXXX: methods. (do not mistake handleXXXX for
handlesXXX). Their role is to manage incoming user interaction events.  As an
example, see handleMouseDown: , it removes a possible pending balloon, it
manages the focus, it starts the mouse still down management, it sends
mouseDown: to the receiver...  Normally you should not have to redefine them.

3. The third way is to create your own EventHandler, and install it with Morph
eventHandler:. Morphs can share EventHandlers, btw.

You may need to inspect an event. (What key was pressed, what mouse button was
clicked)?

4. Additional event are implemented as Announcements such as MorphGotFocus.
These “events" are not necessarily related to the user interaction.
Announcements are suited to define your own specific events.
They allow the implementation of the Observer/Observable pattern nicely.

5. HandleListenEvent: is for particular purpose, used rarely. 

context menu on the shape, calling #connect

```smalltalk
MDShapeconnect
|connector|
    connector := MDTempConnector from: self to: ActiveHand isBezier: false.
    connector openInWorld.
```

When creating the MDTempConnector, I start listening to the hand's events

```smalltalk
MDTempConnector>>to: aHand 
    to := aHand.
    ActiveHand addEventListener: self.

MDTempConnector>>handleListenEvent: anEvent
    anEvent isMouse ifFalse: [ ^super handleListenEvent: anEvent].
    anEvent isMouseUp ifTrue: [ self stopListening: anEvent].
    anEvent isMouseMove ifTrue: [ self moved.  self highlightShapeAt: anEvent ]
```

And I stop listening on mouse up, possibly replacing the temporary one by a
permanent one.

```smalltalk
MDTempConnector>>stopListening: anEvent
    ActiveHand removeEventListener: self.
    (self shapeAtPosition: anEvent) ifNotNil: [ :shape |
        from owner addMorphBack: (MDConnector from: from to: shape isBezier:
        smoothCurve) ].
    over ifNotNil: [ over unhighlight ].
    self delete 
```

