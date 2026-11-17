"
I am a flock: the network of the links from a shepherd to their sheep.

## Responsibility:

- Hold the links of my shepherd to their sheep. A link leaves me when its sheep dies.

## Collaborators:

- `WSHFlockLink`: my links.
- `WSHShepherd`: creates me and adds links to me.

## Public API and Key Messages

- `links`, `add:`.
"
Class {
	#name : 'WSHFlock',
	#superclass : 'CMNetwork',
	#category : 'WolfSheepPredationWithShepherds-Model',
	#package : 'WolfSheepPredationWithShepherds-Model'
}

{ #category : 'aspects' }
WSHFlock >> aspectSize: look [
	"Highlighted along my links in the color of my shepherd, thicker the more sheep I have"

	<aspect>
	look colorGroupedBy: self shepherd id.
	look
		color: (look color alpha: 0.35);
		thicknessForValue: self links size from: 0 to: 100
]

{ #category : 'accessing' }
WSHFlock >> shepherd [

	^ self cormasModel @@ WSHShepherd detect: [ :each |
		  each flock == self ]
]
