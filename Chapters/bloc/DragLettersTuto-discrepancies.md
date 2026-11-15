### Discrepancies with the code: Letters Sorter Drag Example

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review, and compared with
the classes of the `Bloc-Demo` package that the chapter refers to.
Line numbers refer to `DragLettersTuto.md` before the `Diff with Code` notes were added.

#### Differences with `Bloc-Demo`

| Book | `Bloc-Demo` |
| --- | --- |
| `BlSortLettersExample` | `BlDragSortLettersExample` |
| `BlLetterContainer` | `BlDragLetterContainer` |
| `BlLetter` | `BlDragLetter` |
| `BlLetterContainer>>#initializeDropEvent` calls `dropAcceptBehavior` / `dropRejectBehavior` | Moves the element directly and calls `allowMeAndChildrenMouseEvents` on reject. |
| `BlLetter>>#initialize` | Adds a `BlGaussianShadowEffect color: (Color lightGray alpha: 0.4) width: 2 offset: 0 @ 0` and uses `extent:`. |
| `BlSortLettersExample>>#initializeDropEvent` (section "Going beyond") | Not present. |

#### Errors in the book code

| Line | Problem | Fix |
| --- | --- | --- |
| 13-16 | `BlSortLettersExample` is defined with `slots: {}` but uses three instance variables. | `slots: { #lettersContainer . #vowelsContainer . #consonantsContainer }` |
| 137-169 | Sends `dropAcceptCondition`, `dropAcceptBehavior`, `dropRejectBehavior`, `dragEnterAcceptBehavior`, `dragEnterRejectBehavior`, `dragLeaveBehavior` to `self`; the chapter never defines these accessors (nor their setters, used at lines 187-239). | Say that the accessors of `BlLetterContainer` must be created, or show them. |
| 305 | `defaultContainer:` is never defined (only `character:` is shown). | Show or request the `defaultContainer` / `defaultContainer:` accessors. |
| 318 | `TextElement` | `BlTextElement` |

The event API used (`BlDropEvent`, `BlDragEnterEvent`, `BlDragLeaveEvent`, `BlDragStartEvent`, `BlDragEndEvent`,
`BlDragEvent`, `gestureSource`, `consume`, `positionInSpace`, `preventMeAndChildrenMouseEvents`,
`allowMeAndChildrenMouseEvents`, `labelMeasurement`, `whenLayoutedDoOnce:`) is still current.
