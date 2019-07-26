Class {
	#name : #BorgAccelerometerReadCommand,
	#superclass : #BorgSensorCommand,
	#category : #'Borg-Commands'
}

{ #category : #hooks }
BorgAccelerometerReadCommand >> execute [
	^ self borg readAcceleration
]
