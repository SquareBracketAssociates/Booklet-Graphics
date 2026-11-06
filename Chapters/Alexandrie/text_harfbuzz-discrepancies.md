### Discrepancies with the code: Text with Harfbuzz

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.
Line numbers refer to `text_harfbuzz.md` before the `Diff with Code` notes were added.

| Line | Book | Current code | Fix |
| --- | --- | --- | --- |
| 188, 211, 275, 354 | `strokePreserve` | Not implemented in `AeCairoContext`. | `strokePreservingPath` |
| 189, 212, 276, 355 | `source: (AeCairoLinearGradientPattern ...)` | `AeCairoContext` does not understand `source:`. | `sourcePattern:` |

Checked and still valid: `AeCairoScaledFont fontFace:fontMatrix:userToDeviceMatrix:options:` (the `userToDeviceMatrix:` of line 145 is a
keyword of this message), `AeCairoFontOptions` with `AeCairoAntialias`, `AeCairoHintMetrics`, `AeCairoHintStyle`, `AeCairoSubpixelOrder`;
`AeFontManager`, `AeFontSlant`, `AeFontWeight`, `AeFontStretch`, `AeFilesystemResources`; the HarfBuzz buffer API
(`AeHbBuffer`, `AeHbDirection`, `AeHbScript`, `AeHbLanguage`, `AeHbBufferClusterLevel`, `AeHbBufferFlags`, `cairoGlyphArrayForFace:size:`);
`showGlyphs:`, `appendGlyphsPath:`, `glyphArrayForString:`.
