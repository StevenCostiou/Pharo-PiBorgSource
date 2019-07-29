Class {
	#name : #BorgCommandWithArgument,
	#superclass : #CmCommand,
	#instVars : [
		'arg'
	],
	#classVars : [
		'RegisteredCommands'
	],
	#category : #'Borg-Commands'
}

{ #category : #'instance creation' }
BorgCommandWithArgument class >> command: aCommand argument: anArgument for: aBorg [
	^ (self commandsAt: aCommand) new
		arg: anArgument;
		context: aBorg;
		yourself
]

{ #category : #accessing }
BorgCommandWithArgument class >> commandsAt: aCommandName [
	^self registeredCommands at: aCommandName ifAbsent:[BorgNullCommand]
]

{ #category : #initalize }
BorgCommandWithArgument class >> initialize [
	self initializeRegisteredCommands 
]

{ #category : #initalize }
BorgCommandWithArgument class >> initializeRegisteredCommands [
	^ RegisteredCommands := Dictionary new
		at: #fwd put: BorgMotorForwardCommand;
		at: #bwd put: BorgMotorBackwardCommand;
		at: #left put: BorgMotorTurnLeftCommand;
		at: #right put: BorgMotorTurnRightCommand;
		at: #stop put: BorgMotorStopCommand;
		at: #power put: BorgMotorPowerCommand;
		at: #sensor put: BorgSensorCommand;
		yourself
]

{ #category : #accessing }
BorgCommandWithArgument class >> registeredCommands [
	^ RegisteredCommands ifNil: [ self initializeRegisteredCommands ]
]

{ #category : #accessing }
BorgCommandWithArgument >> arg [
	^ arg
]

{ #category : #accessing }
BorgCommandWithArgument >> arg: anObject [
	arg := anObject
]

{ #category : #accessing }
BorgCommandWithArgument >> borg [
	^self context
]
