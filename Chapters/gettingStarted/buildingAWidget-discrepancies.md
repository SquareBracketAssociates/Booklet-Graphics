### Discrepancies with the code: Building a simple widget

Checked on 2026-11-06 against a Pharo 15 image (Bloc, Toplo and Alexandrie from their `dev` branches)
with `BCCChapterChecker` (package `BookCodeChecker`) followed by a manual review.
Line numbers refer to `buildingAWidget.md` before the `Diff with Code` notes were added.

#### API changes

| Line | Book | Current code | Fix |
| --- | --- | --- | --- |
| 46, 92, 135, 210, 268, 292 | `self size: 300@120` | `BlElement>>#size:` is deprecated (Bloc issue 802). | `self extent: 300 @ 120` |
| 345, 347, 358, 378, 381, 387 | `BlSpace simulateClickOn: inputElem minus` | `BlSpace class>>#simulateClickOn:` is deprecated (2026-06-26). | `inputElem minus eventSimulator click` (`BlElement>>#eventSimulator` answers a `BlEventSimulator`). |

#### Errors in the book code

| Line | Problem | Fix |
| --- | --- | --- |
| 97 | `self initializeInputlabel`: the method is `initializeInputLabel`. | Fix the capital `L`. |
| 289 | Header `BlIntegerInputElement >> initialize.` has a trailing period. | Remove it. |
| 300 | No period after `self initializeMinusButton`. | Add it. |
| 297-301 + 307-313 | `callbackBlock` is set after `initializeInputValue: 20`, which calls `changeValueTo:`, which sends `value:` to the still-`nil` `callbackBlock`. | Initialize `callbackBlock` before the sub-elements. |
| 332-390 | Tests use `BlNumberInputElement` / `BlNumberInputElementTest`, while the chapter defines `BlIntegerInputElement` and no test class. | Use `BlIntegerInputElement` and show the `BlIntegerInputElementTest` definition (`TestCase << #BlIntegerInputElementTest`). |
| 345-388 | The tests send `plus`, `minus` and `value`, which the chapter never defines. `value` silently answers the element (`Object>>#value`). | Add the three accessors to the chapter. |
| 375 | No period after the block passed to `whenInputValueChangedDo:`. | Add it. |

The other messages used (`asRopedText`, `attributes:`, `BlTextForegroundAttribute paint:`, `fontSize:`,
`constraintsDo:`, `c frame horizontal alignCenter`, `BlInsets all:`, `transformDo:`, `translateBy:`,
`BlRoundedRectangleGeometry cornerRadius:`, `BlCircleGeometry`, `BlFrameLayout`, `addEventHandlerOn:do:`) exist in the current Bloc.
