### Drag and Drop Example

```
 | surface elt counter|
    counter :=1.
    elt := BlElement new
               size: 20 @ 20;
               geometry: (BlPolygonGeometry vertices: {
                                (10 @ 5).
                                (11.5 @ 9).
                                (15 @ 9).
                                (12.5 @ 11).
                                (13.5 @ 15).
                                (10 @ 13).
                                (6.5 @ 15).
                                (7.5 @ 11).
                                (5 @ 9).
                                (8.5 @ 9) });
               background: (Color red alpha: 0.5);
               border: (BlBorder paint: Color blue width: 1).

    surface := BlElement new
                   size: 400 @ 400;
                   geometry: BlSquareGeometry new;
                   background: (Color pink alpha: 0.2);
                   border: (BlBorder paint: Color orange width: 4).

    surface addChild: elt.
    elt position: 200 @200.

    surface addEventHandler: (BlEventHandler
             on: BlMouseWheelEvent
             do: [ :anEvent |
                 anEvent consumed: true.
                 anEvent isScrollDown ifTrue:  [ counter := counter- 0.5 ].
                anEvent isScrollUp ifTrue:  [ counter := counter + 0.5 ].
                elt transformDo: [ :t | t scaleBy: counter].]).

    surface openInNewSpace.
    ^ surface
```	
	
I want to do different things in the BlDragEvent handler depending on whether the ALT key is currently being pressed (snapping vs no snapping). But the event modifiers list is always empty in all drag event handlers, no matter what I do. Is there any way I can poll whether the ALT key is down right now, or otherwise check this?

You can listen to the alt key at the space level by adding

```
space addEventHandler: (BlEventHandler on: BlKeyDownEvent  do: [ :evt | (evt key = KeyboardKey altLeft or: [ evt key = KeyboardKey altRight ]) ifTrue: [ self inform: 'space alt key pressed' ] ]).
```
 
This event will be caught even if you're in the middle of a BlDragEvent. You can then adapt your logic. Alt being a keyboard event, it must be managed by listening to the proper event raised. As far as I can see in Pharo, anEvent modifiers is only set in the context of keyboard handling. 
Note that if you want to create keyboard shortcut, you should use BlShorcutWithAction, like: 

```
BlShortcutWithAction new 
	combination: (BlKeyCombination builder alt; control; key: KeyboardKey C;  build); 
	action: [ flag := true ].
```

