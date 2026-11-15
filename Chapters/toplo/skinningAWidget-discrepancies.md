### Discrepancies with the code: Skinning a simple widget

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.
Line numbers refer to `skinningAWidget.md` before the `Diff with Code` notes were added.

#### API changes

| Line | Book | Current code | Fix |
| --- | --- | --- | --- |
| 55, 163 | `e size: 200 @ 100` | `BlElement>>#size:` is deprecated (Bloc issue 802). | `e extent: 200 @ 100` |
| 233-240 | Theme hook `newSkinInstanceFor:` | Not implemented anywhere; the hook is `ToTheme>>#newSkinFor:` (`ToRawTheme` answers `anElement newRawSkin`). | Override `newSkinFor:`. |
| 244-252 | `ToBasicSkin` | No such class; `ToTheme>>#newSkinFor:` answers `ToGeneralSkin new`. | Subclass `ToGeneralSkin`. |
| 406 | `self property: #size` | Still a `ToFeatureProperty`, but it writes with the deprecated `size:`; there is no `#extent` property. | Keep it until Toplo offers an `#extent` property, or set the extent in the widget. |

#### Errors in the book code

| Line | Problem | Fix |
| --- | --- | --- |
| 87, 91 | Token name closed with `’` (typographic quote); line 91 also misses a `(`. | `#'color-border-checkable'` and `target border: (target valueOfTokenNamed: ...)` |
| 99, 104, 210, 263 | `ToNumberInputElement` | `ToIntegerInputElement` |
| 127, 326 | `self label: 'Input'`: `ToElement` does not understand `label:`, and the chapter never defines it. | Define `label:` or call `initializeInputLabel`. |
| 446 | Extra `]` at the end of the hover rule. | Remove it. |
| 455 | `input := self new` in a script | `ToIntegerInputElement new` |

Checked and still valid: `ToRawSkin`, `installSkinEvent:` / `elementDo:`, `valueOfTokenNamed:`, the raw theme tokens
`#'color-border'`, `#'line-width'` and `#'color-border-checkable'`, `newRawSkin`, `ToRawTheme`, `ToTheme`,
`defaultTokenProperties` (class and instance side), `ToTokenProperty name:value:`, `TToElement` with `initializeForToplo`,
`BlSpace>>#toTheme:`, `ToStyleSheetTheme` with `initializeStyleRules`, `select:style:`, `write:with:`, `property:`,
`when:write:with:`, `Symbol>>#asIdSelector`, `ToHoveredSkinEvent`.
