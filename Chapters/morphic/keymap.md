# Key mapping & event handling

Morphic has different way to handle event & key mapping. Some can be used for both
keyboard and mouse handling. Others are strictly related to keymap.

- A first one is based on morphic event handling based mechanism
- A second one will use Morphic Event Handler extension mechanism
- A third one, for keymap, will use KMKeymap framework to evaluate keymap.

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

## Using global Keymap

Keymap is a set of classes withing Pharo that will help you define shortcuts
That's the way most shortcuts are defined in the image: when you want to open the
Browser, move your window, etc.

All shortcuts are defined in the same way: 
you create a method which receives a builder. The method *shortcut:* receives a
shortcut name and creates an instance of KMKeymapBuilder. Then, sending the message
*category:default:do:* to the created KMKeymapBuilder, you can define all shortcuts.

- The first parameter is a category. 
- The second is the combination of keys for the shortcut 
- the last parameter is the block to evaluate when such shortcut is pressed.
Notice that the block receives at least the target object.

Now, the last part is to tell the Morph that it should attach those shortcuts.

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

## Using local Keymap in instance initialization

You can initialize your shortcut in the *initialize* instance method, using
*on: do:* message.

**Warning**. Such combination doesn't work
`on: $a meta, $b meta do: [ self startStepping ].`

### Example

```smalltalk
initialize

 super initialize.
 self extent: self defaultExtent.
 self
  on: Character arrowDown do: [ self position: self position + (0 @ 10) ];
  on: $d meta do: [ self position: self position + (0 @ 10) ];
```

## KMKeymap and global key mapping in Pharo

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
