Class {
	#name : #AnalogSensor,
	#superclass : #AbstractSensor,
	#instVars : [
		'address',
		'device'
	],
	#category : #Borg
}

{ #category : #'as yet unclassified' }
AnalogSensor class >> analogPin: arg1 [
	| tmp1 |
	tmp1 := self basicNew.
	tmp1 address: arg1.
	^ tmp1 initialize
]

{ #category : #accessing }
AnalogSensor >> address [
	^ address
]

{ #category : #accessing }
AnalogSensor >> address: arg1 [
	address := arg1
]

{ #category : #'read/write' }
AnalogSensor >> analogRead: arg1 [
	^ AnalogSensorRead new analogRead: arg1
]

{ #category : #'read/write' }
AnalogSensor >> read [
	self subclassResponsibility
]
