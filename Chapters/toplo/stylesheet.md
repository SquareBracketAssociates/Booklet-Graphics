# concept of stylesheet

## Token types

A Token is an information associated with a name, at minimum a name/value pair.
The name may be associated with additional Token Properties.

### Token property (ToTokenProperty)

Token properties allows to define key/value pair, like
`ToTokenProperty name: #'background-color' value: Color white`
or
`ToTokenProperty name: #'border-radius' value: 6`

These properties can later be used in stylesheet, to connect BlElement
properties to token properties. They are read-only properties

You can set token directly on element:
`setToken: #'color-primary' -> Color random.`
`setTokenNamed: #'color-primary-pressed' value: Color random twiceDarker.`

### Feature property (ToFeatureProperty) and Pseudo property (ToPseudoProperty)

"skin managing need a list of unique writeable properties."
Defined in *ToStyleSheet class >> defaultWritablePropertyList*

These properties can read or write values. Writing mean changing a property
on a BlElement.

(ToFeatureProperty name: #background).
(ToFeatureProperty name: #geometry).
(ToFeatureProperty name: #border).
(ToFeatureProperty name: #size).

ToFeatureProperty links to an object feature accessor (getter/setter).

ToPseudoProperty name: #'layout-direction'
               reader: [ :e | e layout direction ]
               writer: [ :e :v | e layout direction: v ]

*writer receive and object and a property value*
*reader receive an object and return a value*

different type of properties and usage

```smalltalk
self select: (self id: #'Space root') style: [
self
    write: (self property: #background)
    with: [ :e | e tokenValueNamed: #'background-color' ] ]
```

 is linked with
 `(ToTokenProperty name: #'background-color' value: Color white).`

 and with `(ToFeatureProperty name: #background).`

```smalltalk
ToButton asTypeSelector style:[ :sr |

"Background"
sr
    when: ToInstallLookEvent
    write: (self property: #'background-color')
    with: [ :e | e tokenValueNamed: #'color-bg-container' ].
sr
    when: ToDisabledLookEvent
    write: (self property: #'background-color')
    with: [ :e | e tokenValueNamed: #'color-bg-container-disabled' ].
 ]
```

is linked with

```smalltalk
(ToPseudoProperty name: #'background-color'
        reader: [ :e | e background paint ifNotNil: [ :f | f color ] ifNil:[ Color transparent ] ]
        writer: [ :e :v | e background: v ]).
```

and
`ToTokenProperty name: #'color-bg-container' value: (Color fromHexString: '#ffffff')`
`ToTokenProperty name: #'color-bg-container-disabled' value: (Color black alpha: 0.04)`

or

```smalltalk
self
    when: ToDisabledLookEvent
    write: (self property: #'text-attributes-with-builder')
    with: [ :e |
        e textAttributesBuilder foreground:
            (e tokenValueNamed: #'color-text-disabled') ].

self select: #H1 asStampSelector style: [
    self
        supplement: (self property: #'text-attributes-with-builder')
        with: [ :e |
            e textAttributesBuilder
                defaultFontSize: (e tokenValueNamed: #'font-size-H1');
                lineSpacing: (e tokenValueNamed: #'line-height-H1');
                yourself ] ].
```

property definition

```smalltalk
(ToPseudoProperty new name: #'text-attributes-with-builder';
    writer: [ :e :v |
        e text attributes: v attributes.
        e textChanged ]).
```

Other example

```smalltalk
self
    select: (#'labeled-icon' asStampSelector
                withParent: #button asStampSelector
                atDepth: 1)
    style: [
        self
            write: (self property: #layout)
            with: [ :e | BlLinearLayout horizontal].

        self write: (self property: #'layout-constraints') with: [ :e |
            [ :c |
            c horizontal fitContent.
            c vertical fitContent.
            c linear vertical alignCenter.
            c linear horizontal alignCenter ] ].
    ]
```

properties definition

```smalltalk
(ToFeatureProperty name: #layout).

(ToPseudoProperty name: #'layout-constraints'
    reader: [ :e | e constraints ]
    writer: [ :e :v | v value: e constraints ])
```

## Style sheet definition

Style are defined through call to *select:style:* with multiple.

select let you select specific element. You can look at various attritute
selection below. You can even refine your selection through parent or child,
with:

### Element selection

Element selection is managed by *ToElementSelector*.

#### type selection

`ToLabel asTypeSelector` or `ToButton asTypeSelector`
or you can use *type:* call like `ToTypeSelector new type: ToElement`

#### Id Selection

element definition: `ToButton id: #buttonA`
element query: `id: #buttonA`

#### Stamp selection

element definition `ToButton new addStamp: #'primary'.`
element query `#primary asStampSelector`

you can *removeStamp:* as well.

#### child, parend or sibling selection

Each will accept another selector to refine your current element search.

- *withChild:*
- *withChild:atDepth:*
- *withParent:*
- *withParent:atDepth:*
- *withSibling:*

#### selection composition

And selector *&&*
`ToButton asTypeSelector && #primary asStampSelector`

Or selector *||*

Inverse selector *not*

You can also target child or parent of your element with

### style definition

Style will be passed a Block to define specific style attribute.

- *write:with:*, if you only want to define a property
- *supplement:with:* if you want to add additional properties to your element.
- *when:write:with:* associate a property change during an event.
- *when:supplement:with:* associate additional property change during an event.
- *when:write:with:animation:* associate change to an event and with an animation

*when:* is a look event, part of the list `ToElementLookEvent allSubclasses`
*write:* and *supplement:* will get the property to change
*with:* will be passed a block, which parameter is the element that need to
be changed.
*animation* is a subclass of *ToPropertyAnimation*. the animation must be
shared by all writers which are using it to stop it correctly.

Examples:

```smalltalk
backgroundColorAnim := ToPropertyColorTransitionAnimation new
    duration: 150 milliSeconds.

select: self buttonSelector && #primary asStampSelector
style: [
    self
        when: ToInstallLookEvent
        write: (self property: #'background-color')
        with: [ :e | e tokenValueNamed: #'color-primary' ].
    self
        when: ToLeavedLookEvent
        write: (self property: #'background-color')
        with: [ :e | e tokenValueNamed: #'color-primary' ]
        animation: backgroundColorAnim.

    self
        when: ToInstallLookEvent
        write: (self property: #'border-with-builder')
        with: [ :e |
            e borderBuilder
                paint: Color transparent;
                width: (e tokenValueNamed: #'line-width') ].
]
```

selection example

```smalltalk
select: (#'labeled-icon' asStampSelector withParent: #button asStampSelector
    atDepth: 1)
```
