## Existing Widgets

### Tag

### Button

### Menu

### List

### Placing buttons inside a Notebook page 

```smalltalk
|book page|

book := ToNotebook new background: Color lightGreen.

page := book addPageTitle: 'page 1' bodyFactory: [ 
	|container|
	container := BlElement new layout: (BlGridLayout horizontal columnCount: 5; cellSpacing: 10).
	
	1 to: 10 do: [ :i |
		|stream|
		stream := String streamContents: [ :out | out nextPutAll: 'Button '; print: i ].
		container addChild: (ToButton new labelText: stream; constraintsDo: [ :c | c horizontal matchParent. c vertical matchParent ])
		 ].
	container ].

book openInSpace
```
To make our buttons take the whole space, we have to apply the matchParent constraint to each button and not to the container layout

### Cool color gradient displayed in notebook

```smalltalk
notebook := ToNotebook new.

500 to: 3000 by: 500 do: [ :numberOfElements |
    | container grid scrollableGrid vscrollBar |
    container := BlElement new
        constraintsDo:[ :c | 
          c horizontal matchParent. 
          c vertical matchParent ];
        yourself.    

    grid := BlElement new 
      layout: 
        (BlGridLayout horizontal 
          columnCount: 10; 
          cellSpacing: 10); 
      constraintsDo: [ :c | 
        c horizontal fitContent. 
        c vertical fitContent ]; 
      yourself .

    (Color wheel: numberOfElements) do: [ :eachColor | 
      grid addChild: (BlElement new background: eachColor; yourself) ].
    scrollableGrid := grid asScrollableElement.
    vscrollBar := BlVerticalScrollbarElement new.
    vscrollBar constraintsDo: [ :c |
            c ignoreByLayout.
            c padding: (BlInsets right: 2).
            c ignored horizontal alignRight.
            c ignored vertical alignBottom ].
    vscrollBar attachTo: scrollableGrid .
    container addChildren: { scrollableGrid. vscrollBar }. 

    notebook addPageTitle: numberOfElements asString, ' elements' body: container ].

    
space := BlSpace new.
space root addChild: notebook.
space show
```