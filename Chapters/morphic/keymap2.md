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
(KMCategory & KMCategoryBinding), stored in (KMStorage), within a repository (KMRepository).

Key pressed will be stored in a (KMBuffer) and checked against key combination.
-> catch by system and dispatch (KMDispatcher, KMDispatch, KMGlobalDispatcher)
-> deliver to target action (KMTarget)

Keymap can be build through builder (KMbuilder) directly in Morph

### combination from Bloc framework

Bloc come with its own keymapping framework.
BlShortcutWithAction would be the equivalent of KMKeymap.

BlShortcutWithAction new
    combination: (BlKeyCombination builder alt; control; key: KeyboardKey C; build);
    action: [ flag := true ].
