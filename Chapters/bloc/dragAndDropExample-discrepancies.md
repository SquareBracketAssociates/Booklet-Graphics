### Discrepancies with the code: Drag and Drop

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.
Line numbers refer to `dragAndDropExample.md` before the `Diff with Code` notes were added.

| Line | Book | Current code | Fix |
| --- | --- | --- | --- |
| 9, 11 | `MouseDownEvent`, `MouseUpEvent` | No such classes. | `BlMouseDownEvent`, `BlMouseUpEvent` |
| 26, 44 | `element size / 2` | `BlElement>>#size` is deprecated (Bloc issue 802). | `element extent / 2` |
| 98, 107 | `PullHandler` | Class name is `BlPullHandler`. | Use the full name. |
| 116, 221, 262, 317 | `size:` | Deprecated. | `extent:` |
| 179 | `BlDragStart`, `BlSpaceDragLift` | No such classes. | `BlDragStartEvent`, `BlSpaceDragLiftEvent` |

Checked and still valid: `BlPullHandler` (subclass of `BlCustomEventHandler`) with `disallowOutOfBounds`, `allowOutOfBounds`,
`beHorizontal`, `beVertical`; `BlDragHandler`; `BlSpaceDragLiftEvent`, `BlDropEvent`, `BlDragEnterEvent`, `BlDragLeaveEvent`,
`BlDragStartEvent`, `BlDragEvent`, `BlDragEndEvent`, `BlKeyDownEvent`, `BlKeyUpEvent`;
`BlDragAndDropExamples` and `BlDragAndDropLetterExampleDemo` (package `Bloc-Demo`).
