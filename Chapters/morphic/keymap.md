# Key mapping & event handling

Morphic has different way to handle event & key mapping. Some can be used for both
keyboard and mouse handling. Others are strictly related to keymap. Commander
and Commander v2 comes as well with their own mechanisme.

- A first one is based on morphic event handling based mechanism. Using subclasses (*handlesKeyDown:* and *keyDown:* overwrite for example)
- A second one will use Morphic Event Handler extension mechanism. Using event handler (*on:* eventName *send:* selector *to:* recipient)
- A third one, for keymap, will use KMKeymap framework to evaluate keymap. Using Keymapping framework (*on:* aShortcut *do:* anAction)

Let's study them.

## Method override using morph event handling base mechanism

Override the *handlesKeyXXX:* method (in event handling protocol) to return true. This will indicate you want to handle the specific key.

Then override the *keyXXX:* event (still in the event handling protocol) to
describe what you want to do when such event happen.

### Example

This will demonstrate how to use the down button or the 'Ctrl+d' shortcut to move
your Morph by 10.

```smalltalk
handlesKeyDown:  evt

 ^ true
```

Follow by

```smalltalk
keyDown: anEvent

 | key |
 key := anEvent key.
 key = KeyboardKey down ifTrue: [ 
  self position: self position - (0 @ 10) ].

 anEvent controlKeyPressed ifTrue: [ 
  anEvent keyCharacter == $d ifTrue: [ 
   self position: self position + (0 @ 10) ] ]
```

## Morph initialization using morph Event Handler

Use the *on: send: to:* message to initialize keyboard and event handling

### example

```smalltalk
initialize

 super initialize.
 self
  on: #keyDown send: #processKeyDown: to: self;
```

Then implement the method you name in the *send:* part.

```smalltalk
processKeyDown: anEvent

 | key |
 key := anEvent key.
 key = KeyboardKey down ifTrue: [
  self position: self position + (0 @ 10) ].

 anEvent controlKeyPressed ifTrue: [
  anEvent keyCharacter == $d ifTrue: [
   self position: self position + (0 @ 10) ] ]
```

## Using Keymapping framework

Keymap is a set of classes withing Pharo that will help you define shortcuts
That's the way most shortcuts are defined in the image: when you want to open the
Browser, move your window, etc.

*KMRepository* keep list of all keymapping defined in Pharo

**KMKeymap** is the central point of key mapping definition
(combination, description target action). It allow name and unnamed keymapping

KeyCombination (**KMKeyCombination** and subclass) allow user to define various
combination of key (single, multiple, meta key, etc.),

Keymap can be classified by category (**KMCategory** & **KMCategoryBinding**),
stored in (**KMStorage**), within a repository (**KMRepository**).

Key pressed will be stored in a (**KMBuffer**) and checked against key combination.
-> catch by system and dispatch (**KMDispatcher**, **KMDispatch**, **KMGlobalDispatcher**)
-> deliver to target action (**KMTarget**)

Keymap can be build through builder (**KMbuilder**) directly in Morph

All shortcuts are defined in the same way:
you create a method which receives a builder. The method *shortcut:* receives a
shortcut name and creates an instance of KMKeymapBuilder. Then, sending the message
*category:default:do:* to the created KMKeymapBuilder, you can define all shortcuts.

- The first parameter is a category.
- The second is the combination of keys for the shortcut
- the last parameter is the block to evaluate when such shortcut is pressed.
Notice that the block receives at least the target object.

Now, the last part is to tell the Morph that it should attach those shortcuts.

If you want to reuse keymapping between object, you can group shortcuts into category.
You need to define your shortcuts in a class side method, and reference category
by redefining *initializeShortcuts:* instance side method.

Use *shortcut* and *keymap* pragmas to registered your shortcut within the system

### Example

Here, we'll define a global shortcut, associated to the category 'CrossMorphShortcuts'
On your class side, define those methods:

```smalltalk
initialize 
 self buildShortCutsOn: KMBuilder keymap  

buildShortCutsOn: aBuilder
 <keymap>

 (aBuilder shortcut: #moveDown)
  category: #CrossMorphShortcuts
  default: Character arrowDown
  do: [ :target | target position: target position + (0 @ 10) ]
  description: 'move morph down'.
```

Then, on the instance side, define these:

```smalltalkinitializeShortcuts: aKMDispatcher
 "Where we may attach keymaps or even on:do: local shortcuts if needed."
 super initializeShortcuts: aKMDispatcher.
 aKMDispatcher attachCategory: #CrossMorphShortcuts
 ```

### key combination

#### from Character class

`$a` asKeyCombination
Character tab asKeyCombination

It will return class from:

- KMSingleKeyCombination
- KMModifiedKeyCombination
- KMModifier
  
### Example

```smalltalk
    $c asShortcut
    Character arrowLeft alt asShortcut
    Character delete asShortcut
    $a meta, $b meta
```

#### from dedicated classes

Collect key, and check if a corresponding shortcut exist. Used to define most
shortcut under the system

Keymapping associate a shortcut with a specific action  as in `KMKeymap shortcut: action:`

shortcut are defined as a key combination, with different cases:

- simple key presses: pressing a single key, as a letter or number, or others like tab or space
- modified key presses: a simple key + a modifier like shift or alt
- option key presses: a list of key presses where only one of them should be valid
- chained shortcuts (with ','): a sequence of shortcuts

Possible modifier are available in protocol 'Keymapping-KeyCombination' in Character class.
Many non-printing characters are available as Character class side method. However,
please note that Character must be part of those defined in KeyboardKey class.

**note**
delete (as pharo 11) is not recognized as a key character

Keymap browser is currently broken.

### Using local Keymap in instance initialization

You can initialize your shortcut in the *initialize* instance method, using
*on: do:* message.

**Warning**. Such combination doesn't work
`on: $a meta, $b meta do: [ self startStepping ].`

#### Example

```smalltalk
initialize
    self
    on: Character arrowDown do: [ self position: self position + (0 @ 10) ];
    on: $d meta do: [ self position: self position + (0 @ 10) ];
```

### Global key mapping key mapping in Pharo

A list of all commun shortcut in Pharo are defined in class **PharoShortcuts**

KMKeymap is a global framework to define keymapping and shortcut in Pharo.
All global shortcuts are defined through this.

Take a look at classes like *PharoShortcuts* and *ToolShortcutsCategory*.
Take a look at the method with pragma *shortcut*, *keymap* and *keymap:*
For example: *class ToolShortcutsCategory*

The class has a couple of special things:

- it inherits from *KMCategory* (a keymapping framework class)
- it defines *isGlobal* returning true on the class side (to say it defines global shortcuts)
- it then has methods defining shortcuts:

```smalltalk
openUnitTestRunner
<shortcut>
^ KMKeymap shortcut: PharoShortcuts current openTestRunnerShortcut action: [ Smalltalk tools openTestRunner ]
```

If you want a shortcut only to be active on a particular tool/window, AND you’re
using Morphic, take a look at the methods in the Morph class related to *keymappings:*

ToolShortcutsCategory is used to definde shortcut for Browser, settings, etc...
They are registered in the singleton *KMRepository*

KMRepository class >> reset will call

```smalltalk
    KMCategory allSubclasses
    select: [ :c | c isGlobalCategory ]
    thenDo: [ :c | c new installAsGlobalCategory ].
```

Inspect `KMRepository default`

TextEditor class >> buildTextEditorShortcutsOn: with pragma *keymap*
    #GlobalShortcuts is never used.
    #WindowShortcuts is bugged

WorldState class >> pharoItemsOn: aBuilder for Pharo menu
SettingBrowser class >> menuCommandOn: aBuilder

### Example

```smalltalk
PluggableButtonMorph class >> buildPluggableButtonShortcutsOn: aBuilder
<keymap>
(aBuilder shortcut: #action1)
category: #PluggableButtonMorph
    default: Character space asKeyCombination | Character cr asKeyCombination
    do: [ :target :morph :event | morph performAction ]
```

Using category in a morph

```smalltalk
PluggableButtonMorph >> initializeShortcuts: aKMDispatcher
    super initializeShortcuts: aKMDispatcher.
    aKMDispatcher attachCategory: #MorphFocusNavigation.
    aKMDispatcher attachCategory: #PluggableButtonMorph
```

Categories can be queried, so one can display shortcut in a help windows.
A sample demo is available in class KMDescriptionPresenter

```smalltalk
(self kmDispatcher directKeymaps commonEntries keymaps asOrderedCollection at:1)  
(self kmDispatcher targets asOrderedCollection at:2) category keymaps
```

## Calypso and Commander v1

Being a subclass of CmdCommand. To make YourCommand executable by shortcut
you need to add following method to class side of command:

```smalltalk
    YourCommand class>>yourAppShortcutActivation
    <classAnnotation>
    ^CmdShortcutCommandActivation by: $e meta for: YourAppContext
```

[Understading class annotation](https://github.com/pharo-ide/ClassAnnotation)

Many commands for calypso are defined in package *SystemCommands-**.
ClassAnnotation mechanism is then used to attach them to specific shortcut.

### example

```smalltalk
    ClyInspectSelectionCommand class >> browserShortcutActivation
        <classAnnotation>
        ^CmdShortcutActivation by: PharoShortcuts current inspectItShortcut for: ClyBrowserContext

    SycAbstractAllInstVarAccessorsCommand class >> browserShortcutActivation
        <classAnnotation>
        ^CmdShortcutActivation  by: $a meta, $a meta for: ClyClass asCalypsoItemContext

    ClyRemoveClassGroupCommand class >> fullBrowserShortcutActivation
        <classAnnotation>
        ^CmdShortcutActivation removalFor: ClyFullBrowserClassGroupContext

    SycRenamePackageCommand class >> fullBrowserShortcutActivation
        <classAnnotation>
        ^CmdShortcutActivation renamingFor: ClyFullBrowserPackageContext
```

If you want to execute command from context menu you need another activator:

```smalltalk
    YourCommand class>>yourAppMenuActivation
        <classAnnotation>
        ^CmdContextMenuCommandActivation byRootGroupItemFor: YourAppContext
```

shortcut are visible in the settings window, but cannot be changed.

## Commander v2 integrate shortcut only in the context of Spec2

- asSpecCommandWithShortcutKey:
- asSpecCommandWithIconNamed: aSymbol shortcutKey: aKMKeyCombination
- asSpecCommand

Using Keymapping framework under the hood.
However, no central place to visualize shortcut.

Book available on Pharo web site to explain how to use it.

## Integration with Settings

Shortcuts are visible as systems settings if they are registed in a class
side method accepting a builder, and with pragma `<systemsettings>`

Settings can be grouped in specific category.
Commander v1 use setting in "CmdShortcutActivation class >> buildSettingsOn:"
