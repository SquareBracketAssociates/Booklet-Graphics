# Bloc - base element for GUI

**Bloc** is the new graphical framework developped for Pharo. Initially
developped by Pharo team, it has been extended by Feenk team for GToolkit. Their
work is now being integrated back into **Pharo**. It should ultimately replace
the aging **Morphic** graphical framework,

To install it in Pharo 11, simply type in the playground

```smalltalk
[ Metacello new
baseline: 'Bloc';
repository: 'github://pharo-graphics/Bloc:dev-1.0/src';
onConflictUseIncoming;
ignoreImage;
load ]
on: MCMergeOrLoadWarning
do: [ :warning | warning load ].
```

Contrary to Morph, which relied a lot on inheritance to customize graphical
element, Bloc is designed to be composable. Basic bloc element can be
customized, and added to each other, to create high level component.

Bloc introduce new concept in the user interface. Previously, Pharo users
where used to talk about the **World** or **Morphic World**, which represent
the environment where we spend most of our time. With Bloc, we now deal with
**BlUniverse** and **BlSpace**. **BlSpace** is an operating system window in
which the Pharo systems is executed. If you have more than one BlSpace opened,
they will be listed as part of BlUniverse - a list of all available BlSpace in
your current Pharo session.

Let's create our first Bloc component. The root of all graphical element is
**BlElement**. You'll have to customize or subclass this element to create your
awesome graphical interface. Let's start with an easy one. Type this in the
playground

```smalltalk
BlElement new
geometry: BlRectangleGeometry  new;
size: 200 @ 100;
background: Color blue;
openInNewSpace
```

Once executed, a new window should appear on your desktop, with a white
background, and a blue rectangle inside. Let's look at it in more detail.

We first create a new BlElement. It's a blank element, and if you try to display
it, you won't see anything. We then define its geometry. The shape of your
element, in Bloc, is defined by its geometry. It's a simple rectangle in our
example, but it can be much more complicated. We'll look at geometry in more
detail later. We then define its size, its color, and then ask to open it in
a new space. As of this writing, it's not possible to open in Morphic World.

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

## geometry of BlElement

Geometry define the shape of your BlElement. You already have many possibilities
defined as subclasses of **BlElementGeometry**

`BlElementGeometry allSubclasses`

As you can see, you already have a lot of geometry possibilities. If you were
used to the Morphic way of doing things, you'll notice a big difference here.

Bloc really favor BlElement composition to create your interface. Most of the
time, you will not have to create a custom painting of your element widget. You
can already do a lot with existing geometry. Ultimately, you can define
drawing methods on a canvas, but once drawn, a canvas cannot be easily inspected
for its elements. However, Bloc element composition create a tree of elements,
that can be inspected, and shaped dynamically.

Morphic was already capable of doing such things, but it was clearly an
afterthough of its creation. It was quite troublesome to define the layout of
different element together, especially when you have to manage resizing of your
element. Bloc offer a very nice way of creating custom component, and advanced
layout possibilities to mix all together.

When drawing with Athens or another vector canvas. you already noticed the
few primitives that we where using: lines, curves and bezier curves. Let's look
at associted geometry in detail to see how you can use them

![base geometry](figures/allGeometry.png)
