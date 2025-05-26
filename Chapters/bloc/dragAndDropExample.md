### Drag and Drop

Bloc has basic support for drag-and-drop which needs to be further improved. In this chapter we try to explain the basics of drag-and-drop with Bloc events and we display some valuable examples.

#### Three basic events

To start understanding the Drag-and-drop process, you must acknowledge the following 3 basic events:

- BlDragStartEvent : Starts the drag process, sent when you move the cursor for the first time after having a MouseDownEvent. 
- BlDragEvent : sent whenever you move the cursor during the drag process. **Needs the BlDragStartEvent to be consumed in order to be sent**.
- BlDragEndEvent : Ends the drag process, sent when you lift your cursor (i.e. send a MouseUpEvent) 

#### First drag and drop

Using the basic events we can write the simplest drag and drop snippet 

```st
element := BlElement new background: Color lightGreen.
offset := 0.
element addEventHandlerOn: BlDragStartEvent do: [ :event |
	offset := event position - element position.
	event consume. ].

element addEventHandlerOn: BlDragEvent do: [ :event | 
	event consume.
	element position: event position - offset.].

element openInSpace 
```

Here we add a small offset variable that is defined when starting to drag the element so that we can redefine the element's position according to the mouse position and have a smooth drag and drop. 

#### Custom Drag Handlers

##### DragHandler 

In Bloc, there is a an implementation of an object called DragHandler. This object is a a CustomEventHandler aiming to deal with basic drag and drop without having to write again the lines above.

As an EventHandler you can simply add it to an Element and use it to start dragging the Element.

```st
element := BlElement new background: Color lightGreen.

element addEventHandler: BlDragHandler new.

element openInSpace
```
However you can see the default behavior when dropping the Element is to bring the element back to its original position.

##### PullHandler

There is also the BlPullHandler which has a more detailed API allowing you more behaviours.

Adapting the same default snippet, we can have a basic drag and drop with the PullHandler however, here the default drop behaviour will leave the element right where it currently is.

```st
element := BlElement new background: Color lightGreen.

element addEventHandler: BlPullHandler new.

element  openInSpace
```

This handler allows you to confine or not your draggable element into its parents bounds using the messages `disallowOutOfBounds`/`allowOutOfBounds`.

```st
element := BlElement new background: Color lightGreen.

element addEventHandler: BlPullHandler new.

"parent := BlElement new size: 200 asPoint; border: (BlBorder paint: Color red width: 2); yourself.

parent addChild: element."

element  openInSpace
```

You can also have different dragging strategies such as dragging only horizontally or vertically. The default strategy is called 'free' and those strategies can me switch dynamically.

In the following example, you can click the element to switch to the next strategy.

```st
element := BlElement new background: Color lightGreen.

pullHandler := BlPullHandler new.

strategy = 'free'.
element addEventHandler: pullHandler.

element addEventHandlerOn: BlClickEvent do: [ :event |
	event consume.
	strategy = 'free'
		ifTrue: [ 
            strategy := 'horizontal'.
			element background: Color lightBlue.
			pullHandler beHorizontal
        ]
		ifFalse: [ 
			strategy = 'horizontal' 
            ifTrue: [ 
                strategy := 'vertical'.
				element background: Color lightRed.
				pullHandler beVertical
            ] 
            ifFalse: [ 
				strategy := 'free'.
				element background: Color lightGreen.
				pullHandler beFree
            ]
        ]
    ].

element  openInSpace
```

#### Events for the environment

Other Events related to Drag and Drop are available in Bloc but they mainly concern the environment in which an Element is dragged.

These events are: 
- BlSpaceDragLiftEvent 
- BlDropEvent
- BlDragEnterEvent
- BlDragLeaveEvent

Let's start with `BlSpaceDragLiftEvent` that acts similar to the `BlDragStartEvent` meaning it is sent once at the beginning of the drag phase but contrary to the DragStart, the SpaceDragLift is an event sent to the space

```st
"SpaceDragLiftEvent seems to be the same as DragStartEvent but sent to the space instead of the dragged Element"

| child space border |
child := BlElement new
                background: Color random;
                addEventHandler: BlDragHandler new.

space := BlSpace new.
space root addChild: child.

child addEventHandlerOn: BlDragEvent do: [
    border := BlBorder paint: Color random width: 5.
    child border: border ].
"event sent during each frame of the drag"
space
    addEventHandlerOn: BlSpaceDragLiftEvent
    do: [ child background: Color random ].
"event sent at the beginning of the drag"

space show
```

---

Then the `BlDropEvent` is an event received by the element behind the dragged element. This event is of course sent at the end of the process after you drop the element

Here is an example snippet:

```st
"sends correctly (and inform) a DropEvent to the target area when dropping the element on it"
| child target space |
child := BlElement new
                background: Color red;
                addEventHandler: BlDragHandler new.

target := BlElement new
                background: Color lightGreen;
                border: (BlBorder paint: Color green width: 3);
                size: 200 asPoint;
                position: 200 @ 200.

space := BlSpace new.

space root addChildren: {
        target.
        child }.

target addEventHandlerOn: BlDropEvent do: [
    'Drop on target' traceCr.
    target background: Color random ].

child
    addEventHandlerOn: BlDragEndEvent
    do: [ 'Drag Ended' traceCr ].

child addEventHandlerOn: BlDropEvent do: [ 'Dropped' traceCr].
"This should never trigger only target will receive this DropEvent"
space show
```

---

The last 2 events are quite similar as `BlDragEnterEvent` and `BlDragLeaveEvent` check if your cursor enters ou leaves the bounds of an Element while dragging. However, it is **important** to know these events are sent to the element directly under the cursor during the drag process. This means that because we usually drag an element that follows the cursor, it won't be possible for the cursor to know if it entered another element's bounds behind.

The following snippet show this behaviour:

```st
element := BlElement new background: Color lightGreen.

element addEventHandler: BlPullHandler new.

target := BlElement new background: Color lightRed; size: 100 asPoint; position: 200 asPoint.

border := BlBorder paint: Color black width: 3. 

target addEventHandlerOn: BlDragEnterEvent do: [ :event |
	event consume.
	target border: border. ].

target addEventHandlerOn: BlDragLeaveEvent do: [ :event |
	event consume.
	target border: (BlBorder empty) ].

space := BlSpace new.
space root addChildren: { target. element }.
space show
```

In this snippet, we add a border to the red element whenever the green element enters its bounds while dragging, and we remove this borders when it leaves.
We can see that to border doesn't appears as intended (unless you drag too quickly the element meaning the cursor will enter the parent first and then consider leaving it when the green element will be brought to the right position).

To avoid this we can make the green element 'transparent to the events' when starting to drag it. Meaning the cursor will know 'see through' the green element and send the correct enter and leave events to the red one. For this we can simply use the messages `preventMouseEvents` and `allowMouseEvents` by adding the next lines :

```st
element addEventHandlerOn: BlDragStartEvent do: [ :event |
	event consume.
	element preventMouseEvents ].

element addEventHandlerOn: BlDragEndEvent do: [ :event |
	event consume.
	element allowMouseEvents ]. 
```

This example now works as we wanted, adding and removing a border to the red element when the cursor enters it while dragging. 
Remember this looks if the **cursor** enters and leaves the bounds and not if the green element itself enters or leaves. To see if 2 elements 'collide' you need to use the `BlBounds` API.

#### Include keyboard events 

In this section, we present an example where we can add some keyboard events during the drag process to change its behaviour dynamically

The following example lets us drag an element freely, however we add some event handlers on keyboard events and check if the shift or alt key is pressed, these will dynamically change the way the handler drags the element (as well as changing the element's background for visual clarity)

```st
| handler child space strategy |
handler := BlPullHandler new.
child := BlElement new
                size: 100 asPoint;
                background: Color red;
                addEventHandler: handler.

child openInSpace.

child addEventHandlerOn: BlDragStartEvent do: [ :evt |
    child requestFocus ].

child addEventHandlerOn: BlDragEndEvent do: [ :evt |
    child loseFocus ]. 

child addEventHandlerOn: BlKeyDownEvent do: [ :evt |
    handler beFree.
    child background: Color red.

    evt modifiers isShift ifTrue: [
        handler beHorizontal. 
        child background: Color green. ].
    
    evt modifiers isAlt ifTrue: [ 
        handler beVertical.
        child background: Color blue. ].
    
    (evt modifiers isShift and: [ evt modifiers isAlt ]) ifTrue: [ 
        child background: Color black.
        child removeEventHandler: handler]
    
].

child addEventHandlerOn: BlKeyUpEvent do: [ :evt |
    (child hasEventHandler: handler) ifFalse: [ child addEventHandler: handler ].
    handler beFree.
    child background: Color red.

    evt modifiers isShift ifTrue: [ 
        handler beHorizontal.
        child background: Color green. ].
    
    evt modifiers isAlt ifTrue: [ 
        handler beVertical.
        child background: Color blue. ].
    
    (evt modifiers isShift and: [ evt modifiers isAlt ]) ifTrue: [ 
        child background: Color black.
        child removeEventHandler: handler ]
    
].
```

One thing important in this snippet is to use the messages `requestFocus` and `loseFocus` so that keyboard events can be listened and we send them only at the start and end of the drag and drop meaning this behaviour can only appear during this process.

The example is not exactly perfect nor practical but it serves as a good example on how to dynamically change the drag behaviour with keyboard events.

#### Other Examples 

You can find more examples/experiments on Drag and Drop in the class `BlDragAndDropExamples`.
We suggest looking at the class `BlDragAndDropLetterExampleDemo` that shows an example of a letter sorter with letters reacting if hovering the 'vowel' or 'consonant' areas.
