# Morphic introduction


## What is morphic ?

 Morphic is a user interface framework that supports composable graphical
 objects, along with the machinery required to display and animate these
 objects, handle user inputs, and manage underlying system resources such as
 displays, fonts and colormaps. A primary goal of Morphic is to make it easy to
 construct and edit interactive graphical objects (morphs), both by direct
 manipulation and from within programs.


### Morphs

The central abstraction of morphic is the graphical object or morph (from the
Greek for "shape" or "form"). A morph has a visual representation that can be
picked up and moved. Any morph can have component morphs (called submorphs). A
morph with submorphs is called a composite morph. A composite morph is treated
as a unit, moving, copying, or deleting a composite morph causes all it's
submorphs to be moved, copied, or deletet as well.

By convention, all morphs are visible; Morphic does not use invisible structural
morphs for aggregation. This means that if a composite morph is disassembled,
all of its component morphs can be seen and manipulated.


### Classic Morphic Programming

In "Classic Morphic Programming" style, you define your own subclasses of one or
more generic Morph classes, and blend them into a working subsystem. Here,
you're directly extending Morphic, in grand and time-honored Smalltalk manner.
The fundamental tool here is the Browser: you locate and familiarize yourself
with particular Morphic classes, and you then subclass the ones that you decide
are appropriate for your application.

Most current Squeak users will prefer this traditional, mature, analytic,
browser-based Smalltalk approach,

### Scripting with Players - The "User-Scripting" Style

The second style of programming is rather more informal, more like "scratch
programming", somewhat comparable to what we Smalltalkers do when we use a
Workspace to construct and evaluate various lines of code for some exploration
or calculation in Smalltalk, and also comparable to the kind of scripting done
by users of systems like HyperCard and HyperStudio, etc.

In the User-Scripting style, you construct surface graphics by directly
assembling standard Morphic parts -- e.g. Rectangles, Images, Joysticks, etc.,
by dragging them from a Parts Bin and arranging them as desired, and then you
add user-defined state and behavior by adding instance variables and writing
methods for "Players" who represent the individual morphs you wish to script.

The user thus does not directly subclass any particular kind of Morph, but
rather she *assembles* Morphs and gives them special state and behavior by
associating them with "Players", which are the fundamental user-scriptable
object types for User Scripting. (The basic hookup is that every Morph can have,
optionally, a Player as it's "costumee", and every Player has an associated
Morph that it "wears" as its "costume". Player itself is a class with lots of
capability but very little instance state; user-defined Players are all
implemented as compact,single-instance subclasses of Player.)

### The "Halo"

The "Halo" lets you interact with any object you can touch (i.e., any morph).
Alt-Click on a morph to bring up its halo.

Successive alt-clicks will transfer the halo to the next morph in the hierarchy. 
Mouse over the various halo handles and read the help-balloons that will pop up
to explain what each handle does. The name of the object that currently bears a
halo will be seen at the base of the halo (and a click on the name will let you
edit it.)

### main classes (somehow historic ones)
**Morph**, **BorderedMorph**, **AlignmentMorph**, **WorldMorph**

You can ask a morph for his world by sending the message world. WorldMorph is a
direct subclass of PasteUpMorph.

[source](https://fmfi-uk.hq.sk/Informatika/Smalltalk/Online%20Book/english/sqk/sqk00030.htm)

• Morph is a superclass of graphical objects; it has methods that let those objects respond to events and display themselves.
• All morphs have bounds (rectangles on the screen), and can have submorphs.
• The world (the screen or page) is itself a morph. This gives you the basic model for a scene graph displayed on the screen.
• A hand object, shown as the cursor (and also part of the world), can pick up other objects and drop them elsewhere, thus effecting not only motion but also changes in the structure of the scene graph. The hand is also the source of user event messages such as mouseDown: and mouseMove:.
• User events such as mouseDown: are passed as messages from the screen, down through the scene graph, to the frontmost morph that contains the location of the event.
• Morphs typically define methods that respond to user input events like mouseDown:, or to the passage of time through a tick message from the world.
• When a morph’s position or appearance changes, a changed message causes the Morphic display system to update the screen efficiently, and without flashing.
• Both normal screen changes and animations are handled by a simple iterative kernel:
    forever do:
    detect and dispatch user events, such as mouseDown:, mouseMove:
    run step methods defined for any morphs,
    compute the affected screen area, and update it using double buffering
(source: the evolution of smalltalk.pdf)

## coordinate systems

A morph has two coordinate system:

- from the outsite world
- from itself, its bounds
Accesssible in the geometry protocol
For example, if you specify a point directly, Morph will position it in the world.
Bounds are recalculated when we move the morph, and coordinate associated with it
are recalculated accordingly.

Morphic:
Un Morph est définis par son "bounds", soit le rectangle délimitant son espace.
<http://wiki.squeak.org/squeak/morphic>
<https://wiki.squeak.org/squeak/2141>

Pour créer un nouveau widget:

- drawOn: dessine le nouveau widget.
- containsPoint: pour définir la place effectivement occupé à l'ecran

Gestion de la souris et des évènement.

- handleMouseDown: et
  - mouseDown:; mouseUp:

- handleMouseOver:
  - mouseEnter: et mouseLeave:

- handleKeyStroke

To get World form:
```
Smalltalk currentWorld worldState  worldRenderer window renderer form
```
Now, you can play a little bit with it:
```smalltalk
canvas := FormCanvas on: (Smalltalk currentWorld worldState  worldRenderer window renderer form).

canvas drawRectangle: (10@10 extent: 200@100) color: Color blue borderWidth: 3 borderColor: Color red.

canvas form.
```
will display a rectangle in the world. You can see it by moving your playground
window on the top of it. To make it disappear, simply do:
`Smalltalk currentWorld fullRepaintNeeded`. Because your rectangle is not part
of the world as calculated by Morphic, it will disappear.

Pour combiner les Morph:
- addMorph: and all method in protocol 'submorphs-add/remove'
- position, dans le protocol geometry
Note that the geometry protocol is used to position element inside a Morph.
It can be used as well in the drawOn: message, so it used either for drawing
or for position Morph when we combine them.
- layout policy: <https://wiki.squeak.org/squeak/2141>

Animation:

- step and StepTime

Drag&Drop:

Get Form generated by Morph: AthensHello new imageForm  

When you open a Morph with the message openInWorld, it'll add itself to the
global world Morph: `aWorld addMorph: self.`

Exemple de construction de fenêtre morphic avec modèle: FontChooserMorph et FontChooser
Exemple de morph affiché dynamiquement: CalendarMorph on: '2020-01-21' asDate
Exemple de morph construit par aggregation de morph: CheckboxMorph  new openInWorld

- on dérive d'un morph, et on ajoute les nouveaux morph intéressant.

self bounds corner - self bounds origin
bounds is a Rectangle object. As such, you can find its coordinate,
either relative from Pharo world: bounds origin, bounds corner,
or by itself, going from 0@0 to bounds extend

Canvas utilisé par défaut: FormCanvas
Athen dessine dans une image, qu'il envoie ensuite dans le canvas.


Morph subclass: #AthensDemoMorph

drawOn: aCanvas

self halt.
 self render.

 aCanvas
  drawImage: surface asForm at: self bounds origin

asForm
 "create a form and copy an image data there"
 self checkSession.
 self flush.
  ^ (AthensCairoSurfaceForm extent: (self width@(self height)) depth: 32 bits: id)
  surface: self;
  yourself

Morph a trop de responsabilité:

- layout de sous-morph (protocol geometry)
- styling
- gestion des menus du World

HandMorph -> souris.

WorldMorph doOneCycle -> permet de rafraichir le monde.
Va parcourir les sous-morph qui composent le monde, et va les dessiner, en utilisant le canvas par défaut: FormCanvas

Le canvas va utiliser la classe Form, qui est un espace rectangulaire pour mettre une image.
La classe Form utilise ensuite BitBlt pour envoyer son dessin vers l'écran

## morphic world

- managing system cursor:
[https://github.com/pharo-project/pharo/commit/a9e5d8cbb142334e002875c72fe4b8eb9f78e64d#diff-9de4d9ca26fa0ecc18374ee9e3087f5309eac071b9eb992e3ff03c27a63aa4a6]

- managing display
[https://github.com/pharo-project/pharo/commit/4e3d8862af9e72110a97bc314ea696677fb1226e#diff-9de4d9ca26fa0ecc18374ee9e3087f5309eac071b9eb992e3ff03c27a63aa4a6]

- updating display resolution
[<https://github.com/pharo-project/pharo/commit/0a6041d7a3331d827a23d465373e591d4fc33e67>#]

## drawing

Morphic is currently the way to go on pharo for Graphics. However, all existing canvas
are pixel based, and not vector based. This can be an issue with current screen,
where the resolution can differ from machine to machine.

Enter Athens, a vector based graphic API. Under the scene, it can either use
balloon Canvas, or the cairo graphic library for the rasterization phase.

When you integrate Athens with Morphic, you'll use the rendering engine to
create your picture. It's then transformed in a Form and displayed using on
the screen using BitBlt.

## Athens with Morphic

We'll see how to use Athens directly integrated with Morphic. So will be the
base class we'll use after for all our experiment:

First, we define a class, which inherit from Morph:

```smalltalk
Morph subclass: #AthensHello
    instanceVariableNames: 'surface'
    classVariableNames: ''
    package: 'Athens-Hello'
```

During the initialization phase, we'll create our Athens surface:

```smalltalk
AthensHello >> initialize
    super initialize.
    self extent: self defaultExtent.
    surface := AthensCairoSurface extent: self extent.
```

where defaultExtent is simply defined as

```smalltalk
AthensHello >> defaultExtent
    ^ 400@400
```

The drawOn: method, mandatory in Morph subclasses, will ask Athens to render
its drawing, and it'll then display it in a Morphic canvas as a Form (a bitmap
pictures)

```smalltalk
AthensHello >> drawOn: aCanvas

    self renderAthens.
    surface displayOnMorphicCanvas: aCanvas at: bounds origin.
```

Our actual Athens code is located into renderAthens method:, and the result is
stored in the surface instance variable.

```smalltalk
AthensHello >> renderAthens
|font|
font := LogicalFont familyName: 'Arial' pointSize: 10.

    surface drawDuring: [:canvas | 
        "canvas pathTransform loadIdentity."
        surface clear. 
        canvas setPaint: ((LinearGradientPaint from: 0@0  to: self extent) colorRamp: {  0 -> Color white. 1 -> Color black }).
        canvas drawShape: (0@0 extent: self extent). 
        canvas setFont: font. 
        canvas setPaint: Color pink.
        canvas pathTransform translateX: 20 Y: 20 + (font getPreciseAscent); scaleBy: 2; rotateByDegrees: 25.
        canvas drawString: 'Hello Athens in Pharo/Morphic'
        
    ].
```

To test your code, let's add an helper method. This will add a button on the left
of the method name. When you click on it, it'll execute the content of the
script instruction.

```smalltalk
AthensHello >> open
    <script: 'self new openInWindow'>
```

On last things. You can already create the window, and see a nice gradient, with
a greeting text. However, you'll notice, if you resize your window, that the
Athens content is not resized. To fix this, we'll need one last method.

```smalltalk
AthensHello >> extent: aPoint
    | newExtent |
    newExtent := aPoint rounded.
    (bounds extent closeTo: newExtent)
        ifTrue: [ ^ self ].
    self changed.
    bounds := bounds topLeft extent: newExtent.
    surface := AthensCairoSurface extent: newExtent.
    self layoutChanged.
    self changed
```

Congratulation, you have now created your first morphic windows where content
is rendered using Athens.
