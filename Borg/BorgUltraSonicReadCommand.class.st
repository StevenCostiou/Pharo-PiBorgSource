Class {
	#name : #BorgUltraSonicReadCommand,
	#superclass : #BorgSensorCommand,
	#category : #'Borg-Commands'
}

{ #category : #hooks }
BorgUltraSonicReadCommand >> execute [
	^self borg readDistance
]
