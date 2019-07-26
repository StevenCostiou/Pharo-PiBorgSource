Class {
	#name : #BorgCamera,
	#superclass : #AbstractSensor,
	#instVars : [
		'imageSize',
		'imagePath',
		'imageName'
	],
	#category : #'Borg-Camera'
}

{ #category : #accessing }
BorgCamera >> imageName [
	^ imageName
]

{ #category : #accessing }
BorgCamera >> imageName: arg1 [
	imageName := arg1
]

{ #category : #accessing }
BorgCamera >> imagePath [
	^ imagePath
]

{ #category : #accessing }
BorgCamera >> imagePath: arg1 [
	imagePath := arg1
]

{ #category : #accessing }
BorgCamera >> imageSize [
	^ imageSize
]

{ #category : #accessing }
BorgCamera >> imageSize: arg1 [
	imageSize := arg1
]

{ #category : #initialization }
BorgCamera >> initialize [
	imageSize := 320 @ 240.
	imagePath := '/home/pi/cam'.
	imageName := 'photo.jpg'
]

{ #category : #API }
BorgCamera >> takeAPicture [
	| command process |
	command := OrderedCollection new.
	command
		add: '-o';
		add: imageName asString;
		add: '-w';
		add: imageSize x asString;
		add: '-h';
		add: imageSize y asString;
		add: '-n';
		add: '-tl';
		add: '250';
		add: '-t';
		add: '1'.
	process := OSSUnixSubprocess new.
	process
		command: 'raspistill';
		arguments: command;
		defaultWriteStreamCreationBlock: [ OSSVMProcess vmProcess systemAccessor makeNonBlockingPipe ];
		redirectStdout;
		redirectStderrTo: '/tmp/stderrFile.txt' asFileReference writeStream;
		createMissingStandardStreams: false;
		workingDirectory: imagePath;
		environmentAt: 'HOME' put: imagePath;
		addAllEnvVariablesFromParentWithoutOverride;
		runAndWaitOnExitDo: [ :arg1 :arg2 :arg3 | ^ imagePath ]
]
