### Discrepancies with the code: Alexandrie

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.
Line numbers refer to `alexandrie.md` before the `Diff with Code` notes were added.

| Line | Book | Current code | Fix |
| --- | --- | --- | --- |
| 221 | `strokePreserve` | Not implemented. | `strokePreservingPath` (`fillPreserve` and `fillPreservingPath` exist). |
| 269, 293, 321, 356 | `context source: aPattern` | `AeCairoContext` does not understand `source:`. | `context sourcePattern: aPattern` |

Checked and still valid: `AeCairoImageSurface`, `AeCairoContext` (`sourceColor:`, `stroke`, `fill`, `fillPreserve`, `paint`),
`AeCairoLinearGradientPattern from:to:addStopsFrom:`, `AeCairoRadialGradientPattern`, `AeCairoMeshPattern`,
`AeCairoPattern>>#matrix:`, `AeCairoMatrix`, `AeCairoSVGSurface`, `AeCairoPDFSurface`, `AeCairoFreetypeFontFace`, `AeFTLibrary`.
The code fragments at lines 253 and 263 are partial cascades.
