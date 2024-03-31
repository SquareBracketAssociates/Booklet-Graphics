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
