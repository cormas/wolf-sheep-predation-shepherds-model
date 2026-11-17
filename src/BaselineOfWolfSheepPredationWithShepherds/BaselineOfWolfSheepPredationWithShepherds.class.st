Class {
	#name : 'BaselineOfWolfSheepPredationWithShepherds',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfWolfSheepPredationWithShepherds',
	#package : 'BaselineOfWolfSheepPredationWithShepherds'
}

{ #category : 'baselines' }
BaselineOfWolfSheepPredationWithShepherds >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec
			package: 'WolfSheepPredationWithShepherds-Model';
			package: 'WolfSheepPredationWithShepherds-Tests' with: [ spec requires: #( 'WolfSheepPredationWithShepherds-Model' ) ] ]
]

{ #category : 'baselines' }
BaselineOfWolfSheepPredationWithShepherds >> isManagedByCormas [
	"Cormas wrote this baseline and keeps it up to date when packages of the model are added, renamed or removed. If you change the baseline yourself, Cormas asks whether you want to manage it yourself: this method then returns false, and Cormas never changes the baseline again"

	^ true
]
