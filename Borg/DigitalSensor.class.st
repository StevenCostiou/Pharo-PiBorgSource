Class {
	#name : #DigitalSensor,
	#superclass : #AbstractSensor,
	#category : #'Borg-Sensors'
}

{ #category : #initialization }
DigitalSensor >> pinAtId: arg1 number: arg2 mode: arg3 [
	| tmp1 |
	tmp1 := PotGPIOPin id: arg1 number: arg2.
	tmp1 board: RpiBoardBRev2 current.
	arg3 = #input
		ifTrue: [ tmp1 beDigitalInput ].
	arg3 = #output
		ifTrue: [ tmp1 beDigitalOutput ].
	^ tmp1
]
