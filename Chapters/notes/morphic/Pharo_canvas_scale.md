# how canvas scale is working to allow better font rendering

canvas scale factor set up in `OSWorldRenderer >> canvasScaleFactor`.
value used in `OSWorldRenderer >> checkForNewScreenSize`.

```smalltalk
(world == World and: [ self class autoSetCanvasScaleFactor ]) ifTrue: [
        self class canvasScaleFactor: (windowRenderer outputExtent / self windowExtent) min * self screenScaleFactor ].
```

Let's look at the different variables:
- windowRenderer outputExtent
    -> `Smalltalk currentWorld worldState worldRenderer osWindowRenderer outputExtent`
    -> (3840@2054 in my current example)
- windowExtent
    -> `Smalltalk currentWorld worldState worldRenderer windowExtent `
    -> (3840@2054 in my current example)
- screenScaleFactor = world scaleFactor * self windowScaleFactor
    -> `Smalltalk currentWorld worldState worldRenderer screenScaleFactor`
    -> `Smalltalk currentWorld worldState worldRenderer world scaleFactor`
    -> `Smalltalk currentWorld worldState worldRenderer windowScaleFactor`
    -> 1.5 in my current example

# OSWorld Canvas definition
```smalltalk
OSWindowFormRenderer >> getCanvas
    | scale formCanvas |
    scale := self canvasScaleFactor.
    formCanvas := form getCanvas.
    ^ scale = 1
        ifTrue: [ formCanvas ]
        ifFalse: [ ScalingCanvas formCanvas: formCanvas scale: scale ]
```

# ScalingCanvas internal works.

A ScalingCanvas provides scaling on an underlying *FormCanvas*.

The method `ScalingCanvas class>>#example` and other methods in the same protocol
compare drawing using a FormCanvas and then scaling the Form to drawing using a
ScalingCanvas directly on a scaled Form. Using the ScalingCanvas, text is drawn
using more detailed character glyphs, and any FormSet is drawn using the
scale-specific Form if available.

Scaling canvas reimplement canvas method by taking in account the zoom factor.
Instead of drawing the figure and then scaling the result, it draws the figure
with the scale factor directly apply to method. This prevent the blurry effect
of scaling the Form after being rendered.
