Class {
	#name : #BorgMotorTurnRightCommand,
	#superclass : #BorgMotorCommand,
	#category : #'Borg-Commands'
}

{ #category : #hooks }
BorgMotorTurnRightCommand >> execute [ 	
	self borg turnRight
]
