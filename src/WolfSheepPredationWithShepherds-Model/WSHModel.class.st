"
I am Wolf Sheep Predation with Shepherds: version 2 of the predator-prey model of Wilensky and Reisman (2006), wolves, sheep and grass, with three shepherds who keep their flocks in pastures and guard them from wolves.

The rules of wolves, sheep and grass are those of `WSPModel`, version 2. The shepherds, pastures and flocks are added on top of them, so my results differ from the paper's.

## Responsibility:

- Create a world of 51 by 51 patches that wraps around, three pastures of 17 by 17 patches in a triangle, a shepherd for each pasture, the sheep split equally among the shepherds, and the wolves anywhere.
- Run a step: shepherds, then sheep, then wolves, each in a random order, then patches.
- Hold the parameters, and count sheep, wolves and patches with grass.

## Collaborators:

- `WSHShepherd`, `WSHSheep`, `WSHWolf`, `WSHPatch` and `WSHPasture`: the entities I create and make step.

## Public API and Key Messages

- `sheepWolvesShepherds`, the init method, and `stepSheepWolvesShepherds`, the control method.
- The parameters, such as `guardingDistance`, and the probes `numberOfSheep`, `numberOfWolves` and `amountOfGrass`.

```
(CMSimulation for: WSHModel new)
	activeInitSelector: #sheepWolvesShepherds;
	activeControlSelector: #stepSheepWolvesShepherds;
	initializeSimulation;
	runStep
```

## Internal Representation

- The parameters of version 2 of Wolf Sheep Predation, with the same defaults, except `wolfGainFromFood`, 40 instead of 20: the sheep live only in the pastures, a third of the world, and the wolves starve with less.
- `guardingDistance`: how far a shepherd keeps wolves from eating, in patches.
"
Class {
	#name : 'WSHModel',
	#superclass : 'CMModel',
	#instVars : [
		'initialNumberOfSheep',
		'initialNumberOfWolves',
		'sheepGainFromFood',
		'wolfGainFromFood',
		'sheepMoveCost',
		'wolfMoveCost',
		'sheepReproductionRate',
		'wolfReproductionRate',
		'grassRegrowthTime',
		'guardingDistance'
	],
	#category : 'WolfSheepPredationWithShepherds-Model',
	#package : 'WolfSheepPredationWithShepherds-Model'
}

{ #category : 'accessing' }
WSHModel class >> prefix [
	"Every class name in the model package begins with this prefix"

	^ 'WSH'
]

{ #category : 'probes' }
WSHModel >> amountOfGrass [
	"The number of patches with grass"

	<probeNamed: 'Grass' color: '00AA00'>
	^ self cells count: [ :each | each hasGrass ]
]

{ #category : 'init' }
WSHModel >> createPastures [
	"Three pastures of 17 by 17 patches, in a triangle, with wild land around and between them, each kept by a shepherd"

	#( #( 3 3 ) #( 3 33 ) #( 33 18 ) ) do: [ :corner |
			self createShepherdFor: (self
					 createAggregate: WSHPasture
					 from: (self patchesFromRow: corner first column: corner second)) ]
]

{ #category : 'init' }
WSHModel >> createPatches [
	"A world of 51 by 51 patches that wraps around. Its size is fixed, since the pastures are at fixed places"

	self
		createGridNumberOfRows: 51
		numberOfColumns: 51
		neighbourhood: 8
		closed: false
]

{ #category : 'init' }
WSHModel >> createSheep [
	"Split the sheep equally among the shepherds, on random patches of their pastures"

	| shepherds |
	shepherds := self @@ WSHShepherd.
	1 to: initialNumberOfSheep do: [ :index |
			| shepherd |
			shepherd := shepherds at: index - 1 \\ shepherds size + 1.
			shepherd adopt: ((self newEntity: WSHSheep)
					 moveTo: (self selectRandomlyFrom: shepherd pasture components);
					 yourself) ]
]

{ #category : 'init' }
WSHModel >> createShepherdFor: aPasture [

	^ (self newEntity: WSHShepherd)
		  keep: aPasture;
		  yourself
]

{ #category : 'parameters' }
WSHModel >> grassRegrowthTime [
	"The number of steps an eaten patch waits before its grass grows again"

	<parameterIntegerMin: 0 max: 100 default: 30>
	^ grassRegrowthTime
]

{ #category : 'parameters' }
WSHModel >> grassRegrowthTime: anInteger [

	<parameterSetter>
	grassRegrowthTime := anInteger
]

{ #category : 'parameters' }
WSHModel >> guardingDistance [
	"How far a shepherd keeps wolves from eating, in patches. At 0, shepherds guard nothing"

	<parameterIntegerMin: 0 max: 3 default: 1>
	^ guardingDistance
]

{ #category : 'parameters' }
WSHModel >> guardingDistance: anInteger [

	<parameterSetter>
	guardingDistance := anInteger
]

{ #category : 'parameters' }
WSHModel >> initialNumberOfSheep [

	<parameterIntegerMin: 0 max: 250 default: 100>
	^ initialNumberOfSheep
]

{ #category : 'parameters' }
WSHModel >> initialNumberOfSheep: anInteger [

	<parameterSetter>
	initialNumberOfSheep := anInteger
]

{ #category : 'parameters' }
WSHModel >> initialNumberOfWolves [

	<parameterIntegerMin: 0 max: 250 default: 50>
	^ initialNumberOfWolves
]

{ #category : 'parameters' }
WSHModel >> initialNumberOfWolves: anInteger [

	<parameterSetter>
	initialNumberOfWolves := anInteger
]

{ #category : 'testing' }
WSHModel >> noAnimalIsLeft [

	<boolean>
	^ (self @@ WSHAnimal) isEmpty
]

{ #category : 'probes' }
WSHModel >> numberOfSheep [

	<probeNamed: 'Sheep' color: '0000FF'>
	^ (self @@ WSHSheep) size
]

{ #category : 'probes' }
WSHModel >> numberOfWolves [

	<probeNamed: 'Wolves' color: 'FF0000'>
	^ (self @@ WSHWolf) size
]

{ #category : 'init' }
WSHModel >> patchesFromRow: aRow column: aColumn [
	"The 17 by 17 patches of a pasture whose top left patch is at aRow and aColumn"

	^ (aRow to: aRow + 16) flatCollect: [ :row |
			  (aColumn to: aColumn + 16) collect: [ :column |
				  self cellAt: row at: column ] ]
]

{ #category : 'perspectives' }
WSHModel >> perspectiveEcology [
	"Is the food chain balanced? Grass growing back, and animals sized by their energy"

	<perspective>
	^ CMPerspective new
		  show: WSHPatch as: #aspectRegrowth:;
		  show: WSHAnimal as: #aspectEnergy:;
		  hide: WSHShepherd;
		  hide: WSHFlockLink;
		  hide: WSHFlock;
		  yourself
]

{ #category : 'perspectives' }
WSHModel >> perspectiveFlocks [
	"Who owns what, and which flock is thriving? Each shepherd, pasture, sheep and link in the color of its flock, and flocks thicker the more sheep they have"

	<perspective>
	^ CMPerspective new
		  show: WSHPatch as: #aspectPlain:;
		  show: WSHPasture as: #aspectFlock:;
		  show: WSHShepherd as: #aspectFlock:;
		  show: WSHSheep as: #aspectFlock:;
		  show: WSHFlockLink as: #aspectFlock:;
		  show: WSHFlock as: #aspectSize:;
		  hide: WSHWolf;
		  yourself
]

{ #category : 'perspectives' }
WSHModel >> perspectiveGuarding [
	"Where are sheep safe? Guarded patches, and wolves by hunger"

	<perspective>
	^ CMPerspective new
		  show: WSHPatch as: #aspectGuarded:;
		  show: WSHWolf as: #aspectHunger:;
		  show: WSHSheep as: #aspectPlain:;
		  hide: WSHFlockLink;
		  hide: WSHFlock;
		  yourself
]

{ #category : 'parameters' }
WSHModel >> sheepGainFromFood [
	"The energy a sheep gets from the grass of a patch"

	<parameterIntegerMin: 0 max: 50 default: 4>
	^ sheepGainFromFood
]

{ #category : 'parameters' }
WSHModel >> sheepGainFromFood: anInteger [

	<parameterSetter>
	sheepGainFromFood := anInteger
]

{ #category : 'parameters' }
WSHModel >> sheepMoveCost [
	"The energy a sheep loses at each move"

	<parameterIntegerMin: 0 max: 10 default: 1>
	^ sheepMoveCost
]

{ #category : 'parameters' }
WSHModel >> sheepMoveCost: anInteger [

	<parameterSetter>
	sheepMoveCost := anInteger
]

{ #category : 'parameters' }
WSHModel >> sheepReproductionRate [
	"The probability that a sheep reproduces at each step"

	<parameterFloatMin: 0 max: 1 default: 0.04>
	^ sheepReproductionRate
]

{ #category : 'parameters' }
WSHModel >> sheepReproductionRate: aNumber [

	<parameterSetter>
	sheepReproductionRate := aNumber
]

{ #category : 'init' }
WSHModel >> sheepWolvesShepherds [
	"Version 2 of the paper, wolves, sheep and grass, with three shepherds who keep their flocks in pastures. Half the patches start without grass, as in NetLogo's model"

	<init>
	<perspective: #perspectiveEcology>
	self createPatches.
	self cells do: [ :each |
		self random < 0.5 ifTrue: [ each beEatenSomeTimeAgo ] ].
	self createPastures.
	self createSheep.
	self
		create: initialNumberOfWolves
		randomlyLocatedEntitiesOfClass: WSHWolf
]

{ #category : 'control' }
WSHModel >> stepSheepWolvesShepherds [
	"Shepherds move first, then all sheep, then all wolves, each in a random order, then the grass grows"

	<control>
	self @@ WSHShepherd do: [ :each | each step ].
	(self shuffled: self @@ WSHSheep) do: [ :each | each step ].
	(self shuffled: self @@ WSHWolf) do: [ :each | each step ].
	self cells do: [ :each | each step ]
]

{ #category : 'parameters' }
WSHModel >> wolfGainFromFood [
	"The energy a wolf gets from a sheep. Twice the value of Wolf Sheep Predation: sheep live only in the pastures, a third of the world, and wolves starve with less"

	<parameterIntegerMin: 0 max: 100 default: 40>
	^ wolfGainFromFood
]

{ #category : 'parameters' }
WSHModel >> wolfGainFromFood: anInteger [

	<parameterSetter>
	wolfGainFromFood := anInteger
]

{ #category : 'parameters' }
WSHModel >> wolfMoveCost [
	"The energy a wolf loses at each move"

	<parameterIntegerMin: 0 max: 10 default: 1>
	^ wolfMoveCost
]

{ #category : 'parameters' }
WSHModel >> wolfMoveCost: anInteger [

	<parameterSetter>
	wolfMoveCost := anInteger
]

{ #category : 'parameters' }
WSHModel >> wolfReproductionRate [
	"The probability that a wolf reproduces at each step"

	<parameterFloatMin: 0 max: 1 default: 0.05>
	^ wolfReproductionRate
]

{ #category : 'parameters' }
WSHModel >> wolfReproductionRate: aNumber [

	<parameterSetter>
	wolfReproductionRate := aNumber
]
