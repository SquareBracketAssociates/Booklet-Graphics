## Renaud notes for widget creation


## For Raw theme:

- element subclass of ToElement
- overwrite method `newRawSkin`

- ToCheckboxSkin which is a subclass of ToRawSkin and ToSkin
=> react to specific event to apply skin to element. Without skin, an element is kind of naked. 
state + evt associé -> skin
Un skin est un event handleur qui va réagir à des look events.

## For BeeTheme => use of stylesheet.

- element subclass of ToElement
- overwrite method: `defaultBeeStyleStamps` and `installBeeStyle`
- associated theme: `ToBeeTheme and method for each element. 

## Theme management. 

Theme -> factory de skin pour tes objets, incluant les propriétés pour décorer.
A theme contains a variant, a list of editable properties and style rules.
element properties (like color, radius, etc.) are defined as part of a theme

theme are added at space level: 
- `aSpace toTheme: Toplo newDefaultThemeInstance.`
- `space toTheme: ToBeeTheme new.`
- `aSpace toTheme inspect`

Theme can be raw or defined through stylesheet
- `ToBeeTheme and method for each element. 
- `ToTheme class >> defaultTokenProperties` and subclasses 

- theme could be generated from theme file and subclass of `ToStyleSheetTheme`
WIP: *ToThemeEditorPresenter*
- stylesheet could be exported in a CSS style like (and could probably be
imported in the same format - TBC).

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

## properties handling - writable properties and property writers.

When you write:

```smalltalk
self
write: (self property: #outskirts)
with: [ :e | BlOutskirts centered ].
```

This rule constructs a “property writer” (instance of ToPropertyWriter) that is stored in the skin if the rule that uses it is selected.
This implies that there is a *ToWritableProperty* declared with the name *#outskirts*.
A WriteableProperty is used to read and write a value as a property of an object.
The API is therefore identical to that of Slot for reading and writing. We have #read: and #write:to:.

There are 3 types of ToWritableProperty:
- ToFeatureProperty
- ToSlotProperty (not very useful, not used, may need to be removed)
- ToPseudoProperty

For a property whose name is #a:
- Feature is used if an element has both #a and #a: methods (as in the case of #outskirts). A ToFeatureProperty is then simply constructed using the name. ToFeatureProperty name: #a.
- use Slot if you have a slot with name #a. ToSlotProperty name: #a.
- and use Pseudo if you have neither accessors nor a slot. The reader and writer must therefore be explicitly declared.
ToPseudoProperty name: #a reader: [:e | e monA ] writer: [:e :v | e monA: v ].

The default declarations are in ToStyleSheet class>>defaultWritablePropertyList.
The exception you have comes from the fact that there was no property name #outskirts declared until now.
I've added “(ToFeatureProperty name: #outskirts).” 
In ToStyleSheet class>>defaultWritablePropertyList.

I've added the following test with your example:

```smalltalk
ToStyleSheetTest>>testOutskirts

	| e styleSheet theme writers |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.

	theme := ToStyleSheetTheme new.

	styleSheet select: styleSheet any style: [ :sr |
		sr write: (styleSheet property: #outskirts) with: BlOutskirts centered].

	e := ToElement new.
	e outskirts: BlOutskirts inside.
	e localTheme: theme.
	e styleSheet: styleSheet.
	space root addChild: e.
	space applyAllSkinPhases.

	writers := theme applicableWritersFor: e.
	self assert: writers size equals: 1.
	self assert: e outskirts equals: BlOutskirts centered
```

You can dynamically add writable properties to a stylesheet with #addWritableProperty:.
The addition must be made before the selection rules are declared.

Here's a test with the #myOutskirts “pseudo-property”:

```smalltalk
ToStyleSheetTest>>testMyOutskirts

	| e styleSheet theme writers |
	styleSheet := ToStyleSheet new
		              inherits: false;
		              yourself.

	theme := ToStyleSheetTheme new.

	styleSheet addWritableProperty: (ToPseudoProperty
			   name: #myOutskirts
			   reader: [ :elem | elem outskirts ]
			   writer: [ :elem :v | elem outskirts: v ]).

	styleSheet select: styleSheet any style: [ :sr |
		sr write: (styleSheet property: #myOutskirts) with: BlOutskirts centered].

	e := ToElement new.
	e outskirts: BlOutskirts inside.
	e localTheme: theme.
	e styleSheet: styleSheet.
	space root addChild: e.
	space applyAllSkinPhases.

	writers := theme applicableWritersFor: e.
	self assert: writers size equals: 1.
	self assert: e outskirts equals: BlOutskirts centered
```

## advance stylesheet - default stamps for element

You can select element with

- Id: asIdSelector
- Stamp: asStampSelector (comme les classes CSS)
- type: asTypeSelector
  
You might want to have a default stamp to allow selection of a default style.

You might think of placing an #addStamp: in #initialize, but for which theme (BeeTheme won't be the only one)
And you don't want to have a stamp initialized if you're not going to use it (for another theme). 
And you can't change #initialize depending on the theme...
So there you have it, hence the idea of having default stamps by theme

It's the theme that decides how to define the default stamps.

```smalltalk
ToBeeTheme>>defaultElementStampsFor: anElement 
	^ anElement defaultBeeStyleStamps
```

On your element, you can then declare

```smalltalk
ToClock >> defaultBeeStyleStamps
    ^ #( #clock )
```

So, a theme may very well not use default stamps.
This is the default case.

```smalltalk
ToStyleSheetTheme>>defaultElementStampsFor: anElement 
	^ { }
```
