Class {
	#name : #BorgApp,
	#superclass : #Object,
	#instVars : [
		'borg',
		'commandServer',
		'start1'
	],
	#category : #'Borg-App'
}

{ #category : #'as yet unclassified' }
BorgApp >> scenario1 [
	borg beginAutoNavigation
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
	| server |
	borg := Borg initializeBorgWithBiMotors: BiMotors defaultMotors.
	server := BorgServer new.
	server model: borg.
	commandServer := server startBorg
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
