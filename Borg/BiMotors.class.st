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
		motorLeft: PotPicoBorgMotors newMotorLeft;
		motorRight: PotPicoBorgMotors newMotorRight.
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

{ #category : #moves }
BiMotors >> moveBackward [
	motorLeft power: -1 * power.
	motorRight power: -1 * power
]

{ #category : #moves }
BiMotors >> moveForward [
	motorLeft power: power.
	motorRight power: power
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
	self motorRight power: power.
	self motorLeft power: -1 * power
]

{ #category : #moves }
BiMotors >> turnRight [
	self motorRight power: -1 * power.
	self motorLeft power: power
]
