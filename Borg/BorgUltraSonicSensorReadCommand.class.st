Class {
	#name : #BorgUltraSonicSensorReadCommand,
	#superclass : #BorgSensorCommand,
	#category : #'Borg-Commands'
}

{ #category : #hooks }
BorgUltraSonicSensorReadCommand >> execute [
	^self borg readDistance
]
