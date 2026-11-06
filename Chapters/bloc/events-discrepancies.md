### Discrepancies with the code: Event handling

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.
Line numbers refer to `events.md` before the `Diff with Code` notes were added.

| Line | Book | Current code | Fix |
| --- | --- | --- | --- |
| 30-98, 146, 373-375, 420-421 | `size:` | `BlElement>>#size:` is deprecated (Bloc issue 802). | `extent:` |
| 287-288 | `Key leftShift`, `Key rightShift` | No `Key` class. | `KeyboardKey shiftLeft`, `KeyboardKey shiftRight` |
| 296-297 | `Key leftMeta`, `Key rightMeta` | No `Key` class. | `KeyboardKey metaLeft`, `KeyboardKey metaRight` |
| 307-308, 316-317 | `Key arrowLeft`, `Key w` | No `Key` class. | `KeyboardKey left`, `KeyboardKey W` |

Checked and still valid: `addEventHandlerOn:do:` answers the new handler; `addEventHandlerOn:doOnce:`;
`addEventFilterOn:do:`; `BlEventHandler on:do:`; `BlEventHandler>>#wantsEvent:` is still exactly the code quoted at line 182;
`BlPullHandler>>#eventsToHandle` is still the code of lines 118-119; `BlPullHandler>>#disallowOutOfBounds`;
`removeEventHandlersSuchThat:`; `eventDispatcher removeEventHandlers`; `BlMouseWheelEvent>>#isScrollUp` / `isScrollDown`;
`primaryButtonPressed`, `secondaryButtonPressed`, `middleButtonPressed`; `BlBackground paint:`;
`BlShortcutWithAction` (subclass of `BlBasicShortcut`), `BlKeyCombination builder`, `BlSingleKeyCombination key:`,
`BlAlternativeCombination` and `BlCompulsoryCombination` with `key:` and `with:`; `KeyboardKey altLeft`;
`BlElementFlags`, `BlElementEventDispatcherActivatedEvents`.
