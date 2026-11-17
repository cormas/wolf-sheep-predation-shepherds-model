"
I am a sheep of a flock. I live in the pasture of my shepherd, and eat its grass.

## Responsibility:

- Act as in version 2 of the paper, but only within my pasture: move, lose energy, eat grass, die when my energy is below 0, reproduce.
- Give my lambs to my shepherd.

## Collaborators:

- `WSHShepherd`: my shepherd, linked to me by a `WSHFlockLink`.
- `WSHPatch`: its grass feeds me.

## Public API and Key Messages

- `step`, `eatGrass`, `shepherd`, `pasture`.

```
shepherd adopt: ((model newEntity: WSHSheep) moveTo: aPatch; yourself)
```

### Implementation Points

- I do not remember my shepherd: the link from my shepherd says who it is. When I die, Cormas removes the link, so I leave my flock.
"
Class {
	#name : 'WSHSheep',
	#superclass : 'WSHAnimal',
	#category : 'WolfSheepPredationWithShepherds-Model',
	#package : 'WolfSheepPredationWithShepherds-Model'
}

{ #category : 'aspects' }
WSHSheep >> aspectDefault: look [

	<aspect>
	look
		color: CMColor white;
		size: 0.6
]

{ #category : 'aspects' }
WSHSheep >> aspectFlock: look [
	"The color of my shepherd, with a dark border to stand out on my pasture"

	<aspect>
	self aspectDefault: look.
	look
		colorGroupedBy: self shepherd id;
		borderColor: CMColor black;
		borderThickness: 0.05
]

{ #category : 'aspects' }
WSHSheep >> aspectPlain: look [
	"In the background"

	<aspect>
	look
		color: Color gray;
		size: 0.4
]

{ #category : 'accessing' }
WSHSheep >> birthPatches [

	^ self cell neighbourhood select: [ :each |
		  each pasture == self pasture ]
]

{ #category : 'biology' }
WSHSheep >> eatGrass [

	<action>
	self cell hasGrass ifFalse: [ ^ self ].
	self cell beEaten.
	energy := energy + self gainFromFood
]

{ #category : 'accessing' }
WSHSheep >> gainFromFood [

	^ self cormasModel sheepGainFromFood
]

{ #category : 'biology' }
WSHSheep >> giveBirthOn: aPatch [
	"My lamb joins my flock"

	^ self shepherd adopt: (super giveBirthOn: aPatch)
]

{ #category : 'biology' }
WSHSheep >> move [
	"Move to a random neighbouring patch of my pasture"

	<action>
	self randomWalkConstrainedBy: [ :each | each pasture == self pasture ]
]

{ #category : 'accessing' }
WSHSheep >> moveCost [

	^ self cormasModel sheepMoveCost
]

{ #category : 'accessing' }
WSHSheep >> pasture [

	^ self shepherd pasture
]

{ #category : 'accessing' }
WSHSheep >> reproductionRate [

	^ self cormasModel sheepReproductionRate
]

{ #category : 'accessing' }
WSHSheep >> shepherd [

	^ (self previousEntitiesLinkedBy: WSHFlockLink) anyOne
]

{ #category : 'biology' }
WSHSheep >> step [
	"Version 2 of the paper, within my pasture: move at a cost, eat the grass of my patch, die when my energy is below 0, and reproduce"

	<action>
	self
		move;
		loseEnergy;
		eatGrass.
	energy < 0 ifTrue: [ ^ self die ].
	self reproduce
]
