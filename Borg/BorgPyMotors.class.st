Class {
	#name : #BorgPyMotors,
	#superclass : #BasicMotor,
	#classVars : [
		'lib'
	],
	#category : #Borg
}

{ #category : #initialization }
BorgPyMotors >> initialize [
	super initialize.
	lib := PyLibrary new.
	lib initLib: '/home/pi/pylibs' name: 'motor.py'
]

{ #category : #private }
BorgPyMotors >> move: arg1 [
	position = #left
		ifTrue: [ lib pyCall: (Array with: arg1 asFloat negated asString with: '2') ].
	position = #right
		ifTrue: [ lib pyCall: (Array with: arg1 asFloat asString with: '1') ]
]
