"
I am the link from a shepherd to one of their sheep: the sheep belongs to the shepherd's flock.

## Responsibility:

- Connect a shepherd to a sheep. Cormas removes me when the sheep dies.

## Collaborators:

- `WSHShepherd`: my start. `WSHSheep`: my end.
- `WSHFlock`: the network I belong to.

## Public API and Key Messages

- `from`, `to`.

```
model newEntity: WSHFlockLink from: aShepherd to: aSheep
```
"
Class {
	#name : 'WSHFlockLink',
	#superclass : 'CMLink',
	#category : 'WolfSheepPredationWithShepherds-Model',
	#package : 'WolfSheepPredationWithShepherds-Model'
}

{ #category : 'aspects' }
WSHFlockLink >> aspectDefault: look [
	"A faint line, so that a hundred links do not hide the sheep"

	<aspect>
	look color: (Color gray alpha: 0.3)
]

{ #category : 'aspects' }
WSHFlockLink >> aspectFlock: look [
	"A line in the color of the shepherd"

	<aspect>
	look colorGroupedBy: self from id; hasArrowhead: false
]
