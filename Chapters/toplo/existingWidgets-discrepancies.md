### Discrepancies with the code: Existing Widgets

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.
Line numbers refer to `existingWidgets.md` before the `Diff with Code` notes were added.

| Line | Book | Current code | Fix |
| --- | --- | --- | --- |
| 16, 36 | `ToNotebook` | Class removed (no notebook package any more). | `ToTabPaneElement` (package `Toplo-Widget-TabPane`). |
| 18 | `addPageTitle:bodyFactory:` | Not implemented anywhere. | `tabPane itemBuilder: [ :tabItem :data | tabItem labelText: data asString; paneBuilder: [ :body :btn :holder | body addChild: ... ] ]` then `tabPane addTabItemData: 'page 1'` (see `ToSandBox class>>#example_SimpleTabPane`). |
| 68 | `addPageTitle:body:` | Not implemented anywhere. | Same as above. |

Checked and still valid: `ToButton>>#labelText:`, `BlGridLayout horizontal columnCount:` / `cellSpacing:`, `asScrollableElement`,
`BlVerticalScrollbarElement>>#attachTo:`, `c ignoreByLayout`, `c ignored horizontal alignRight`.
The sections Tag, Button, Menu and List are still empty.
