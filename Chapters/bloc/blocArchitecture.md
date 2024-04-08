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

###