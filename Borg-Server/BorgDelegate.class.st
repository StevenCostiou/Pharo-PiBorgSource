Class {
	#name : #BorgDelegate,
	#superclass : #ZnDefaultServerDelegate,
	#instVars : [
		'borgController'
	],
	#category : #'Borg-Server'
}

{ #category : #initialization }
BorgDelegate >> borg: arg1 [
	borgController := arg1
]

{ #category : #initialization }
BorgDelegate >> handleRequest: arg1 [
	self perform: arg1 uri lastPathSegment asSymbol.
	^ ZnResponse ok: arg1 uri
]

{ #category : #initialization }
BorgDelegate >> start [
	borgController scenario1
]

{ #category : #initialization }
BorgDelegate >> stop [
	borgController
		stop;
		stop.
	2 seconds wait.
	borgController stop.
	2 seconds wait.
	borgController stop.
	2 seconds wait.
	borgController stop
]
