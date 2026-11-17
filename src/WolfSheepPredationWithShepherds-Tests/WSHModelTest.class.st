"
I test the rules of Wolf Sheep Predation with Shepherds on a world of 7 by 7 patches, with one pasture of 3 by 3 patches and its shepherd.
"
Class {
	#name : 'WSHModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'model',
		'pasture',
		'shepherd',
		'wildPatch'
	],
	#category : 'WolfSheepPredationWithShepherds-Tests',
	#package : 'WolfSheepPredationWithShepherds-Tests'
}

{ #category : 'helpers' }
WSHModelTest >> newSheepWithEnergy: aNumber on: aPatch [
	"A sheep of the shepherd's flock"

	| sheep |
	sheep := (model newEntity: WSHSheep)
		         energy: aNumber;
		         moveTo: aPatch;
		         yourself.
	shepherd adopt: sheep.
	^ sheep
]

{ #category : 'helpers' }
WSHModelTest >> newWolfWithEnergy: aNumber on: aPatch [

	^ (model newEntity: WSHWolf)
		  energy: aNumber;
		  moveTo: aPatch;
		  yourself
]

{ #category : 'running' }
WSHModelTest >> setUp [
	"A world of 7 by 7 patches with grass, a pasture of 3 by 3 patches in its corner, kept by a shepherd who stands in the pasture's middle, and a patch of wild land 3 patches away from them"

	super setUp.
	model := WSHModel new.
	model
		createGridNumberOfRows: 7
		numberOfColumns: 7
		neighbourhood: 8
		closed: false.
	model cells do: [ :each | each growGrass ].
	model sheepReproductionRate: 0.
	model wolfReproductionRate: 0.
	pasture := model
		           createAggregate: WSHPasture
		           from: ((1 to: 3) flatCollect: [ :row |
				            (1 to: 3) collect: [ :column |
					            model cellAt: row at: column ] ]).
	shepherd := model createShepherdFor: pasture.
	shepherd moveTo: (model cellAt: 2 at: 2).
	wildPatch := model cellAt: 5 at: 5
]

{ #category : 'tests' }
WSHModelTest >> testALambIsBornInsideItsMothersPasture [

	| sheep |
	model sheepReproductionRate: 1.
	sheep := self newSheepWithEnergy: 1000 on: (model cellAt: 1 at: 1).
	10 timesRepeat: [ sheep reproduce ].
	self assert: (model @@ WSHSheep) size equals: 11.
	model @@ WSHSheep do: [ :each |
		self assert: each cell pasture equals: pasture ]
]

{ #category : 'tests' }
WSHModelTest >> testALambJoinsItsMothersFlock [

	| sheep lamb |
	model sheepReproductionRate: 1.
	sheep := self newSheepWithEnergy: 8 on: shepherd cell.
	sheep reproduce.
	lamb := model @@ WSHSheep detect: [ :each | each ~~ sheep ].
	self assert: lamb shepherd equals: shepherd.
	self
		assert: (shepherd flock links collect: [ :each | each to ] as: Set)
		equals: {
				sheep.
				lamb } asSet
]

{ #category : 'tests' }
WSHModelTest >> testAPatchIsGuardedWithinTheGuardingDistanceOfAShepherd [

	self assert: (model cellAt: 3 at: 3) isGuarded.
	self deny: (model cellAt: 4 at: 4) isGuarded.
	model guardingDistance: 2.
	self assert: (model cellAt: 4 at: 4) isGuarded.
	self deny: wildPatch isGuarded
]

{ #category : 'tests' }
WSHModelTest >> testASheepNeverLeavesItsPasture [

	| sheep |
	sheep := self newSheepWithEnergy: 100 on: (model cellAt: 1 at: 1).
	20 timesRepeat: [
			sheep step.
			self assert: sheep cell pasture equals: pasture ]
]

{ #category : 'tests' }
WSHModelTest >> testASheepOnGreenGrassEatsIt [

	| sheep |
	sheep := self newSheepWithEnergy: 3 on: shepherd cell.
	sheep eatGrass.
	self deny: shepherd cell hasGrass.
	self assert: sheep energy equals: 3 + model sheepGainFromFood
]

{ #category : 'tests' }
WSHModelTest >> testASheepThatDiesLeavesItsFlock [

	| sheep |
	sheep := self newSheepWithEnergy: 1 on: shepherd cell.
	self assert: shepherd flock links size equals: 1.
	sheep die.
	self assert: shepherd flock links isEmpty
]

{ #category : 'tests' }
WSHModelTest >> testASheepWithNoEnergyLeftDies [

	| sheep |
	model cells do: [ :each | each beEaten ].
	sheep := self newSheepWithEnergy: 0 on: shepherd cell.
	sheep step.
	self assert: sheep isDead
]

{ #category : 'tests' }
WSHModelTest >> testAShepherdNeverLeavesTheirPasture [

	shepherd moveTo: (model cellAt: 1 at: 1).
	20 timesRepeat: [
			shepherd step.
			self assert: shepherd cell pasture equals: pasture ]
]

{ #category : 'tests' }
WSHModelTest >> testAWolfEatsASheepOnItsPatchAndGainsEnergy [

	| wolf sheep |
	wolf := self newWolfWithEnergy: 5 on: wildPatch.
	sheep := self newSheepWithEnergy: 1 on: wildPatch.
	wolf eatSheep.
	self assert: sheep isDead.
	self assert: wolf energy equals: 5 + model wolfGainFromFood
]

{ #category : 'tests' }
WSHModelTest >> testAWolfOnAGuardedPatchDoesNotEat [

	| wolf sheep patch |
	patch := model cellAt: 3 at: 3.
	wolf := self newWolfWithEnergy: 5 on: patch.
	sheep := self newSheepWithEnergy: 1 on: patch.
	wolf eatSheep.
	self deny: sheep isDead.
	self assert: wolf energy equals: 5
]

{ #category : 'tests' }
WSHModelTest >> testAWolfWhoseEnergyReachesZeroDies [

	| wolf |
	wolf := self newWolfWithEnergy: model wolfMoveCost on: wildPatch.
	wolf step.
	self assert: wolf isDead
]

{ #category : 'tests' }
WSHModelTest >> testAnAnimalThatReproducesSharesItsEnergyWithItsOffspring [

	| wolf offspring |
	model wolfReproductionRate: 1.
	wolf := self newWolfWithEnergy: 8 on: wildPatch.
	wolf reproduce.
	offspring := model @@ WSHWolf detect: [ :each | each ~~ wolf ].
	self assert: wolf energy equals: 4.
	self assert: offspring energy equals: 4.
	self assert: (wildPatch neighbourhood includes: offspring cell)
]

{ #category : 'tests' }
WSHModelTest >> testAnEatenPatchGrowsGrassAgainAfterTheRegrowthTime [

	model grassRegrowthTime: 3.
	wildPatch beEaten.
	2 timesRepeat: [ wildPatch step ].
	self deny: wildPatch hasGrass.
	wildPatch step.
	self assert: wildPatch hasGrass
]

{ #category : 'tests' }
WSHModelTest >> testEachPerspectiveCanBeBuilt [
	"Cormas checks that each aspect a perspective names exists, so a misspelt aspect fails here"

	#( #perspectiveEcology #perspectiveFlocks #perspectiveGuarding ) do: [
		:each |
		self shouldnt: [ model perspectiveNamed: each ] raise: Error ]
]

{ #category : 'tests' }
WSHModelTest >> testGuardingReachesAcrossTheEdgeOfTheWorld [

	shepherd moveTo: (model cellAt: 1 at: 1).
	self assert: (model cellAt: 7 at: 7) isGuarded.
	self deny: (model cellAt: 6 at: 6) isGuarded
]

{ #category : 'tests' }
WSHModelTest >> testWithoutGuardingAWolfNextToAShepherdEats [

	| wolf sheep patch |
	model guardingDistance: 0.
	patch := model cellAt: 3 at: 3.
	wolf := self newWolfWithEnergy: 5 on: patch.
	sheep := self newSheepWithEnergy: 1 on: patch.
	wolf eatSheep.
	self assert: sheep isDead
]
