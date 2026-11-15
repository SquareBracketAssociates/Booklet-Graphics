### Discrepancies with the code: Athens

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.

No discrepancy found: the 17 code blocks parse, and every class and message they use exists in the image
(packages `Athens-Core`, `Athens-Cairo`, `Athens-Text`, `Athens-Morphic`, `Athens-Examples`):
`AthensCanvas`, `AthensSurface`, `AthensCairoSurface`, `AthensCairoPatternPaint`, `AthensPathBuilder`, `AthensSimplePathBuilder`,
`AthensPolygon`, and the path segments `AthensMoveSegment`, `AthensLineSegment`, `AthensCubicSegment`, `AthensQuadSegment`,
`AthensCWArcSegment`, `AthensCCWArcSegment`, `AthensCloseSegment`.
`AthensSketch` (line 517) is an external project, not part of the image.
