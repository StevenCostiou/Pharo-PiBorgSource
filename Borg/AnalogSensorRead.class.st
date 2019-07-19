Class {
	#name : #AnalogSensorRead,
	#superclass : #Object,
	#instVars : [
		'device',
		'channel',
		'rawValue',
		'value',
		'log'
	],
	#category : #'Borg-Sensors'
}

{ #category : #initialization }
AnalogSensorRead >> analogRead: arg1 [
	channel := arg1.
	rawValue := device read: channel.
	value := [ rawValue asNumber ]
		on: Error
		do: [ 0 ].
	log add: Time now
]

{ #category : #initialization }
AnalogSensorRead >> asArray [
	^ {device.
	channel.
	rawValue.
	value.
	log}
]

{ #category : #initialization }
AnalogSensorRead >> initialize [
	device := MCP3008Device index: 0.
	log := OrderedCollection new
]
