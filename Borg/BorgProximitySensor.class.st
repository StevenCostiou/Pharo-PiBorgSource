Class {
	#name : #BorgProximitySensor,
	#superclass : #AnalogSensor,
	#category : #Borg
}

{ #category : #api }
BorgProximitySensor >> proximity [
	^ self read value < 30
]

{ #category : #api }
BorgProximitySensor >> read [
	^ self analogRead: address
]
