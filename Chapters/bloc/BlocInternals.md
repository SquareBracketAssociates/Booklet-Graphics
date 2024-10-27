## relation between BlUniserse, BlSpace, BlHost

BlUniverse contain multiple BlSpace.
However, we call `BlElement openInNewSpace`
This will open a new OS Windows, with our scene

BlSpace is your main entry point to your application. It'll connect you to 
OS window, manage which element needs drawing and the rendering of your scene.
Rendering is done by a dedicated render class, BARenderer by default.

Host has their own pulse loop which are then transmitted to their BlSpace
My loop follows the next rules:

•	The #pulsePeriod duration is the minimum amount of time between two subsequent sends of #pulse.
•	If a pulse took more time than #pulsePeriod, then the next pulse may either send the next #pulse immediately, or do a small wait before if another process with lower priority is suspended (and may be starving).

The opened spaces listen the pulse to be synchronized and to update their state when it is needed.



Each BlSpace is hosted in  a specific BlHost environment.
All these BlHost are then accessible through BlUniverse.

 As of this writing, it can be Morphic or an OS Window,
using OSWindow and SDL2 backend. 



We begin with `BlElement >> openInNewSpace`
or `BlElement >> openInSpace`  which are equivalent.

```smalltalk
BlElement >> openInNewSpace
	"Add self to a new BlSpace and show it. Answer such space."
	
	| aSpace |
	aSpace := BlSpace new.
	aSpace root addChild: self.
	aSpace show.
	^ aSpace
```

## window & event management

Contrary to GTookit, BlSpace is not a subclass of BlElement. It has, however,
a lot of specific responsabilities:

```smalltalk
BlSpace >> initialize

	super initialize.
	id := UniqueIdGenerator generateUniqueId.

	host := BlHost pickHost. "Return all supported Bloc host classes, sorted by priority (lowest first)."
	nextPulseRequested := true.
	session := Smalltalk session.
	elementsNeedingPaint := Set new.
	elementsNeedingLayout := Set new.

	eventDispatcher := self defaultEventDispatcher.
	eventListener := self defaultEventListener.
	self initDispatcher.

	mouseProcessor := BlMouseProcessor space: self.
	focusProcessor := BlFocusProcessor space: self.
	keyboardProcessor := BlKeyboardProcessor space: self.

	tasks := BlSpaceTaskQueue space: self.
	time := BlTime real.
	frame := BlSpaceFrame new.

	rootElement := self defaultRoot.

	self extent: self defaultExtent.

	self resizable: true.
	self borderless: false.
	self fullscreen: false.
	self fullsize: false.
	self title: self defaultTitle.
	self focused: false.

	self updateCursor: Cursor normal.

	self root space: self
```

```smalltak
BlSpace >> show
	"Open me in a window and show it to the user"

	"delegate showing work to the Universe"
	(BlParallelUniverse forHost: self host class) openSpace: self
```

BlHost and other possibilities:
- BlOSWindowSDL2Host (define its own pulse loop)
- BlMorphicWindowHost (use morphic loop)

We can define in the space which host to use:
```
BlSpace new
		host: host;
		title: host asString;
		extent: 200 asPoint;
		show
```

By default, it'll use `BlOSWindowSDL2Host`

You can look at `window - properties` protocol for all public API BlSpace offer
to manage its windows. 

*BlSpace* are containted in a *BlUniverse*, and its OS Window is managed by a 
*BlHost*.

BlOSWindowSDL2Host will create it own its own element and renderer.

Host is linked to a renderer and a way to catch keyboard event.

```smalltalk
BlOSWindowSDL2Host >> createHostSpace
	^ BlOSWindowSDL2HostSpace new
```

```smalltalk
BlOSWindowSDL2Host >> keyboardKeyTable
	^ BlOSWindowSDL2KeyboardKeyTable default
```






## Pulse and animation management.
`BlOSWindowSDL2Host` has its own pulse loop

```smalltalk
BlHostPulseLoop >> defaultPulsePeriod
	^ 15 milliSeconds
```


```smalltalk
BlSpaceFrameDrawingValidationPhase >> runOn: aSpace

	aSpace hasHostSpace
		ifFalse: [ ^ self ].

	aSpace hostSpace needsRebuild
		ifTrue: [ ^ self ].

	aSpace hostSpace hasResized
		ifFalse: [ ^ self ].

	aSpace invalidateAll.
	aSpace hostSpace initializeRenderer
```

Renderer is defined by 
```smalltalk
BlOSWindowSDL2Host >> createHostSpaceFor: aSpace
	"Create and assign a new host space for given bloc space"

	| aHostSpace|
	aHostSpace := self createWindowSpaceFor: aSpace.
	aHostSpace renderer: BlHostRenderer preferableClass new.

	aSpace hostSpace: aHostSpace
```

`BlHostRenderer preferableClass` return `BARenderer`

```smalltalk
BARenderer >> initializeForHostSpace: aBlHostSpace
	"Initialize this renderer for a given host space.
	Please note, that it I be called multiple times"

	self initialize.

	session := Smalltalk session.
	
	"we should mark it as a current one before initializing a canvas as it may rely on opengl context"
	aBlHostSpace makeCurrent.

	surface := aBlHostSpace newBlHostRendererSurface.
	surfaceRenderer := surface newSurfaceRendererOn: aBlHostSpace.
	spaceRenderer := surface newSpaceRendererOn: self.

	textMeasurer := BASpaceTextMeasurer new
		spaceRenderer: spaceRenderer;
		yourself
```

new BLHostRendererSurface ->
```smalltalk
BlOSWindowSDL2HostSpace >> newBlHostRendererSurface

	^ BlHostRendererBufferSurface newForHostSpace: self
``` 

`surface newSpaceRenderOn: self will lead to:

```smalltalk
BlHostRendererBufferSurface >> createSpaceRendererOn: anObject

	^ anObject createBufferSpaceRenderer
```

which will return `BABufferSpaceRenderer new`

Which will end to 

```smalltalk
BABufferSpaceRenderer >> initializeForSurface: aBlHostRendererBufferSurface 

	self
		initializeForSurface: aBlHostRendererBufferSurface
		and: (AeCairoImageSurface
					newForData: aBlHostRendererBufferSurface buffer
					extent: aBlHostRendererBufferSurface extent
					stride: aBlHostRendererBufferSurface stride
					format: AeCairoSurfaceFormat argb32)
```

## BlSpace frame
Each phase knows about its start time and send a corresponding event once the phase is completed.


```smalltalk
BlSpace >> processPulse
	self ensureSession.
	
	self pulseRequested
		ifFalse: [ ^ self ].
	
	"flip to false beforehand to be able to know if the next pulse was needed during the frame"
	nextPulseRequested := false.
	self frame runOn: self
```

```smalltalk
BlSpaceFrame >> runOn: aSpace
	self incrementFrameId.
	self runCurrentPhaseOn: aSpace.

	[ self hasNextPhase ] whileTrue: [
		self switchToNextPhase.
		self runCurrentPhaseOn: aSpace ].

	"move back to the first phase"
	self switchToNextPhase
```

`BlSpaceFrame class`, 
```smalltalk
BlSpaceFrame >> initializePhases
	self addPhases: { 
		BlSpaceFrameIdlePhase new.
		BlSpaceFrameHostValidationPhase new.
		BlSpaceFrameTaskPhase new. " animation as an example "
		BlSpaceFrameEventPhase new. " generate BlMouse events from host mouse event as an example "
		BlSpaceFrameDrawingValidationPhase new.
		BlSpaceFrameLayoutPhase new. " layouting all elements that requested layout "
		BlSpaceFrameDrawingPhase new " drawing invalidate elements  "}
```

This sequence will repeat itself and redraw invalidate elements in the end.

```smalltalk
BlSpaceFrameDrawingPhase >> runOn: aSpace
	aSpace
		dispatchTimeEvent: BlSpaceRenderEndEvent
		during: [ :theSpace | BlSpaceRenderSignal for: theSpace block: [ theSpace render ] ]
```

Which calls:

```smalltalk
BlSpace >>> render
	"Render this space in my host window if it is assigned, otherwise do nothing"

	self
		hostSpaceDo: [ :aHostSpace | aHostSpace render: self ]
		"if there is no host we should clear dirty areas, otherwise
		it may lead to memory leaks"
		ifAbsent: [ self clearDirtyElements ]
```

```smalltalk
BlHostRenderer >> render: aHostSpace
	"Render a given space according to its dirty areas.
	Note: if there are no dirty areas nothing will happen, including window
	or canvas update."

	| aSpace shouldUpdateEveryFrame isRenderNeeded |
	aSpace := aHostSpace space.
	shouldUpdateEveryFrame := surface shouldUpdateEveryFrame.
	isRenderNeeded := aSpace hasDirtyElements.

	(shouldUpdateEveryFrame or: [ isRenderNeeded ])
		ifFalse: [ ^ self ].

	self isValid
		ifFalse: [ ^ self ].

	[ | theDamagedRectangles |
		aHostSpace makeCurrent.
		
		theDamagedRectangles := isRenderNeeded
			ifTrue: [ spaceRenderer renderSpace: aSpace ]
			ifFalse: [ #() ].

		surface performUpdates.

		surfaceRenderer renderSurface: surface damaged: theDamagedRectangles ]
			ensure: [ self finishedRender: aSpace ]
```

Which finally call:

```smalltalk
BASpaceRenderer >> renderSpace: aBlSpace
	"Render a space and return a collection of damaged rectangles"

	aBlSpace aeFullDrawOn: aeCanvas.
	^ #()
```


## BlSpace drawing sequence

It'll begin with

```smalltalk
BASpaceRenderer >>renderSpace: aBlSpace
	"Render a space and return a collection of damaged rectangles"

	aBlSpace aeFullDrawOn: aeCanvas.
	^ #()
```

```smalltak
BlSpace >> faeFullDrawOn: aeCanvas

	self root aeFullDrawOn: aeCanvas
```

Which then call BlElement render call

```
BlElement >> aeFullDrawOn: aCanvas
	"Main entry point to draw myself and my children on an Alexandrie canvas."

	self aeDrawInSameLayerOn: aCanvas.

	self aeCompositionLayersSortedByElevationDo: [ :each | each paintOn: aCanvas ]
```


```smalltalk
BlElement >> aeCompositionLayersSortedByElevationDo: aBlock

	(self isTransparent or: [ self isVisible not ])
		ifTrue: [ ^ self ].

	self wantsSeparateCompositingLayer ifTrue: [
		self hasCompositionLayer ifFalse: [
			self compositionLayer:
				(BAAxisAlignedCompositionLayer newFor: self) ].
		aBlock value: self compositionLayer ].

	self flag: #todo. "extract to allow overriding, exactly as aeDrawChildrenOn:"
	self children sortedByElevation do: [ :each |
		(each aeCompositionLayersSortedByElevationDo: aBlock) ]
```

Drawing is separated into layers.

Drawing is done on one instance of AeCanvas.
Alexandrie Canvas for bloc, which is not Alexandrie Canvas for Cairo.
You can still view the temporary result with `aeCanvas asForm`.

Start with BASpaceRenderer >> renderSpace: aBlSpace
	aBlSpace aeFullDrawOn: aeCanvas.
	
BlElement >> aeFullDrawOn: aCanvas
	BlElement >> aeDrawInSameLayerOn: aCanvas.
		BlElement >> aeDrawOn: aeCanvas
		BlElement >> aeDrawIgnoringOpacityAndTransformationOn: aeCanvas
			BlElement >> aeDrawEffectBelowGeometryOn: aeCanvas.
			BlElement >> aeDrawGeometryOn: aeCanvas.
			BlElement >> aeDrawEffectAboveGeometryOn: aeCanvas.
			BlElement >> aeDrawChildrenOn: aeCanvas. "Z-index: children sorted by elevation"
				BlElement >> aeDrawInSameLayerOn: aCanvas "and recursive repeat"
	BlElement >> aeCompositionLayersSortedByElevationDo: [ :each | each paintOn: aCanvas ].
	
BlElement >> aeCompositionLayersSortedByElevationDo:  call
	BAAxisAlignedCompositionLayer >> paintOn: aCanvas
	BAAxisAlignedCompositionLayer>> ensureReadyToPaintOn: aCanvas
		BlElement >> aeDrawAsSeparatedLayerOn: layerCanvas
			BlElement >> aeDrawIgnoringOpacityAndTransformationOn: layerCanvas