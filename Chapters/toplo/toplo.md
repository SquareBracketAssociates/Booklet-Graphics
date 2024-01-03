# Toplo widget - highlevel

```smalltalk
Metacello new
    baseline: 'Toplo';
    repository: 'github://plantec/Toplo/src';
    onConflictUseIncoming;
    load
```

Toplo include bloc widget

## Theme

Define elementary properties that can be used by widgets:

- colors
- Fonts
- icons
- etc...

## skins

Toplo widgets interact with skins for the look.
*Skins rely on theme for elementary properties (colors, font, sizes…).*

Additionally, a skin can add animations and more.

ToButton >> defaultSkin

ToButtonSkin can be customized with the *type:* message, dependant of the button you want
to create:

- ToButtonDefaultType
- ToButtonLinkType
- ToButtonTextType
- etc.

## Behaviour

Created using method, factorized using Traits

## Spec styles

The idea behind styling in spec is that each backend will have its own way of define styling
a toplo skin can be taken as a "stylesheet"
(in the fact it can be defined at application level and then common to all widget created within that context).
In that sense the idea of Spec is:

- user defines an application which uses a backend
- user configure that backend, adding the stylesheets they use, in the format the backend expect: css for gtk, morphic stylesheet for morphic, skins for toplo(?)

at the end, the only constraint styling in spec would have is:

- styles are defined at the level of application
- styles are defined with a name
- styles can be applied to presenters using that name

## Hierarchy & Theme

Le **skin** est calculé, et stocké dans le **look** (ToWidgetSkin, sous classe de BlCustomEventHandler)

Skin will update the layout of parent ToElement, by adding for exemple child element
to your main element. ToCheckBox will get 2 additional element, label and image
that will show up on the screen.

look at childSkinsToHandle and skinnablePropertyChangedEvent: anEvent

Ex. ToCheckbox
ToCheckbox >> defaultDresser => ToCheckableButtonDresser (event management)
ToCheckbox >> defaultSkin -> ToCheckboxSkin (appearance)
    -> use Traits TToCheckboxSkin, to define look using Theme

Could use Look like in ``ToCheckableSkin >> onSkinInstalledIn:`` which use
ToCheckLook. Look connec event to appearance (like clicked, hover, etc.)

Theme are subclasses of ToAbstractTheme, added to a BlElement (toTheme method)

When element change, raise an event: ToSkinnablePropertyChangedEvent

childSkinsToHandle

^ {
    (ToChildSkinBuilder new
        slotName: #icon;
        builder: [ :e | self iconSkinIn: e ];
        yourself).
    (ToChildSkinBuilder new
        slotName: #label;
        builder: [ :e | self labelSkinIn: e ];
        yourself) }

ToChildSkinBuilder >> updateIn: anElement
childElement withSkin: skin

ToCheckableButtonDresser >> whenAddedToSpace: anEvent in: anElement

self flag: 'Leads to ToSpaceFrameSkinInstallationPhase installation in space frame. Should be revised to avoid this kind of workaround'.
    anElement space checkSpaceFrameSkinInstallationPhase.
    anElement checkSkinInstallation

## Process for Skin and look

For viewing the whole stack, put a breakpoint in `addChildren:` in ToCheckBox.

1. BlSpace generate a pulse,  and send *checkSkinInstallation* to its root and its children (ToCheckBox instance).

1. On each children, this will call *launchSkinInstallation* if *privateSkin* is not nill

`ToCheckBoxSkin (ToWidgetSkin) >> launchSkinInstallationIn:` on *ToCheckBox*
-> (double dispatch) `anElement switchToSkinState: ToInitialState` new will raise an event *ToElementStateChangedEvent* with element state.

1. Event will be catched by *ToCheckBoxSkin* which will change it again to

??? how ToCheckBoxSkin will subscribe to ToElementStateChangedEvent ???
Because its a subclass of ToElementLookEvent ?

ToElementStateChangedEvent sendTo: ToCheckBoxSkin
ToCheckBoxSkin elementLookEvent: ToElementStateChangedEvent
ToElementStateChangedEvent sendTo: ToCheckBoxSkin look
ToCheckLook elementLookEvent: ToElementStateChangedEvent
ToElementStateChangedEvent sendToLook: ToCheckLook
ToElementStateChangedEvent state sendEvent: ToElementStateChangedEvent toLook: ToCheckLook => ToElementStateChangedEvent state = ToInitialState.
ToCheckLook initialLookEvent: ToElementStateChangedEvent
ToElementStateChangedEvent elementDo: [ :e | self syncImageIn: e ] => element = self target = ToCheckBox.

=> ToCheckLook syncImageIn: ToCheckBox

ToCheckBox iconImage: im

ToCheckBox (from ToButton) will return a triplet { icon . label . extra }
This will be called because of `ToCheckLook syncImageIn: ToCheckBox`. Label can be called
separetely because you can set it when creating a new ToCheckBox.

4. Important element
**Skin are repeatable widget sub element. Look are graphical appearance for each sub widget element.**

Skin are defined with widget in *defaultSkin* method, referenced in trait **TToSkinable**.
Trait is applied to ToElement, which means every ToElement are skinnable.
*initializeSkin* is called in ToElement and subclasses, which wil call `BlElement >> withSkin: aSkin`

Look are added to skin in `ToWidgetSkin onSkinInstalledIn: anElement` subclasses.
Look must be added for each widget state.

*Widget state can be defined by subclassing ToInitialState* => to be confirmed, doesn't seems the case

For CheckBox button, default type is *ToButtonTextType* or *ToClickableType*
Button will call its *privateUpdateChildren* to update all internal properties.
