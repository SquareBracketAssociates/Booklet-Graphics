### Discrepancies with the code: List

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.

No discrepancy: the chapter only has section titles (Selection, Hide/Unselect, Infinite, Select, Group) and no code.
For the *Infinite* section, note that `ToListElement` uses an infinite layout by default (`ToBasicListElement>>#useInfiniteLayout:`),
and that selections are managed by `ToSelectionModel`.
