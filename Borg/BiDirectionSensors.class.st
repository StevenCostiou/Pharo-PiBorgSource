Class {
	#name : #BiDirectionSensors,
	#superclass : #Object,
	#instVars : [
		'frontSensor',
		'backSensor'
	],
	#category : #Borg
}

{ #category : #initialization }
BiDirectionSensors class >> initializeFrontDirectionSensor: arg1 backDirectionSensor: arg2 [
	| tmp1 |
	tmp1 := self new.
	tmp1
		frontSensor: arg1;
		backSensor: arg2.
	^ tmp1
]

{ #category : #accessing }
BiDirectionSensors >> backSensor [
	^ backSensor
]

{ #category : #accessing }
BiDirectionSensors >> backSensor: arg1 [
	backSensor := arg1
]

{ #category : #accessing }
BiDirectionSensors >> frontSensor [
	^ frontSensor
]

{ #category : #accessing }
BiDirectionSensors >> frontSensor: arg1 [
	frontSensor := arg1
]
