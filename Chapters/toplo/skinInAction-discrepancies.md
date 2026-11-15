### Discrepancies with the code: Skins in Action

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.

No discrepancy found. `ToAttributedLabel` is still a subclass of `ToLabel`; `withNullSkin`, `addTokenNamed:withValue:`,
`ToLabel class>>#text:` and `ToPane class>>#horizontal` exist and are used as in the chapter.
