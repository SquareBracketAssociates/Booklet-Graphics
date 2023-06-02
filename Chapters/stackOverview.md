# OSWindow 
- connection with external operating system
- based on SDL2 library
- manage Operating system window, system events, and connect them to Pharo
- host morphic world or Toplo space

# Form class
- bitmap manipulation and storage in Pharo
- 1, 2, 4, 8, 16 and 32 bits.
- creation, rotation, zooming, etc...
- load/save PNG, JPG files, store them as method (base64 encoding) 

# Color class
- color management and definition
- support rgba, hsla, hsva and named color definition
- color conversion, and adjustment
- Colormap class, used for 1, 2, 4, 8 bits Forms.

# Alexandrie - AeCanvas class
- vectorial canvas, based on Cairo & harbuzz
- draw line, geometric and bezier curve with absolute & relative path.
- linear, radial, solid & translucent color drawing, or bitmap
- border and filling painting.
- alpha & mask painting.
- text rendering

# Bloc -  BlElement class
- base graphical element
- geometry/shape
- drawing
- event handling
- state
- style
- animation 
- layout
- rich text (rope text)

# OnBloc - layer between bloc and Toplo
- Space definition (the equivalent of a world window in Morphic).
- infinite element definition for various items.
- theme - OBlTheme.

# Toplo
- widget definition, on Top of Bloc - ToElement and subclasses, ToCompanion
- widget appearance (look) implemented with Bloc/BlElement - ToDresser
- widget state and internal model (view-model pattern) - ToViewModel
- widget specific behavior, implemented through method & traits (like any other object).

- widget list include (as of 2nd of june 2023):
 * Album - ToAlbum
 * Button - ToButton, ToCheckbox, ToRadioButton, ToToggleButton
 * Choice box - ToChoiceBox
 * Combo box - ToComboBox
 * Image - ToImage
 * Label & TextField - ToLabel, ToTextField
 * List - ToListElement, ToListInfiniteElement
 * Menu & MenuBar - ToMenuItem, ToMenu, ToMenuWindow, ToMenuBar
 * Notebook - ToNotebook
 * Pane - ToPane, ToDivider
 * tooltip - ToTooltipWindow
 * Space window - ToWindowElement


# Spec 
- user interface description, working on multiple backend
- back widget coming from (Toplo), Morphic & Roassal or Gtk
- Command design pattern built-in
- Transmission - communication between object made easy.
- user interface layout - SpExecutableLayout and subclasses
- widget list (as of 2nd of june 2023)
 * SpAbstractWidgetPresenter and subclasses
