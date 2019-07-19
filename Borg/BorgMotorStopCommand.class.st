Class {
	#name : #BorgMotorStopCommand,
	#superclass : #BorgMotorCommand,
	#category : #'Borg-Commands'
}

{ #category : #hooks }
BorgMotorStopCommand >> execute [
	self borg fullStop
]
