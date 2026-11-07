### Discrepancies with the code: Bloc Architecture

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.
Line numbers refer to `blocArchitecture.md` before the `Diff with Code` notes were added.

| Line | Book | Current code | Fix |
| --- | --- | --- | --- |
| 8-16 | Seven phases, starting with **Idle** | `BlSpaceFrame>>#initializePhases` installs six phases (host validation, task, event, drawing validation, layout, drawing); there is no idle phase class. Toplo adds `ToSpaceConfigurationPhase`, `ToSpaceSkinInstallerPhase` and `ToSpaceSkinStateApplicationPhase`. | Remove Idle; mention the Toplo phases. |
| 22, 41 | `BlUniverse` | No such class. | `BlParallelUniverse` (owned by `BlPulseLoopHost`). |
| 30-44 | Hosts and pulse loop | Hosts are `BlOSWindowSDL2Host`, `BlSDLHost`, `BlMorphicHost`, `BlMorphicWindowHost`, `BlHeadlessHost`; `pulsePeriod` belongs to `BlPulseLoopHost` / `BlHostPulseLoop`. | Name the classes. |
| 48-60 | Source of `BlElement>>#openInNewSpace` | Now `^ self openInSpace`; `openInSpace` does `self inSpace` then `show`. | Show `openInSpace` instead. |
| 75 | `space addChild: rootUniqueChild` | `BlSpace` does not understand `addChild:`. | `space root addChild: rootUniqueChild` |

Checked and still valid: `#runOn:` on each phase, `BlSpace>>#enqueueTask:`, `BlTaskAction>>#action:`, `BlSpace>>#center`,
`BlElementExtentChangedEvent`, `BARenderer` (a `BlHostRenderer`).
