### Discrepancies with the code: BlElement

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.
Line numbers refer to `element.md` before the `Diff with Code` notes were added.

#### API changes

| Line | Book | Current code | Fix |
| --- | --- | --- | --- |
| 21-25 | `BlUniverse` holds the spaces | No `BlUniverse` class. | `BlParallelUniverse` (owned by `BlPulseLoopHost`). |
| 440 | `origin=BlocExamples>>shadow` | No `BlocExamples` class. | Point to an existing example method or drop the argument. |
| 718 | `AlexandrieCanvas` | No such class. | `AeCanvas` |
| 798 | `AeCaireContext`, protocol *API - Path* | `AeCairoContext`, protocol `API - path`. | Fix the names. |
| 807 | `canvas setBackgroundWithForm: form` | Only `setBackgroundWithForm:alpha:` exists. | `canvas setBackgroundWithForm: form alpha: 1.0` |
| 833-837 | `PathFactory:`; `aeApplyWithInsideBorderTo:element:borderWidth:` named twice | `pathFactory:`; the pair is `aeApplyWithInsideBorderTo:element:borderWidth:` / `aeApplyWithOutsideBorderTo:element:borderWidth:`. | Fix the names. |

#### Errors in the book code

| Line | Problem | Fix |
| --- | --- | --- |
| 128 | Annulus expression ends with `);` | Remove the extra `)`. |
| 131 | Ellipse expression ends with `)` | Remove it. |
| 149 | `numberOfPoints := N` | Use a number. |
| 599 | `child transformDo: [...];` ends with `;` | Use `.` |
| 976, 1020 | `self new` / `anAlexandrieCanvasExperiment inform:` in a playground script | Drop the variable and use `UIManager default inform:`. |

Checked and still valid: the geometry constructors of lines 128-138 (once the parentheses are fixed),
`BlBorder builder` with `dashed`, `dashedSmall`, `capRound`, `capSquare`, `capButt`, `joinRound`, `joinBevel`, `joinMiter`;
`BlOutskirts centered`; `BlPaintBackground paint:`; `BlLinearGradientPaint direction:` / `vertical`; `BlRadialGradientPaint`;
`BlSimpleShadowEffect color:offset:`; `BlGaussianShadowEffect color:offset:width:`; `BlElementLocalTransformation newWith:`;
`BlAffineTransformationCenterOrigin defaultInstance`; `BlElementIdentityTransformation uniqueInstance`; `BlTransformationBuilder>>#inherit`;
`BlTransformAnimation rotate:` / `translate:`; `BlElement>>#aeFullDrawOn:` (its source still matches lines 707-711);
the `AeCanvas` drawing API of lines 745-1045 (`pathFactory:`, `setBorderBlock:`, `maskGroupWith:`, `drawGlyphs:font:`, ...).
