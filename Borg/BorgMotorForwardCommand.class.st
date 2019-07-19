Class {
	#name : #BorgMotorForwardCommand,
	#superclass : #BorgMotorCommand,
	#category : #'Borg-Commands'
}

{ #category : #hooks }
BorgMotorForwardCommand >> execute [
	self borg moveForward
]
