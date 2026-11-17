"
I am a wolf. I roam the whole world and eat sheep, unless a shepherd guards them.

## Responsibility:

- Act as in the paper: move, lose energy, eat a sheep of my patch, die when my energy reaches 0, reproduce.
- Never eat on a guarded patch.

## Collaborators:

- `WSHSheep`: my prey.
- `WSHPatch`: tells me whether it is guarded.

## Public API and Key Messages

- `step`, `eatSheep`.
"
Class {
	#name : 'WSHWolf',
	#superclass : 'WSHAnimal',
	#category : 'WolfSheepPredationWithShepherds-Model',
	#package : 'WolfSheepPredationWithShepherds-Model'
}

{ #category : 'aspects' }
WSHWolf >> aspectDefault: look [

	<aspect>
	look
		color: CMColor black;
		size: 0.8
]

{ #category : 'aspects' }
WSHWolf >> aspectHunger: look [
	"Red, pale when I am starving and dark when I am well fed"

	<aspect>
	self aspectDefault: look.
	look
		colorShadeOf: CMColor red
		forValue: energy
		from: 0
		to: 2 * self gainFromFood
]

{ #category : 'biology' }
WSHWolf >> eatSheep [
	"Eat a sheep of my patch, unless a shepherd guards it"

	<action>
	| sheep |
	self cell isGuarded ifTrue: [ ^ self ].
	sheep := self cell occupantsOfClass: WSHSheep.
	sheep ifEmpty: [ ^ self ].
	(self selectRandomlyFrom: sheep) die.
	energy := energy + self gainFromFood
]

{ #category : 'accessing' }
WSHWolf >> gainFromFood [

	^ self cormasModel wolfGainFromFood
]

{ #category : 'biology' }
WSHWolf >> move [
	<action>
	self randomWalkConstrainedBy: [ :patch | patch isGuarded not ]
]

{ #category : 'accessing' }
WSHWolf >> moveCost [

	^ self cormasModel wolfMoveCost
]

{ #category : 'accessing' }
WSHWolf >> reproductionRate [

	^ self cormasModel wolfReproductionRate
]

{ #category : 'biology' }
WSHWolf >> step [
	"As in the paper: move at a cost, eat a sheep of my patch, die when my energy reaches 0, and reproduce"

	<action>
	self
		move;
		loseEnergy;
		eatSheep.
	energy <= 0 ifTrue: [ ^ self die ].
	self reproduce
]
