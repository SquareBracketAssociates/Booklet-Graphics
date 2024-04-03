## Bloc and its ecosystem

### Introduction

**Bloc** is a powerful and innovative graphical framework designed specifically
for Pharo. Initially developed by Alain Plantec, it has received large and valuable
contributions from the Feenk team for **GToolkit** integration. These combined
efforts are now being merged back into **Pharo**, paving the way for a
significant step forward in its graphical capabilities.

### Evolution beyond Morphic

**Bloc** is poised to become the primary graphical framework for Pharo,
gradually replacing the well-established but aging Morphic framework. 
This transition promises to bring numerous advantages, including:

- Enhanced performance and efficiency
- Greater flexibility and customization options
- Modernized development experience
- Improved compatibility with various platforms and technologies

### Bloc stack 

A full graphical stack can be intimidating and the one of Bloc is not simple either. 
Here are some explanation of the key components that compose it. 

#### Alexandrie
Alexandrie is a low-level canvas based on Cairo and harfbuzz for the text rendering. It is a vectorial canvas.
Think about it has a canvas like in painting. Instructions are sent to draw on this canvas. 

- Important class: `Ae Canvas` 
Instructions support drawing of:
- lines, geometrics, and bezier curves with absolute & relative path.
- linear, radial, solid, translucent color drawing, or bitmap
- border and filling painting.
- alpha & mask painting.
- text rendering.

#### Bloc
Bloc is the base object graphics infrastructure. It uses Alexandrie to render its elements. 
Bloc offers spaces in which elements are placed using layouts and displayed. These elements react to 
events. 
Important classes:  `BlElement`, `BlBasicLayout`, `BlEvent`, `BlSpace`

Bloc has the following responsibilities: 
- the drawing of elements
- shape of the elements using geometry objects. 
- drawing
- event handling (dispatch, bubbling)
- element state
- animations 
- layouts
- rich text (rope text)


#### Toplo (update widget list)
Toplo is a fully skinnable widget library defined on top of Bloc based inspired by the functionalities of http://ant.design. 

Important classes: ToElement, ToSkin, 
Toplo offers:
- widget definition
- widget appearance (look) implemented with Bloc/BlElement
- widget state and internal model (view-model pattern) - ToViewModel
- widget specific behavior, implemented through method & traits (like any other object).

The widget list includes (as of this writing)
- Album a Text Editor - `ToAlbum`
-  Button - `ToButton`, `ToCheckbox`, `ToRadioButton`, `ToToggleButton`
- Choice box - `ToChoiceBox`
- Combo box - `ToComboBox`
- Image - `ToImage`
- Label & TextField - `ToLabel`, `ToTextField`
- List - `ToListElement`, `ToListInfiniteElement`
-  Menu & MenuBar - `ToMenuItem`, `ToMenu`, `ToMenuWindow`, `ToMenuBar`
-  Notebook - `ToNotebook`
- Pane - `ToPane`, `ToDivider`
- Tooltip - `ToTooltipWindow`
- Space window - `ToWindowElement`

#### Spec 
Spec is a UIbuilder framework focusing on the reuse of component interaction.
As such is an user interface description, working on multiple backends such Toplo (underway), Morphic and GTK.

Important classes: SpPresenter, SpAbstractWidgetPresenter SpApplication, SpLayout, 

Spec is based on 
- the Command design pattern.
- transmissions pattern that eases the communication between components.



#### OSWindow 
OSWindow is a library to access low-level information such as keyboard status, events. 
It is the connection with external operating system.
It is based on SDL2 library.
OSWindow manages: 
- operating system window, system events, and connect them to Pharo, and 
- host morphic world or Toplo spaces.

#### Form class
- bitmap manipulation and storage in Pharo
- 1, 2, 4, 8, 16 and 32 bits.
- creation, rotation, zooming, etc...
- load/save PNG, JPG files, store them as method (base64 encoding) 

#### Color class
The `Color` class manages colors. 
It supports; 
- rgba, hsla, hsva and named color definition
- color conversion, and adjustment
- Colormap class, used for 1, 2, 4, 8 bits Forms.




### Installation
To install it in Pharo 11, simply type in the playground

```smalltalk
EpMonitor disableDuring: [
  Author useAuthor: 'Load' during: [
    [ Metacello new baseline: 'Toplo'; repository: 'github://pharo-graphics/Toplo:master/src';
	onConflictUseIncoming;
	ignoreImage;
	load.
    ] on: MCMergeOrLoadWarning do: [ :warning | warning load ].
  ].
]
```

**Bloc** distinguishes itself by prioritizing object composition over
inheritance as its core design principle. This means that instead of relying
heavily on complex inheritance hierarchies, **Bloc** encourages building user
interface components by combining and customizing basic building blocks.

Note that Toplo is a new skinnable widget library built on top of Bloc.
