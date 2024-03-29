Class {
	#name : #BaselineOfPiBorg,
	#superclass : #BaselineOf,
	#category : #BaselineOfPiBorg
}

{ #category : #baselines }
BaselineOfPiBorg >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
		"		baseline: 'PharoThings'
					with: [ spec repository: 'github://pharo-iot/PharoThings:dev/src' ];"
				baseline: 'Commander2'
					with: [ spec repository: 'github://pharo-spec/Commander2/src' ];
				baseline: 'OSSubprocess'
					with: [ spec
						repository: 'github://pharo-contributions/OSSubprocess:master/repository' ];
				baseline: 'MCP3008'
					with: [ spec repository: 'github://pharo-iot/Pharo-MCP3008' ];
				baseline: 'PyLibrary'
					with: [ spec repository: 'github://StevenCostiou/PyLibrary' ];
				baseline: 'PicoMotors'
					with: [ spec repository: 'github://StevenCostiou/PicoBorgReverseMotors:Refactorings' ].
			spec package: 'Borg' ]
]
