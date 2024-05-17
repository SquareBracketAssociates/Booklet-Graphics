Class {
	#name : #MfInputText,
	#superclass : #BlTextElement,
	#category : #InputWidget
}

{ #category : #initialization }
MfInputText >> initialize [ 

super initialize .
self text: ('Input' asRopedText attributes:  { (BlTextForegroundAttribute paint: Color white)}).
self text fontSize: 25.
self constraintsDo: [ :c |
	c frame horizontal alignCenter ].
self transformDo: [ :t |
	t translateBy: 0@10].
]

{ #category : #accessing }
MfInputText >> text [ 

^text
]

{ #category : #accessing }
MfInputText >> text: aText [

text:= aText .
]
