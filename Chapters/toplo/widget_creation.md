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









