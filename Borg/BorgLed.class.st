Class {
	#name : #BorgLed,
	#superclass : #DigitalSensor,
	#instVars : [
		'pin',
		'isOff'
	],
	#category : #Borg
}

{ #category : #initialization }
BorgLed class >> initializeALedWithPinId: arg1 number: arg2 [
	| tmp1 |
	tmp1 := self new.
	tmp1 pin: (tmp1 pinAtId: arg1 number: arg2 mode: #output).
	^ tmp1
]

{ #category : #initialization }
BorgLed >> initialize [
	isOff := false
]

{ #category : #accessing }
BorgLed >> isOff [
	^ isOff
]

{ #category : #accessing }
BorgLed >> pin [
	^ pin
]

{ #category : #accessing }
BorgLed >> pin: arg1 [
	pin := arg1
]

{ #category : #'as yet unclassified' }
BorgLed >> turnLightOff [
	self pin writeDigitalValue: 0.
	isOff := false
]

{ #category : #'as yet unclassified' }
BorgLed >> turnLightOn [
	self pin writeDigitalValue: 1.
	isOff := true
]
