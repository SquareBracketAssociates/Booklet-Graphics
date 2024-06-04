## Skinning a simple widget

In this chapter we will show how we can take the simple input widget developed in a previous chapter and make it skinnable. 
Remember that we want to create a widget as shown in Figure *@inputFinalSkin@*.

![An integer input widget. % anchor=inputFinalSkin&width=50](figures/input.png )


### Getting started

If you implemented the widget as presented earlier, just copy the class giving it a new name for example `ToNumberInputElement`.
The definition of the `BlNumberInputElement` is available SD:DefineAPlace.

The first thing that we should do is to make `ToNumberInputElement` inherit from `ToElement` as follows:

```
ToElement << #ToNumberInputElement	slots: { #plus . #minus . #inputValue . #value . #inputLabel };	tag: 'Input';	package: 'myBecherBloc'
```

### Define a skin

We define a skin 

```
ToRawSkin << #ToInputElementSkin	package: 'myBecherBloc'```

```

We will now define action that should be done when the skin is installed. 

```
ToInputElementSkin >> installLookEvent: anEvent	"when installing the skin, changes the properties of widget mentionned down here"	super installLookEvent: anEvent.	anEvent elementDo: [ :e |		e border: (BlBorder				 paint: (e valueOfTokenNamed: #'color-border')				 width: (e valueOfTokenNamed: #'line-width')).		e background: e backgroundPaint ]
```

```

ToInputElementSkin >> pressedLookEvent: anEvent	"Change the color of the widget when clicking on it"	super pressedLookEvent: anEvent.	anEvent elementDo: [ :e |		e plus background: Color blue.		e minus background: Color red ]
```


SD: Je n'ai pas compris comment on passe du skin au theme. 
Ou sont definis les token color-border et autre. 

In the `ToNumberInputElement` we define the method 


```
newRawSkin	"Allow to create an instance of the widget skin"	^ ToInputElementSkin new
```

SD: comment on sait ou est defini #'color-border'

SD:Alain est ce que cela fait du sens d'invoker  `defaultSkin:` dans l'initialize?

```
ToNumberInputElement >> initialize	super initialize.	self size: self inputExtent.	self background: self backgroundPaint.	self geometry: (BlRoundedRectangleGeometry cornerRadius: 20).	self layout: BlFrameLayout new.	self border: (BlBorder paint: Color pink).	self initializePlusButton.	self initializeMinusButton.	self initializeInputValue: 20.	self label: 'Input'.	self defaultSkin: self newRawSkin
```


Alexis le faisait ailleurs mais je trouvais cela un peu moche:


```
ToNumberInputElement >> openInput: anInput	"sets configuration to display the input element in a space"	| space |	space := BlSpace new.	self defaultSkin: self newRawSkin.	space root layout: BlFlowLayout horizontal.	anInput transformDo: [ :c | c translateBy: 250 @ 200 ].	space root addChild: anInput.	space toTheme: MfInputElementTheme new.	space applyAllSkinInstallers.	space show.	^ anInput
```


### Define a theme

we also define a theme

```
ToRawTheme << #ToInputElementTheme	package: 'Mooflod'
```


```
ToInputElementTheme class >> defaultTokenProperties	"define here token properties of the widget theme"	^ super defaultTokenProperties	  ,	  { (ToTokenProperty		   name: #'background-color'		   value: Color lightGreen) }
```


```
ToNumberInputElement class >> openInputWithSkin	<script>	| space anInput |	anInput := self new.	space := BlSpace new.	space root		background: Color purple;		layout: BlFlowLayout horizontal.	anInput transformDo: [ :c | c translateBy: 200 @ 200 ].	space root addChild: anInput.	space toTheme: ToInputElementTheme new.	space applyAllSkinInstallers.	space show.	^ anInput
```

Why the following does not use the install skin and it does not work. 

the following does call default skin but the button do not get color changed :(

```
openInputWithSkin	<script>	| space anInput |	anInput := self new.	anInput defaultSkin: anInput newRawSkin.	space := BlSpace new.	space root		background: Color purple;		layout: BlFlowLayout horizontal.	anInput transformDo: [ :c | c translateBy: 200 @ 200 ].	space root addChild: anInput.	space toTheme: ToInputElementTheme new.	space applyAllSkinInstallers.	space show.	^ anInput
```

