### Discrepancies with the code: Bloc and its ecosystem

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.
Line numbers refer to `blocStack.md` before the `Diff with Code` notes were added.

| Line | Book | Current code | Fix |
| --- | --- | --- | --- |
| 31 | `` `Ae Canvas` `` | `AeCanvas` | Remove the space. |
| 63 | widget model `ToViewModel` | No `ToViewModel` class exists. | Remove the mention or describe the current widget model. |
| 69 | `ToChoiceBox` | Class removed. | Use `ToSelectElement`. |
| 70 | `ToComboBox` | Class removed. | Use `ToSelectElement`. |
| 73 | `ToListInfiniteElement` | Class removed. | `ToListElement` uses an infinite layout by default (`ToBasicListElement>>#defaultInnerElementClass` answers `ToInfiniteElement`, see `useInfiniteLayout:`). |
| 74 | `ToMenuBar` | Class removed. | Use `ToMenuPane` (the Spec Toplo menu bar adapter builds a `ToMenuPane`). |
| 75 | `ToNotebook` | Class removed. | Use `ToTabPaneElement` (package `Toplo-Widget-TabPane`). |
| 78 | `ToWindowElement` | Class removed. | Use `ToInnerWindow` for a window inside a space, or a `BlSpace`. |
| 84 | `SpLayout` | No such class. | Name actual layouts: `SpBoxLayout`, `SpPanedLayout`, `SpGridLayout` (all `SpExecutableLayout` subclasses). |
| 117-128 | Installation for Pharo 11 with `Author useAuthor: 'Load' during: [...]` | `Author` and `useAuthor:during:` do not exist in Pharo 15. | Remove the `Author` wrapper, update the Pharo version and check the branch (`master` versus `dev`). |

Verified as still correct: `BlElement`, `BlBasicLayout`, `BlEvent`, `BlSpace`, `ToElement`, `ToSkin`, `ToAlbum`,
`ToButton`, `ToCheckbox`, `ToRadioButton`, `ToToggleButton`, `ToImage`, `ToLabel`, `ToTextField`, `ToListElement`,
`ToMenuItem`, `ToMenu`, `ToMenuWindow`, `ToPane`, `ToDivider`, `ToTooltipWindow`, `SpPresenter`,
`SpAbstractWidgetPresenter`, `SpApplication`.
