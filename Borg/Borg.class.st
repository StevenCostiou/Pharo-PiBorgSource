Class {
	#name : #Borg,
	#superclass : #Object,
	#instVars : [
		'biMotors',
		'camera',
		'sensors',
		'navigation',
		'runningAlgorithm',
		'lastSensorReadings'
	],
	#category : #'Borg-Model'
}

{ #category : #'instance creation' }
Borg class >> newBorgModelA [
	| borg |
	borg := self new.
	
	"US Sensors"
	borg addSensor: (PotHCSR04Device signalPin: 22) named: #leftUSSensor.
	borg addSensor: (PotHCSR04Device signalPin: 23) named: #frontUSSensor.
	borg addSensor: (PotHCSR04Device signalPin: 24) named: #rightUSSensor.
	
	"Accelerometer"
	borg addSensor: (RpiBoard3B current installDevice: PotADXL345Device new connect) named: #accelerometer.

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
			navigation updateTimeDuration wait ] ] fork
]

{ #category : #accessing }
Borg >> biMotors [
	^ biMotors
]

{ #category : #accessing }
Borg >> biMotors: arg1 [
	biMotors := arg1
]

{ #category : #'API - commands' }
Borg >> execute: commandSymbol withArguments: commandArgument [
	^ (BorgCommandWithArgument
		command: commandSymbol
		argument: commandArgument
		for: self) execute
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
	runningAlgorithm := false.
	biMotors := BiMotors defaultMotors
]

{ #category : #'API - motors' }
Borg >> moveBackward [
	biMotors moveBackward
]

{ #category : #'API - motors' }
Borg >> moveForward [
	biMotors moveForward
]

{ #category : #mode }
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

{ #category : #sensors }
Borg >> registerSensor: aSensor [
	self sensors at: aSensor name put: aSensor
]

{ #category : #sensors }
Borg >> sensors [
	^ sensors ifNil: [ sensors := Dictionary new ]
]

{ #category : #'API - motors' }
Borg >> turnLeft [
	biMotors turnLeft
]

{ #category : #'API - motors' }
Borg >> turnRight [
	biMotors turnRight
]
