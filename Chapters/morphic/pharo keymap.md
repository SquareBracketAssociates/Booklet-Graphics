# Keyboard shortcut in Morphic

A list of all commun shortcut in Pharo are defined in class **PharoShortcuts**

## Keymap framework (Keymapping-* packages)

Collect key, and check if a corresponding shortcut exist. Used to define most
shortcut under the system

Keymapping associate a shortcut with a specific action  as in `KMKeymap shortcut: action:`

shortcut are defined as a key combination, with different cases:

* simple key presses: pressing a single key, as a letter or number, or others like tab or space
* modified key presses: a simple key + a modifier like shift or alt
* option key presses: a list of key presses where only one of them should be valid
* chained shortcuts (with ','): a sequence of shortcuts

Possible modifier are available in protocol 'Keymapping-KeyCombination' in Character class.
Many non-printing characters are available as Character class side method. However,
please note that Character must be part of those defined in KeyboardKey class.

### Example

```smalltalk
    $c asShortcut
    Character arrowLeft alt asShortcut
    Character delete asShortcut
    $a meta, $b meta
```

**note**
delete (as pharo 11) is not recognized as a key character

Keymap browser is currently broken.

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

## Morphic level (registered within morph)

* Using subclasses (*handlesKeyDown:* and *keyDown:* overwrite for example)
* Using Keymapping framework (*on:* aShortcut *do:* anAction)
* Using event handler (*on:* eventName *send:* selector *to:* recipient)

If you want to reuse keymapping between object, you can group shortcuts into category.
You need to define your shortcuts in a class side method, and reference category
by redefining *initializeShortcuts:* instance side method.

Use *shortcut* and *keymap* pragmas to registered your shortcut within the system

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

    YourCommand class>>yourAppShortcutActivation
    <classAnnotation>
    ^CmdShortcutCommandActivation by: $e meta for: YourAppContext

[Understading class annotation](https://github.com/pharo-ide/ClassAnnotation)

Many commands for calypso are defined in package *SystemCommands-**.
ClassAnnotation mechanism is then used to attach them to specific shortcut.

### example

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

If you want to execute command from context menu you need another activator:

    YourCommand class>>yourAppMenuActivation
        <classAnnotation>
        ^CmdContextMenuCommandActivation byRootGroupItemFor: YourAppContext

shortcut are visible in the settings window, but cannot be changed.

## Commander v2 integrate shortcut only in the context of Spec2

* asSpecCommandWithShortcutKey:
* asSpecCommandWithIconNamed: aSymbol shortcutKey: aKMKeyCombination
* asSpecCommand

Using Keymapping framework under the hood.
However, no central place to visualize shortcut.

Book available on Pharo web site to explain how to use it.

## Integration with Settings

Shortcuts are available as systems settings if they are registed in a class
side method accepting a builder, and with pragma <systemsettings>

Settings can be grouped in specific category.
Commander v1 use setting in "CmdShortcutActivation class >> buildSettingsOn:"
