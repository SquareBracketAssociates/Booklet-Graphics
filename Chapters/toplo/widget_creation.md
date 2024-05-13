## How to create a raw widget from Toplo



https://thegnomejournal.wordpress.com/2006/02/16/writing-a-widget-using-cairo-and-gtk2-8-part-2/

With Bloc, we have low-level tools to define custom graphical elements. However,
if we want to reproduce the appearance and behavior on our element, we should
group them under a library. This is what is Toplo: A collection a high-level
widget build on top of Bloc. You'll find all widget you expect to create your
own graphical user interface, like:

- button
- checkbox
- menu
- pane
- etc.

Defining our own widget is quite easy. We'll guide you steps by steps.

Inspiration taken from Gtk2 widget creation example with a clock
https://thegnomejournal.wordpress.com/2005/12/02/writing-a-widget-using-cairo-and-gtk2-8/

### Define a model

This step may be optional, but since our widget will hold a state, we should
have one.

Model members:
- hour
- minute
- seconds  

### Define graphical element

Our widget should be a subclass of `ToElement`, which is the ancestor of all Toplo
widgets.

### Widget appearance

Widgets on the bare form is like a ghost. It doesn't have any visual appearance.
To keep maximum flexibility, Toplo introduces the concept of **skin** which defines
how to dress your widget. 

You'll have to overwrite two methods to define your skins:

- installRawStyle -> for raw skin
- installBeeStyle -> for bee skin
- newRawSkin

You can override *uninstallRawStyle* if that's necessary.

Skins are subclasses of `ToSkin` which reacts to event handling. 
For each event, your widget can have a different **look**.

Look will get specific properties into `#toStyleStore` properties of its `BlElement` (Under the hood, a `ToStyleStore` instance which stores properties
such color-primary, color-border, etc. ).

### Widget state

Your widget may need to hold your state. Like a checkbox, which has three
differents states (checked, unchecked, indeterminate). Usually, you don't care
about it, until you want to.


### More here


### To use skin and theme

Skins are a good way to customize widgets created with Bloc. 
Here is a simple how to to define skins for your widget.


- Firstly, if your widget is a `BlElement`, you must change it to a `ToElement` (subclass of `BlElement`).
- You'll need to implement/override the methods `newRawSkin` and `installRawStyle`, for example `newRawSkin` will return an instance of the skin of your widget. ( It can be `newBeeSkin` and `installBeeStyle` ).
- By subclassing `ToRawSkin`, now you have to create the skin of your widget, that will implement methods related to events.

The common one is `installLookEvent` that will apply the changes you give to your skin when you'll install it.
For example you can use `pressedLookEvent` that will apply the changes you want when you click on the widget.

#### skin creation - to be place in another chapter

There are several ways to set the skin of an element.

- The first is to redefine #newRawSkin (or newXXXSkin for a ToXXXTheme )
- The second way is to use #defaultRawSkin: to set a skin different from the one returned by newRawSkin.
- The third way it #defaultSkin: that is theme independent.

To set its skin, it select in order:

1. An element use the one set by #defaultRawSkin: (if not nil), 
2. The one set by #defaultSkin: 
3. The one returned by #newRawSkin.

Thus inside an #installedLookEvent:, an element can set the skin of its sub
elements by sending it the #defaultRawSkin: message with the desired skin as
argument :

```smalltalk
ToRawRoundClockSkin>>installLookEvent: anEvent

	super installLookEvent: anEvent.
	anEvent elementDo: [ :e |
		e minutesNeedle defaultRawSkin: ToNeedleInRoundClockSkin new.
	].
```

```smalltalk
ToRawSquareClockSkin>>installLookEvent: anEvent

	super installLookEvent: anEvent.
	anEvent elementDo: [ :e |
		e minutesNeedle defaultRawSkin: ToNeedleInSquareClockSkin new.
	]
```

It should work ok for an element with its direct sub-elements.
Now, a sub-element’s skin is installed with one delay pulse.
A sub-element sub-element skin is then installed with two delay pulse, etc…
So, some undesirable transition effect can arise with such a skin installation
in case of a deep composition tree.  this is where a stylesheet can be useful
because of the selection mechanism that allow the skin selection/building in one
pass

Two precisions:

- If e minutesNeedle return a BlElement, and not a ToElement, then you need to send it #ensureCanManageSkin
e ensureCanManageSkin. 
- One can send #withNullSkin to an element to set a NullSkin.

`#ensureCanManageSkin` just add two event handlers: one to generate the element
states (and then dispatch the look events) and a second to setup the skin when
the element is added in a space.

## Token properties explanation
 A token property is a key/value pair. Those pairs are all defined in the `defaultTokenProperties` method of `ToTheme` class.
So if you want to customize the graphical properties, you can call those Token properties to use them for your widget.
And if you want to change the values of those properties to make your skin more customizable, you'll need to define the appareance of your theme.

### Implement a Theme

To create your own theme with your own values, you'll have to subclass `ToRawTheme` ( or `ToBeeTheme` ) and implement its class-sided method `defaultTokenProperties` to define the values of your properties.
For example: 

``` 
defaultTokenProperties 
	^ super defaultTokenProperties , 
		{   (ToTokenProperty name: #'background-color' value: (Color lightGreen)). }
```
This will set the token property "background-color" to value "lightGreen"


### Little example

In this case: Imagine you've not defined the border and the background of your widget, well you can configure it in the `installLookEvent`: 

```
installLookEvent: anEvent
	"when installing the skin, changes the properties of widget mentionned down here"

	super installLookEvent: anEvent.
	anEvent elementDo: [ :e |
		e border: (BlBorder
				 paint: (e valueOfTokenNamed: #'color-border')
				 width: (e valueOfTokenNamed: #'line-width')).
		e background: e backgroundPaint ]
```
Those tokens can be defined in your theme.

### Last things to do

Now that you have your own skin/theme, you need to link them to your widget.
So in a class of your `ToElement`, you have to set the `defaultSkin` attribute to a new instance of your skin.
And for your theme, you need to link it to the space you're using like this:

```	
space toTheme: (name of your theme) new.
```



## Notes in bulk
Your element needs to be a Toplo Element. 

* If e minutesNeedle return a BlElement, and not a ToElement, then you need to send it #ensureCanManageSkin `e ensureCanManageSkin.`

*  One can send #withNullSkin to an element to set a NullSkin.

* stylesheet can be useful because of the selection mechanism that allow the skin selection/building in one pass.
* 
I’ve no particular solution for this kind of issue.

An example of this kind of sub-element skin is the ToLabelInListElementSkin that can be used when a node is selected in a ListElement.
It is typically set from a ToListElement nodeBuilder (not in a #installLookEvent:  in my examples).


A theme is to manage common token values for the set of widgets it is supposed to be designed for. So I’ve added the ToThemePreInstallEvent that you can use ton add new token values in the current theme.
(Have a look at #example_WithLateBoundPropertyWriter).
But the implementation of token values storage have to be revised to nicely fulfill this need.

First if you only need a ToInstallLookEvent handling, note that adding a skin class is not mandatory. You can simply redefine the #installRawStyle method instead.

In your #installLookEvent:, I see a lot of code that, I think, should stay in the initialize method because changing the theme Would not lead to the change of your element appearance.


