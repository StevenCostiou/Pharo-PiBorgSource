Class {
	#name : #BorgMotionSensor,
	#superclass : #AnalogSensor,
	#instVars : [
		'addressLeft',
		'addressRight'
	],
	#category : #Borg
}

{ #category : #'as yet unclassified' }
BorgMotionSensor class >> analogPinLeft: arg1 pinRight: arg2 [
	| tmp1 |
	tmp1 := self basicNew.
	tmp1
		addressLeft: arg1;
		addressRight: arg2.
	^ tmp1 initialize
]

{ #category : #accessing }
BorgMotionSensor >> addressLeft [
	^ addressLeft
]

{ #category : #accessing }
BorgMotionSensor >> addressLeft: arg1 [
	addressLeft := arg1
]

{ #category : #accessing }
BorgMotionSensor >> addressRight [
	^ addressRight
]

{ #category : #accessing }
BorgMotionSensor >> addressRight: arg1 [
	addressRight := arg1
]

{ #category : #'read/write' }
BorgMotionSensor >> isMotionToLeft [
	self readLeft
]

{ #category : #'read/write' }
BorgMotionSensor >> isMotionToRight [
	self readLeft
]

{ #category : #'read/write' }
BorgMotionSensor >> read [
	^ Array
		with: (self analogRead: addressLeft)
		with: (self analogRead: addressRight)
]

{ #category : #'read/write' }
BorgMotionSensor >> readLeft [
	^ device read: addressLeft
]

{ #category : #'read/write' }
BorgMotionSensor >> readRight [
	^ device read: addressRight
]
