## Stylesheets

Toplo widgets are fully skinnable. All their visual aspects can be controlled via stylesheets. Stylesheets are composed of rules. Such rules are manipulate token properties. In addition, an element gets a skin, a selection of the stylesheet rules that apply to the element. 

### Core elements

A stylesheet is composed of rules and token properties. Tokens are kind of variables holding values. Rules are kinds of declarations and event condition actions.

An element gets a skin. A Skin is a selection of rules and values dedicated 
to the element. A skin is a handler that will react of events.
At the implementation level there are two kinds of skins: raws that are defined by mere classes and rule-based ones that are a selection of the rules that apply to the element.


### Token Property

A Token is a piece of information associated with a name, at minimum a name/value pair. The name may be associated with additional token properties.
There are different types of token properties: the basic one (`ToTokenProperty`), using accessors of an element (`ToFeatureProperty`), and pseudo properties based on function definitions (`ToPseudoProperty`).

Token properties allow one to define key/value pairs and are read-only.

```
ToTokenProperty 
	name: #'background-color' 
	value: Color white
```
or
```
ToTokenProperty 
	name: #'border-radius' 
	value: 6
```

These properties can later be used in stylesheets to connect `BlElement`
properties to token properties. 

You can set token directly on an element using the method `setToken: anAssociation` or 
`setTokenNamed:value:`.

```
anElt setToken: #'color-primary' -> Color random.
anElt 
	setTokenNamed: #'color-primary-pressed' 
	value: Color random twiceDarker
```

### Feature and Pseudo properties

Property are also declined into feature property (`ToFeatureProperty`) and Pseudo property (`ToPseudoProperty`). 

Skin managing needs a list of unique writeable properties defined in `ToStyleSheet class >> defaultWritablePropertyList`.

These properties can read or write values. Writing means changing a property
on a `BlElement`.

#### Feature property.
`ToFeatureProperty` links to an object feature accessor (getter/setter).

```
(ToFeatureProperty name: #background).
(ToFeatureProperty name: #geometry).
(ToFeatureProperty name: #border).
(ToFeatureProperty name: #size).
(ToFeatureProperty name: #layout).
```



#### Pseudo property.
A pseudo property is a block-based mapper in the sense that it defines 
two functions to control the logic of the property where
- reader receives an object and returns a value
- writer receives an object and a property value


```
ToPseudoProperty 
	name: #'layout-direction'
	reader: [ :e | e layout direction ]
	writer: [ :e :v | e layout direction: v ]
```
```
(ToPseudoProperty name: #'layout-constraints'
	reader: [ :e | e constraints ]
	writer: [ :e :v | v value: e constraints ])
```

### Examples of properties and usage

```smalltalk
self 
	select: (self id: #'Space root') 
	style: [
		self
		write: (self property: #background)
		with: [ :e | e tokenValueNamed: #'background-color' ] ]
```

 is linked with the feature property `#background`

 ```
 (ToFeatureProperty name: #background).
 ```
 and the token #'background-color' 
 ```
 (ToTokenProperty name: #'background-color' value: Color white).
 ```
 

```smalltalk
ToButton asTypeSelector 
	style: [ :sr |
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

is linked with the pseudo property

```smalltalk
(ToPseudoProperty name: #'background-color'
        reader: [ :e | e background paint 
        	ifNotNil: [ :f | f color ] 
	ifNil:[ Color transparent ] ]
        writer: [ :e :v | e background: v ]).
```

and the following token 

```
ToTokenProperty 
	name: #'color-bg-container' 
	value: (Color fromHexString: '#ffffff')
ToTokenProperty 
	name: #'color-bg-container-disabled' 
	value: (Color black alpha: 0.04)
```


Finally 

```smalltalk
self
	when: ToDisabledLookEvent
	write: (self property: #'text-attributes-with-builder')
	with: [ :e |
		e textAttributesBuilder foreground:
			(e tokenValueNamed: #'color-text-disabled') ].

self 
	select: #H1 asStampSelector 
	style: [
		self 
			supplement: (self property: #'text-attributes-with-builder')
			with: [ :e |
				e textAttributesBuilder
					defaultFontSize: (e tokenValueNamed: #'font-size-H1');
					lineSpacing: (e tokenValueNamed: #'line-height-H1');
					yourself ] ].
```

### Another example of property definition

```smalltalk
(ToPseudoProperty new name: #'text-attributes-with-builder';
	writer: [ :e :v |
		e text attributes: v attributes.
		e textChanged ]).
```

```smalltalk
self
	select: (#'labeled-icon' asStampSelector
                	withParent: #button asStampSelector
                	atDepth: 1)
	style: [
		self
			write: (self property: #layout)
			with: [ :e | BlLinearLayout horizontal].
        		self 
			write: (self property: #'layout-constraints') 
			with: [ :c |
			c horizontal fitContent.
 			c vertical fitContent.
            			c linear vertical alignCenter.
            			c linear horizontal alignCenter ] ].
    ]
```



### Style sheet definition

Styles are defined vis  `select:style:`messages with multiple arguments.

`select:` lets you select a specific element. You can look at various attribute
selection below. You can even refine your selection through parent or child,
with the following element element selection.
Element selection is managed by `ToElementSelector`.

#### Type selection
Type selector are selection based on the class of the BlElement. 
Using the message `asTypeSelector any element class can play this role.

`ToLabel asTypeSelector` or `ToButton asTypeSelector`
or you can use `type:` as in `ToTypeSelector new type: ToElement`

#### Id selection
The selection can also be based on the id of an element. 

- element definition as in  `ToButton id: #buttonA`
- element query as in `id: #buttonA`

#### Stamp selection
The selection can be based on specific stamp attached to an element.

- element definition as in:  `ToButton new addStamp: #'primary'.`
- element query as in: `#primary asStampSelector`

You can also use `removeStamp:` as well to change a stamp.

#### Child, parent or sibling selection

Each selection will accept another selector to refine your current element search.

- `withChild:`
- `withChild:atDepth:`
- `withParent:`
- `withParent:atDepth:`
- `withSibling:`

#### Selection composition
Finally selection can be composed with traditional boolean logic operators:

- And selector `&&`
- Or selector `||`
- Inverse selector `not`

```
ToButton asTypeSelector && #primary asStampSelector
```

You can also target a child or parent of your element.

### Style definition

Style will be passed a Block to define specific style attribute.

- `write:with:`, if you only want to define a property.
- `supplement:with:` if you want to add additional properties to your element.
- `when:write:with:` associates a property change during an event.
- `when:supplement:with:` associates additional property change during an event.
- `when:write:with:animation:` associates change to an event and with an animation

The message arguments follow:
- `when:` argument is a look event, part of the list `ToElementLookEvent allSubclasses`
- `write:` and `supplement:` argument will get the property to change
- `with:` argument is a block whose parameter is the element that needs to
be changed.
- `animation:` argument is a subclass of `ToPropertyAnimation`. The animation must be
shared by all writers that are using it to stop it correctly.

### Examples

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

### Selection example

```smalltalk
select: (#'labeled-icon' asStampSelector withParent: #button asStampSelector
    atDepth: 1)
```
