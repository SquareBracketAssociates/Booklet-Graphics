## Skinning a simple widget

In this chapter we show how we can take the simple input widget developed in a previous chapter and make it skinnable. 

In a first period, we will focus on what is called raw skins. The idea behind raw skins are that we define classes with states and methods to define the behavior of a skin in a given theme. At the end of this chapter we will see that we can also skin widgets
using stylesheets following the spirit of CSS. 
 
The outline of this chapter is then: first we show that we can extend a theme and define a skin. 
Then in a second time we show that we can define an autonomous theme. 
Finally we will show that we can use stylesheet

Remember that we want to create a widget as shown in Figure *@inputFinalSkin@*.

![An integer input widget. % anchor=inputFinalSkin&width=50](figures/input.png )

### Getting started

If you implemented the widget as presented earlier, just copy the class giving it a new name for example `ToNumberInputElement`.
The definition of the `BlNumberInputElement` is available SD:DefineAPlace.

The first thing that we should do is to make `ToNumberInputElement` inherit from `ToElement` as follows:

```
ToElement << #ToNumberInputElement
	slots: { #plus . #minus . #inputValue . #value . #inputLabel };
	tag: 'Input';
	package: 'myBecherBloc'
```

### Define a skin

We define a skin 

```
ToRawSkin << #ToInputElementSkin
	package: 'myBecherBloc'```

```

We will now define action that should be done when the skin is installed. 

```
ToInputElementSkin >> installLookEvent: anEvent
	"when installing the skin, changes the properties of widget mentionned down here"

	super installLookEvent: anEvent.
	anEvent elementDo: [ :e |
		e border: (BlBorder
				 paint: (e valueOfTokenNamed: #'color-border')
				 width: (e valueOfTokenNamed: #'line-width')).
		e background: e backgroundPaint.
		e plus background: Color blue.
		e minus background: Color red ]
```

In the `ToNumberInputElement` we define the method 


Notice that two following forms are equivalent: 

```
anEvent elementDo: [ :e | 
		e border: (e valueOfTokenNamed: #'color-border-checkable’).

target := anEvent currentTarget.
target border: target valueOfTokenNamed: #'color-border-checkable’)
```


```
ToNumberInputElement >> newRawSkin
	"Allow to create an instance of the widget skin"

	^ ToInputElementSkin new
```


Update the following instance method.

```
ToNumberInputElement >> initialize

	super initialize.
	self size: self inputExtent.
	self background: self backgroundPaint.
	self layout: BlFrameLayout new.
	self border: (BlBorder paint: Color pink).
	self initializePlusButton.
	self initializeMinusButton.
	self initializeInputValue: 20.
	self label: 'Input'.
```

### Decorating a BlElement to get a ToElement

```
BlNumberInputElement << #ToNumberInputElement	traits: {TToElement}

```

```
ToNumberInputElement >> initialize
	super initialize. 
	self initializeForToplo
```


??? we should check if the following is necessary
```
ToNumberInputElement >> onAddedToSceneGraph

    super onAddedToSceneGraph.
    self ensuredSkinManager requestInstallSkinIn: self.
    self addEventHandler: ToSkinStateGenerator new
```









### Define a theme that extends an existing one

we also define a theme

```
ToRawTheme << #ToInputElementTheme
	package: 'Mooflod'
```


```
ToInputElementTheme class >> defaultTokenProperties
	"define here token properties of the widget theme"

	^ super defaultTokenProperties ,
	  { (ToTokenProperty
		   name: #'background-color'
		   value: Color lightGreen) }
```


```
ToNumberInputElement class >> openInputWithSkin	<script>	| space anInput |	space := BlSpace new.	space toTheme: ToInputElementTheme new.	anInput := self new position: 200 @ 200.	space root addChild: anInput.	space show.	^ anInput
```


### Autonome theme

```
ToTheme << #ToMooflooTheme	slots: {};	tag: 'Input';	package: 'myBecherBloc'
```

```
ToMooflooThemenewSkinInstanceFor: anElement	^ anElement newMooflooSkin
```

```
ToNumberInputElement class >> openInputWithSkin	<script>	| space anInput |	space := BlSpace new.	space toTheme: ToMooflooTheme new.	anInput := self new position: 200 @ 200.	space root addChild: anInput.	space show.	^ anInput
```

```
BlElement >> newMooflooSkin	^ ToBasicMooflooSkin new
```

```
ToNumberInputElement >> newMooflooSkin	^ ToInputElementSkin new
```


### Using a stylesheet


