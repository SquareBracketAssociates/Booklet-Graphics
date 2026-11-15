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

> [!note] Diff with Code
> `ToNotebook` and `addPageTitle:bodyFactory:` no longer exist. Tabs are now built with `ToTabPaneElement`: give it an `itemBuilder: [ :tabItem :data | tabItem labelText: data asString; paneBuilder: [ :body :btn :holder | body addChild: ... ] ]`, then send `addTabItemData:` for each tab. See `ToSandBox class>>#example_SimpleTabPane`. The other messages (`labelText:`, `BlGridLayout horizontal columnCount:`, `cellSpacing:`) are still valid.

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

> [!note] Diff with Code
> `ToNotebook` and `addPageTitle:body:` no longer exist: use `ToTabPaneElement` with `itemBuilder:` and `addTabItemData:` (see `ToSandBox class>>#example_SimpleTabPane`). `asScrollableElement`, `BlVerticalScrollbarElement>>#attachTo:` and `c ignoreByLayout` are still valid.
