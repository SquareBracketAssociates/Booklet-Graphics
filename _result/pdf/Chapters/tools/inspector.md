# Inspector presentation extent

One can extend the view of inspector, using spec2 presenter

## integration with spec

Add method with pragma: `<inspectorPresentationOrder: xx title: 'aTitle'>`
The method can accept zero or one argument: an instance of *SpPresenterBuilder*,
and it must return an instance of a spec2 presenter. 

Inspector extension work by instanciating spec presenter. You can call
any presenter you want to display in this panel, or you can use the builder if
you prefer this way of working

* SpListPresenter <=> builder newList
* SpTextPresenter <=> builder newText
* SpTablePresenter <=> builder newTable
* SpMorphPresenter <=> builder newMorph
* Etc.

The builder allow users to compose presenters without needed to have hard coded
the name of them (which could or not change/be present/etc.), The following two
lines are equivalent, and the second one is preferred for common presenters.

    list := self instantiate: SpListPresenter
    list := self newList.

Ex:

```smalltalk
inspectionMock1
<inspectorPresentationOrder: 0 title: 'Mock 1'>

^ SpLabelPresenter new
    label: 'Test';
    yourself
```

```smalltalk
inspectionTree: aBuilder
    <inspectorPresentationOrder: 1 title: 'Tree Structure'>

    ^ aBuilder newTree
        roots: { self };
        children: [ :each | each children ];
        expandRoots;
        yourself
```

For simple key-value panel, you can use *StSimpleInspectorBuilder*

```smalltalk
(StSimpleInspectorBuilder on: specBuilder)
    key: 'error' value: 'too many bytes, size is ' , self size asString;
    table
```

An example using double dispatch:

```smalltalk
AeCairoContext >> inspectionOfSurfaceAsForm: aBuilder
    <inspectorPresentationOrder: 0 title: 'Surface'>

    ^ surface inspectionAsForm: aBuilder

AeCairoImageSurface inspectionAsForm: aBuilder
    <inspectorPresentationOrder: 1 title: 'Form'>

    ^ aBuilder newMorph
        morph: (AePollingImageMorph new model: self; yourself);
        yourself
```

Presenter can be standard spec2 widget, or custom spec2 view you may have
created for your project. If you want to have custom layout with multiple
widgets, it may be necessary to create your own spec2 presenter. This can
be reused like any other presenter as inspector extension panel.

## roassal integration

```smalltalk
SpRoassal3InspectorPresenter new
    canvas: self gtCanvasForInspector;
    yourself
```
