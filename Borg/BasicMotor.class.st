Class {
	#name : #BasicMotor,
	#superclass : #Object,
	#instVars : [
		'power',
		'position'
	],
	#category : #Borg
}

{ #category : #accessing }
BasicMotor >> angle [
	^ 0.3
]

{ #category : #initalize }
BasicMotor >> initialize [
	super initialize.
	power := 0
]

{ #category : #private }
BasicMotor >> move: arg1 [
	self subclassResponsibility
]

{ #category : #'public api' }
BasicMotor >> moveBackward [
	self move: -1 * (power / 100)
]

{ #category : #'public api' }
BasicMotor >> moveForward [
	self move: power / 100
]

{ #category : #accessing }
BasicMotor >> position [
	^ position
]

{ #category : #accessing }
BasicMotor >> position: arg1 [
	position := arg1
]

{ #category : #accessing }
BasicMotor >> power [
	^ power
]

{ #category : #accessing }
BasicMotor >> power: arg1 [
	power := arg1
]

{ #category : #'public api' }
BasicMotor >> stop [
	self move: 0
]

{ #category : #'public api' }
BasicMotor >> turnLeft [
	position = #left
		ifTrue: [ self move: power * self angle / 100 ].
	position = #right
		ifTrue: [ self move: power / 100 ]
]

{ #category : #'public api' }
BasicMotor >> turnLeftStandStill [
	position = #left
		ifTrue: [ self move: power * 0.3 / 100 ].
	position = #right
		ifTrue: [ self move: power / 100 ]
]

{ #category : #'public api' }
BasicMotor >> turnRight [
	position = #left
		ifTrue: [ self move: power / 100 ].
	position = #right
		ifTrue: [ self move: power * self angle / 100 ]
]

{ #category : #'public api' }
BasicMotor >> turnRightStandStill [
	position = #left
		ifTrue: [ self move: power / 100 ].
	position = #right
		ifTrue: [ self move: power * 0.3 / 100 ]
]
