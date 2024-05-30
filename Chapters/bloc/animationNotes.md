

Here is how I currently understand how animation works.

An animation is a loop that can be repeated 0 to infinite times, during a specific duration, that can be splitted into steps,

           Step          Step        Step        Step          Step
|---------^---------^---------^---------^---------^------| animation loop

When your animation loop end, It'll emit the BlAnimationLoopDoneEvent event.
At each step, it'll emit the BlAnimationStepEvent event.

Here, an infinite animation, which loop every 1 second. 
```smalltalk
animation := BlAnimation new
	beInfinite;
	duration: 1 seconds.

animation addEventHandler: (BlEventHandler
	on: BlAnimationLoopDoneEvent
	do: [ :anEvent | self inform: 'loop done'. self dieValue: (1 to: faces) atRandom ]).
```

Each step is called at every BlUniverse pulse, as shown in this example: The random color is updated at every universe pulse, which surprised me at first. 

animation := BlNumberTransition new
             from: 0;
             to: 1;
             by: 0.5;
             loops: 5;
             duration: 3 seconds;
"onStepDo: is called on every space pulse. Color are updated at each pulse..."
             onStepDo: [ :aValue :anElement |
             aValue < 0.5
             ifTrue: [ anElement background: Color random ]
             ifFalse: [ anElement background: Color blue ] ].

You have various BlAnimation subclasses in the image, like BlColorTransition or BlNumberTransition to help transition between colors and a range of number. You also have BlTransformAnimation to help transform a BlElement. The mathematical effect for the transition is given by a subclass of BlEasing 

For a single element, you can apply multiple sequential animations with BlSequentialAnimation  .
You can also apply the same animation to multiple elements using BlParallelAnimation

```smalltalk
| space element translation scale sequential |
translation := (BlTransformAnimation translate: 300 @ 300)
   easing: BlEasingElastic new ;
   duration: 2 seconds.

scale := (BlTransformAnimation scale: 2 @ 2)
easing: BlEasingElastic new;
duration: 2 seconds.

sequential := BlSequentialAnimation new addAll: {
  translation.
  scale }.

element := BlElement new
   background: Color blue;
   size: 100 @ 100;
   position: 100 @ 100.
element addAnimation: sequential.

space := BlSpace new.
space root addChild: element.
space show.
^space
```

Hope this helps.
Renaud