### Discrepancies with the code: Defining a theme

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.

No discrepancy: the chapter only contains the sentence "MooflodTheme creation illustrated." and no code.
Themes are now subclasses of `ToTheme` (for example `ToRawTheme`, `ToStyleSheetTheme`, `ToBeeTheme`); see the skinning and stylesheet chapters.
