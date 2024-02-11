# Bloc

Bloc introduction to be written
This chapter is heavily inspired by [morphic introduction](https://github.com/SquareBracketAssociates/NewPharoByExample9/blob/master/Chapters/Morphic/Morphic.pillar)

## BlElement

All of the objects that you see on the screen when you run Pharo are
*BlElemments*, that is, they are instances of subclasses of class `BlElement`.

The class `BlElement` itself is a large class with many methods;
this makes it possible for subclasses to implement interesting
behaviour with little code. You can also customize an element
directly. Contrary to the old Morphic environment, Bloc favor
much more object composition over inheritance.

To create a BlElement to represent a string object, execute the following code in a Playground.

```smalltalk
BlTextElement new text: 'Hello world!' asRopedText openInNewSpace.
```

This creates a BlTextElement to represent the string
*'Hello World!'*, and then opens it (that is, displays it) in the
*space*, which is the name that Pharo gives to  the screen.
You should obtain a graphical element (a `BlElement`), which you can
inspect.

Of course, it is possible to define morphs that are more interesting
graphical representations than the one that you have just seen.

Now execute
`BlElement new size: 20@20; background: (BlBackground paint: Color orange)`
in a Playground. Instead of the string-like morph, you get an orange square.
![basic element inspect](figures/basicelementinspect.png)

## manipulating BlElement

Bloc elements are objects, so we can manipulate them like any other
object in Pharo: by sending messages, we can change their
properties, create new subclasses of Morph, and so on.

Every bloc element, when opened on the screen has a position and a
size. If they are irregularly shaped, their position and size are
those its *bounds*.

- The **position** method returns a **Point** that describes the location of
the bloc element upper left corner of its bounding box. The origin of the
coordinate system is the parent's upper left corner, with *y* coordinates
increasing *down* the screen and *x* coordinates increasing to the right.
- The **extent** method also returns a point, but this point specifies the width
and height of the bloc element rather than a location.

Type the following code into a playground and **Do it**:

```smalltalk
joe := BlElement new size: 20@20; background: (BlBackground paint: Color blue).
joe openInNewSpace.
joe.
```

Then, in the inspector, type `self position` and then `Print it`. To move joe,
execute `self position: (self position + (10@3))` repeatedly.

It is possible to do a similar thing with size. `self extent` answers joe's
size; to have joe grow, execute `self size: (self extent * 1.1)`. To change
the color of a morph, send it the **color:** message with the desired **Color**
object as argument, for instance, `self background: (BlBackground paint: Color orange)`.
To add transparency, try `self background: (BlBackground paint: (Color orange alpha: 0.2))`.

## Composing bloc elements

One way of creating new graphical representations is by placing one
bloc element inside another. This is called *composition*; Bloc elements can be
composed to any depth. You can place a morph inside another by sending the
message ==addChild:== to the container morph. This is what happen when you send
the message *openInNewSpace*. Your element is added to the *space* element.

Try adding an element to another one as follows:

```smalltalk
|joe balloon|
joe := BlElement new size: 100@100; background: (BlBackground paint: (Color orange alpha: 0.2)).
balloon := BlElement new 
            geometry: (BlCircleGeometry new matchExtent: 100 @ 50);
            size: 100 @ 100;
            background: (BlBackground paint: Color yellow).
joe addChild: balloon.
joe openInNewSpace.
joe.
```

The ballon is added inside joe following default layout rules. More on that later.

![balloon as child](figures/balloonandelementaschild.png)

## Creating your own bloc element

BlElement offers you various method to customize their appearance. As an example,
Let's use this knowledge to create a cross-shaped bloc element.

```smalltalk
|cross w h|

w := 200.
h := 200.
cross := BlElement new 
size:w@h ;
background: (BlBackground paint: (Color blue alpha: 0.2));
geometry: (BlPolygonGeometry vertices: {
                        (w/3 @ 0).
                        (w/3*2 @ 0).
                        (w/3*2 @ (h/3)).
                        (w @ (h/3)).
                        (w @ (h/3*2)) .
                        (w/3*2 @ (h/3*2)) .
                        (w/3*2 @ h) .
                        (w/3 @ h).
                        (w/3 @ (h/3*2)) .
                        (0 @ (h/3*2)) .
                        (0 @ (h/3)) .
                        (w/3 @ (h/3))}
                        ).
```

![cross shape element](figures/crossshapeelementgeometry.png)

BlElement bounding box is automatically defined by its geometry. Now, letś add
some mouse interaction.

### Mouse events for interaction

To build live user interfaces using bloc elements, we need to be able to
interact with them using the mouse and keyboard. Moreover, the element need to
be able respond to user input by changing their appearance and position — that
is, by animating themselves.

Let's extend our cross element to handle mouse events. Suppose that when we
enter on the cross, we want to change the color of the cross to red, and when
we leave it, we want to change the color to yellow.

```smalltalk
cross addEventHandler: (BlEventHandler
                on: BlMouseEnterEvent
                do: [ :anEvent | cross background: (Color red alpha: 0.2) ]).

cross addEventHandler: (BlEventHandler
                on: BlMouseLeaveEvent 
                do: [ :anEvent | cross background: (Color yellow alpha: 0.2) ]).
```

The *BlMouseEnterEvent* and *BlMouseLeaveEvent* are an instance of
**BlMouseEvent**, which is a subclass of **BlEvent**.
Browse those class to see what other object are available for the mouse events.

### Keyboard events

To catch keyboard events, we need to ask our object to manage those events as
well.

With a single key combination

```smalltalk
cross addShortcut: (BlShortcutWithAction new
      combination: (BlSingleKeyCombination key: KeyboardKey right);
      action: [ :anEvent :aShortcut | self inform: 'right key used'  ]).
```

with multiple key combination (builder being an instance of *BlKeyCombinationBuilder*)

```smalltalk
cross addShortcut: (BlShortcutWithAction new
      combination: (BlKeyCombination builder control l build);
      action: [ :anEvent :aShortcut | self inform: 'meta-L key used' ]).
```

```smalltalk
addEventHandler: (BlEventHandler
                on: BlKeyDownEvent
                do: [ :evt | | key |
                key := anEvent key.
                key = KeyboardKey up ifTrue: [ cross position: cross position - (0 @ 10) ].
                key = KeyboardKey down ifTrue: [ cross position: cross position + (0 @ 10) ].
                key = KeyboardKey right ifTrue: [ cross position: cross position + (10 @ 0) ].
                key = KeyboardKey left ifTrue: [ cross position: cross position - (10 @ 0) ].);
                ])
```

We have written this method so that you can move the morph using the arrow keys.
To discover the key values, you can open add this method to your element

```smalltalk
cross addEventHandler: (BlEventHandler
        on: BlKeyDownEvent
        do: [ :anEvent | self inform: 'Key down: ' , anEvent key asString ]).
```

To ensure your cross has the focus, send the message
`cross requestFocus.`
