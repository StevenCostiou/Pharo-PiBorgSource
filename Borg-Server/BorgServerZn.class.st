Class {
	#name : #BorgServerZn,
	#superclass : #Object,
	#instVars : [
		'znServer',
		'borg'
	],
	#category : #'Borg-Server'
}

{ #category : #initialization }
BorgServerZn >> initialize [
	| tmp1 |
	tmp1 := BorgDelegate new.
	tmp1 borg: BorgApp allInstances first.
	znServer := ZnSingleThreadedServer defaultOn: 8080.
	znServer delegate: tmp1
]

{ #category : #initialization }
BorgServerZn >> start [
	znServer start
]

{ #category : #initialization }
BorgServerZn >> stop [
	znServer stop
]
