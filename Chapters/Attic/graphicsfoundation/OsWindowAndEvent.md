# Event handling on Pharo

- *SDL2MappedEvent allSubclasses* implement the visitor pattern, with OSSDL2BackendWindow
is class being visited

events are then managed through an event handler, *OSWindowMorphicEventHandler*
which is a subclass of *OSWindowEventVisitor*. Then *OSEvent allSubclasses* implement again the
visitor pattern, with OSWindowMorphicEventHandler being visited.

To create your own event handler, subclass *OSWindowEventVisitor* and implement the
*visitXXXEvent* method, like *visitMouseMoveEvent*

Morphic events are managed with OSWindowMorphicEventHandler, which convert event
to format expected by Morphic.

1. return true to accept specific events in method in category *event handling*
2. implement logic to this events by overriding method in category *event processing*

TODO: define your own event handler for your morph.

```smalltalk
eventHandler: anEventHandler 
 "Note that morphs can share eventHandlers and all is OK. "
 self assureExtension eventHandler: anEventHandler
```

Event handler is created and associated in the open method:

 window := OSWindow createWithAttributes: attrs.
 window eventHandler: (self createEventHandler).

 SDL2AthensDrawingExample >> createEventHandler
  ^ OSWindowAthensDrawingExampleEventHandler new
    athensExample: self

   smalltalk
A newly created OSWindow instance can be used and controlled by application.
To handle events (mouse/keyboard) of newly created window, one must
bind own event handler to it (#eventHandler:) which must understand #handleEvent: message.

To render on window's surface, first application must obtain an OSWindowRenderer instance.
Currently there's two kinds of renderers available:
• form renderer (to use existing form for updating window's contents)
• opengl renderer (to render using OpenGL).

OSWindowEventVisitor -> OSWindowAthensExampleEventHandler -> OSWindowAthensExampleEventHandler
has 1 instance variable

- athensExample

Define 4 method (through inheritance):

- visitMouseButtonPressEvent: anEvent
- visitMouseButtonReleaseEvent: anEvent
- visitMouseMoveEvent: anEvent
- visitWindowCloseEvent: anEvent

The specific events are coming from operating system and converted to corresponding
OSEvent subinstance(s) in order to handle them. Events can implement a default
action, which will be performed after dispatch on event handling,  unless they
are suppressed using #suppressDefaultAction message.

Chain of event delivery (OSMouseMoveEvent in this example).

```txt
##############################################################
# setup
##############################################################
# OSSDL2Driver >> initialize
#  self setupEventLoop
#  
#  
# OSSDL2Driver >> setupEventLoop
#  self eventLoopProcessWithVMWindow (forked by VM)
##############################################################  

##############################################################
# processing
##############################################################
# OSSDL2Driver >> eventLoopProcessWithVMWindow
#  |event|
#  event := SDL_Event new
#  self processEvent: event
# 
#
# OSSDL2Driver >> processEvent: sdlEvent
#  | event |
#  event := self convertEvent: sdlEvent
#
# 
# OSSDL2Driver >> convertEvent: sdlEvent
#  | mappedEvent window |
#  mappedEvent := sdlEvent mapped
#  window := WindowMap at: mappedEvent windowID
#  window handleNewSDLEvent: mappedEvent
#
#
# OSSDL2BackendWindow >> handleNewSDLEvent: sdlEvent
#  ^ sdlEvent accept: self
#
#
# SDL_MouseMotionEvent >> accept: aVisitor
#  ^ aVisitor visitMouseMotionEvent: self
#
#
# OSSDL2BackendWindow >> visitMouseMotionEvent: sdlEvent
#  | osEvent |
#  osEvent := OSMouseMoveEvent for: osWindow
#  ^ osEvent deliver
#
#
# OSEvent >> deliver
#  ^ window deliverEvent: self
#  
#  
# OSWindow >> DeliverEvent: anEvent
#  eventHandler ifNotNil: [ eventHandler handleEvent: anEvent ]
#
# In the open method, we have: window eventHandler: (self createEventHandler)
# which is defined as
# OSWindowAthensExampleEventHandler new athensExample: self
#
# OSWindowAthensDrawingExampleEventHandler >> handleEvent: anEvent
#
# inherit code from
# OSWindowEventVisitor >> handleEvent: anEvent
#  anEvent accept: self
#
#
# OSMouseMoveEvent >> accept: aVisitor
#  ^ aVisitor visitMouseMoveEvent: self
#  
#  
# OSWindowAthensExampleEventHandler >> visitMouseMoveEvent: anEvent
#  "your code reacting to event here"
#  athensExample moveAt: anEvent position
##############################################################  

##############################################################
# event conversion
##############################################################
# In OSSDL2Driver >> convertEvent: sdlEvent, we have: mappedEvent := sdlEvent mapped.
#
# SDL_Event >> mapped
#  ^ (EventTypeMap at: self type ifAbsent: [ ^ self unknownEvent ]) fromSdlEvent: self
#
# EventTypeMap is defined in the method
# SDL_Event class >> initializeEventTypeMap
#  "self initializeEventTypeMap"
#  EventTypeMap := Dictionary new
#  SDL2MappedEvent  allSubclassesDo: [ :cls |
#   | eventType |
#   eventType := cls eventType
#   eventType ifNotNil: [ EventTypeMap at: eventType put: cls ] ]
# ]
#
# And for SDL_MouseMotionEvent class eventType
# ^ SDL_MOUSEMOTION
# which link SDL enum to Pharo class type.
#
#
# SDL2MappedEvent class >> fromSdlEvent: event
#  ^  self new setHandle: event getHandle
# which return an instance of the SDL2 event class.
##############################################################
```
