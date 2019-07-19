Class {
	#name : #BorgSensorCommand,
	#superclass : #BorgCommandWithArgument,
	#category : #'Borg-Commands'
}

{ #category : #hooks }
BorgSensorCommand >> execute [
	^self borg readSensor: arg
]
