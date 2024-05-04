## Renaud notes for widget creation

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


## skin creation - to be place in another chapter

There are several ways to set the skin of an element.

- The first is to redefine #newRawSkin (or newXXXSkin for a ToXXXTheme )
- The second way is to use #defaultRawSkin: to set a skin different from the one returned by newRawSkin.
- The third way it #defaultSkin: that is theme independent.

To set its skin, it select in order:

1. An element use the one set by #defaultRawSkin: (if not nil), 
2. The one set by #defaultSkin: 
3. The one returned by #newRawSkin.

Thus inside an #installedLookEvent:, an element can set the skin of its sub
elements by sending it the #defaultRawSkin: message with the desired skin as
argument :

```smalltalk
ToRawRoundClockSkin>>installLookEvent: anEvent

	super installLookEvent: anEvent.
	anEvent elementDo: [ :e |
		e minutesNeedle defaultRawSkin: ToNeedleInRoundClockSkin new.
	].
```

```smalltalk
ToRawSquareClockSkin>>installLookEvent: anEvent

	super installLookEvent: anEvent.
	anEvent elementDo: [ :e |
		e minutesNeedle defaultRawSkin: ToNeedleInSquareClockSkin new.
	]
```

It should work ok for an element with its direct sub-elements.
Now, a sub-element’s skin is installed with one delay pulse.
A sub-element sub-element skin is then installed with two delay pulse, etc…
So, some undesirable transition effect can arise with such a skin installation
in case of a deep composition tree.  this is where a stylesheet can be useful
because of the selection mechanism that allow the skin selection/building in one
pass

Two precisions:

- If e minutesNeedle return a BlElement, and not a ToElement, then you need to send it #ensureCanManageSkin
e ensureCanManageSkin. 
- One can send #withNullSkin to an element to set a NullSkin.

#ensureCanManageSkin just add two event handlers: one to generate the element
states (and then dispatch the look events) and a second to setup the skin when
the element is added in a space.