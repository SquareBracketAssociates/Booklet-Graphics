# animation & Task

## task

space has its own pulse. At each pulse, it can call a BlTask.
`BlElement >> enqueueTask:` and `BlElement >> dequeueTask:` and monitor
`taskQueue`, either at space or element level.

You can defined pre-compute activity through BlTask which has different states

- new
- queued
- pendingExecution
- executing
- complete

BlTask is an abtract class that is specialized by *BlBaseAnimation* and *BlAnimation*

## Bloc animation & Task

Animation is a kind of BlTask, with additional information

- steps
- loops: the number of loops to execute an animation
- delay: how much time to postpone the actual start after an animation is added
- duration: how much time the animation will last for each step (start time + delay)
- event raised when step is done or loop is done.
 
Execution is done by *steps*

=> announcer
=> BlBaseAnimation and subclasses
=> addAnimation method in BlElement

```smalltalk
animtedBackground
<gtExample>
|element animation|

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
^element
```

## pre-defined animation

### Gaussian Effect opacity animation

Apply a gaussian blur effect with opacity on BlElement

TODO: Example to develop

### Opacity animation

Update the opacity of the BlElement from its initial value to specified opacity.

```smalltalk
(BlOpacityAnimation new opacity: 1.6) 
    duration: 300 milliSeconds.
```

### transform animation

Transform BlElement position. aBuilder being `BlTransformationBuilder`

Transform animation can be absolute or relative.
(consistent with absolute/relative vector path builder)

- #relative builds on existing element transformation
- #absolute defines new element independent transformation
  
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

### number transition

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

## animation composition

You can run multiple animation, in parallel or in sequence.

In `BlAnimationExamplesTest class >> ballsAnim` 2 transformation are applied
in parallel to multiples balls:

- position
- color

In `BlAnimationExamplesTest class >> sequential` 2 transformation are applied
sequencially to an element:

- position
- scale
