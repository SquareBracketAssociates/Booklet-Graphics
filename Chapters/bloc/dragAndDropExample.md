## Drag and Drop

Bloc supports drag-and-drop of elements. In this chapter, we explain the basics of drag-and-drop with Bloc events. We present some custom event handles encapsulated drag-and-drop behavior. Finally we present some how the element behind an element can also get event in addition to the element being dragged.

### Three basic events

To start understanding the Drag-and-drop process, you must know the following three basic events:

- `BlDragStartEvent`: This event is raised at the start of the drag process. It is sent when you move the cursor for the first time after having a `MouseDownEvent`.
- `BlDragEvent`: This event is sent whenever you move the cursor during the drag process. Notice that it is required that the `BlDragStartEvent` is consumed first, else the `BlDragEvent` is not raised.
- `BlDragEndEvent`: This event ends the drag process. It is sent when you lift your cursor (i.e., after a `MouseUpEvent` event) 


### First drag and drop

Using the basic events mentioned earlier, we can write a simple drag-and-drop example as shown by the following snippet:

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


Here we use an `offset` variable whose value is set when starting to drag the element. We use this value to compute the relative position since the beginning of the start and we redefine the element's position according to the mouse position and have a smooth drag and drop. 

### Custom Drag Handlers

Bloc supports the possibility of defining more advanced ways to support drag-and-drop. This is based on the use of `BlCustomEventHandler` definition.

Let us look at the definition of `BlDragHandler`

#### BlDragHandler 

Bloc defines a custom event handler named `BlDragHandler`. It supports simple drag-and-drop without having to duplicate the logic presented previously.

As an EventHandler you can simply add it to an Element and use it to start dragging the Element.



```st
element := BlElement new background: Color lightGreen.
element addEventHandler: BlDragHandler new.

element openInSpace
```

You can see the default behavior when dropping the element is to bring it back to its original position.



#### PullHandler
Another possibility is to use another `BlCustomEventHandler`: the `BlPullHandler` it has a more detailed API allowing you more behaviors.

Adapting the same snippet, we can have a basic drag and drop with the `PullHandler` however, here the default drop behavior is to leave the element right where it currently is.

```st
element := BlElement new background: Color lightGreen.
element addEventHandler: BlPullHandler new.

element  openInSpace
```
#### Out of the bounds strategy with `BlPullHandler`

This handler allows you to confine or not your draggable element into its parents bounds using the messages `disallowOutOfBounds`/`allowOutOfBounds`.

```st
element := BlElement new background: Color lightGreen.
element addEventHandler: BlPullHandler new.

parent := BlElement new 
		size: 200@200; 
		border: (BlBorder paint: Color red width: 2); yourself.
parent addChild: element.

parent  openInSpace
```

![Dragging an element outside its parent using the `allowOutOfBounds` configuration message.](figures/dragPullOutOfBounds.png)


#### Different dragging strategies with `BlPullHandler`
You can also have different dragging strategies such as dragging only horizontally or vertically. The default strategy is called 'free' and those strategies can be switched dynamically.

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
			pullHandler beHorizontal ]
		ifFalse: [ 
			strategy = 'horizontal' 
				ifTrue: [ 
					strategy := 'vertical'.
					element background: Color lightRed.
					pullHandler beVertical ] 
				ifFalse: [ 
					strategy := 'free'.
					element background: Color lightGreen.
					pullHandler beFree ] ]
].

element  openInSpace
```


### Events for the environment

There are other events related to Drag-and-Drop. However they mainly concern the environment in which an element is dragged.

These events are: 

- `BlSpaceDragLiftEvent` 
- `BlDropEvent`
- `BlDragEnterEvent`
- `BlDragLeaveEvent`


#### `BlSpaceDragLiftEvent`

Let's start with `BlSpaceDragLiftEvent` that acts similarly to the `BlDragStartEvent`: it is sent once at the beginning of the drag phase but contrary to the `BlDragStart`, `BlSpaceDragLift` is an event sent to the space itself.

The following snippet shows that both an element and its space will receive different events. 
The code illustrates this by making the child changes its border while the space changes the child background color but only once at the beginning of the drag.

```st
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

#### BlDropEvent

The `BlDropEvent` is an event received by the element behind the dragged element. This event is, of course, sent at the end of the process after you drop the element.

The following snippet defines two elements: a child (a red box) and target (a green large box). We define the handlers so that one drop reception the background of the target changes color. Then we just define some traces showing that the child should receive the `BlDragEndEvent` event and that it should not receive `BlDropEvent`.

```st
| child target space |
child := BlElement new
	background: Color red;
	addEventHandler: BlDragHandler new.

target := BlElement new
	background: Color lightGreen;
	border: (BlBorder paint: Color green width: 3);
	size: 200@200;
	position: 200@200.

space := BlSpace new.
space root addChildren: { target . child }.

target 
	addEventHandlerOn: BlDropEvent 
	do: [
		'Drop on target' traceCr.
		target background: Color random ].

child
	addEventHandlerOn: BlDragEndEvent
	do: [ 'Drag Ended' traceCr ].

"This should never trigger only target will receive this DropEvent"

child 
	addEventHandlerOn: BlDropEvent 
	do: [ 'Dropped' traceCr].

space show
```


![]{figures/dragandropTarget.png}

#### `BlDragEnterEvent` and `BlDragLeaveEvent`

The last two events are quite similar as `BlDragEnterEvent` and `BlDragLeaveEvent` check if your cursor enters or leaves the bounds of an Element while dragging. However, it is **important** to know these events are sent to the element directly under the cursor during the drag process. This means that because we usually drag an element that follows the cursor, it won't be possible for the cursor to know if it entered another element's bounds behind.

The following snippet shows this behavior:
It creates a light green and a target light red element 

```st
element := BlElement new background: Color lightGreen.
element addEventHandler: BlPullHandler new.

target := BlElement new 
	background: Color lightRed; 
	size: 100@100; 
	position: 200@200.

target 
	addEventHandlerOn: BlDragEnterEvent 
	do: [ :event |
		event consume.
		target border: (BlBorder paint: Color black width: 3) ].

target 
	addEventHandlerOn: BlDragLeaveEvent 
	do: [ :event |
		event consume.
		target border: BlBorder empty ].

space := BlSpace new.
space root addChildren: { target. element }.
space show
```

In this snippet, we add a border to the red element whenever the green element enters its bounds while dragging, and we remove this border when it leaves.

We can see that the border doesn't appear as intended (unless you drag too quickly the element meaning the cursor will enter the parent first and then consider leaving it when the green element will be brought to the right position).

To avoid this, we can make the green element 'transparent to the events' when starting to drag it. Meaning the cursor will know 'see through' the green element and send the correct enter and leave events to the red one. For this we can simply use the messages `preventMouseEvents` and `allowMouseEvents` by adding the next lines :

```st
element 
	addEventHandlerOn: BlDragStartEvent 
	do: [ :event |
		event consume.
		element preventMouseEvents ].

element 
	addEventHandlerOn: BlDragEndEvent 
	do: [: event |
		event consume.
		element allowMouseEvents ]. 
```

This example now works as we wanted, adding and removing a border to the red element when the cursor enters it while dragging. 
Remember this looks if the **cursor** enters and leaves the bounds and not if the green element itself enters or leaves. To see if two elements 'collide' you need to use the `BlBounds` API.

### Keyboard events 

In this section, we present an example where we can add some keyboard events during the drag process to change its behavior dynamically

The following example lets us drag an element freely, however we add some event handlers on keyboard events and check if the shift or alt key is pressed, these will dynamically change the way the handler drags the element (as well as changing the element's background for visual clarity)

```st
| handler child space strategy |
handler := BlPullHandler new.
child := BlElement new
                size: 100@100;
                background: Color red;
                addEventHandler: handler.



child addEventHandlerOn: BlDragStartEvent do: [ :evt |
	child requestFocus ].

child addEventHandlerOn: BlDragEndEvent do: [ :evt |
	child loseFocus ]. 

child addEventHandlerOn: BlKeyDownEvent do: [ :evt |
	handler beFree.
	child background: Color red.

	evt modifiers isShift ifTrue: [
		handler beHorizontal. 
		child background: Color green].

	evt modifiers isAlt ifTrue: [ 
		handler beVertical.
		child background: Color blue. ].

	(evt modifiers isShift and: [ evt modifiers isAlt]) ifTrue: [ 
		child background: Color black.
		child removeEventHandler: handler ]
].

child addEventHandlerOn: BlKeyUpEvent do: [ :evt |
	(child hasEventHandler: handler) ifFalse: [ child addEventHandler: handler ].
	handler beFree.
	child background: Color blue.

	evt modifiers isShift ifTrue: [ 
		handler beHorizontal.
		child background: Color green ].

	evt modifiers isAlt ifTrue: [ 
		handler beVertical.
		child background: Color blue ].

	(evt modifiers isShift and: [ evt modifiers isAlt ]) ifTrue: [ 
		child background: Color black.
		child removeEventHandler: handler ]
].
child openInSpace.
```

One thing important in this snippet is to use the messages `requestFocus` and `loseFocus` so that keyboard events can be listened and we send them only at the start and end of the drag and drop meaning this behavior can §only appear during this process.

The example is not exactly perfect nor practical but it serves as a good example on how to dynamically change the drag behavior with keyboard events.

### Other Examples 

You can find more examples/experiments on Drag-and-Drop in the class `BlDragAndDropExamples`.
We suggest looking at the class `BlDragAndDropLetterExampleDemo` that shows an example of a letter sorter with letters reacting if hovering the 'vowel' or 'consonant' areas.
