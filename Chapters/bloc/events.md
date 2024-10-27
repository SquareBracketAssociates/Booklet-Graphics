## Event handling

In graphical applications, whenever a user interacts with the application (BlElements),
an event is said to have been occurred. For example, clicking on a button, moving
the mouse, entering a character through keyboard, selecting an item from list, etc.
are the activities that causes an event to happen.

Bloc provides support to handle a wide varieties of events. The class named *BlEvent* is the base class for an event. An instance of any of its subclass is an event. Some of them are are listed below.

- **Mouse Event**  − This is an input event that occurs when a mouse is clicked. It includes actions like mouse clicked, mouse pressed, mouse released, mouse moved, etc.

- **Key Event** − This is an input event that indicates the key stroke occurred on an element. Those events includes actions like key pressed, key released and key typed.

- **Drag Event** − This occurs when an Element is dragged by mouse. It includes actions like drag entered, drag dropped, drag entered target, drag exited target, drag over, etc.

Event Handling is the mechanism that controls the event and decides what should happen, if an event occurs. This mechanism has the code which is known as an event handler that is executed when an event occurs.

Bloc provides handlers and filters to handle events. Every event has:

- Target − The element on which an event occurred.
- Source - Used in drag&drop to identify the source element.
- Type − Type of the occurred event

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

`addEventHandlerOn:do:` returns the new handler so that we can store to remove it in case. Add a #yourself send after to return a BlElement.

`when:do:` is now deprecated and rewritten as `addEventHandlerOn:do:`
SD: we should update the following

Instead of using addEventHandlerOn:do: you can also see users of `addEventHandler:`.

```
deco addEventHandler: (BlEventHandler 
						on: BlMouseLeaveEvent
	 					do: [ :event | event currentTarget border: BlBorder empty ]).
```

You can also add event filter:

`addEventFilterOn:do:` returns the new handler so that we can store to remove it in case. 

Event filters receive events before general event handlers. Their main goal is
to prevent some specific events from being handled by basic handlers. For that
custom filters should mark event as ==consumed: true== which instantly stops propagation

In the example below, the element will catch `BlMouseEnterEvent`. If you uncomment
`anEvent consumed: true`, you'll only have the filtered version. If the event keep
propagating, both will be called, filter and then handler.

```smalltalk
addEventFilterOn:  BlMouseEnterEvent do: [ :anEvent | "anEvent consumed: true". self inform: 'event filter'];
addEventHandlerOn:  BlMouseEnterEvent do: [ :anEvent | "anEvent consumed: true". self inform: 'event handler' ];
```

### About event bubbling

#### Event Capturing Phase
This event travels to all elements in the dispatch chain (from top to bottom), starting from *BlSpace*. If any of these element has a handler for this event, it will be executed, until it reach the target element which can process it.

#### Event Bubbling Phase
In the event bubbling phase, the event is travelled from the target element to BlSpace (bottom to top). If any of the element in the event dispatch chain has a handler registered for the event, it will be executed. When the event reaches the BlSpace element the process will be completed.

#### Event Handlers
Event handlers are those which contains application logic to process an event. An element can register more than one handler.

You can stop the event propagation in an event handler by adding
`anEvent consumed: true.`

We should check `example_mouseEvent_descending_bubbling`

![event propagation](figures/EventPropagation.png)

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

1. Subclass `BlEventListener` and override all method that match specific event you want to catch, for example `BlEventListener>>clickEvent:`
2. Add your listener to your BlElement with method: `BlElement>>addEventHandler:`

This allows complete flexibility. 

### Using event Handler

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

how do I remove all eventHandlers from a Blelement?

```smalltalk
el removeEventHandlersSuchThat: [:e|true] 
```

or

```smalltalk
el eventDispatcher removeEventHandlers
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

Shortcut represents a keyboard shortcut that can be registered to any arbitrary BlElement.
Shortcut consist of an Action that is evaluated when a Shortcut is triggered and BlKeyCombination that describes when shortcut should be triggered. A combination is a logical formula expression that is composed of various key combinations such as alternative, compulsory or single key. See subclasses of BlKeyCombination.
Additionally, shortcut may provide its optional textual description and name.

A shortcut can be added or removed from the element by using BlElement>>#addShortcut: or BlElement>>#removeShortcut: methods.
BlElement>>#shortcuts message can be sent to an element in order to access a list of all registered shortcuts.

BlShortcutWithAction extend BlBasicShortcut with ability to specify a runtime action that should be evaluated when shortcut is performed. In addition to that, shortcuts with action allow users to customise the name and description of the shortcut.

BlShortcutWithAction new
    combination: (BlKeyCombination builder alt; control; key: KeyboardKey C; build);
    action: [ flag := true ].

	space addEventHandlerOn: BlKeyDownEvent
			 do: [ :evt |
				 (evt key = KeyboardKey altLeft or: [
					  evt key = KeyboardKey altRight ]) ifTrue: [
					 self inform: 'source 1 alt key pressed' ] ].


### Drag and Drop

Full drag&drop example

```
| source1 source2 target space offset |
space := BlSpace new.
source1 := BlElement new size: 100 @ 100; background: Color red; border: (BlBorder paint: Color gray width: 2); position: 0@0.
source2 := BlElement new size: 100 @ 100; background: Color purple; border: (BlBorder paint: Color gray width: 2); position: 150@0.
target := BlElement new size: 100 @ 100; background: Color blue; border: (BlBorder paint: Color gray width: 2); position: 500 @ 500.

space root addChildren: { source1. source2. target. }.

source1 addEventHandlerOn: BlDragStartEvent do: [ :event | event consumed: true. self inform: 'source1 BlStartDragEvent'. 
	offset := event position - source1 position. 
	source1 removeFromParent.].
source1 addEventHandlerOn: BlDragEndEvent do: [ :event | event consumed: true. self inform: 'source1 BlDragEndEvent'. 	 ].
source1 addEventHandlerOn: BlDragEvent do: [ :event | event consumed: true. "self inform:  'source1 BlDragEvent'."
	source1 position: event position - offset.
	source1 hasParent ifFalse: [space root addChild: source1].
	source1 preventMeAndChildrenMouseEvents ].

source2 addEventHandlerOn: BlDragStartEvent do: [ :event | event consumed: true. self inform: 'source2 BlStartDragEvent'. 
	offset := event position - source2 position.
	source2  removeFromParent.].
source2 addEventHandlerOn: BlDragEndEvent do: [ :event | event consumed: true. self inform: 'source2 BlDragEndEvent'. ].
source2 addEventHandlerOn: BlDragEvent do: [ :event | event consumed: true. "self inform:  'source BlDragEvent'."
	source2 position: event position - offset.
	source2 hasParent ifFalse: [space root addChild: source2].
	source2 preventMeAndChildrenMouseEvents ].

target addEventHandlerOn: BlDropEvent do: [ :event | event consumed: true. self inform: 'target BlDropEvent'.
	event gestureSource background paint color = (Color red)
			ifTrue: [ self inform: 'drop accepted' ]
			ifFalse: [ self inform: 'drop rejected'. event gestureSource position: 100 @ 400; allowMeAndChildrenMouseEvents] ].
target addEventHandlerOn: BlDragEnterEvent do: [ :event | event consumed: true. self inform: 'target BlDragEnterEvent' ].
target addEventHandlerOn: BlDragLeaveEvent do: [ :event | event consumed: true. self inform: 'target BlDragLeaveEvent' ].

space show
```

### BlPullHandler


```
parent := BlElement new background: Color lightGreen; size: 600 asPoint.
elt := BlElement new background: Color red; size: 100 asPoint.
parent addChild: elt.

elt addEventHandler: BlPullHandler new disallowOutOfBounds.

parent openInSpace.
```

