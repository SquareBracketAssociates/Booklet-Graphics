Class {
	#name : #MfInputElement,
	#superclass : #BlElement,
	#instVars : [
		'inputValue',
		'value',
		'minus',
		'plus'
	],
	#category : #InputWidget
}

{ #category : #'visual properties' }
MfInputElement >> backgroundPaint [ 
	
	^ Color black
]

{ #category : #action }
MfInputElement >> decreaseInput [

value > 0 ifTrue: [ 
	value:= value -1.
 ].
inputValue removeFromParent .
inputValue:= self initializeInputValue: value asString.


]

{ #category : #action }
MfInputElement >> increaseInput [ 

value := value + 1.
inputValue removeFromParent .
inputValue:= self initializeInputValue: value asString.

]

{ #category : #initialization }
MfInputElement >> initialize [ 

super initialize .
self size: self inputExtent .
self background: self backgroundPaint .
self geometry: (BlRoundedRectangleGeometry cornerRadius: 20).
self layout: BlFrameLayout new.
self border: (BlBorder paint: Color pink).
plus := self initializePlus.
minus :=self initializeMinus.
inputValue:= self initializeInputValue. 
value := inputValue text asString asNumber.
self initializeInputText .






]

{ #category : #initialization }
MfInputElement >> initializeInputText [

| inputtext |

inputtext := MfInputText new.
self addChild: inputtext.

^inputtext 
]

{ #category : #initialization }
MfInputElement >> initializeInputValue [

| ivalue|
ivalue := MfInputValue new.
ivalue  text: '20' asRopedText .
ivalue text attributes:  { (BlTextForegroundAttribute paint: Color white)}.
ivalue text fontSize: 30.
self addChild: ivalue.

^ivalue
]

{ #category : #initialization }
MfInputElement >> initializeInputValue: aValue [

| ivalue|
ivalue := MfInputValue new.
ivalue  text: aValue asRopedText .
ivalue text attributes:  { (BlTextForegroundAttribute paint: Color white)}.
ivalue text fontSize: 30.
self addChild: ivalue.

^ivalue
]

{ #category : #initialization }
MfInputElement >> initializeMinus [

| circle |

circle := BlElement new 
	background: Color black;
	border: (BlBorder paint: Color pink width: 2) ;
	layout: BlFrameLayout new;
	geometry: BlCircle new.
circle constraintsDo: [ :c |
	c frame horizontal alignLeft .
	c frame vertical alignCenter ].
circle transformDo: [ :t |
	t translateBy: 15@0].

minus := BlTextElement new
	text: ('-' asRopedText attributes:  { (BlTextForegroundAttribute paint: Color white)}).
minus text fontSize: 80.
minus constraintsDo: [ :c |
          c frame horizontal alignCenter.
          c frame vertical alignCenter ].
circle addEventHandlerOn: BlMouseDownEvent   do: [ :e | 
			self decreaseInput .
			 ].
		
circle addChild: minus.
self addChild: circle.

^circle


]

{ #category : #initialization }
MfInputElement >> initializePlus [
	| circle |
	
circle := BlElement new 
	background: Color black;
	border: (BlBorder paint: Color pink width: 2) ;
	layout: BlFrameLayout new;
	geometry: BlCircle new.
circle constraintsDo: [ :c |
	c frame horizontal alignRight .
	c frame vertical alignCenter ].
circle transformDo: [ :t |
	t translateBy: (-15)@0].

plus := BlTextElement new
	text: ('+' asRopedText attributes:  { (BlTextForegroundAttribute paint: Color white)}).
plus text fontSize: 55.
plus constraintsDo: [ :c |
	c frame horizontal alignCenter .
	c frame vertical alignCenter ].
circle addEventHandlerOn: BlMouseDownEvent   do: [ :e | 
			self increaseInput .
			 ].
circle addChild: plus.
self addChild: circle.

^ circle.
   
]

{ #category : #'visual properties' }
MfInputElement >> inputExtent [

	^ 300@120
]

{ #category : #accessing }
MfInputElement >> minus [ 

^minus.
]

{ #category : #action }
MfInputElement >> openInput: anInput [
	| space |
	space := BlSpace new.
	space root
		background: Color purple ;
		layout: BlFlowLayout horizontal.
	anInput transformDo: [ :c |
		c translateBy: 200@200
		 ].
	space root addChild: anInput  .
	space show.
	^ anInput 


]

{ #category : #'special characters' }
MfInputElement >> plus [
^plus.
]

{ #category : #'special characters' }
MfInputElement >> plusOrMinus [ 
^plus.
]

{ #category : #evaluating }
MfInputElement >> value [ 

^ value.
]
