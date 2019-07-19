Class {
	#name : #BorgMotorBackwardCommand,
	#superclass : #BorgMotorCommand,
	#category : #'Borg-Commands'
}

{ #category : #hooks }
BorgMotorBackwardCommand >> execute [
	self borg moveBackward
]
