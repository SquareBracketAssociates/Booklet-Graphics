## Skins in Action

### Why my label changes when in space

When we assign a foreground color to a `ToLabel`, this color will be applied when inspecting the label but not when displaying the label in a space. 

```
label := ToLabel new text: 'Hello'; foreground: Color blue; yourself.

label inspect.

label openInSpace.

label inspect.
```

![Difference between inspection and space rendering.](figures/helloBlackBlue)


### Skins in Action

What you observe is the label skin in action.
The skin is installed when the label is added in a space.
And the installed default label color is black (for the raw theme).

Now, you have three solutions to customize your label look.

- 1 First you can use a `ToAttributedLabel`, which is a subclass of `ToLabel` without any skin.
- 2 You can send `withNullSkin` directly to the label if you prefer to use a `ToLabel`.
- 3 The default text color is looked-up in the theme. It is stored in the token value named `#’color-text’`. You can redefine it locally with `#addTokenNamed:withValue:`. 

We use more and more solution 3 when we want to customize a label in a skin (as an example, in the tab node skin)

### Solution 1 

```
| label |
label := ToAttributedLabel new text: 'Hello'; foreground: Color red; yourself.
label openInSpace
```

### Solution 2

```
| label |
label := ToLabel new withNullSkin; text: 'Hello'; foreground: Color red; yourself.
label openInSpace
```

### Solution 3 variation one 

```
| label |
label := ToLabel text: 'Hello'.
label addTokenNamed: #'color-text' withValue: Color red.
label openInSpace
```

### Solution 3 variation two

```
| container label |
label := ToLabel text: 'Hello'.
container := ToPane horizontal.
container addChild: label.
container addTokenNamed: #'color-text' withValue: Color red.
container openInSpace
```