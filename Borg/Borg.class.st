Class {
	#name : #Borg,
	#superclass : #Object,
	#instVars : [
		'biMotors',
		'camera',
		'size',
		'sensors',
		'navigation',
		'runningAlgorithm',
		'lastSensorReadings'
	],
	#category : #'Borg-Model'
}

{ #category : #'instance creation' }
Borg class >> initializeBorgWithBiMotors: motors [
	| borg |
	borg := self new.
	
	"US Sensors"
	borg addSensor: (PotHCSR04Device signalPin: 22) named: #leftUSSensor.
	borg addSensor: (PotHCSR04Device signalPin: 23) named: #frontUSSensor.
	borg addSensor: (PotHCSR04Device signalPin: 24) named: #rightUSSensor.
	
	"Accelerometer"
	borg addSensor: (PotADXL345Device new) named: #accelerometer.

	"Motors"
	borg biMotors: motors.
	^ borg
]

{ #category : #sensors }
Borg >> addSensor: aSensor named: aSymbol [
	self sensors at: aSymbol put: aSensor
]

{ #category : #mode }
Borg >> beginAutoNavigation [
	self fullStop.
	runningAlgorithm := true.
	[ [ runningAlgorithm ]
		whileTrue: [ navigation
				controlCourseFor: self
				fromSensorReadings: self readAllSensors.
			350 milliSeconds wait ] ] fork
]

{ #category : #accessing }
Borg >> biMotors [
	^ biMotors
]

{ #category : #accessing }
Borg >> biMotors: arg1 [
	biMotors := arg1
]

{ #category : #mode }
Borg >> bypassObstacleWithDistance: arg1 [
	| tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 |
	self flag: 'Broken'.
	self flag: 'Find original temp var names and refactor'.
	self biMotors power: 50.
	tmp1 := 60.
	tmp2 := OrderedCollection new.
	self biMotors turnRightStandStillAngle: tmp1 / 2.
	tmp3 := 1.
	[ tmp3 < 3 ]
		whileTrue: [ tmp2 add: self getDistance.
			tmp3 := tmp3 + 1.
			self biMotors turnLeftStandStillAngle: tmp1 / 2 ].
	tmp2 add: self getDistance.
	tmp4 := (BorgNavigation getIndexOfMaxValueOfCollection: tmp2) - 1.
	tmp5 := (2 - tmp4) * (tmp1 / 2).
	tmp5 = 0
		ifFalse: [ self biMotors turnRightStandStillAngle: tmp5 ].
	self biMotors moveDistance: arg1.
	tmp6 := tmp1 / 2 - tmp5.
	tmp6 > 0
		ifTrue: [ self biMotors turnRightStandStillAngle: tmp6 ]
		ifFalse: [ self biMotors turnLeftStandStillAngle: -1 * tmp6 ].
	self biMotors moveDistance: self size
]

{ #category : #'API - commands' }
Borg >> execute: commandSymbol withArguments: commandArgument [
	^ (BorgCommandWithArgument
		command: commandSymbol
		argument: commandArgument) execute
]

{ #category : #'API - commands' }
Borg >> executeMotorCommand: arg1 [
	self deprecated: 'Behavior replaced by commands'.
	arg1 = #stop
		ifTrue: [ biMotors stop ].
	arg1 = #left
		ifTrue: [ biMotors turnLeft ].
	arg1 = #right
		ifTrue: [ biMotors turnRight ].
	arg1 = #fwd
		ifTrue: [ biMotors moveForward ].
	arg1 = #bwd
		ifTrue: [ biMotors moveBackward ].
	arg1 = #standStillTurn
		ifTrue: [ biMotors standStillTurn ].
	^ 'OK'
]

{ #category : #'API - commands' }
Borg >> executeMotorCommand: arg1 withArgument: arg2 [
	self deprecated: 'Behavior replaced by commands'.
	arg1 = #stop
		ifTrue: [ biMotors stop ].
	arg1 = #left
		ifTrue: [ [ arg2 = 0 ]
				ifTrue: [ biMotors turnLeft ]
				ifFalse: [ biMotors turnLeftAngle: arg2 ] ].
	arg1 = #right
		ifTrue: [ [ arg2 = 0 ]
				ifTrue: [ biMotors turnRight ]
				ifFalse: [ biMotors turnRightAngle: arg2 ] ].
	arg1 = #fwd
		ifTrue: [ arg2 = 0
				ifTrue: [ biMotors moveForward ]
				ifFalse: [ biMotors moveDistance: arg2 ] ].
	arg1 = #bwd
		ifTrue: [ biMotors moveBackward ].
	arg1 = #standStillRight
		ifTrue: [ arg2 = 0
				ifTrue: [ biMotors standStillTurn ]
				ifFalse: [ biMotors turnRightStandStillAngle: arg2 ] ].
	arg1 = #standStillLeft
		ifTrue: [ arg2 = 0
				ifTrue: [ biMotors standStillTurn ]
				ifFalse: [ biMotors turnLeftStandStillAngle: arg2 ] ].
	^ 'OK'
]

{ #category : #'API - motors' }
Borg >> fullStop [
	biMotors fullStop.
	runningAlgorithm := false
]

{ #category : #initialize }
Borg >> initialize [
	super initialize.
	navigation := BorgNavigation new.
	size := 20.
	runningAlgorithm := false
]

{ #category : #'API - motors' }
Borg >> moveBackward [
	biMotors moveBackward
]

{ #category : #'API - motors' }
Borg >> moveForward [
	biMotors moveForward
]

{ #category : #camera }
Borg >> orienteToBlackRectangle: arg1 [
	| tmp1 tmp2 |
	self flag: 'Broken'.
	self flag: 'Find original temp var names and refactor'.
	self biMotors power: 80.
	self camera takeAPicture.
	tmp2 := BorgNavigation
		calculDestinationPointOfWithPython: self camera imagePath , '/' , self camera imageName.
	tmp2 = (0 @ 0)
		ifTrue: [ biMotors turnRightStandStillAngle: 30.
			self orienteToBlackRectangle: arg1 ]
		ifFalse: [ tmp1 := BorgNavigation
				calculAngleFromPictureSize: self camera imageSize
				toDestinationPoint: tmp2.
			tmp1 > 0
				ifTrue: [ self biMotors turnLeftAngle: tmp1 withBorgSpeed: arg1 ]
				ifFalse: [ self biMotors turnRightAngle: tmp1 * -1 withBorgSpeed: arg1 ] ]
]

{ #category : #'API - motors' }
Borg >> power: aFloat [
	biMotors power: aFloat
]

{ #category : #'API - sensors' }
Borg >> readAcceleration [
	^ (self sensors at: #accelerometer) readCoordinates
]

{ #category : #'API - sensors' }
Borg >> readAllSensors [
	lastSensorReadings := Dictionary new.
	lastSensorReadings at: #distanceArray put: self readDistance.
	lastSensorReadings at: #accelerationVector put: self readAcceleration.
	^ lastSensorReadings
]

{ #category : #'API - sensors' }
Borg >> readDistance [
	"Returns an array containing readings from the front left, front and front right sensors.
	These values are distances in cm"

	^ Array
		with: (self sensors at: #leftUSSensor) readDistance
		with: (self sensors at: #frontUSSensor) readDistance
		with: (self sensors at: #rightUSSensor) readDistance
]

{ #category : #'API - sensors' }
Borg >> readYaw [
	^ navigation computeYawFromAcceleration: self readAcceleration
]

{ #category : #sensors }
Borg >> registerSensor: aSensor [
	self sensors at: aSensor name put: aSensor
]

{ #category : #sensors }
Borg >> sensors [
	^ sensors ifNil: [ sensors := Dictionary new ]
]

{ #category : #accessing }
Borg >> size [
	self flag: 'size of the robot to avoid obstacles. Ugly...'.
	^ size
]

{ #category : #'API - motors' }
Borg >> turnLeft [
	biMotors turnLeft
]

{ #category : #'API - motors' }
Borg >> turnRight [
	biMotors turnRight
]
