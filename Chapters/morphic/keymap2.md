# Keymap at system platform level

KeyboardKey class, which is used when a key on the keyboard is pressed.

It's used at Morphic level, when your morph want to catch a specific keyboard
event.

It can be used by Keymapping (KMSingleKeyCombination & KMShortcutPrinter) as an
equivalent of `$a asKeyCombination`

It's used ultimately by BlKeyCombinationBuilder to build keyboard shortcut
in bloc. It's also used to convert key from event by BlOSWindowEventHandler.

## key combination

### from Character class

`$a` asKeyCombination
Character tab asKeyCombination

It will return class from:

- KMSingleKeyCombination
- KMModifiedKeyCombination
- KMModifier

### Combination from Keymapping framework

*KMRepository* keep list of all keymapping defined in Pharo

KMKeymap is the central point of key mapping definition
(combination, description target action)

KeyCombination (KMKeyCombination and subclass) allow user to define various
combination of key (single, multiple, meta key, etc.), classified by category
(KMCategory & KMCategoryBinding), stored in (KMStorage), within the singleton
repository (KMRepository).

Key pressed will be stored in a (KMBuffer) and checked against key combination.
-> catch by system and dispatch (KMDispatcher, KMDispatch, KMGlobalDispatcher)
-> deliver to target action (KMTarget)

#### keymap within morph
Keymap can be build through builder (KMbuilder) directly in Morph

overwrite the method

```smalltalk
initializeShortcuts: aKMDispatcher
    "Where we may attach keymaps or even on:do: local shortcuts if needed."

    super initializeShortcuts: aKMDispatcher.
    aKMDispatcher attachCategory: #WindowShortcuts
```

Shortcut registered within this category will be associated to your morph.

On the class side:

```smalltalk
buildShortcutsOn: aBuilder
    <keymap>

    (aBuilder shortcut: #close)
        category: #WindowShortcuts
        default: PharoShortcuts current closeWindowShortcut
        do: [ :target | SystemWindow closeTopWindow ]
        description: 'Close this window'
```

aBuilder is an instance of *KMKeymapBuilder*
`shortcut:category:default:do:description:` helps build a shortcut
in a specific category.

Keymap can also be queried with the <keymap> pragma, with the Class 
*KMPragmaKeymapBuilder*

#### dispatch

During Morphic loop cycle, OSWindowMorphicEventHandler >> dispatchMorphicEvent
will catch OS event, like key stroke, and ask the activeHand (the cursor), to 
handle the event. 

The HandMorph will send the keyboard event to the active Morph, and then
call *handleKeyDown* to handle event at system level. It'll ask Morph
default shortcutHandler to handle key stroke, being an instance of 
*KMShortcutHandler*. The key stroke will then be dispatched through *KMDispatcher*.
In the dispath chain, it'll call *KMGlobalDispatcher* who will match global
keymap categories.

### combination from Bloc framework

Bloc come with its own keymapping framework.
BlShortcutWithAction would be the equivalent of KMKeymap.

BlShortcutWithAction new
    combination: (BlKeyCombination builder alt; control; key: KeyboardKey C; build);
    action: [ flag := true ].
