# How to create a raw widget from Toplo

Inspiration taken from Gtk2 widget creation example with a clock
https://thegnomejournal.wordpress.com/2005/12/02/writing-a-widget-using-cairo-and-gtk2-8/

https://thegnomejournal.wordpress.com/2006/02/16/writing-a-widget-using-cairo-and-gtk2-8-part-2/

## introduction

With Bloc, we have low level tools to define custom graphical element. However,
if we want to reproduce appearance and behaviour on our element, we should
group them under a library. This is what is Toplo. A collection a high-level
widget build on top of Bloc. You'll find all widget you expect to create your
own graphical user interface, like:

- button
- checkbox
- menu
- pane
- etc.

Defining our own widget is quite easy. We'll guide you steps by steps.

## define model

This step may be optional, but since our widget will hold a state, we should
have one.

Model members:

- hour
- minute
- seconds  

## define graphical element

Our widget should be a subclass of ToElement, which is the ancestor of all Toplo
widgets.

## widget appearance

Widget on the bare form, is like a ghost. It doesn't have any visual appearance.
The keep maximum flexibility, Toplo introduce the concept of **skin**, which tell
how to dress your widget. 

You'll have to overwrite 2 methods to define your skins:

- installRawStyle -> for raw skin
- installBeeStyle -> for bee skin
- newRawSkin

You can override *uninstallRawStyle* if that's necessary.

*skin* are descendant of **ToSkin** which react to event handling. For each 
event, your widget can have a different **look**

**Look** will get specific properties into **#toStyleStore** properties of its *BlElement* (Under the hood, a **ToStyleStore** instance, which store properties
like *color-primary*, *color-border*, etc. ).

## widget state

Your widget may need to hold your state. Like a checkbox, which can have 3
differents states (checked, unchecked, indeterminate). Usually, you don't care
about it, until you want to 

## theme

Theme define color and pattern to be applied on widget so they conform to the
look&feel definition. Theme is added to a *bloc* space like
`space toTheme: ToBeeTheme light.`

When a Theme is installed

```lang=smalltalk
BlSpace >> toTheme: aTheme

    self userData at: #toTheme put: aTheme.
    aTheme onInstalledIn:  self. "(call ToTheme class defaultTokenProperties.)"
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

########################################################

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
 

########################################################
For checkbox (as of 1 jan 2024)
Implement rawSkin/rawStyle (*ToRawTheme* and *ToRawSkin*) which is the default theme

```smalltalk
Toplo class >> defaultThemeClass
    ^ DefaultThemeClass ifNil: [ DefaultThemeClass := ToRawTheme ]
```

```smalltalk
ToRawTheme >> newRootSkinInstance
    ^ ToSpaceRootSkin new "subclass of ToRawSkin and ToSkin"
```

```smalltalk
ToRawTheme >> newSkinInstanceFor: anElement

    | space |
    space := anElement space.
    ^ (space notNil and: [ space root == anElement ])
          ifTrue: [ self newRootSkinInstance ]
          ifFalse: [ anElement newRawSkin ]
```

An element can either have a default skin, or reference a skin given byt its
space theme. *skinManager* is a property of every BlElement, brough by Toplo.

Reference ToCheckboxSkin, which for each event define a look for each part of
the element (border, background, etc.). It can use default value defined in
`ToTheme class >> defaultTokenProperties` or refined in 
`ToThemeDarkVariant class >> changedTokenProperties`

Theme defined through Raw must implement **newRawSkin**
Raw Skin are called through theme defintion.

you can define default skin to your element
`ToCheckBox new defaultSkin: ToCheckboxSkin new.`

Theme can defined from a StyleSheet (*ToStyleSheetTheme*).
StyleSheet can be refined through `initializeStyleRules` method.
Theme can be applied to a space through `space toTheme: ToBeeTheme light` or
`space toTheme: ToBeeTheme dark`

```smalltalk
ToBeeTheme >> skinClassFor: anElement

    ^ ToBeeSkin "-> anElement installBeeStyle, pour l'instant ToLabeledIcon"
```

Associate an element Id with custom style, associated with specific properties.

```smalltalk
ToBeeTheme >> declareRootPaneRules
        self halt.
    self select: (self id: #'Space root') style: [

        self
            write: (self property: #background)
            with: [ :e | e tokenValueNamed: #'background-color' ] ]
```

You can create element with specific Id, like `(ToButton id: #buttonA)`
and then associate custom style through stylesheet.
Or associate style by button class (ToTypeSelector), like `ToButton asTypeSelector`

BlSpace have a default Id: 'Space root' (in method defaultRootLabel)
Each element is associated with a skin by Toplo, and skin can be associated with
a stylesheet.

style element properties are written in toStyleStore of target BlElement.
Store is then queried and property applied during execution

ToFeatureProperty >> write: aPropertyValue to: anObject
    anObject perform: self name asSymbol asMutator with: aPropertyValue
with
    name = background,  self name asSymbol asMutator return background:
    property value = Color white.
so you write dynamically to BlElemement properties their value.

To reach that:
```smalltalk
BlElement >> tokenValueNamed: aSymbol
self haltIf: [ aSymbol = #'background-color' ].
    ^ self toStyleStore tokenPropertyValue: aSymbol from: self
```
