### Discrepancies with the code: Animations

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.
Line numbers refer to `animation.md` before the `Diff with Code` notes were added.

| Line | Book | Current code | Fix |
| --- | --- | --- | --- |
| 30, 69, 99, 188-190, 279-281, 416 | `size:` | `BlElement>>#size:` is deprecated (Bloc issue 802). | `extent:` |
| 160-168 | Class definition and method `angle:` in the same code block | Not evaluable as one block. | Split it in two blocks (definition, then method). |

Checked and still valid: `BlAnimation>>#doStep` is exactly the code quoted at line 126; `valueForStep:` and `applyValue:`
are still the hooks to override; `BlEasing`, `BlEasingBounceIn`, `BlEasingBounceOut`, `BlEasingBounceInOut`, `BlEasingElastic`,
`BlEasingQuad`, `BlLinearInterpolator`, `BlQuinticInterpolator`, `BlSineInterpolator`, `BlViscousFluidInterpolator`;
`BlTransformAnimation`, `BlOpacityAnimation`, `BlGaussianEffectOpacityAnimation`, `BlColorTransition`, `BlNumberTransition`,
`BlParallelAnimation`, `BlSequentialAnimation`, `BlAnimationStepEvent`, `BlAnimationLoopDoneEvent`, `BlDelayedTaskAction`.
