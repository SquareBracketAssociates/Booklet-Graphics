## Event handling

### Event handling

```smalltalk
BlElement new 
  background: Color white; 
  border: (BlBorder paint: Color black width: 2); 
  size: 300 @ 200;
  addEventHandlerOn: BlMouseEnterEvent do: [ :anEvent | anEvent consumed: true. anEvent currentTarget background: Color veryVeryLightGray];
  addEventHandlerOn: BlMouseLeaveEvent do: [ :anEvent | anEvent consumed: true. anEvent currentTarget background: Color white ]; 
  openInNewSpace 
```

`addEventHandlerOn:do:` returns the new handler so that we can store to remove it in case. 

#addEventHandlerOn: do: returns the new event handler.  add a #yourself send after to return a BlElement.

`when:do:` is now deprecated and rewritten as `addEventHandlerOn:do:`
SD: we should update the following

Instead of using addEventHandlerOn:do: you can also see users of `addEventHandler:`.

```
deco addEventHandler: (BlEventHandler 
						on: BlMouseLeaveEvent
	 					do: [ :event | event currentTarget border: BlBorder empty ]).
```

### About event bubbling

We should check `example_mouseEvent_descending_bubbling`


![Windows nested in each others in Toplo.](figures/4windows.png width=80)

To stop event propagation `anEvent consumed: true`

There is an option to forbid mouse events for an element. 
You just send `preventMouseEvent` to it

```smalltalk
"As a more general explanation, all UI related events can be controlled. Have a look at BlElementFlags and BlElementEventDispatcherActivatedEvents and how these classes are used. "

container := BlElement new size: 500 asPoint; border: (BlBorder paint: Color red width: 2).


"#addEventHandlerOn: do: returns the new event handler.  add a #yourself send after"
child1 := BlElement new size: 300 asPoint; background: Color lightGreen; position: 100 asPoint; addEventHandlerOn: BlClickEvent do: [ self inform: '1' ]; yourself .

"There is an option to forbid mouse events for an element. 
You just send #preventMouseEvent to it."
child2 := BlElement new size: 200 asPoint; position: 200 asPoint; border: (BlBorder paint: Color blue width: 2);preventMouseEvents.

container addChild: child1.
container addChild: child2.

container openInSpace.
```

### Drag&drop

```smalltalk
"Draggable card that says 'Rainbow!'"
  a := BlElement new
          geometry: BlRectangleGeometry new;
          size: 65 @ 24;
          background: Color white;
          border: stroke;
          addEventHandlerOn: BlMouseOverEvent
          do: [ :e | a background: Color lightGray ];
          addEventHandlerOn: BlMouseOutEvent
          do: [ :e | a background: Color white ];
          addEventHandler: BlPullHandler new disallowOutOfBounds;
          addChild: (BlTextElement new
              position: 5 @ 5;
              text: ('Rainbow!' asRopedText attributes:
                      { (BlTextForegroundAttribute paint: Color black) })).
addEventHandler: BlPullHandler new disallowOutOfBounds;
```

### Keyboard

```smalltalk
addShortcut: (BlShortcutWithAction new
      combination: (BlKeyCombination builder shift; meta; key: BlKeyboardKey arrowLeft; build);
      action: [ :anEvent :aShortcut | self inform: 'Triggered ', aShortcut combination asString ]);
```

### Introductive example

```smalltalk
eventExample

 "This is a new method"
|toto|
toto := BlDevElement new size:200@200;
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
border: (BlBorder paint: Color orange width: 4);
"layout: BlLinearLayout horizontal alignCenter;"
"constraintsDo: [:c | c horizontal matchParent. c vertical matchParent.];"
outskirts: BlOutskirts outside.

toto addEventHandlerOn: BlMouseEnterEvent do: [ :anEvent |
  anEvent consumed: true.
  toto background: (Color red alpha:0.2) ].
  
 toto when: BlMouseLeaveEvent do: [ :anEvent |
  anEvent consumed: true.
  toto background: (Color blue alpha:0.2) ].
^toto
```

### Other example

```smalltalk
eventExampleMouseMove

|surface elt|
elt := BlElement new size:20@20;
geometry: ( BlPolygon
  vertices:
   {(10 @ 5).
   (11.5 @ 9).
   (15 @ 9).
   (12.5 @ 11).
   (13.5 @ 15).
   (10 @ 13).
   (6.5 @ 15).
   (7.5 @ 11).
   (5 @ 9).
   (8.5 @ 9)});
background: (Color red alpha:0.5);
border: (BlBorder paint: Color blue width: 1).

surface := BlElement new size:400@400;
geometry: BlSquare new;
background: (Color pink alpha:0.2);
border: (BlBorder paint: Color orange width: 4).

surface addChild: elt.
elt relocate: -20@(-20).
  
surface when: BlMouseMoveEvent do: [ :anEvent |
  anEvent consumed: true. "Event stops getting propagated while also not doing anything"
  elt relocate: (anEvent localPosition + (10@10)) ].
  
surface when: BlMouseLeaveEvent do: [ :anEvent |
  anEvent consumed: true.
  elt relocate: -20@(-20) ].
^surface
```

### Events definition

The announcement framwork is an event notification framework. Compared to
"traditional" Smalltalk event systems in this new framework, an event is a real
object rather than a symbol. Announcement is the superclass for events that
someone might want to announce, such as a button click or an attribute change.
Typically you create subclasses for your own events you want to announce.

Events are defined as subclasses of {{gtClass:name=BlEvent|expanded}}

 An event someone might want to announce, such as a button click or an attribute
 change, is defined as a subclass of the abstract superclass Announcement. The
 subclass can have instance variables for additional information to pass along,
 such as a timestamp, or mouse coordinates at the time of the event, or the old
 value of the parameter that has changed. To signal the actual occurrence of an
 event, the "announcer" creates and configures an instance of an appropriate
 announcement, then broadcasts that instance. Objects subscribed to receive such
 broadcasts from the announcer receive a broadcast notification together with
 the instance. They can talk to the instance to find out any additional
 information about the event that has occurred.!

### Managing events

You have 3 players:

- The element that will receive the events.
- Events, or announcement in Pharo, subclasses of BlEvent.
- Event handler. Either BlEventHandler, or by subclassing BlEventListener.

#### Simple case for BlElement.

1. use method: {{gtMethod:name=BlElement>>when:do:}}
2. anEventClass can be a subclass of {{gtClass:name=BlUIEvent}}

This will use BlEventHandler, and will associate a single block action to an Event.

### Complex case - reusing event handling logic with BlEventListener

1. Subclass `BlEventListener` (which is a subclass of {{gtClass:name=BlBasicEventHandler}} and override all method that match specific event you want to catch, for example `BlEventListener>>clickEvent:`
2. Add your listener to your BlElement with method: `BlElement>>addEventHandler:`

This allows complete flexibility. You can define custom behavior and interact with
domain model object in a much cleaner way than when using **when:do:** messages.

### Using event Handler

UI element model can use Announcer (observer) pattern to tell when their state
change:
- `card announcer when: CardFlipped send: #onFlipped to: self.`
- `card announcer when: CardDisappeared send: #onDisappear to: self.`

To add event to an element, you first need to subclass 'BlEventListener' and
override the event you want to manage. You then add your event handler to your
bloc element with method 'addEventHandler'. Event are bloc announcement method
and classes.

- event handling (`BlEvent` and children)
- handling mouse and keyboard event (shortcut, keybinding, etc...)
=> subclass `BlEventListener`, overwrite method which handle event, and add
instance of the class to your BlElement with method addEventHandler:

Keyboard shortcut: BlShortcut

- Drag&Drop
Explore BlBaseDragEvent and subclasses.

Take a look at `BlEventHandler|` comments:

BlEventHandler: I am a scriptable event handler that allows users to assign a valuable action to the event of chosen type.

```smalltalk
BlEventHandler
	on: BlClickEvent
	do: [ :anEvent | self inform: 'Click!' ]
```




### Keymap at system platform level

KeyboardKey class, which is used when a key on the keyboard is pressed.

It's used at Morphic level, when your morph want to catch a specific keyboard
event.

It can be used by Keymapping (KMSingleKeyCombination & KMShortcutPrinter) as an
equivalent of `$a asKeyCombination`

It's used ultimately by BlKeyCombinationBuilder to build keyboard shortcut
in bloc. It's also used to convert key from event by BlOSWindowEventHandler.

### Combination from Bloc framework

Bloc come with its own keymapping framework.
BlShortcutWithAction would be the equivalent of KMKeymap.

BlShortcutWithAction new
    combination: (BlKeyCombination builder alt; control; key: KeyboardKey C; build);
    action: [ flag := true ].



### Drag and Drop

The drop event should be applied to the element that will receive the dragged content.
`Elt1` uses the dragEnd to know when the drag has ended.
`Elt2` uses the dropEvent to know when something try to be dropped on it.
If you drop `elt1` on `elt2`, `elt2` opens an inspector on `elt1`.

```
| elt1 elt2 space |
elt1 := BlElement new 
	background: Color lightBlue;	position: 100 asPoint;	addEventHandler: BlPullHandler new disallowOutOfBounds;	id: #elt1;	yourself.
	elt2 := BlElement new 
	background: Color red;	size: 100 asPoint;	position: 200 asPoint;	id: #elt2;	yourself.
	space := BlSpace new.space root addChildren: { elt1 . elt2 }. elt2 
	addEventHandlerOn: BlDropEvent 
	do: [ :evt | evt gestureSource inspect ].elt1 
	addEventHandlerOn: BlDragEndEvent 
	do: [ :evt | ]. space show.
```


