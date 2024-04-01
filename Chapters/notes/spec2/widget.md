# Spec2 - widget

## How to find the relationship between Morphic and Spec component

Each component is a presenter, which basic class is 'SpPresenter'
The list of widget available are available in the package 'Spec2-Core-Widgets'
and its sub-package. Their morphic counterpart are in the package
'Spec2-Adapters-Morphic-Backend'

Ex: for a button.

```smalltalk
SpButtonPresenter class >> adapterName
^ #ButtonAdapter
```

```smalltalk
SpAbstractWidgetPresenter class >> defaultSpec
<spec: #default>
^ SpAbstractWidgetLayout for: self adapterName
```

```smalltalk
SpAdapterBindings subclass: #SpMorphicAdapterBindings 
SpMorphicAdapterBindings >> abstractAdapterClass
 ^ SpAbstractMorphicAdapter
```

To link the name:

```smalltalk
 SpAbstractMorphicAdapter  class >> adaptingName
 ^ (self name withoutPrefix: 'SpMorphic') asSymbol
```
