## Bloc Architecture

A graphic element (`BlElement`) has properties such as its color, a transformation matrix, a border value, layout rules, and so on. 
If the graphic element is a text, it can have a font name, font size, ... A graphic element can be animated, i.e. its properties can be modified with time-based events. A graphic element can have *event handlers* that enable the element to react according to events (e.g. adding a new element inside the graphic element, clicking on it with the mouse, etc.). A graphic element can contain other graphic elements. To display a graphic element on the screen, it must be added to a *space* (`BlSpace`).

A space contains a *frame* that manages the various stages of drawing and event/animation management. 
A frame is made up of different phases. When the "space" receives a *pulse*, the frame calls all the `#runOn:` methods of each phase on the space in turn. 
The phases are:

1. **Idle:** Do nothing. This is a waiting phase when the space has nothing to do.
2. **Host Validation:** Creates a new window when Pharo is launched. This mechanism is not currently used.
3. **Task:** Triggers time-based events such as  the animations.
4. **Event:** Updates the focus of elements in the space, then retrieves events from the window (mouse, keyboard, zoom, etc.) and sends them to the various elements in the space.
5. **Drawing Validation:** Checks whether the window needs to redraw elements. For example, if the window has changed size.
6. **Layout:** Computes the layout of the various elements.
7. **Drawing:** Orders the renderer to draw the various elements.

### BlElement basic

### Space explanation

BlUniverse contain multiple BlSpace.
We call `BlElement openInNewSpace`
This will open a new OS Windows, with our scene

BlSpace is your main entry point to your application. It'll connect you to 
OS window, manage which element needs drawing and the rendering of your scene.
Rendering is done by a dedicated render class, BARenderer by default.

Host has their own pulse loop which are then transmitted to their BlSpace
My loop follows the next rules:

•	The #pulsePeriod duration is the minimum amount of time between two subsequent sends of #pulse.
•	If a pulse took more time than #pulsePeriod, then the next pulse may either send the next #pulse immediately, or do a small wait before if another process with lower priority is suspended (and may be starving).

The opened spaces listen the pulse to be synchronized and to update their state when it is needed.



Each BlSpace is hosted in  a specific BlHost environment.
All these BlHost are then accessible through BlUniverse.

 As of this writing, it can be Morphic or an OS Window,
using OSWindow and SDL2 backend. 



We begin with `BlElement >> openInNewSpace`
or `BlElement >> openInSpace`  which are equivalent.

```smalltalk
BlElement >> openInNewSpace
	"Add self to a new BlSpace and show it. Answer such space."
	
	| aSpace |
	aSpace := BlSpace new.
	aSpace root addChild: self.
	aSpace show.
	^ aSpace
```

### Space extent following its child extent 

```smalltalk
space := BlSpace new.
space show.

rootUniqueChild := BlElement new
	geometry: BlEllipseGeometry new;
	background: Color blue;
	"Transfer the new extent to the space"
	addEventHandlerOn: BlElementExtentChangedEvent
		do: [ :evt | space extent: evt target extent ]; 
	yourself.
space addChild: rootUniqueChild.

"Gradually expand element in a background process"
[ 	50 to: 400 by: 50 do: [ :sideLength |
		rootUniqueChild size: (sideLength*2) @ sideLength.
		500 milliSeconds wait ].
	space close ] fork
```

Here, space extent is redefined whenever the extent of its child changes using a basic eventHandler

### Center a space

```smalltalk
space := BlSpace new.
space root background: Color lightGreen.

space enqueueTask:
   (BlTaskAction new
      action: [ space center ];
      yourself).

space show
```

Spaces are by default opened with their origin on the top left or the screen, but we can change this by sending the message `BlSpace>>center`.
However you might wonder why in this example we send it as a task that we enqueue, the reason behind it is that (apparently) the space needs to be rendered to be centered and executing something like the following snippet doesn't work

```st
space show; center
```

### Root Element is special

```smalltalk
a := BlElement new.
aSpace := BlSpace new.
aSpace root addChild: a.
aSpace root background: Color transparent.
aSpace extent: 200 asPoint; show.
	
wheel := Color wheel: 20.
[ 	wheel do: [ :eachColor |
		0.25 seconds wait.
		a position: (a position + 5 asPoint).
		a background: eachColor ] ] fork
```

When you set Color transparent as root's background, nothing clears the space

```smalltalk
a := BlElement new.
aSpace := BlSpace new.
aSpace root addChild: a.
aSpace root background: Color blue.
aSpace root size: 100 asPoint.
aSpace extent: 150 asPoint; show.
	
wheel := Color wheel: 20.
[ 	wheel do: [ :eachColor |
		0.25 seconds wait.
		a position: (a position + 5 asPoint).
		a background: eachColor ] ] fork.
```

"When you set an exact root size, only a portion of the space might be cleared between frames"

[Enzo] I keep this note here but I don't see any changes personally

###