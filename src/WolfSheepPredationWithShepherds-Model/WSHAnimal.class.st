"
I am an animal, a sheep or a wolf, with some energy.

## Responsibility:

- Move to a random neighbouring patch, as the paper says.
- Lose energy when I move, and reproduce with my reproduction rate, sharing my energy with my offspring.

## Collaborators:

- `WSHModel` gives me my food gain, my move cost and my reproduction rate, through my subclasses.
- `WSHPatch`: where I am, and where my offspring are born.

## Public API and Key Messages

- `energy`, `move`, `loseEnergy`, `reproduce`, and `birthPatches`, which subclasses may restrict.

## Internal Representation

- `energy`: a number.
"
Class {
	#name : 'WSHAnimal',
	#superclass : 'CMAgent',
	#instVars : [
		'energy'
	],
	#category : 'WolfSheepPredationWithShepherds-Model',
	#package : 'WolfSheepPredationWithShepherds-Model'
}

{ #category : 'aspects' }
WSHAnimal >> aspectEnergy: look [
	"My default look, with a size that follows my energy"

	<aspect>
	self aspectDefault: look.
	look sizeForValue: energy from: 0 to: 2 * self gainFromFood
]

{ #category : 'biology' }
WSHAnimal >> beBornWithRandomEnergy [
	"Start with a random energy below twice my food gain. Not in the paper: taken from NetLogo's model"

	energy := self randomIntegerBetween: 0 and: 2 * self gainFromFood - 1
]

{ #category : 'accessing' }
WSHAnimal >> birthPatches [
	"Answer the patches where my offspring may be born"

	^ self cell neighbourhood
]

{ #category : 'accessing' }
WSHAnimal >> energy [

	^ energy
]

{ #category : 'accessing' }
WSHAnimal >> energy: aNumber [

	energy := aNumber
]

{ #category : 'accessing' }
WSHAnimal >> gainFromFood [
	"Answer the energy I get from what I eat"

	^ self subclassResponsibility
]

{ #category : 'biology' }
WSHAnimal >> giveBirthOn: aPatch [
	"Share my energy equally with an offspring born on aPatch, and answer it. Not in the paper: taken from NetLogo's model"

	energy := energy / 2.
	^ (self cormasModel newEntity: self class)
		  energy: energy;
		  moveTo: aPatch;
		  yourself
]

{ #category : 'initialization' }
WSHAnimal >> initialize [

	super initialize.
	self beBornWithRandomEnergy
]

{ #category : 'biology' }
WSHAnimal >> loseEnergy [

	<action>
	energy := energy - self moveCost
]

{ #category : 'biology' }
WSHAnimal >> move [

	<action>
	self randomWalk
]

{ #category : 'accessing' }
WSHAnimal >> moveCost [
	"Answer the energy I lose at each move"

	^ self subclassResponsibility
]

{ #category : 'biology' }
WSHAnimal >> reproduce [
	"With my reproduction rate, give birth on one of my birth patches"

	<action>
	self random < self reproductionRate ifTrue: [
		self giveBirthOn: (self selectRandomlyFrom: self birthPatches) ]
]

{ #category : 'accessing' }
WSHAnimal >> reproductionRate [
	"Answer the probability that I reproduce at each step"

	^ self subclassResponsibility
]
