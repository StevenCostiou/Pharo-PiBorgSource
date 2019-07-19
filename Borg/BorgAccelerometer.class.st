Class {
	#name : #BorgAccelerometer,
	#superclass : #AnalogSensor,
	#instVars : [
		'addrX',
		'addrY',
		'addrZ'
	],
	#category : #Borg
}

{ #category : #'as yet unclassified' }
BorgAccelerometer class >> addrX: arg1 addrY: arg2 addrZ: arg3 [
	| tmp2 |
	tmp2 := self new.
	tmp2
		addrX: arg1;
		addrY: arg2;
		addrZ: arg3.
	^ tmp2 yourself
]

{ #category : #accessing }
BorgAccelerometer >> addrX [
	^ addrX
]

{ #category : #accessing }
BorgAccelerometer >> addrX: arg1 [
	addrX := arg1
]

{ #category : #accessing }
BorgAccelerometer >> addrY [
	^ addrY
]

{ #category : #accessing }
BorgAccelerometer >> addrY: arg1 [
	addrY := arg1
]

{ #category : #accessing }
BorgAccelerometer >> addrZ [
	^ addrZ
]

{ #category : #accessing }
BorgAccelerometer >> addrZ: arg1 [
	addrZ := arg1
]

{ #category : #accessing }
BorgAccelerometer >> read [
	^ Array
		with: (self analogRead: addrX)
		with: (self analogRead: addrY)
		with: (self analogRead: addrZ)
]
