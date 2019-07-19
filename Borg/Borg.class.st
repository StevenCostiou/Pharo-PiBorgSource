Class {
	#name : #Borg,
	#superclass : #Object,
	#instVars : [
		'biMotors',
		'ultrasonicSensor',
		'motionSensor',
		'camera',
		'led',
		'size',
		'accelerometer',
		'proximitySensor',
		'sensorReads'
	],
	#category : #Borg
}

{ #category : #'instance creation' }
Borg class >> initializeBorgWithBiMotors: arg1 [
	| tmp1 |
	tmp1 := self new.
	tmp1
		biMotors: arg1;
		ultrasonicSensor:
			(BorgUltrasonicSensor
				ultrasonicSensorEcho: #(22 3 #input)
				trigger: #(17 0 #output));
		motionSensor: (BorgMotionSensor analogPinLeft: 2 pinRight: 1);
		accelerometer: (BorgAccelerometer addrX: 7 addrY: 6 addrZ: 5);
		proximitySensor: (BorgProximitySensor analogPin: 0);
		camera: BorgCamera new.
	^ tmp1
]

{ #category : #'instance creation' }
Borg class >> ip: arg1 [
	| tmp1 |
	tmp1 := self new.
	tmp1
		ip: arg1;
		motors: (BorgXPIMotors address: tmp1 ip);
		ultrasonic: (BorgUltrasonicSensor address: tmp1 ip).
	^ tmp1
]

{ #category : #accessing }
Borg >> accelerometer [
	^ accelerometer
]

{ #category : #accessing }
Borg >> accelerometer: arg1 [
	accelerometer := arg1
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
Borg >> bypassObstacle [
	| tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 |
	self biMotors power: 50.
	tmp1 := 120.
	tmp2 := 15.
	tmp3 := OrderedCollection new.
	self biMotors turnRightStandStillAngle: tmp1 / 2.
	tmp4 := 1.
	[ tmp4 < 3 ]
		whileTrue: [ tmp3 add: self getDistance.
			tmp4 := tmp4 + 1.
			self biMotors turnLeftStandStillAngle: tmp1 / 2 ].
	tmp3 add: self getDistance.
	tmp5 := (Calculator getIndexOfMaxValueOfCollection: tmp3) - 1.
	tmp6 := (2 - tmp5) * (tmp1 / 2).
	tmp6 = 0
		ifFalse: [ self biMotors turnRightStandStillAngle: tmp6 ].
	self biMotors moveDistance: 25.
	tmp7 := tmp1 / 2 - tmp6.
	tmp7 > 0
		ifTrue: [ self biMotors turnRightStandStillAngle: tmp7 ]
		ifFalse: [ self biMotors turnLeftStandStillAngle: -1 * tmp7 ].
	self biMotors moveDistance: 20
]

{ #category : #mode }
Borg >> bypassObstacleWithDistance: arg1 [
	| tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 |
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
	tmp4 := (Calculator getIndexOfMaxValueOfCollection: tmp2) - 1.
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

{ #category : #accessing }
Borg >> camera [
	^ camera
]

{ #category : #accessing }
Borg >> camera: arg1 [
	camera := arg1
]

{ #category : #API }
Borg >> execute: arg1 withArguments: arg2 [
	arg1 = #distance
		ifTrue: [ ^ self getDistance printString ].
	arg1 = #power
		ifTrue: [ biMotors power: arg2.
			^ 'ok' ].
	^ self executeMotorCommand: arg1
]

{ #category : #API }
Borg >> executeMotorCommand: arg1 [
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

{ #category : #API }
Borg >> executeMotorCommand: arg1 withArgument: arg2 [
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
	biMotors fullStop
]

{ #category : #sensors }
Borg >> getDistance [
	^ ultrasonicSensor getWallDistance
]

{ #category : #initialize }
Borg >> initialize [
	super initialize.
	size := 20
]

{ #category : #accessing }
Borg >> led: arg1 [
	led := arg1
]

{ #category : #accessing }
Borg >> motionSensor [
	^ motionSensor
]

{ #category : #accessing }
Borg >> motionSensor: arg1 [
	motionSensor := arg1
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
	self biMotors power: 80.
	self camera takeAPicture.
	tmp2 := Calculator
		calculDestinationPointOfWithPython: self camera imagePath , '/' , self camera imageName.
	tmp2 = (0 @ 0)
		ifTrue: [ biMotors turnRightStandStillAngle: 30.
			self orienteToBlackRectangle: arg1 ]
		ifFalse: [ tmp1 := Calculator
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

{ #category : #accessing }
Borg >> proximitySensor [
	^ proximitySensor
]

{ #category : #accessing }
Borg >> proximitySensor: arg1 [
	proximitySensor := arg1
]

{ #category : #sensors }
Borg >> readAllSensors [
	sensorReads := Dictionary new.
	sensorReads
		at: 'distance' put: self getDistance;
		at: 'speeds' put: accelerometer read;
		at: 'motions' put: motionSensor read;
		at: 'proximity' put: proximitySensor read.
	^ sensorReads
]

{ #category : #'API - sensors' }
Borg >> readSensor: sensorId [
	self flag: 'TODO'
]

{ #category : #accessing }
Borg >> size [
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

{ #category : #accessing }
Borg >> ultrasonicSensor [
	^ ultrasonicSensor
]

{ #category : #accessing }
Borg >> ultrasonicSensor: arg1 [
	ultrasonicSensor := arg1
]
