"
Dummy navigation for the Borg experiment.

Smarter navigation should be implemented.
"
Class {
	#name : #BorgNavigation,
	#superclass : #Object,
	#instVars : [
		'borg',
		'lastRecordedTime',
		'turning',
		'currentTurningAngle',
		'direction',
		'turningDirection',
		'forceNextTurningDirection',
		'totalTurningTime',
		'turningBackTimer',
		'turnBackDirection'
	],
	#category : #'Borg-Model'
}

{ #category : #'instance creation' }
BorgNavigation class >> on: aBorg [
	^ self new
		borg: aBorg;
		yourself
]

{ #category : #private }
BorgNavigation >> beginTurningBackTimer [
	turningBackTimer ifNil:[turningBackTimer := 0]
]

{ #category : #accessing }
BorgNavigation >> borg: anObject [
	borg := anObject
]

{ #category : #'image manipulation' }
BorgNavigation >> calculAngleFromPictureSize: arg1 toDestinationPoint: arg2 [
	| tmp1 tmp2 tmp3 |
	tmp1 := arg1 x / 2 - arg2 x.
	tmp2 := arg1 y - arg2 y.
	tmp3 := (tmp1 / tmp2) arcTan.
	^ tmp3 * (180 / Float pi)
]

{ #category : #'image manipulation' }
BorgNavigation >> calculDestinationPointOfWithPython: arg1 [
	| tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 |
	tmp1 := PyLibrary uniqueInstance.
	tmp1
		initLib: '/home/pi/pylibs' name: 'find_rectangle.py';
		pyCall: (Array with: arg1).
	tmp3 := tmp1 stdout.
	tmp2 := OrderedCollection new.
	tmp5 := 0 @ 0.
	tmp4 := tmp3 readStream.
	[ tmp4 atEnd ]
		whileFalse: [ tmp5 := (tmp4 upTo: $@) asNumber @ (tmp4 upTo: $!) asNumber.
			tmp2 add: tmp5 ].
	tmp2 size >= 4
		ifTrue: [ tmp6 := ((tmp2 at: 4) - (tmp2 at: 1)) x.
			tmp7 := ((tmp2 at: 2) - (tmp2 at: 1)) y.
			^ ((tmp2 at: 1) x + (tmp6 / 2)) @ ((tmp2 at: 1) y + (tmp7 / 2)) ].
	^ 0 @ 0
]

{ #category : #'navigation algorithms' }
BorgNavigation >> computeTimeToMakeDistance: distance withBorgSpeed: speed [
	"Code from Louise. We lost the source."
	| tmp1 tmp2 tmp3 |
	tmp2 := 0.065.
	tmp1 := 0.0001 * (speed raisedTo: 3) - (0.014 * speed squared)
		+ (1.3324 * speed) - 13.048.
	tmp3 := 3.6 * Float pi * tmp1 * tmp2 / 60 * 1000 / 3600 * 100.
	^ distance / tmp3
]

{ #category : #'navigation algorithms' }
BorgNavigation >> computeTurningParametersFromDistanceArray: distanceArray [
	| leftFrontDistance rightFrontDistance |
	leftFrontDistance := distanceArray first.
	rightFrontDistance := distanceArray last.
	turningDirection := leftFrontDistance > rightFrontDistance
		ifTrue: [ #left ]
		ifFalse: [ #right ].
	turnBackDirection := turningDirection = #right
		ifTrue: [ #left ]
		ifFalse: [ #right ]
]

{ #category : #'navigation api' }
BorgNavigation >> controlCourseFromSensorReadings: sensorReadings [
	| distanceArray |
	distanceArray := sensorReadings at: #distanceArray.

	"If nothing in front go forward"
	(distanceArray anySatisfy: [ :d | d < self maxFrontDistance ])
		ifFalse: [ borg moveForward.
			^ self ].
		
	"Else we avoid the obstacle until we are clear or until auto navigation stops"
	self simpleAvoidObstacleUsing: distanceArray
]

{ #category : #'navigation constants' }
BorgNavigation >> forwardSpeed [
	^50
]

{ #category : #initialize }
BorgNavigation >> initialize [
	lastRecordedTime := Time now.
	turning := false.
	turningDirection := nil.
	forceNextTurningDirection := nil.
	totalTurningTime := 0.
	turningBackTimer := nil
]

{ #category : #'navigation constants' }
BorgNavigation >> maxFrontDistance [
	^20
]

{ #category : #private }
BorgNavigation >> setNextTurningDirection [
	forceNextTurningDirection := turningDirection = #right
		ifTrue: [ #left ]
		ifFalse: [ #right ]
]

{ #category : #private }
BorgNavigation >> setTurningParametersFromDistanceArray: distanceArray [
	| leftFrontDistance rightFrontDistance |
	turning ifTrue: [ ^ self ].
	leftFrontDistance := distanceArray first.
	rightFrontDistance := distanceArray last.
	turningDirection := leftFrontDistance > rightFrontDistance
		ifTrue: [ #left ]
		ifFalse: [ #right ].
	self setNextTurningDirection.
	turning := true
]

{ #category : #private }
BorgNavigation >> shouldTurnBack [
	self beginTurningBackTimer.
	turningBackTimer := turningBackTimer + self updateTimeDuration.
	^ turningBackTimer >= 2 seconds
]

{ #category : #'navigation algorithms' }
BorgNavigation >> simpleAvoidObstacleUsing: distanceArray [
	| stopAngle timer timeToWait |
	self computeTurningParametersFromDistanceArray: distanceArray.
	
	stopAngle := "borg readAngle abs + "90.
	borg power: 40.
	
	self turn: stopAngle direction: turningDirection.
	
	borg isRunningAlgorithm
		ifFalse: [ ^ self ].
		
	timeToWait := self computeTimeToMakeDistance: 60 withBorgSpeed: 30.
	timer := 0.
	borg moveForward.
	
	[ borg isRunningAlgorithm and: [ timeToWait < timer ] ]
		whileFalse: [ 100 milliSeconds wait.
			timer := timer + 100 ].
		
	stopAngle := "borg readAngle abs -" 90.
	self turn: stopAngle direction: turnBackDirection
]

{ #category : #private }
BorgNavigation >> stopTurning [
	turning := false.
	turningBackTimer := nil.
	totalTurningTime := 0.
	turningDirection := nil.
	forceNextTurningDirection := nil
]

{ #category : #'navigation algorithms' }
BorgNavigation >> turn: angle direction: dir [
	| timer currentTime |
	timer := 0.
	currentTime := Time now asMilliSeconds.
	
	borg execute: dir withArguments: nil.
	[ borg isRunningAlgorithm and: [ timer < 2500 ] ]
		whileTrue: [ 
			|newTime|
			newTime := Time now asMilliSeconds.
			timer := timer + (newTime  - currentTime).
			currentTime := newTime.
			100 milliSeconds wait ].
		
	 "| gyro currentAngle targetAngle |
	gyro := borg gyro.
	gyro wakeUpSensor.
	gyro monitorRollPitchYaw.
	currentAngle := gyro yaw abs.
	targetAngle := currentAngle + angle.
	[ borg isRunningAlgorithm and: [ targetAngle < currentAngle ] ]
		whileTrue: [ borg execute: dir withArguments: nil.
			currentAngle := gyro yaw abs.
			100 milliSeconds wait ]."
]

{ #category : #'navigation constants' }
BorgNavigation >> turningSpeed [
	^30
]

{ #category : #'navigation constants' }
BorgNavigation >> updateTimeDuration [
	^ 350 milliSeconds
]

{ #category : #private }
BorgNavigation >> updateTurningTime [
	totalTurningTime := totalTurningTime + self updateTimeDuration
]
