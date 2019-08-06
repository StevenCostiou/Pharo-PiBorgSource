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

{ #category : #navigation }
BiMotors >> accelerate [
	| tmp1 tmp2 tmp3 |
	tmp2 := power.
	tmp1 := 1.
	tmp3 := 1.
	[ tmp3 > 0 ]
		whileTrue: [ self power: tmp2 - tmp3.
			self direction = #fwd
				ifTrue: [ self motorLeft moveForward.
					self motorRight moveForward ]
				ifFalse: [ self motorLeft moveBackward.
					self motorRight moveBackward ].
			tmp1 seconds wait.
			tmp3 := tmp3 - 1 ]
]

{ #category : #private }
BiMotors >> calculTimeToMakeDistance: arg1 withBorgSpeed: arg2 [
	| tmp1 tmp2 tmp3 |
	tmp2 := 0.065.
	tmp1 := 0.0001 * arg2 * arg2 * arg2 - (0.014 * arg2 * arg2)
		+ (1.3324 * arg2) - 13.048.
	tmp3 := 3.6 * Float pi * tmp1 * tmp2 / 60 * 1000 / 3600 * 100.
	^ arg1 / tmp3
]

{ #category : #navigation }
BiMotors >> decelerate [
	| tmp1 tmp2 tmp3 |
	tmp2 := power.
	tmp1 := 1.
	tmp3 := 3.
	[ tmp3 < 4 ]
		whileTrue: [ self power: tmp2 - tmp3.
			self direction = #fwd
				ifTrue: [ self motorLeft moveForward.
					self motorRight moveForward ]
				ifFalse: [ self motorLeft moveBackward.
					self motorRight moveBackward ].
			tmp1 seconds wait.
			tmp3 := tmp3 + 1 ].
	self motorLeft stop.
	self motorRight stop
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

{ #category : #navigation }
BiMotors >> moveDistance: arg1 [
	| tmp1 |
	arg1 > 0
		ifTrue: [ tmp1 := self calculTimeToMakeDistance: arg1 withBorgSpeed: power ]
		ifFalse: [ tmp1 := self
				calculTimeToMakeDistance: arg1 * -1
				withBorgSpeed: power ].
	power > 20
		ifFalse: [ self power: 20 ].
	arg1 > 0
		ifTrue: [ self motorLeft moveForward.
			self motorRight moveForward ]
		ifFalse: [ self motorLeft moveBackward.
			self motorRight moveBackward ].
	('t = ' , tmp1 asString) logCr.
	tmp1 seconds wait.
	self motorLeft stop.
	self motorRight stop
]

{ #category : #navigation }
BiMotors >> moveDistance: arg1 withBorgSpeed: arg2 [
	| tmp1 |
	arg1 > 0
		ifTrue: [ tmp1 := self calculTimeToMakeDistance: arg1 withBorgSpeed: arg2 ]
		ifFalse: [ tmp1 := self calculTimeToMakeDistance: arg1 * -1 withBorgSpeed: arg2 ].
	arg2 > 20
		ifTrue: [ self power: arg2 ]
		ifFalse: [ self power: 20 ].
	arg1 > 0
		ifTrue: [ self motorLeft moveForward.
			self motorRight moveForward ]
		ifFalse: [ self motorLeft moveBackward.
			self motorRight moveBackward ].
	('t = ' , tmp1 asString) logCr.
	tmp1 seconds wait.
	self motorLeft stop.
	self motorRight stop
]

{ #category : #moves }
BiMotors >> moveForward [
	motorLeft power: power.
	motorRight power: power
]

{ #category : #accessing }
BiMotors >> power: aFloat [
	power := aFloat
]

{ #category : #navigation }
BiMotors >> standStillTurn [
	self motorLeft turnLeftStandStill.
	self motorRight turnLeftStandStill
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
