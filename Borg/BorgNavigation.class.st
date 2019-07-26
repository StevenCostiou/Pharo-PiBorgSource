Class {
	#name : #BorgNavigation,
	#superclass : #Object,
	#instVars : [
		'lastRecordedTime',
		'turning',
		'maxTurningAngle',
		'currentTurningAngle',
		'direction'
	],
	#category : #'Borg-Model'
}

{ #category : #'image manipulation' }
BorgNavigation class >> calculAngleFromPictureSize: arg1 toDestinationPoint: arg2 [
	| tmp1 tmp2 tmp3 |
	tmp1 := arg1 x / 2 - arg2 x.
	tmp2 := arg1 y - arg2 y.
	tmp3 := (tmp1 / tmp2) arcTan.
	^ tmp3 * (180 / Float pi)
]

{ #category : #'image manipulation' }
BorgNavigation class >> calculDestinationPointOfWithPython: arg1 [
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

{ #category : #'image manipulation' }
BorgNavigation class >> calculDestinationPointWithColorForm: arg1 [
	| tmp1 tmp2 tmp3 tmp4 tmp5 |
	tmp1 := ColorForm fromFileNamed: arg1.
	tmp2 := tmp1 rectangleEnclosingPixelsNotOfColor: Color white.
	tmp3 := tmp2 corner - tmp2 origin.
	tmp4 := tmp3 / 2.
	tmp5 := (tmp4 x + tmp2 origin x) @ (tmp4 y + tmp2 origin y).
	^ tmp5
]

{ #category : #orderedCollection }
BorgNavigation class >> getIndexOfMaxValueOfCollection: arg1 [
	| tmp1 tmp2 |
	tmp1 := 0.
	tmp2 := 0.
	1 to: arg1 size do: [ :tmp3 | 
		tmp1 < (arg1 at: tmp3)
			ifTrue: [ tmp1 := arg1 at: tmp3.
				tmp2 := tmp3 ] ].
	^ tmp2
]

{ #category : #'navigation api' }
BorgNavigation >> computeTurningDirectionFromDistanceArray: distanceArray [
	| leftFrontDistance rightFrontDistance |
	leftFrontDistance := distanceArray first.
	rightFrontDistance := distanceArray last.
	^ leftFrontDistance > rightFrontDistance
		ifTrue: [ #left ]
		ifFalse: [ #right ]
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
	distanceArray second < self maxFrontDistance
		ifFalse: [ borg execute: #power withArguments: self forwardSpeed.
			^ borg execute: #fwd withArguments: nil ].

	"Else we turn where there is the larger distance"
	borg execute: #power withArguments: self turningSpeed.
	^ borg
		execute: (self computeTurningDirectionFromDistanceArray: distanceArray)
		withArguments: nil
]

{ #category : #'navigation constants' }
BorgNavigation >> forwardSpeed [
	^50
]

{ #category : #initialize }
BorgNavigation >> initialize [
	lastRecordedTime := Time now
]

{ #category : #'navigation constants' }
BorgNavigation >> maxFrontDistance [
	^50
]

{ #category : #'navigation constants' }
BorgNavigation >> turningSpeed [
	^30
]
