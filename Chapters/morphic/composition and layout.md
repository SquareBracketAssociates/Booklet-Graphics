# Morph composition and layout

Every Morph now has the capability to layout it's submorphs if it is given a LayoutPolicy. The default is to have no layout policy. Each Morph may have its own LayoutPolicy: either a *ProportionalLayout* or a *TableLayout*

*AlignmentMorph*, which originaly was the only morph who could implement layout policies, is  available because of compatibility reasons and some utility methods it implements.

You should also be able to make your own subclasses of **LayoutPolicy**.

## examples

### centeredMorph1

```smalltalk
 | myLayoutMorph m |
 myLayoutMorph := Morph new.
 myLayoutMorph layoutPolicy: TableLayout new. "center submorphs"
 myLayoutMorph listCentering: #center.
 myLayoutMorph wrapCentering: #center.

 myLayoutMorph width: 320.
 myLayoutMorph height: 240.
 myLayoutMorph color: Color white darker.

 m := Morph new color: Color red.
 m width: myLayoutMorph width - 40.
 m height: myLayoutMorph height - 40.


 myLayoutMorph addMorph: m.
 myLayoutMorph openInWorld
```

### centeredMorph2

```smalltalk
 | myLayoutMorph m |
 myLayoutMorph := Morph new.
 myLayoutMorph layoutPolicy: TableLayout new.
 myLayoutMorph color: Color gray.

 myLayoutMorph listDirection: #leftToRight.
 myLayoutMorph
  hResizing: #shrinkWrap;
  vResizing: #shrinkWrap.
 myLayoutMorph layoutInset: 20.

 m := Morph new color: Color green darker.
 m width: 300.
 m height: 200.

 myLayoutMorph addMorph: m.
 myLayoutMorph openInHand
```

### textLayoutMorph1

```smalltalk
 | r e s b |
 r := Morph new.
 r color: Color gray.
 r position: 10 @ 10.
 r extent: 150 @ 200.
 r name: 'background'.
 r openInWorld.

 r layoutPolicy: TableLayout new. "lay out contents as a table"
 r listDirection: #topToBottom. "how we want to place the contents"
 r listCentering: #topLeft. "start list at the top"
 r wrapCentering: #center. "each item is in the center"
 e := EllipseMorph new.
 r addMorph: e.

 s := Morph new.
 s borderWidth: 1.
 s color: Color blue twiceDarker.
 r addMorph: s. "note that the new item goes at the top"

 b := SimpleButtonMorph new.
 b
  color: Color red;
  label: 'remove';
  target: r;
  actionSelector: #delete;
  setBalloonText: 'click to remove the background rectangle and contents'.
 r addMorph: b.

 r cellInset: 2 @ 5. "controls distance between content elements. Note that the inset can be a Number, a Point or even a Rectangle"

 r hResizing: #shrinkWrap. "try it and see!"
 r layoutInset: 4 @ 8. "that was a bt too cramped. Note that the inset can be a Number, a Point or even a Rectangle"
 r vResizing: #shrinkWrap "Now we are done"
```

## references

[source 1](https://wiki.squeak.org/squeak/2141)
[source 2](https://wiki.squeak.org/squeak/2765)
