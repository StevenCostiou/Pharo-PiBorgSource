Class {
	#name : #BorgMotorPowerCommand,
	#superclass : #BorgMotorCommand,
	#category : #'Borg-Commands'
}

{ #category : #hooks }
BorgMotorPowerCommand >> execute [
	self borg power: arg
]
