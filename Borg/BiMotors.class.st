Class {
	#name : #BiMotors,
	#superclass : #Object,
	#instVars : [
		'power',
		'motorRight',
		'motorLeft',
		'lastCommand',
		'currentCommand',
		'direction'
	],
	#category : #'Borg-Motors'
}

{ #category : #initialization }
BiMotors class >> initializePythonMotors [
	| tmp1 |
	tmp1 := self basicNew.
	tmp1
		motorLeft: BorgPyMotors new;
		motorRight: BorgPyMotors new.
	^ tmp1 initialize
]

{ #category : #initialization }
BiMotors class >> initializeXPIMotors [
	| tmp1 |
	tmp1 := self basicNew.
	tmp1
		motorLeft: BorgXPIMotors new;
		motorRight: BorgXPIMotors new.
	^ tmp1 initialize
]

{ #category : #moves }
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

{ #category : #calculs }
BiMotors >> calculTimeToMakeDistance: arg1 withBorgSpeed: arg2 [
	| tmp1 tmp2 tmp3 |
	tmp2 := 0.065.
	tmp1 := 0.0001 * arg2 * arg2 * arg2 - (0.014 * arg2 * arg2)
		+ (1.3324 * arg2) - 13.048.
	tmp3 := 3.6 * Float pi * tmp1 * tmp2 / 60 * 1000 / 3600 * 100.
	^ arg1 / tmp3
]

{ #category : #accessing }
BiMotors >> currentCommand [
	^ currentCommand
]

{ #category : #accessing }
BiMotors >> currentCommand: arg1 [
	currentCommand := arg1
]

{ #category : #moves }
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

{ #category : #accessing }
BiMotors >> direction [
	^ direction
]

{ #category : #accessing }
BiMotors >> direction: arg1 [
	direction := arg1
]

{ #category : #moves }
BiMotors >> fullStop [
	motorLeft stop.
	motorRight stop
]

{ #category : #initialization }
BiMotors >> initialize [
	super initialize.
	lastCommand := #stop.
	currentCommand := #stop.
	direction := #fwd.
	power := 0
]

{ #category : #accessing }
BiMotors >> lastCommand [
	^ lastCommand
]

{ #category : #accessing }
BiMotors >> lastCommand: arg1 [
	lastCommand := arg1
]

{ #category : #accessing }
BiMotors >> motorLeft [
	^ motorLeft
]

{ #category : #accessing }
BiMotors >> motorLeft: arg1 [
	motorLeft := arg1.
	motorLeft position: #left
]

{ #category : #accessing }
BiMotors >> motorRight [
	^ motorRight
]

{ #category : #accessing }
BiMotors >> motorRight: arg1 [
	motorRight := arg1.
	motorRight position: #right
]

{ #category : #moves }
BiMotors >> moveBackward [
	self motorLeft moveBackward.
	self motorRight moveBackward
]

{ #category : #moves }
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

{ #category : #moves }
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
	self motorLeft moveForward.
	self motorRight moveForward
]

{ #category : #accessing }
BiMotors >> power [
	^ power
]

{ #category : #accessing }
BiMotors >> power: arg1 [
	power := arg1.
	motorLeft power: power.
	motorRight power: power
]

{ #category : #moves }
BiMotors >> standStillTurn [
	self motorLeft turnLeftStandStill.
	self motorRight turnLeftStandStill
]

{ #category : #moves }
BiMotors >> stop [
	self currentCommand = #stop
		ifFalse: [ motorRight stop.
			motorLeft stop ]
]

{ #category : #moves }
BiMotors >> turnLeft [
	self motorRight turnLeft.
	self motorLeft turnLeft
]

{ #category : #moves }
BiMotors >> turnLeftAngle: arg1 [
	| tmp1 tmp2 tmp3 tmp4 tmp5 |
	power > 20
		ifFalse: [ self power: 20 ].
	tmp4 := 6.5.
	tmp5 := 36.4.
	tmp2 := arg1 / 360 * Float pi * tmp5.
	tmp3 := tmp2 / (Float pi * tmp4).
	power > 20
		ifTrue: [ tmp1 := 943.15 * (power raisedTo: -1.535) * tmp3 ]
		ifFalse: [ tmp1 := 11.8 * tmp3 ].
	self motorRight moveForward.
	('t = ' , tmp1 asString) logCr.
	tmp1 seconds wait.
	self motorRight stop
]

{ #category : #moves }
BiMotors >> turnLeftAngle: arg1 withBorgSpeed: arg2 [
	| tmp1 tmp2 tmp3 tmp4 tmp5 |
	arg2 > 20
		ifTrue: [ self power: arg2 ]
		ifFalse: [ self power: 20 ].
	tmp4 := 6.5.
	tmp5 := 36.4.
	tmp2 := arg1 / 360 * Float pi * tmp5.
	tmp3 := tmp2 / (Float pi * tmp4).
	arg2 > 20
		ifTrue: [ tmp1 := 943.15 * (power raisedTo: -1.535) * tmp3 ]
		ifFalse: [ tmp1 := 11.8 * tmp3 ].
	self motorRight moveForward.
	('t = ' , tmp1 asString) logCr.
	tmp1 seconds wait.
	self motorRight stop
]

{ #category : #moves }
BiMotors >> turnLeftStandStillAngle: arg1 [
	| tmp1 tmp2 tmp3 tmp4 tmp5 |
	power > 20
		ifFalse: [ self power: 20 ].
	tmp4 := 6.5.
	tmp5 := 18.2.
	tmp2 := arg1 / 360 * Float pi * tmp5.
	tmp3 := tmp2 / (Float pi * tmp4).
	power > 20
		ifTrue: [ tmp1 := 2051.3 * (power raisedTo: -1.719) * tmp3 ]
		ifFalse: [ tmp1 := 16 * tmp3 ].
	('t = ' , tmp1 asString) logCr.
	self motorRight moveBackward.
	self motorLeft moveForward.
	tmp1 seconds wait.
	self motorRight stop.
	self motorLeft stop
]

{ #category : #moves }
BiMotors >> turnLeftStandStillAngle: arg1 withBorgSpeed: arg2 [
	| tmp1 tmp2 tmp3 tmp4 tmp5 |
	arg2 > 20
		ifTrue: [ self power: arg2 ]
		ifFalse: [ self power: 20 ].
	tmp4 := 6.5.
	tmp5 := 18.2.
	tmp2 := arg1 / 360 * Float pi * tmp5.
	tmp3 := tmp2 / (Float pi * tmp4).
	arg2 > 20
		ifTrue: [ tmp1 := 2051.3 * (arg2 raisedTo: -1.719) * tmp3 ]
		ifFalse: [ tmp1 := 16 * tmp3 ].
	('t = ' , tmp1 asString) logCr.
	self motorRight moveBackward.
	self motorLeft moveForward.
	tmp1 seconds wait.
	self motorRight stop.
	self motorLeft stop
]

{ #category : #moves }
BiMotors >> turnRight [
	self direction = #fwd
		ifTrue: [ self
				lastCommand: self currentCommand;
				currentCommand: #right.
			self motorRight turnRight.
			self motorLeft turnRight ].
	self direction = #bwd
		ifTrue: [ self
				lastCommand: self currentCommand;
				currentCommand: #left.
			self motorRight turnLeft.
			self motorLeft turnLeft ]
]

{ #category : #moves }
BiMotors >> turnRightAngle: arg1 [
	| tmp1 tmp2 tmp3 tmp4 tmp5 |
	power > 20
		ifFalse: [ self power: 20 ].
	tmp4 := 6.5.
	tmp5 := 36.4.
	tmp2 := arg1 / 360 * Float pi * tmp5.
	tmp3 := tmp2 / (Float pi * tmp4).
	power > 20
		ifTrue: [ tmp1 := 943.15 * (power raisedTo: -1.535) * tmp3 ]
		ifFalse: [ tmp1 := 11.8 * tmp3 ].
	self motorLeft moveForward.
	('t = ' , tmp1 asString) logCr.
	tmp1 seconds wait.
	self motorLeft stop
]

{ #category : #moves }
BiMotors >> turnRightAngle: arg1 withBorgSpeed: arg2 [
	| tmp1 tmp2 tmp3 tmp4 tmp5 |
	arg2 > 20
		ifTrue: [ self power: arg2 ]
		ifFalse: [ self power: 20 ].
	tmp4 := 6.5.
	tmp5 := 36.4.
	tmp2 := arg1 / 360 * Float pi * tmp5.
	tmp3 := tmp2 / (Float pi * tmp4).
	arg2 > 20
		ifTrue: [ tmp1 := 943.15 * (power raisedTo: -1.535) * tmp3 ]
		ifFalse: [ tmp1 := 11.8 * tmp3 ].
	self motorLeft moveForward.
	('t = ' , tmp1 asString) logCr.
	tmp1 seconds wait.
	self motorLeft stop
]

{ #category : #moves }
BiMotors >> turnRightStandStillAngle: arg1 [
	| tmp1 tmp2 tmp3 tmp4 tmp5 |
	('Speed = ' , power asString) logCr.
	power > 20
		ifFalse: [ self power: 20 ].
	tmp4 := 6.5.
	tmp5 := 18.2.
	tmp2 := arg1 / 360 * Float pi * tmp5.
	tmp3 := tmp2 / (Float pi * tmp4).
	power > 20
		ifTrue: [ tmp1 := 2051.3 * (power raisedTo: -1.719) * tmp3 ]
		ifFalse: [ tmp1 := 16 * tmp3 ].
	('t = ' , tmp1 asString) logCr.
	self motorRight moveForward.
	self motorLeft moveBackward.
	tmp1 seconds wait.
	self motorRight stop.
	self motorLeft stop
]

{ #category : #moves }
BiMotors >> turnRightStandStillAngle: arg1 withBorgSpeed: arg2 [
	| tmp1 tmp2 tmp3 tmp4 tmp5 |
	('Speed = ' , arg2 asString) logCr.
	arg2 > 20
		ifTrue: [ self power: arg2 ]
		ifFalse: [ self power: 20 ].
	tmp4 := 6.5.
	tmp5 := 18.2.
	tmp2 := arg1 / 360 * Float pi * tmp5.
	tmp3 := tmp2 / (Float pi * tmp4).
	arg2 > 20
		ifTrue: [ tmp1 := 2051.3 * (arg2 raisedTo: -1.719) * tmp3 ]
		ifFalse: [ tmp1 := 16 * tmp3 ].
	('t = ' , tmp1 asString) logCr.
	self motorRight moveForward.
	self motorLeft moveBackward.
	tmp1 seconds wait.
	self motorRight stop.
	self motorLeft stop
]
