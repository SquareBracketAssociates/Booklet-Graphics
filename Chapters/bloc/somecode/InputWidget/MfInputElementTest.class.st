Class {
	#name : #MfInputElementTest,
	#superclass : #TestCase,
	#category : #InputWidget
}

{ #category : #tests }
MfInputElementTest >> testEverythingIsInitializedCorrectly [

| inputElem |

inputElem:= MfInputElement new.
self assert: inputElem children size equals: 4. 

]

{ #category : #tests }
MfInputElementTest >> testValueCantBeNegative [

| inputElem value | 

inputElem:= MfInputElement new.
value := (inputElem initializeInputValue:  '0') text asString asNumber .
BlSpace simulateClickOn: inputElem minus.
self assert: value equals: 0.

]

{ #category : #tests }
MfInputElementTest >> testValueUpdatedOnClick [

| inputElem |

inputElem:= MfInputElement new.
BlSpace simulateClickOn: inputElem minus.
self assert: inputElem value equals: 19.
1 to: 6 do: [ :i |
	BlSpace simulateClickOn: inputElem plus ].
self assert: inputElem value equals: 25.  



]
