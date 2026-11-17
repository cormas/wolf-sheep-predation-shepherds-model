"
I am a patch of the world, the place where sheep, wolves and shepherds meet. I am a Cormas cell: patch is the word of the paper.

## Responsibility:

- Know whether I have grass, and grow it again `grassRegrowthTime` steps after it was eaten.
- Know the pasture I belong to, if any.
- Know whether a shepherd guards me, so that wolves cannot eat on me.

## Collaborators:

- `WSHSheep` eat my grass, and `WSHWolf` ask whether I am guarded.
- `WSHShepherd`: their distance to me decides whether I am guarded.
- `WSHPasture`: the aggregate I may belong to.

## Public API and Key Messages

- `hasGrass`, `beEaten`, `step`, `pasture`, `isGuarded`.

## Internal Representation

- `hasGrass`: whether I have grass (green) or not (brown).
- `countdown`: the steps left before my grass grows again.
"
Class {
	#name : 'WSHPatch',
	#superclass : 'CMCell',
	#instVars : [
		'hasGrass',
		'countdown'
	],
	#category : 'WolfSheepPredationWithShepherds-Model',
	#package : 'WolfSheepPredationWithShepherds-Model'
}

{ #category : 'aspects' }
WSHPatch >> aspectDefault: look [

	<aspect>
	look color: (hasGrass
			 ifTrue: [ CMColor green ]
			 ifFalse: [ CMColor brown ])
]

{ #category : 'aspects' }
WSHPatch >> aspectGuarded: look [
	"Light blue where wolves cannot eat"

	<aspect>
	look color: (self isGuarded
			 ifTrue: [ Color lightBlue ]
			 ifFalse: [ Color veryLightGray ])
]

{ #category : 'aspects' }
WSHPatch >> aspectPlain: look [
	"In the background"

	<aspect>
	look color: Color veryLightGray
]

{ #category : 'aspects' }
WSHPatch >> aspectRegrowth: look [
	"Green with grass. Without grass, from brown to green as my grass grows back"

	<aspect>
	hasGrass ifTrue: [ ^ look color: CMColor green ].
	look
		colorBetween: CMColor brown
		and: CMColor green
		forValue: self cormasModel grassRegrowthTime - countdown
		from: 0
		to: self cormasModel grassRegrowthTime
]

{ #category : 'grass' }
WSHPatch >> beEaten [
	"Lose my grass, which grows again after the regrowth time of the model"

	hasGrass := false.
	countdown := self cormasModel grassRegrowthTime
]

{ #category : 'grass' }
WSHPatch >> beEatenSomeTimeAgo [
	"Lose my grass, which grows again at a random step within the regrowth time, as if it had been eaten some time ago"

	hasGrass := false.
	countdown := self
		             randomIntegerBetween: 1
		             and: self cormasModel grassRegrowthTime
]

{ #category : 'grass' }
WSHPatch >> growGrass [

	hasGrass := true
]

{ #category : 'grass' }
WSHPatch >> hasGrass [

	^ hasGrass
]

{ #category : 'initialization' }
WSHPatch >> initialize [

	super initialize.
	hasGrass := true.
	countdown := 0
]

{ #category : 'accessing' }
WSHPatch >> isGuarded [
	"Answer whether a shepherd is within the guarding distance of the model, so that wolves cannot eat here"

	^ self cormasModel @@ WSHShepherd anySatisfy: [ :each |
		  (self distanceTo: each cell) <= self cormasModel guardingDistance ]
]

{ #category : 'accessing' }
WSHPatch >> pasture [
	"Answer the pasture I belong to, or nil on wild land"

	^ self getAggregateType: WSHPasture
]

{ #category : 'grass' }
WSHPatch >> step [
	"Without grass, wait for the regrowth time, then grow grass again. The paper: 'If brown, then wait X1 clock-ticks and turn green'"

	<action>
	hasGrass ifTrue: [ ^ self ].
	countdown := countdown - 1.
	countdown <= 0 ifTrue: [ self growGrass ]
]
