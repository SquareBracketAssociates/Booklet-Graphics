# BlLayout and constraint

what you get in **constraintsDo:** is an object that represents constraint common to all layouts
for example not all layout support alignment therefore it is not realistic to expect common constraints to respond to alignments
let's take a linear layout as an example
you would say:

constraintsDo: [ :c |
   c linear horizontal alignCenter.
   c linear vertical alignBottom ];

layout is a global layout level alignment (see picture)
but constraints are per child element something like setting padding to each child,
vs padding to a container

## layout example 1

```smalltalk
layout1

 "This is a new method"
<gtExample>
^BlElement new layout: BlLinearLayout horizontal;
size: 400@300;
background: (Color gray alpha: 0.2);
addChildren: {
BlElement new size: 100@200; background:(Color red alpha: 0.2).
BlElement new size: 200@100; background:(Color blue alpha: 0.2)
}
```

## layout example 2

```smalltalk
layout2
<gtExample>
 "This is a new method"
 
 ^BlElement new layout: BlLinearLayout horizontal alignCenter;
size: 400@300;
background: (Color gray alpha: 0.2);
addChildren: {
BlElement new size: 100@200; background:(Color red alpha: 0.2).
BlElement new size: 200@100; background:(Color blue alpha: 0.2)
}
```

## layout example 3

```smalltalk
layout3
<gtExample>
 "This is a new method"
 ^BlElement new layout: BlLinearLayout horizontal "alignCenter";
size: 400@300;
background: (Color gray alpha: 0.2);
addChildren: {
BlElement new size: 100@200; background:(Color red alpha: 0.2).
BlElement new size: 200@100; background:(Color blue alpha: 0.2);
constraintsDo:[ :c | c ignoreByLayout.
c vertical exact: 200.
   c horizontal exact: 100.
   c ignored horizontal alignRight.
   c ignored vertical alignBottom].
}  
```

## layout example 4

```smalltalk
layout4
<gtExample>
 "This is a new method"
 ^BlElement new layout: BlLinearLayout horizontal "alignCenter";
size: 400@300;
background: (Color gray alpha: 0.2);
addChildren: {
BlElement new size: 100@200; background:(Color red alpha: 0.2).
BlElement new size: 200@100; background:(Color blue alpha: 0.2);
constraintsDo:[ :c | c ignoreByLayout.
c vertical exact: 200.
   c horizontal exact: 100.
   c horizontal matchParent.
   c ignored horizontal alignRight.
   c ignored vertical alignBottom].
}
```

## layout example 5

```smalltalk
layout5
<gtExample>
 "This is a new method"
 
 ^BlElement new layout: BlLinearLayout horizontal alignCenter;
size: 400@300;
background: (Color gray alpha: 0.2);
addChildren: {
BlElement new size: 100@200; background:(Color red alpha: 0.2).
BlElement new size: 200@100; background:(Color blue alpha: 0.2);
constraintsDo:[ :c | c margin: (BlInsets all: 10)].
}
```
