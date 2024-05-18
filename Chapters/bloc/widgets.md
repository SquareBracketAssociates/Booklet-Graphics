## Building a simple widget

In this chapter we will define a little widget to input integer with two buttons as shown in Figure *@input@*.


![An integer input widget.](figures/input.png label=input&width=50)

### Analysing the widget 

Figure *@input@* was created using the following logic. 
```
anInput := BlIntegerInputElement new.
anInput transformDo: [ :c | c translateBy: 200 @ 200 ].
space := BlSpace new.
space root
	background: Color purple;
	layout: BlFlowLayout horizontal.
space root addChild: anInput.
space show.
```

The main widget is composed of four elements: two buttons, a label,  and  a value.
Let us detail these elements: 
- the label and the value are text elements,
- the two buttons are in fact a composite elment composed of a circle element with a text element inside. 


### Getting started

We start by defining a new class called `BlIntegerInputElement` with an attribute for each of its subelement
as well as an extra attribute to hold directly the value

```
BlElement << BlIntegerInputElement
	slots: { #plus . #minus . #inputValue . #value . #inputLabel };
	tag: 'Input';
	package: 'myBecherBloc'
```

We start by defining the shape of the main element. Notice that visual properties such the background, the border could be stored differently to be customized afterwards.This is what we will show in a following chapter using stylesheet and skins as done in Toplo.

```
BlIntegerInputElement >> inputExtent 

	^ 300@120
```

```
backgroundPaint

	^ Color black
```


```
BlIntegerInputElement >> initialize

	super initialize.
	self size: self inputExtent.
	self background: self backgroundPaint.
	self geometry: (BlRoundedRectangleGeometry cornerRadius: 20).
	self layout: BlFrameLayout new.
	self border: (BlBorder paint: Color pink).
```


Add Missing Figure

We will start to add the label.
Now since this widget will manipulate a lot of text we define a simple fonction to 
set the same visual properties to all the text element. 

```
BlIntegerInputElement >> configuredString: aString

	^ aString asRopedText attributes: { (BlTextForegroundAttribute paint: Color white) }.
```	

The `label:` method creates a `BlTextElement`, sets its text using properties and translate is

```
BlIntegerInputElement >> label: aString

	inputLabel := BlTextElement new.
	inputLabel text: (self configuredString: aString).
	inputLabel text fontSize: 25.
	inputLabel constraintsDo: [ :c | c frame horizontal alignCenter ].
	inputLabel transformDo: [ :t | t translateBy: 0 @ 10 ].
	self addChild: inputLabel
```	













### Writing some tests


```
BlNumberInputElementTest >> testChildrenAreSet

	| inputElem |
	inputElem := BlNumberInputElement new.
	self assert: inputElem children size equals: 4 
```

```
BlNumberInputElementTest >> testCanChangeLabel

	| inputElem |
	inputElem := BlNumberInputElement new.
	self assert: inputElem label text asString equals: 'Input'.
	inputElem label: 'Volume'.
	self assert: inputElem label text asString equals: 'Volume'.
```

```
BlNumberInputElementTest >> testValueUpdatedOnClick

	| inputElem |
	inputElem := BlNumberInputElement new.
	BlSpace simulateClickOn: inputElem minus.
	self assert: inputElem value equals: 19.
	6 timesRepeat: [ BlSpace simulateClickOn: inputElem plus ].
	self assert: inputElem value equals: 25
```

```
BlNumberInputElementTest >> testValueCantBeNegative

	| inputElem value |
	inputElem := BlNumberInputElement new.
	inputElem changeValueTo: 0.
	BlSpace simulateClickOn: inputElem minus.
	value := inputElem value. 
	self assert: value equals: 0
```