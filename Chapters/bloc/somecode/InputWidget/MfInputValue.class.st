Class {
	#name : #MfInputValue,
	#superclass : #BlTextElement,
	#category : #InputWidget
}

{ #category : #initialization }
MfInputValue >> initialize [ 

super initialize .

self constraintsDo: [ :c |
	c frame horizontal alignCenter.
	c frame vertical alignCenter  ].

]
