# Morphic Coordinates

## World Morph

```smalltalk
Smalltalk ui currentWorld 

myMorph := (Morph new) color: Color red; 
            position: 50@75; 
            extent: 200@100; 
            openInWorld.
```

myMorph

## measure

extent          -> 200@100

### bounds

bounds size can vary if the morph is added to another one, or if it's independent.
It's closely related to the layout.
bounds          -> (50.0@75.0) corner: (250.0@175.0)
innerBounds     -> (50.0@75.0) corner: (250.0@175.0) (because it is not a bordered morph)
boundsInWorld   -> (50.0@75.0) corner: (250.0@175.0) (identical to bounds in this case, because we open our morph in world)
fullBoundsInWorld -> (50.0@75.0) corner: (250.0@175.0)
outerBounds     -> (50.0@75.0) corner: (250.0@175.0)

## dimension

height          -> 100
left            -> 50
right           -> 250
top             -> 75
bottom          -> 175
width           -> 200

## position

position        -> (50.0@75.0)
positionInWorld -> (50.0@75.0)
referencePosition -> (150.0@125.0)
referencePositionInWorld -> (150.0@125.0)

bottomCenter    -> 150@175
bottomLeft      -> 50@175
bottomRight     -> 250@175
leftCenter      -> (50.0@125)
center          -> (150@125)
rightCenter     -> (250.0@125)
topLeft         -> (50.0@75.0)
topCenter       -> (150@75.0)
topRight        -> (250.0@75.0)

`+------------------------------------------------------------------+`
`| Smalltalk ui currentWorld or Parent Morph                        |`
`+------------------------------------------------------------------+`
`|                  topCenter                                       |`
`|       topLeft       |       topRight                             |`
`|          +---------------------+                                 |`
`|          |                     |                                 |`
`|leftCenter|       center        | rightCenter                     |`
`|          |                     |                                 |`
`|          +---------------------+                                 |`
`|    bottomLeft       ^    bottomRight                             |`
`|               bottomCenter                                       |`
`+------------------------------------------------------------------+`
