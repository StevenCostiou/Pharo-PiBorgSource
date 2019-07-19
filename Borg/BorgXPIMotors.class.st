Class {
	#name : #BorgXPIMotors,
	#superclass : #BasicMotor,
	#instVars : [
		'httpDriver'
	],
	#category : #Borg
}

{ #category : #initialization }
BorgXPIMotors >> defaultServerHTTPAddress [
	^ 'http://192.168.1.100:5000'
]

{ #category : #initialization }
BorgXPIMotors >> initialize [
	super initialize.
	httpDriver := XPiHTTPDriver new.
	httpDriver address: self defaultServerHTTPAddress
]

{ #category : #private }
BorgXPIMotors >> move: arg1 [
	position = #left
		ifTrue: [ ^ httpDriver
				write:
					{'motorLeft'.
					(STON toJsonString: {arg1 negated})} ].
	position = #right
		ifTrue: [ ^ httpDriver
				write:
					{'motorRight'.
					(STON toJsonString: {arg1})} ]
]
