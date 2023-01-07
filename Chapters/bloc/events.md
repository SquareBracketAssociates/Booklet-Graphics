# introductive example

```smalltalk
eventExample
<gtExample>
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

toto when: BlMouseEnterEvent do: [ :anEvent |
  anEvent consumed: true.
  toto background: (Color red alpha:0.2) ].
  
 toto when: BlMouseLeaveEvent do: [ :anEvent |
  anEvent consumed: true.
  toto background: (Color blue alpha:0.2) ].
^toto
```

## other example

```smalltalk
eventExampleMouseMove
<gtExample>
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
  anEvent consumed: true.
  elt relocate: (anEvent localPosition + (10@10)) ].
  
surface when: BlMouseLeaveEvent do: [ :anEvent |
  anEvent consumed: true.
  elt relocate: -20@(-20) ].
^surface
```

## events definition

The announcement framwork is an event notification framework. Compared to "traditional" Smalltalk event systems in this new framework, an event is a real object rather than a symbol. Announcement is the superclass for events that someone might want to announce, such as a button click or an attribute change. Typically you create subclasses for your own events you want to announce.

Events are defined as subclasses of {{gtClass:name=BlEvent|expanded}}

 An event someone might want to announce, such as a button click or an attribute change, is defined as a subclass of the abstract superclass Announcement. The subclass can have instance variables for additional information to pass along, such as a timestamp, or mouse coordinates at the time of the event, or the old value of the parameter that has changed. To signal the actual occurrence of an event, the "announcer" creates and configures an instance of an appropriate announcement, then broadcasts that instance. Objects subscribed to receive such broadcasts from the announcer receive a broadcast notification together with the instance. They can talk to the instance to find out any additional information about the event that has occurred.!

## managing events

### simple case for BlElement

1. use method: {{gtMethod:name=BlElement>>when:do:}}
2. anEventClass can be a subclass of {{gtClass:name=BlUIEvent}}

### complex case - reusing event handling logic with BlEventListener

1. Subclass {{gtClass:name=BlEventListener}} (which is a subclass of {{gtClass:name=BlBasicEventHandler}} and override all method that match specific event you want to catch, for example {{gtMethod:name=BlEventListener>>clickEvent:}}
2. Add your listener to your BlElement with method: {{gtMethod:name=BlElement>>addEventHandler:}}

### using event Handler

Take a look at {{gtClass:name=BlEventHandler|full}} comments:

BlEventHandler: I am a scriptable event handler that allows users to assign a valuable action to the event of chosen type.

```smalltalk
BlEventHandler
 on: BlClickEvent
 do: [ :anEvent | self inform: 'Click!' ]
```

## underlying mecanism

BlEventDispatcher -> announcer qui dispatch event
BlSpaceEventListener >> handleEvent

BlMouseEnterEvent

double dispatch: Classe de base: BlEvent
BlMouseEnterEvent >> sendTo: anObject
 anObject mouseEnterEvent: self

BlEventListener >> mouseEnterEvent: anEvent qui peut être spécialisé par une sous-classe.

On pharo side, using OSWindow
OSWindowMorphicEventHandler => gère les évènements au niveau OS Windows, qui fait le lien avec SDL2.
BlMorphicEventHandler => convertit les évènements Morphic en évenements Bloc
OSEvent -> Announcement coté Pharo
BlEvent -> announcement coté Bloc/GToolkit
