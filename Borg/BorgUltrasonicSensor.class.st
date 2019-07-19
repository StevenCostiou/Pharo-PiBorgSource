Class {
	#name : #BorgUltrasonicSensor,
	#superclass : #DigitalSensor,
	#instVars : [
		'trigger',
		'echo'
	],
	#category : #Borg
}

{ #category : #'as yet unclassified' }
BorgUltrasonicSensor class >> ultrasonicSensorEcho: arg1 trigger: arg2 [
	| tmp1 tmp2 tmp3 |
	tmp1 := self new.
	tmp2 := tmp1
		pinAtId: (arg1 at: 1)
		number: (arg1 at: 2)
		mode: (arg1 at: 3).
	tmp3 := tmp1
		pinAtId: (arg2 at: 1)
		number: (arg2 at: 2)
		mode: (arg2 at: 3).
	tmp1
		echo: tmp2;
		trigger: tmp3.
	^ tmp1
]

{ #category : #accessing }
BorgUltrasonicSensor >> echo [
	^ self echo
]

{ #category : #accessing }
BorgUltrasonicSensor >> echo: arg1 [
	echo := arg1
]

{ #category : #'as yet unclassified' }
BorgUltrasonicSensor >> getWallDistance [
	| tmp1 tmp3 tmp4 tmp5 |
	tmp1 := Semaphore new.
	self write: 0.
	1 milliSecond wait.
	self write: 1.
	1 milliSecond wait.
	self write: 0.
	[ [ self read = 0 ] whileTrue: [  ].
	tmp4 := Time now asNanoSeconds.
	[ self read = 1 ] whileTrue: [  ].
	tmp3 := Time now asNanoSeconds.
	tmp5 := (tmp3 - tmp4) / 1000000000 * 17000 asFloat.
	tmp1 signal ] fork.
	tmp1
		wait: 10 milliSeconds
		onCompletion: [ ^ tmp5 ]
		onTimeout: [ self rebootSensor.
			^ -1 ]
]

{ #category : #'read/write' }
BorgUltrasonicSensor >> read [
	^ echo readDigitalValue
]

{ #category : #'as yet unclassified' }
BorgUltrasonicSensor >> rebootSensor [
	echo
		beDigitalOutput;
		writeDigitalValue: 1.
	300 milliSeconds wait.
	echo
		writeDigitalValue: 0;
		beDigitalInput
]

{ #category : #accessing }
BorgUltrasonicSensor >> trigger [
	^ self trigger
]

{ #category : #accessing }
BorgUltrasonicSensor >> trigger: arg1 [
	trigger := arg1
]

{ #category : #'read/write' }
BorgUltrasonicSensor >> write: arg1 [
	trigger writeDigitalValue: arg1
]
