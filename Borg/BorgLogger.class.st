Class {
	#name : #BorgLogger,
	#superclass : #Object,
	#instVars : [
		'logs'
	],
	#classInstVars : [
		'logs'
	],
	#category : #'Borg-Model'
}

{ #category : #accessing }
BorgLogger class >> log: arg1 [
	self logs add: arg1
]

{ #category : #accessing }
BorgLogger class >> logs [
	| tmp2 |
	tmp2 := logs.
	^ tmp2 ifNil: [ logs := OrderedCollection new ] ifNotNil: [ tmp2 ]
]
