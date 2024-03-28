# Spec2 - introduction

## architecture

Spec2 is an MVP framework (Model-View-Presenter)

1. The model represent the domain logic of the application
2. The presenter let the developer do the UI programmaticaly
3. The UI is then managed by Pharo.

<https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93presenter>

```smalltalk
+-----------------------------------------------+
| passive view (backend morphic, gtk)           | Managed by Pharo through Spec
| your code shouldn't directly interact with it |
+-----------------------------------------------+
                        |
+-----------------------------------------------+
| presenter (your pharo spec code)              | You're responsible of this part
| Subclass of SpPresenter                       |
+-----------------------------------------------+
                        |
+-----------------------------------------------+
| model (your application logic)                | You're responsible of this part
+-----------------------------------------------+
```

MVP is a user interface architectural pattern engineered to facilitate automated unit testing and improve the separation of concerns in presentation logic:

- The model is an interface defining the data to be displayed or otherwise acted upon in the user interface.
- The presenter acts upon the model and the view. It retrieves data from repositories (the model), and formats it for display in the view.
- The view is a passive interface that displays data (the model) and routes user commands (events) to the presenter to act upon that data.

In Spec, presenter is a derivative of [[ComposableModel]] Class. It manage the logic and the link between widgets and domain objects.

### SpApplication & SpNotification

SpApplication concentrate ressource for user application like

- which backend to use (Gtk, default is Morphic)
- which style to apply.

### SpPresenter

Your presenter should be a subclass of SpPresenter
SpPresenter subclass: #MyApplicationUI
It must implement:

- initializePresenters => declare the list of widget that compose the GUI

It shoud implement:

- connectPresenters => declare the interaction between the widget
- initializeWindow: for classic windows (method found in SpWindowPresenter)
- initializeDialogWindow: for dialog and modal windows (method found in
SpDialogWindowPresenter and SpModalWindowPresenter)
=> those method set the title, size, about box, etc... of the window of the UI.

## ObservableSlot

SpObservableSlot is used in variable declaration using slot, to define variable
that could change and could be observable. Look for example at the definition of
class SpPresenter

## creating spec 2 widget

-> link event: aPresenter eventHandler whenMouseDownDo: aBlock
