### Discrepancies with the code: Stylesheets and Skins

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.
Line numbers refer to `stylesheet.md` before the `Diff with Code` notes were added.

| Line | Book | Current code | Fix |
| --- | --- | --- | --- |
| 21 | Idle phase | No such phase (see `BlSpaceFrame>>#initializePhases`). | Remove it. |
| 29-34 | Toplo adds 2 phases | Toplo adds 3: `ToSpaceConfigurationPhase`, `ToSpaceSkinInstallerPhase`, `ToSpaceSkinStateApplicationPhase`. | Add the configuration phase. |
| 58 | `ToStyleStore` | No such class. | Describe the element token API instead (`addTokenNamed:withValue:`, `valueOfTokenNamed:`, ...). |
| 91 | `ToSkinEventListeners` | No such class. | `ToSkinEventListener` |
| 96 | `#write:whitAll:` | Typo. | `#write:withAll:` |
| 134-141 | `setToken:`, `setTokenNamed:value:` | Not implemented. | `addTokenNamed:withValue:` / `updateTokenNamed:withValue:` |
| 193, 214, 218, 252, 261-262, 408, 412, 421 | `e tokenValueNamed: ...` | Not implemented. | `e valueOfTokenNamed: ...` |
| 208-219 | `ToButton asTypeSelector style: [ :sr | sr when: ... ]` | Selectors do not understand `style:`; style blocks have no argument. | `self select: ToButton asTypeSelector style: [ self when: ... ]` |
| 235-240 | Two `ToTokenProperty name:value:` expressions without a period | Parsed as `name:value:name:value:`. | Add a period. |
| 410 | `ToLeavedSkinEvent` | No such class. | `ToLeftSkinEvent` |
| 403 | `self buttonSelector` | Not defined in `ToStyleSheetTheme`. | Define it or use `ToButton asTypeSelector`. |

Checked and still valid: `ToSkinStateGenerator`, `ToStyleSheetSkin`, `ToSkinEvent` and its subclasses, `ToSelectorInterpreter`,
`TToStyleRuleScripter` (`do:`, `when:do:`, `write:with:`, `write:withAll:`, `when:write:with:`, `when:write:with:animation:`,
`supplement:with:`, `when:supplement:with:`, `select:style:`), `ToStyleSheet class>>#defaultWritablePropertyList`,
`ToFeatureProperty name:`, `ToPseudoProperty name:reader:writer:`, `ToTokenProperty name:value:`, the selectors
(`asTypeSelector`, `asIdSelector`, `asStampSelector`, `asActionSelector`, `ToTypeSelector>>#exact:`, `ToIdSelector>>#id:`,
`ToStampSelector>>#addAllStamps:`, `ToActionSelector>>#action:`, `ToUniversalSelector`, `withChild:`, `withChild:atDepth:`,
`withParent:`, `withParent:atDepth:`, `withSibling:`, `&&`, `||`, `not`), `addStamp:`, `removeStamp:`, `textAttributesBuilder`,
`borderBuilder`, `ToPropertyColorTransitionAnimation duration:`.
