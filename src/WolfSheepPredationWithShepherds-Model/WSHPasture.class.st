"
I am a pasture: a square of patches where a shepherd keeps a flock. I am a Cormas aggregate of patches.

## Responsibility:

- Hold my patches, so that sheep and shepherds can stay within them.

## Collaborators:

- `WSHPatch`: my components.
- `WSHShepherd`: keeps a flock in me.

## Public API and Key Messages

- `components`.

```
model createAggregate: WSHPasture from: somePatches
```
"
Class {
	#name : 'WSHPasture',
	#superclass : 'CMSpatialEntityAggregate',
	#category : 'WolfSheepPredationWithShepherds-Model',
	#package : 'WolfSheepPredationWithShepherds-Model'
}

{ #category : 'aspects' }
WSHPasture >> aspectFlock: look [
	"A translucent tint in the color of my shepherd, so that my patches show through"

	<aspect>
	look colorGroupedBy: self shepherd id.
	look color: (look color alpha: 0.35)
]

{ #category : 'accessing' }
WSHPasture >> shepherd [

	^ self cormasModel @@ WSHShepherd detect: [ :each |
		  each pasture == self ]
]
