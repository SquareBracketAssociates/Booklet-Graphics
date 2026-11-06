### Discrepancies with the code: Play with Elements

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.
Line numbers refer to `miniTutorial.md` before the `Diff with Code` notes were added.

| Line | Book | Current code | Fix |
| --- | --- | --- | --- |
| 9, 46 | `BlElement new size: 150 @ 150` | `BlElement>>#size:` is deprecated (Bloc issue 802) and rewritten automatically on first call. | Use `extent: 150 @ 150`. |

The rest of the scripts (`BlPolygonGeometry vertices:`, `BlBorder paint:width:`, `addEventHandlerOn:do:` with
`BlMouseOverEvent`, `BlMouseLeaveEvent`, `BlMouseDownEvent`, `openInNewSpace`) matches the current API.
