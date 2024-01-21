# introduction

Bloc comes with a full API to deal with text. Not only you can deal with
raw text, but you can apply styles as well.

Here is a short example to see what is possible

```smalltalk
labelText := 'hello from bloc' asRopedText
foreground: Color orange;
fontSize: 16;
fontName: 'Helvetica';
thin.

label := BlTextElement new.
label text: labelText.

label openInNewSpace
```

Before being displayed, you define your text as an instance of **BlRopedText**,
which you can then style with attributes like:

- font name
- font size
- font foreground and background color
- font style (normal, italic, bold).

Text can after be rendered as **BlTextElement**, which will take care of
displaying properly the text with all properties defined on it.
Once you have a **BlTextElement**, all properties of **BlElement** apply. You
can add your element to any existing **BlElement**, and integrate it easily in
your graphical interface.

## Text handling

(BlTextElement new text: 'hello' asRopedText)

```smalltalk
BlTextElement new
        position: 5 @ 5;
        text: ('Rainbow!' asRopedText attributes:
        { (BlTextForegroundAttribute paint: Color black)

```
