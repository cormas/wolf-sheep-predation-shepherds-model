"
I am a shepherd. I keep a flock in my pasture, and guard the sheep near me from wolves.

## Responsibility:

- Keep a pasture and a flock.
- Adopt sheep into my flock, with a link from me to each of them.
- Walk at random within my pasture. I never die, and have no energy.

## Collaborators:

- `WSHPasture`: where I walk and my sheep live.
- `WSHFlock`: the network of my links to my sheep.
- `WSHPatch`: patches near me are guarded.

## Public API and Key Messages

- `keep:`, `adopt:`, `step`, `pasture`, `flock`.

```
shepherd := model createShepherdFor: aPasture.
shepherd adopt: aSheep
```

## Internal Representation

- `pasture`: a `WSHPasture`.
- `flock`: a `WSHFlock`.
"
Class {
	#name : 'WSHShepherd',
	#superclass : 'CMAgent',
	#instVars : [
		'pasture',
		'flock'
	],
	#category : 'WolfSheepPredationWithShepherds-Model',
	#package : 'WolfSheepPredationWithShepherds-Model'
}

{ #category : 'actions' }
WSHShepherd >> adopt: aSheep [
	"Add aSheep to my flock, and answer it"

	flock add:
		(self cormasModel newEntity: WSHFlockLink from: self to: aSheep).
	^ aSheep
]

{ #category : 'aspects' }
WSHShepherd >> aspectDefault: look [

	<aspect>
	look
		color: CMColor blue;
		shape: #square;
		size: 0.7
]

{ #category : 'aspects' }
WSHShepherd >> aspectFlock: look [
	"A star in the color of my flock"

	<aspect>
	look
		colorGroupedBy: self id;
		shape: #star;
		size: 0.9
]

{ #category : 'accessing' }
WSHShepherd >> flock [

	^ flock
]

{ #category : 'actions' }
WSHShepherd >> keep: aPasture [
	"Keep a new flock in aPasture, starting on one of its patches"

	pasture := aPasture.
	flock := self cormasModel newEntity: WSHFlock.
	self moveTo: (self selectRandomlyFrom: pasture components)
]

{ #category : 'accessing' }
WSHShepherd >> pasture [

	^ pasture
]

{ #category : 'actions' }
WSHShepherd >> step [
	"Move to a random neighbouring patch of my pasture"

	<action>
	self randomWalkConstrainedBy: [ :each | each pasture == pasture ]
]
