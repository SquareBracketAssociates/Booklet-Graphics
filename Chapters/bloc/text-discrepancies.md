### Discrepancies with the code: About text

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.
Line numbers refer to `text.md` before the `Diff with Code` notes were added.

| Line | Book | Current code | Fix |
| --- | --- | --- | --- |
| 251-265 | `BlElement new size: 0@0` | `BlElement>>#size:` is deprecated (Bloc issue 802). | `extent: 0 @ 0` |
| 330 | `evt currentTarget size x` | `BlElement>>#size` is deprecated. | `evt currentTarget extent x` |
| 334 | `container removeChildNamed: 'text'` | No `removeChildNamed:` in `BlElement`. `addChild:as:` sets the child id. | `container removeChildWithId: 'text'` |
| 405, 412 | `label size`, `label size: ...` | Deprecated. | `label extent`, `label extent: ...` |
| 415 | `TBlTransformable>>tranformDo:` | Typo. | `transformDo:` (implemented in `BlElement`) |

Note on lines 103-122: two code blocks open with four backquotes (```` ````smalltalk ````) but the first closes with three,
so Microdown merges the text between them into a single code block.

Checked and still valid: the `BlRopedText` styling messages (`foreground:`, `background:`, `fontSize:`, `fontName:`, `thin`,
`medium`, `italic`, `bold`, `monospace`, `underline`, `underlineColor:`, `vertical`, `attributes:`, `from:to:`, `stylerDo:`);
`BlTextAttributesStyler on:` / `style`; `BlAttributedTextElement>>#attributesBuilder`; `tightMeasurement` (still the default,
see `BlTextElement>>#initializeMeasurement`), `labelMeasurement`, `editorMeasurement`, `measurement:`, `baselineMeasurer:`;
`BlTextElementTightMeasurementStrategy uniqueInstance`, `BlBoundsBaselineMeasurer uniqueInstance`;
`AeFontManager globalInstance` with `familyNames`, `scanDirectory:`, `scanDefaultDirectories`;
the text announcements (`BlTextStringsInserted`, `BlTextsDeleted`, `BlTextAttributeAdded`, `BlTextAttributesRemoved`) and
`BlTextElement>>#textChanged`; `BlCornerRadii`; `transformedBounds`.
