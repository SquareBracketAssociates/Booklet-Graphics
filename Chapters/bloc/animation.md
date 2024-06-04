## Animations

### Introduction

An animation is a transformation of a **target** bloc element that can
be decomposed into multiple **steps**. The total of each steps
composes a **loop** which can be repeated N time or **beInfinite**.

Animation can be started with a certain **delay**, and last for a
specific **duration**. Execution **progress** can be measured.
When a step or the full loop is complete, animation
will raise `BlAnimationStepEvent` or `BlAnimationLoopDoneEvent`.

Animation is automatically started when added to an element.
Once stopped, an animation is considered as **complete**.

### Lifetime 
Animation is a subclass of `BlTask`, a kind of runnable. You can
define pre-computed activities through BlTask which has different
states.

Tasks go through the following steps:

- new
- queued
- pendingExecution
- executing
- complete

Tasks cannot be submitted twice, so you cannot add multiple time
the same animation to the same element.

You can call **stop** to stop an animation. Restarting it is much
less obvious, as your animation will keep its current state.


#### Restarting an animation.

To restart an animation, you'll have to do this in a specific order,
as: `animation reset; start; setNew; enqueue`

- reset will, well, reset the animation internal state.
- start will tell the animation it can start. This is not enough, we also need to enqueue it into BlElement task queue. As you cannot add the same task twice, you need to tell it's new.
- setNew will set the *BlTask* state to #new.
- enqueue will re-enqueue your animation into BlElement task queue.

### Bloc animation & Task

- steps
- loops: the number of loops to execute an animation
- delay: how much time to postpone the actual start after an animation is added
- duration: how much time the animation will last for each step (start time + delay)
- event raised when step is done or loop is done.

When animation run, it'll call the `step` which in turn will call the `doStep`
When one step is done, it'll fire the `BlAnimationStepEvent` event.
When an entire loop animation is done, it'll fire the `BlAnimationLoopDoneEvent`event.

Step can be decomposed into multiple sub-step. All those sub-step
comprise the animation loop, which can be repeated multiple time of indefinitely.

At every pulse, `doStep` is called. Because of that, you can't
compute any new state during a step. You either have to pre-compute
it, or react to `BlAnimationStepEvent` to get new state.

You can use pre-defined animation class, or create your own animation
by subclassing `BlAnimation` and overwrite `valueForStep:`


```
valueForStep:` receive a progress number:
	"a normalized number within [0..1] representing animation progress.
	0 - means animation is not yet started.
	1 - animation loop is done"

	the progress value is the result of `BlEasing`selected class, which
	provides different mathematical function to go from 0 to 1

	progress := (elapsedTime / self duration) asFloat
	BlEasing: Math function taking progress as argument to show different animation style
	self applyValue: (self valueForStep: (easing interpolate: progress))
```

"Execute an actual animation step. My subclasses define this hook, and assume it's executed after my internal state has been updated, for example, progress."

Execution is done by *steps*:

```smalltalk
animatedBackground
	| element animation |
	element := BlElement new size: 50@50.
	animation := BlNumberTransition new
		from: 0;
		to: 1;
		by: 0.5;
		beInfinite;
		duration: 3 seconds;
		onStepDo: [ :aValue :anElement |
			aValue < 0.5
				ifTrue: [ anElement background: Color red ]
				ifFalse: [ anElement background: Color blue ] ].
	element addAnimation: animation.
```

### Pre-defined animations

#### Gaussian Effect opacity animation.

Apply a gaussian blur effect with opacity on `BlElement`:

```smalltak
BlGaussianEffectOpacityAnimation new
	delay: 1 second;
	color: Color red;
	width: 25;
	opacity: 0.9;
	duration: 300 milliSeconds.
```

#### Opacity animation.

Update the opacity of the BlElement from its initial value to specified opacity.

```smalltalk
 BlOpacityAnimation new
	delay: 1 second;
	opacity: 0.1;
	duration: 300 milliSeconds.
```

### Transform animation

Transform BlElement position. aBuilder being `BlTransformationBuilder`

Transform animation can be absolute or relative.
(consistent with absolute/relative vector path builder)

- relative builds on existing element transformation
- absolute defines new element independent transformation
  
```smalltalk
BlTransformAnimation new
	target: el;
	transformDo: [ :aBuilder |
		aBuilder translateBy:
			i * 15 @ (500 - (30 * (i / 25) ceiling)) ];
	delay: 80 milliSeconds * i;
	duration: 5000 milliSeconds;
	easing: BlEasing bounceOut.
```

You can have multiple easing classes. Have a look at:

- `BlViscousFluidInterpolator`
- `BlSineInterpolator`
- `BlQuinticInterpolator`
- `BlLinearInterpolator`
- `BlEasingQuad`
- `BlEasingElastic`
- `BlEasingBounceIn`
- `BlEasingBounceOut`
- `BlEasingBounceInOut`

### Color transition

Transition from one color to another

Switch from Color white to color random in 1 second.

```smalltalk
BlColorTransition new
	from: (Color white alpha: 0);
	to: Color random;
	delay: 80 milliSeconds * i;
	duration: 1000 milliSeconds;
	onStepDo: [ :c | el background: c ].
```

### Number transition

Transition from one number to another by specific jump.

Switch background from red to blue every 3 seconds.

```smalltalk
BlNumberTransition new
	from: 0;
	to: 1;
	by: 0.5;
	beInfinite;
	duration: 3 seconds;
	onStepDo: [ :aValue :anElement |
		aValue < 0.5
			ifTrue: [ anElement background: Color red ]
			ifFalse: [ anElement background: Color blue ] ].
```

### Animation composition

You can run multiple animations, in parallel or in sequence.

In `BlAnimationExamplesTest class >> ballsAnim` shows two transformations are applied
in parallel to multiples balls:

- position
- color

In `BlAnimationExamplesTest class >> sequential` two transformations are applied
sequencially to an element:

- position
- scale

### A simple rotation

A custom animation for element rotation.

```
BlAnimation << #BlRotateAnimation 
	slots: { #angle }; 
	tag: 'Animation'; 
	package: 'BookletGraphics'

BlRotateAnimation >> angle: anAngle 
	angle := anAngle

BlRotateAnimation >> applyValue: anAngle 
	self target transformDo: [ :t | t rotateBy: anAngle ]

BlRotateAnimation >> valueForStep: aNumber 
	^ (angle * aNumber)
```

You then update your example with:

```
| elt frame container anim |
elt := BlElement new 
	background: (Color red alpha: 0.5); 
	position: 100 asPoint; 
	size: 100 asPoint.
frame := BlElement new 
	background: Color yellow; 
	position: 100 asPoint; 
	size: 100 asPoint.
container := BlElement new 
	background: Color lightGreen; 
	size: 500 asPoint; 
	addChildren: {frame. elt}.

anim := BlRotateAnimation new angle: 90; duration: 1 second.

elt addEventHandlerOn: BlClickEvent do: [ elt addAnimation: anim copy ].

container openInSpace
```



### Conclusion (missing)