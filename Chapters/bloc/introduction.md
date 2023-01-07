# Bloc - base element for GUI

- Root: BlElement

Defines

- geometry (shape) and bounds (BlBounds)
- size
- background (BlBackground). Paints (BlPaint) are used for background, border, text fill or stroke.
- border (BlBorder)
- opacity
- layout and children composition. (BlLayout, BlChildren, and their children)
- event handling (BlEvent and children)

You can add element with **addChild:**, and the will be disposed according the
the layout specified.

UI element model can use Announcer (observer) pattern to tell when their state
change:
 card announcer when: CardFlipped send: #onFlipped to: self.
 card announcer when: CardDisappeared send: #onDisappear to: self.

Drawing is done through method 'drawOnSpartaCanvas', which receive a sparta
(vector) canvas as an argument.

To add event to an element, you first need to subclass 'BlEventListener' and
override the event you want to manage. You then add your event handler to your
bloc element with method 'addEventHandler'. Event are bloc announcement method
and classes.

You can apply transformation to a BlElement:

- rotation
- translation
- Scaling
- reflection
- etc...

**important class to look at**
{{gtClass:BlElement}}
{{gtClass:BlBackground}}
{{gtClass:BlStyles}}
{{gtClass:BlGeometryVisualAndLayoutBoundsExamples}}
{{gtClass:BlBasicShortcut}}
{{gtClass:BrStencil}}

- also possible to activate in the GT-Inspector's menu, next to the tabs.

## Bloc Basic

- interacting with Bloc element
=> coordinate
=> style
=> background paint.
=> Geometry

- creating and drawing your own block
=> subclass BlElement
=> Custom drawing is done with drawOnSpartaCanvas: method.
=>

- handling mouse and keyboard event (shortcut, keybinding, etc...)
=> subclass BlEventListener, overwrite method which handle event, and add
instance of the class to your BlElement with method addEventHandler:

Keyboard shortcut: BlShortcut

- Bloc animation
=> announcer
=> BlBaseAnimation and subclasses
=> addAnimation method in BlElement

- Drag&Drop
Explore BlBaseDragEvent and subclasses.

## Bloc Example

look at Bloc-example package.

 widget size: 22@14.
 widget layout: BlFrameLayout new.
 widget padding: (BlInsets all: 3).
 widget border: (BlBorder builder width: 1; build).
 widget geometry: (BlRoundedRectangleGeometry cornerRadius: 8).

- composing Bloc element
=> Bloc Layout and addChild method (children Add/remove category)
BlBasicLayout, BlFrameLayout, BlGridLayout.
- element size: 100@200 is equivalent to:
child constraintsDo: [ :c |
        c horizontal exact: 100.
        c vertical exact: 200 ].

centersAndSizes := {
 { 50@10. 100@10 }.
 { 50@10. 80@15 } }.
container := BlElement new
    size: 200@100;
    yourself.
centersAndSizes do: [ :c |
    container addChild: (
        BlElement new
            border: (BlBorder paint: Color red width: 1);
            relocate: c first;
            size: c second;
            yourself)
        ].
container

centersAndSizes := {
 { 50@10. 100@10 }.
 { 50@10. 80@15 } }.
container := BlElement new
    size: 200@100;
    yourself.
centersAndSizes do: [ :c |
    container addChild: (
        BlElement new
            background: (Color random alpha: 0.5);
            relocate: (c first - (c second / 2));
            size: c second;
            yourself)
        ].
container
