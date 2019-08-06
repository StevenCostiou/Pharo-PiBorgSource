Class {
	#name : #BiMotors,
	#superclass : #Object,
	#instVars : [
		'power',
		'motorRight',
		'motorLeft'
	],
	#category : #'Borg-Motors'
}

{ #category : #initialization }
BiMotors class >> defaultMotors [
	^ self initializePicoBorgMotors
]

{ #category : #initialization }
BiMotors class >> initializePicoBorgMotors [
	| bimotors |
	bimotors := self basicNew.
	bimotors
		motorLeft: (PotPicoBorgMotors newMotorLeft connect; yourself);
		motorRight: (PotPicoBorgMotors newMotorRight connect; yourself).
	^ bimotors initialize
]

{ #category : #initialization }
BiMotors class >> initializePythonMotors [
	| bimotors |
	bimotors := self basicNew.
	bimotors
		motorLeft: BorgPyMotors new;
		motorRight: BorgPyMotors new.
	^ bimotors initialize
]

{ #category : #initialization }
BiMotors class >> initializeXPIMotors [
	| bimotors |
	bimotors := self basicNew.
	bimotors
		motorLeft: BorgXPIMotors new;
		motorRight: BorgXPIMotors new.
	^ bimotors initialize
]

{ #category : #moves }
BiMotors >> fullStop [
	motorLeft stop.
	motorRight stop
]

{ #category : #initialization }
BiMotors >> initialize [
	super initialize.
	power := 0
]

{ #category : #accessing }
BiMotors >> motorLeft: anObject [
	motorLeft := anObject
]

{ #category : #accessing }
BiMotors >> motorRight: anObject [
	motorRight := anObject
]

{ #category : #moves }
BiMotors >> moveBackward [
	motorLeft power: power.
	motorRight power:-1* power
]

{ #category : #moves }
BiMotors >> moveForward [
	motorLeft power: -1 * power.
	motorRight power:  power
]

{ #category : #accessing }
BiMotors >> power [
	^ power
]

{ #category : #accessing }
BiMotors >> power: aFloat [
	power := aFloat
]

{ #category : #moves }
BiMotors >> turnLeft [
	motorRight power: power.
	motorLeft power: power
]

{ #category : #moves }
BiMotors >> turnRight [
	motorRight power: -1 * power.
	motorLeft power: -1 * power
]
