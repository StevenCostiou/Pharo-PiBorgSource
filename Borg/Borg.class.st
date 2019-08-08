Class {
	#name : #Borg,
	#superclass : #Object,
	#instVars : [
		'biMotors',
		'camera',
		'sensors',
		'navigation',
		'runningAlgorithm',
		'lastSensorReadings',
		'lastMeasuredTime'
	],
	#category : #'Borg-Model'
}

{ #category : #'instance creation' }
Borg class >> instantiateSensorDevice: aSensorDevice [
	|device|
	device := RpiBoard3B current installDevice: aSensorDevice. 
	device initialize.
	device connect.
	^device
]

{ #category : #'instance creation' }
Borg class >> newBorgModelA [
	| borg |
	borg := self new.
	borg initializeMotors.
	
	"US Sensors"
	borg addSensor:  (self instantiateSensorDevice: (PotHCSR04Device triggerPin: 26 gpio echoPin: 22 gpio)) named: #leftUSSensor.
	borg addSensor:  (self instantiateSensorDevice: (PotHCSR04Device triggerPin: 19 gpio echoPin: 27 gpio)) named: #frontUSSensor.
	borg addSensor:  (self instantiateSensorDevice: (PotHCSR04Device triggerPin: 13 gpio echoPin: 17 gpio)) named: #rightUSSensor.
	"borg addSensor:  (self instantiateSensorDevice: PotMPU6050Device new) named: #gyroSensor."
	
	"Accelerometer"
	"borg addSensor: (RpiBoard3B current installDevice: PotADXL345Device new connect) named: #accelerometer."

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
		whileTrue: [ self power: 50.
			navigation controlCourseFromSensorReadings: self readAllSensors.
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

{ #category : #sensors }
Borg >> gyro [
	^ self sensors at: #gyroSensor
]

{ #category : #initialize }
Borg >> initAngleZProcess [
	| yaw |
	yaw := 0.
	lastMeasuredTime := Time now asMilliSeconds.
	[ [ true ]
		whileTrue: [ | currentTime elapsedTime |
			currentTime := Time now asMilliSeconds.
			elapsedTime := currentTime - lastMeasuredTime.
			lastMeasuredTime := currentTime.
			elapsedTime crLog.
			yaw := yaw
				+
					((elapsedTime / 1000) asFloat
						* (self sensors at: #gyroSensor) readGyroscopeSkaliert last).
			yaw crLog.
			0.5 seconds wait ] ] fork
]

{ #category : #initialize }
Borg >> initialize [
	super initialize.
	navigation := BorgNavigation on: self.
	runningAlgorithm := false
]

{ #category : #initialize }
Borg >> initializeMotors [
	biMotors := BiMotors defaultMotors
]

{ #category : #testing }
Borg >> isRunningAlgorithm [
	^runningAlgorithm 
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
Borg >> power [
	^biMotors power
]

{ #category : #'API - motors' }
Borg >> power: aFloat [
	biMotors power: (aFloat / 100) asFloat
]

{ #category : #'API - sensors' }
Borg >> readAcceleration [
	^ (self sensors at: #accelerometer) readCoordinates
]

{ #category : #'API - sensors' }
Borg >> readAllSensors [
	lastSensorReadings := Dictionary new.
	lastSensorReadings at: #distanceArray put: self readDistance.
	"lastSensorReadings at: #accelerationVector put: self readAcceleration."
	^ lastSensorReadings
]

{ #category : #'API - sensors' }
Borg >> readAngle [
	^ (self sensors at: #gyroSensor) readRotationXY
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
