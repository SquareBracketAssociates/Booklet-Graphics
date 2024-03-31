## How to create a raw widget from Toplo

Inspiration taken from Gtk2 widget creation example with a clock
https://thegnomejournal.wordpress.com/2005/12/02/writing-a-widget-using-cairo-and-gtk2-8/

https://thegnomejournal.wordpress.com/2006/02/16/writing-a-widget-using-cairo-and-gtk2-8-part-2/

## introduction

With Bloc, we have low-level tools to define custom graphical elements. However,
if we want to reproduce the appearance and behavior on our element, we should
group them under a library. This is what is Toplo: A collection a high-level
widget build on top of Bloc. You'll find all widget you expect to create your
own graphical user interface, like:

- button
- checkbox
- menu
- pane
- etc.

Defining our own widget is quite easy. We'll guide you steps by steps.

### Define a model

This step may be optional, but since our widget will hold a state, we should
have one.

Model members:
- hour
- minute
- seconds  

### Define graphical element

Our widget should be a subclass of `ToElement`, which is the ancestor of all Toplo
widgets.

### Widget appearance

Widget on the bare form, is like a ghost. It doesn't have any visual appearance.
The keep maximum flexibility, Toplo introduces the concept of **skin**, which defines
how to dress your widget. 

You'll have to overwrite two methods to define your skins:

- installRawStyle -> for raw skin
- installBeeStyle -> for bee skin
- newRawSkin

You can override *uninstallRawStyle* if that's necessary.

Skins are subclases of `ToSkin` which reacts to event handling. 
For each  event, your widget can have a different **look**.

Look will get specific properties into `#toStyleStore` properties of its `BlElement` (Under the hood, a `ToStyleStore` instance which stores properties
such color-primary, color-border, etc. ).

### Widget state

Your widget may need to hold your state. Like a checkbox, which has three
differents states (checked, unchecked, indeterminate). Usually, you don't care
about it, until you want to.


### More here



## Theme plumbing logic

Theme defines color and pattern to be applied on widget so they conform to the
look&feel definition. The theme is added to a bloc space using the method `toTheme:` as in
`space toTheme: ToBeeTheme light.`

When a Theme is installed

```lang=smalltalk
BlSpace >> toTheme: aTheme

    self userData at: #toTheme put: aTheme.
    aTheme onInstalledIn:  self.
    self root toThemeChanged
```

```lang=smalltalk
ToSkin >> onInstalledIn: anElement

    super onInstalledIn: anElement.
    anElement skinManager installedSkin: self.
    " install the event handler that will ask for a skin uninstaller when element is removed from space"
    removeFromSceneGraphHandler := BlEventHandler
                                        on: BlElementRemovedFromSceneGraphEvent
                    do: [ :evt | evt currentTarget requestUninstallSkin ].
    anElement addEventHandler: removeFromSceneGraphHandler
```

look at ToStyleSheet class >> defaultWritablePropertyList

```smalltalk
ToStyleSheetTheme >> initialize 
    super initialize.
    styleSheet := ToStyleSheet new.
    self initializeStyleRules
```


ToStyleSheetTheme (and descendant like ) ToBeeTheme have method
*initializeStyleRules* which will initialize widget properties

aSpace root skinManager return a ToSkinManager, installed as a property
#skinManager in a BlElement

ToThemeExamples >> example_buttons

Theme is linked to a ToStyleSheet, and a ToThemeVariant (light or dark).
`ToStyleSheet >> defaultScript` return *ToStyleScript*, which give value for different properties (ToFeatureProperty)

ToThemeDarkVariant class >> changedTokenProperties redefine some colors while
light variant don't touch anything.

When space is launched, apply skin recursively to all elements.
If button defined with raw theme, use the class skin defined in *newRawSkin*
method. You can inspect stack trace from the *installLookEvent:* method.

Same pattern is applied from StyleSheet theme, but skin is *ToBeeSkin*,
and style is installed from *onInstalledIn:* method. Element must then
implement *installBeeStyle* method.

Style is based on token (*ToTokenProperty*) which defined name/value key for
element properties.

