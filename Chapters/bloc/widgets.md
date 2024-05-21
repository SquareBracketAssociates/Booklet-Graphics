## Building a simple widget

In this chapter we will define a little widget to perform input integer with two buttons as shown in Figure *@input@*. It is inspired from the work of A. Cnokaert in the context of his internship to design  the CoypuIDE (an IDE for live music) and Moofloo (a support for spectator understanding music performance). 

![An integer input widget.](figures/input.png label=input&width=50)

### Analysing the widget 

Figure *@input@* was created using the following logic. 

```
| anInput space |
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
- the two buttons are, in fact, a composite element composed of a circle element with a text element inside.


### Getting started

We start by defining a new class called `BlIntegerInputElement` with an attribute for each of its subelement as well as an extra attribute to hold directly the value:

```
BlElement << #BlIntegerInputElement
	slots: { #plus . #minus . #inputValue . #value . #inputLabel . #callbackBlock };
	tag: 'Input';
	package: 'ABlocPackage'
```

We start by defining the shape of the main element. Notice that visual properties such the background, the border could be stored differently to be customized afterwards.This is what we will show in a following chapter using stylesheet and skins as done in Toplo.


```
BlIntegerInputElement >> inputExtent 

	^ 300@120
```

```
BlIntegerInputElement >> backgroundPaint

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


![Empty integer input widget.](figures/Input0.png label=input&width=50)


### Label

We will start to add the label.
Now since this widget manipulates a lot of text we define a simple function to 
set the same visual properties to all the text elements. 

```
BlIntegerInputElement >> configuredString: aString

	^ aString asRopedText attributes: { (BlTextForegroundAttribute paint: Color white) }
```	

The `label:` method creates a `BlTextElement`, sets its text using properties and translates it to place it above the center. 

```
BlIntegerInputElement >> label: aString

	inputLabel := BlTextElement new.
	inputLabel text: (self configuredString: aString).
	inputLabel text fontSize: 25.
	inputLabel constraintsDo: [ :c | c frame horizontal alignCenter ].
	inputLabel transformDo: [ :t | t translateBy: 0 @ 10 ].
	self addChild: inputLabel
```	

Note that we use `addChild:` method to add the text element in the composite (the instance of the BlIntegerInputElement`).

![With a label.](figures/Input1.png label=input1&width=50)

We modify the initialize method to invoke the `label` method.
```
BlIntegerInputElement >> initialize

	super initialize.
	self size: self inputExtent.
	self background: self backgroundPaint.
	self geometry: (BlRoundedRectangleGeometry cornerRadius: 20).
	self layout: BlFrameLayout new.
	self border: (BlBorder paint: Color pink).
	self label: 'Input'
```

We should get now a widget similar to the one shown in Fig *@input1@*.

### Adding the input representation

We add the element that will display the current value of the counter.

```
BlIntegerInputElement >> initializeInputValue: aValue

	inputValue := BlTextElement new.
	inputValue constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].
	self changeValueTo: aValue.
	self addChild: inputValue
```

We define a little helper method `changeValueTo:` that we will expose as pubic API for example 
to start the input with a specific value.
Note again that we add the input value element in the composite one. 

```
BlIntegerInputElement >> changeValueTo: aValue

	inputValue text: (self configuredString: aValue asString).
	inputValue text fontSize: 30.
	value := aValue
```


Then we change the `initialize` method to invoke `initializeInputValue:`.

```
BlIntegerInputElement >> initialize

	super initialize.
	self size: self inputExtent.
	self background: self backgroundPaint.
	self geometry: (BlRoundedRectangleGeometry cornerRadius: 20).
	self layout: BlFrameLayout new.
	self border: (BlBorder paint: Color pink).
	self initializeInputValue: 20.
	self label: 'Input'
```

We should obtain now a widget similar to the one show in Fig *@input2@*.

![With a label and a value.](figures/Input2.png label=input2&width=50)



### Adding the plus button

We focus on adding the two buttons to change the value of the input. 
Their logic is similar even if we will have to pay attention of their different placement and actions.

We first define a method `createCircle` that returns an element in a circle shape. 

```
BlIntegerInputElement >> createCircle

	| circle |
	circle := BlElement new
		          background: Color black;
		          border: (BlBorder paint: Color pink width: 2);
		          layout: BlFrameLayout new;
		          geometry: BlCircleGeometry new.
	^ circle
```

We introduce the method `increaseInput` that increments the value of the counter.

```
BlIntegerInputElement >>increaseInput

	self changeValueTo: value + 1
```

Then we define the method `initializePlusButton` that uses the method `createCircle`.
We create a new text element and place it inside the circle and then add the circle as child of the composite.

```
BlIntegerInputElement >> initializePlusButton

	| circle |
	circle := self createCircle.
	circle constraintsDo: [ :c |
		c frame horizontal alignRight.
		c frame vertical alignCenter ].
	circle transformDo: [ :t | t translateBy: -15 @ 0 ].

	plus := BlTextElement new text: (self configuredString: '+').
	plus text fontSize: 55.
	plus constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].
	circle
		addEventHandlerOn: BlMouseDownEvent
		do: [ :e | self increaseInput ].
	circle addChild: plus.
	self addChild: circle.
```

Note that in addition, we use the message `addEventHandlerOn:do:` to configure
the circle element to react to mouse-down events.

```
BlIntegerInputElement >> initialize

	super initialize.
	self size: self inputExtent.
	self background: self backgroundPaint.
	self geometry: (BlRoundedRectangleGeometry cornerRadius: 20).
	self layout: BlFrameLayout new.
	self border: (BlBorder paint: Color pink).
	self initializePlusButton.
	self initializeInputValue: 20.
	self label: 'Input'
```

We should now get a widget similar to the one shown in Fig *@input3@*.
![With a plus button.](figures/Input3.png label=input3&width=50)


### Adding the minus button

We follow a similar path for the minus button. 

We define a method to decrease the value of the input. 
By default we decided against negative values but we could have used a bloc such as `[:x | x > 1]` to be able to customize better the range of the input value. We left this to the reader.

```
BlIntegerInputElement >> decreaseInput

	value > 0 ifTrue: [ self changeValueTo: value - 1 ]
```

We define another method to create and assemble the minus button. 
Here we adjusted the size of the minus character so that it has a similar shape than the plus character.
```
BlIntegerInputElement >> initializeMinusButton

	| circle |
	circle := self createCircle.
	circle constraintsDo: [ :c |
		c frame horizontal alignLeft.
		c frame vertical alignCenter ].
	circle transformDo: [ :t | t translateBy: 15 @ 0 ].

	minus := BlTextElement new text: (self configuredString: '-').
	minus text fontSize: 80.
	minus constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].
	circle
		addEventHandlerOn: BlMouseDownEvent
		do: [ :e | self decreaseInput ].

	circle addChild: minus.
	self addChild: circle.
```

FInally we update the initialize method to call the minus creation. 
```
BlIntegerInputElement >> initialize

	super initialize.
	self size: self inputExtent.
	self background: self backgroundPaint.
	self geometry: (BlRoundedRectangleGeometry cornerRadius: 20).
	self layout: BlFrameLayout new.
	self border: (BlBorder paint: Color pink).
	self initializePlusButton.
	self initializeMinusButton.
	self initializeInputValue: 20.
	self label: 'Input'
```

Now we should have the full widget. 

### Adding callback methods

When the state of the widget is changed we need to detect it and have the possibility to use the new state.
Any time the `inputValue` is changed we will value a block with the new value of the input.

First we initialize the callback block.

```
BlIntegerInputElement >> initializeInputValue: aValue

	callbackBlock := [ :newInputValue | ].
	inputValue := BlTextElement new.
	inputValue constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].
	self changeValueTo: aValue.
	self addChild: inputValue
```

Then anytime we changed the state, we update the value.

```
BlIntegerInputElement >> changeValueTo: aValue

	inputValue text: (self configuredString: aValue asString).
	inputValue text fontSize: 30.
	value := aValue.
	callbackBlock value: aValue
```

Finnaly we create a mutator for the `callbackBlock` variable.

```
BlIntegerInputElement >> callbackBlock: aBlock

	callbackBlock := aBlock
```

Now we can detect any change in the value of the widget.

### Writing some tests

We take the opportunity show that we can define some simple tests that will help maintaining and improving this little widget.

The first test is rather naive and just check that all the widget as indeed the number of expected elements. In general we are not found of such kind of test because the elements should be grouped into another one for interaction purpose and still be widget would work normally but the test would fail. 

```
BlNumberInputElementTest >> testChildrenAreSet

	| inputElem |
	inputElem := BlNumberInputElement new.
	self assert: inputElem children size equals: 4 
```

Let us see a more interesting test.
The following test shows that we can effectively changes the label. 

```
BlNumberInputElementTest >> testCanChangeLabel

	| inputElem |
	inputElem := BlNumberInputElement new.
	self assert: inputElem label text asString equals: 'Input'.
	inputElem label: 'Volume'.
	self assert: inputElem label text asString equals: 'Volume'.
```

The following tests are checking that the interaction on the buttons is working correctly.
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

The following tests are checking that the callback block is working correctly.

```
BlNumberInputElementTest >> testCallbackCallOnClick

	| inputElem testNumberOfCall testValue |
	testNumberOfCall := 0.
	testValue := -1.
	inputElem := BlNumberInputElement new.
	inputElem callbackBlock: [ :val |
		testNumberOfCall := testNumberOfCall + 1.
		testValue := val.
	]
	self assert: testNumberOfCall equals: 0.
	self assert: testValue equals: -1.
	BlSpace simulateClickOn: inputElem minus.
	self assert: testNumberOfCall equals: 1.
	self assert: testValue equals: 19.
	6 timesRepeat: [ BlSpace simulateClickOn: inputElem plus ].
	self assert: testNumberOfCall equals: 7.
	self assert: testValue equals: 25.
	inputElem changeValueTo: 0.
	self assert: testNumberOfCall equals: 8.
	self assert: testValue equals: 0.
	BlSpace simulateClickOn: inputElem minus.
	self assert: testNumberOfCall equals: 8.
	self assert: testValue equals: 0.
```


### Conclusion

This chapter shows how to build a simple widget. 
In a subsequent chapter we will show how to build a skinnable widget using stylesheets and skins. 

