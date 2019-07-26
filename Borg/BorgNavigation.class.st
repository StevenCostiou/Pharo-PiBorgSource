"
Dummy navigation for the Borg experiment.

Smarter navigation should be implemented.
"
Class {
	#name : #BorgNavigation,
	#superclass : #Object,
	#instVars : [
		'lastRecordedTime',
		'turning',
		'currentTurningAngle',
		'direction',
		'turningDirection',
		'forceNextTurningDirection',
		'totalTurningTime',
		'turningBackTimer'
	],
	#category : #'Borg-Model'
}

{ #category : #private }
BorgNavigation >> beginTurningBackTimer [
	turningBackTimer ifNil:[turningBackTimer := 0]
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

{ #category : #yaw }
BorgNavigation >> computeYawFromAcceleration: accelerationVector [
	| accX accZ |
	accX := accelerationVector first.
	accZ := accelerationVector last.
	^ 180 * (accZ / (accX squared + accZ squared) sqrt / Float pi) arcTan
]

{ #category : #'navigation api' }
BorgNavigation >> controlCourseFor: borg fromSensorReadings: sensorReadings [
	| distanceArray |
	distanceArray := sensorReadings at: #distanceArray.

	"If nothing in front go forward"
	(distanceArray anySatisfy: [ :d | d < self maxFrontDistance ])
		ifFalse: [ turning
				ifTrue: [ self shouldTurnBack
						ifTrue: [ borg execute: forceNextTurningDirection withArguments: nil.
							totalTurningTime wait.
							self stopTurning ] ].
			borg execute: #power withArguments: self forwardSpeed.
			^ borg execute: #fwd withArguments: nil ].

	"Else we turn where there is the larger distance"
	borg execute: #power withArguments: self turningSpeed.
	self setTurningParametersFromDistanceArray: distanceArray.
	self updateTurningTime.
	^ borg execute: turningDirection withArguments: nil
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
	^50
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

{ #category : #private }
BorgNavigation >> stopTurning [
	turning := false.
	turningBackTimer := nil.
	totalTurningTime := 0.
	turningDirection := nil.
	forceNextTurningDirection := nil
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
