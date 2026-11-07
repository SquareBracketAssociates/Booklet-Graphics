### Discrepancies with the code: Layouts in Bloc

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.
Line numbers refer to `layout.md` before the `Diff with Code` notes were added.

| Line | Book | Current code | Fix |
| --- | --- | --- | --- |
| 265 | `BlZoomLayout` | No such class. | `BlZoomableLayout` |
| 258-266 | List of layouts | Other layouts exist: `BlAnchorLayout` (described later in the chapter), `BlRelativeLayout`, `BlSquaredLayout`, `BlFitLayout`, `BlFitChildrenLayout`, `BlCompositeLayout`, ... | Complete the list or refer to `BlLayout allSubclasses` only. |
| 914 | `BlSvgIcons settingsIcon` | No `BlSvgIcons` class. | `BlSvgIconExamples new settingsIcon` |

Checked and still valid: default size of an element is `Exact 50.0` on each axis (`50@50` after layout);
the proportional constraints of lines 1003-1024 (`c proportional horizontal left:`/`right:`, `75 percent`);
`BlLinearLayout`, `BlFlowLayout`, `BlGridLayout`, `BlFrameLayout`, `BlProportionalLayout`, `BlAnchorLayout`, `BlAnchorLayoutRule`,
`BlLayoutCommonConstraints`, `BlLayoutCommonConstraintsAxis`, `BlLinearLayoutConstraints`, `BlFrameLayoutConstraints`,
`BlVisibilityGone`, `BlVisibilityHidden`, `BlElementLayoutComputedEvent`, `BlSpaceFrame`, `BlSpaceFramePhase`.
The code fragments of lines 200, 212, 1003, 1013 and 1022 are partial cascades; they are not meant to compile alone.
