Class {
	#name : #BorgServer,
	#superclass : #Object,
	#instVars : [
		'server',
		'model',
		'peerConnection',
		'connectedToPeer'
	],
	#category : #Borg
}

{ #category : #initialization }
BorgServer >> connectToPeer: arg1 port: arg2 [
	| tmp1 |
	tmp1 := Delay forDuration: 0.5 second.
	connectedToPeer := true.
	peerConnection := [ [ connectedToPeer ]
		whileTrue: [ [ | tmp2 |
			tmp2 := self getSensorData.
			ZnEasy
				put: 'http://' , arg1 , ':' , arg2
				data: (ZnEntity text: tmp2) ]
				on: Error
				do: [ connectedToPeer := false ].
			tmp1 wait ] ] fork.
	^ 'ok'
]

{ #category : #initialization }
BorgServer >> getSensorData [
	| tmp1 tmp2 |
	tmp1 := model readAllSensors.
	tmp2 := Dictionary new.
	tmp1 keysAndValuesDo: [ :arg1 :arg2 | tmp2 at: arg1 put: arg2 ].
	^ STON toString: tmp2
]

{ #category : #initialization }
BorgServer >> handleRequest: arg1 [
	| tmp1 tmp2 |
	tmp1 := STON fromString: arg1 contents.
	tmp2 := tmp1 first = 'connect'
		ifTrue: [ self
				connectToPeer: (arg1 headers at: 'X-Zinc-Remote-Address')
				port: tmp1 last ]
		ifFalse: [ model execute: tmp1 first withArguments: tmp1 last ].
	^ ZnEntity text: tmp2
]

{ #category : #accessing }
BorgServer >> model [
	^ model
]

{ #category : #accessing }
BorgServer >> model: arg1 [
	model := arg1
]

{ #category : #initialization }
BorgServer >> startBorg [
	connectedToPeer := false.
	server := (ZnServer startDefaultOn: 1701)
		onRequestRespond: [ :arg1 | ZnResponse ok: (self handleRequest: arg1) ]
]

{ #category : #initialization }
BorgServer >> startUI [
	server := (ZnServer startDefaultOn: 1702)
		onRequestRespond: [ :arg1 | 
			Transcript crShow: (STON fromString: arg1 contents).
			ZnResponse ok: 'ok' ]
]

{ #category : #initialization }
BorgServer >> stop [
	server stop.
	ZnSingleThreadedServer stopDefault
]
