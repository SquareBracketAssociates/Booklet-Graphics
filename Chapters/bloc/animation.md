## animation


- Bloc animation
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