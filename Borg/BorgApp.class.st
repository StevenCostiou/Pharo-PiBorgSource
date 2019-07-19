Class {
	#name : #BorgApp,
	#superclass : #Object,
	#instVars : [
		'borg',
		'commandServer',
		'start1'
	],
	#category : #Borg
}

{ #category : #'as yet unclassified' }
BorgApp >> scenario1 [
	| power distance |
	power := 30.
	start1 := true.
	borg
		execute: #power withArguments: power;
		executeMotorCommand: #fwd withArgument: 0.
	[ [ start1 ]
		whileTrue: [ distance := borg getDistance.
			distance < power
				ifTrue: [ borg
						executeMotorCommand: #stop withArgument: 0;
						bypassObstacle;
						executeMotorCommand: #fwd withArgument: 0 ] ] ] fork
]

{ #category : #'as yet unclassified' }
BorgApp >> scenario2 [
	| tmp1 tmp2 |
	tmp2 := 40.
	borg
		execute: #power withArguments: tmp2;
		orienteToBlackRectangle: tmp2;
		executeMotorCommand: #fwd withArgument: 0.
	tmp1 := borg getDistance.
	[ tmp1 > tmp2 ] whileTrue: [ tmp1 := borg getDistance ].
	borg
		executeMotorCommand: #stop withArgument: 0;
		bypassObstacleWithDistance: tmp2
]

{ #category : #initialization }
BorgApp >> startBorg [
	| tmp2 |
	borg := Borg
		initializeBorgWithBiMotors: BiMotors initializePythonMotors.
	tmp2 := BorgServer new.
	tmp2 model: borg.
	commandServer := tmp2 startBorg
]

{ #category : #initialization }
BorgApp >> startUI [
	commandServer := BorgServer new startUI
]

{ #category : #accessing }
BorgApp >> stop [
	start1 := false.
	borg fullStop
]
