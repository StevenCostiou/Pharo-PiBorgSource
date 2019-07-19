Class {
	#name : #BorgMotorTurnLeftCommand,
	#superclass : #BorgMotorCommand,
	#category : #'Borg-Commands'
}

{ #category : #hooks }
BorgMotorTurnLeftCommand >> execute [ 	
	self borg turnLeft
]
