Class {
	#name : #BorgTest,
	#superclass : #Object,
	#category : #'Borg-App'
}

{ #category : #motors }
BorgTest class >> biPythonMotorsAllMovesTest [
	<script>
	| tmp1 tmp2 |
	tmp2 := 1.
	tmp1 := Borg new.
	tmp1
		biMotors: BiMotors initializePythonMotors;
		execute: #power withArguments: 50;
		executeMotorCommand: #fwd.
	tmp2 second wait.
	tmp1 executeMotorCommand: #left.
	tmp2 second wait.
	tmp1 executeMotorCommand: #right.
	tmp2 second wait.
	tmp1 executeMotorCommand: #bwd.
	tmp2 second wait.
	tmp1 executeMotorCommand: #left.
	tmp2 second wait.
	tmp1 executeMotorCommand: #right.
	tmp2 second wait.
	tmp1 executeMotorCommand: #bwd.
	tmp2 second wait.
	tmp1 executeMotorCommand: #stop
]

{ #category : #motors }
BorgTest class >> biPythonMotorsTest [
	<script>
	[ | tmp1 tmp2 |
	tmp2 := 2.
	tmp1 := Borg new.
	tmp1
		biMotors: BiMotors initializePythonMotors;
		execute: #power withArguments: 50;
		executeMotorCommand: #fwd.
	tmp2 seconds wait.
	tmp1 executeMotorCommand: #stop ] fork
]

{ #category : #motors }
BorgTest class >> biXPIMotorsAllMovesTest [
	<script>
	| tmp1 tmp2 |
	tmp2 := 1.
	tmp1 := Borg new.
	tmp1
		biMotors: BiMotors initializeXPIMotors;
		execute: #power withArguments: 50;
		executeMotorCommand: #fwd.
	tmp2 second wait.
	tmp1 executeMotorCommand: #left.
	tmp2 second wait.
	tmp1 executeMotorCommand: #right.
	tmp2 second wait.
	tmp1 executeMotorCommand: #bwd.
	tmp2 second wait.
	tmp1 executeMotorCommand: #left.
	tmp2 second wait.
	tmp1 executeMotorCommand: #right.
	tmp2 second wait.
	tmp1 executeMotorCommand: #bwd.
	tmp2 second wait.
	tmp1 executeMotorCommand: #stop
]

{ #category : #motors }
BorgTest class >> biXPIMotorsTest [
	<script>
	| tmp1 tmp2 |
	tmp2 := 1.
	tmp1 := Borg new.
	tmp1
		biMotors: BiMotors initializeXPIMotors;
		execute: #power withArguments: 20;
		executeMotorCommand: #fwd.
	tmp2 seconds wait.
	tmp1 executeMotorCommand: #stop
]

{ #category : #'borg-sensors' }
BorgTest class >> borgCameraTest [
	<script>
	| tmp1 |
	tmp1 := Borg initializeBorgWithBiMotors: BiMotors initializeXPIMotors.
	tmp1 camera takeAPicture
]

{ #category : #'borg-sensors' }
BorgTest class >> borgDirectionTest [
	<script>
	| tmp1 |
	tmp1 := Borg initializeBorgWithBiMotors: BiMotors initializeXPIMotors.
	Transcript
		crShow:
			'F ' , tmp1 motionSensor readLeft , ' , '
				, tmp1 motionSensor readRight
]

{ #category : #'borg-sensors' }
BorgTest class >> borgMotionTest [
	<script>
	| tmp1 |
	tmp1 := Borg initializeBorgWithBiMotors: BiMotors initializeXPIMotors.
	Transcript crShow: tmp1 motionSensor read
]

{ #category : #'borg-sensors' }
BorgTest class >> borgUltrasonicTest [
	<script>
	| tmp1 |
	tmp1 := Borg initializeBorgWithBiMotors: BiMotors initializeXPIMotors.
	Transcript
		crShow: 'Front';
		crShow: tmp1 getDistance
]

{ #category : #borgApp }
BorgTest class >> calculatorMaxValue [
	<script>
	| tmp1 |
	tmp1 := OrderedCollection new.
	tmp1
		add: 2;
		add: 1;
		add: 5;
		add: 2.
	(Calculator getIndexOfMaxValueOfCollection: tmp1) asString logCr
]

{ #category : #borgApp }
BorgTest class >> findBlackRectangleTest [
	<script>
	| tmp1 |
	tmp1 := Borg initializeBorgWithBiMotors: BiMotors initializeXPIMotors.
	tmp1 orienteToBlackRectangle: 50
]

{ #category : #motors }
BorgTest class >> motorMoving18cmTest [
	<script>
	| tmp1 |
	tmp1 := Borg new.
	tmp1 biMotors: BiMotors initializeXPIMotors.
	tmp1 biMotors goToDistance: -18 withBorgSpeed: 90
]

{ #category : #motors }
BorgTest class >> motorMoving90DegreeRightStandStillTest [
	<script>
	| tmp1 |
	tmp1 := Borg new.
	tmp1 biMotors: BiMotors initializeXPIMotors.
	tmp1 biMotors turnRightStandStillAngle: 90 withBorgSpeed: 25
]

{ #category : #motors }
BorgTest class >> motorMoving90DegreeRightTest [
	<script>
	| tmp1 |
	tmp1 := Borg new.
	tmp1 biMotors: BiMotors initializeXPIMotors.
	tmp1 biMotors turnRightAngle: 90 withBorgSpeed: 25
]

{ #category : #motors }
BorgTest class >> moveAroundBoxDemo [
	<script>
	| tmp1 tmp2 tmp3 tmp4 |
	tmp2 := 3.
	tmp3 := 7.
	tmp4 := 5.
	tmp1 := Borg new.
	tmp1
		biMotors: BiMotors initializeXPIMotors;
		execute: #power withArguments: 40;
		executeMotorCommand: #fwd.
	tmp2 second wait.
	tmp1 executeMotorCommand: #left.
	tmp3 second wait.
	tmp1 executeMotorCommand: #fwd.
	tmp2 second wait.
	tmp1
		executeMotorCommand: #standStillTurn;
		execute: #power withArguments: 40.
	tmp4 second wait.
	tmp1 executeMotorCommand: #bwd.
	tmp2 second wait.
	tmp1 executeMotorCommand: #left.
	tmp3 second wait.
	tmp1 executeMotorCommand: #bwd.
	tmp2 second wait.
	tmp1 executeMotorCommand: #stop
]

{ #category : #motors }
BorgTest class >> sandBoxTest [
	<script>
	| tmp1 tmp2 |
	tmp2 := 0.
	tmp1 := Borg new.
	tmp1 biMotors: BiMotors initializeXPIMotors.
	tmp1 biMotors power: 100.
	tmp1 biMotors motorRight moveForward.
	tmp1 biMotors motorLeft moveBackward.
	tmp2 seconds wait.
	tmp1 biMotors motorRight stop.
	tmp1 biMotors motorLeft stop
]

{ #category : #borgApp }
BorgTest class >> scenario1Test [
	<script>
	| tmp1 |
	tmp1 := BorgApp new.
	tmp1 scenario1
]

{ #category : #borgApp }
BorgTest class >> scenario2Test [
	<script>
	| tmp1 |
	tmp1 := BorgApp new.
	tmp1 scenario2
]

{ #category : #sensor }
BorgTest class >> testCamera [
	<script>
	| tmp1 |
	tmp1 := BorgCamera new.
	tmp1 openPicture.
	(tmp1 calculAngleToDestinationOfPicture: 'samuel2.png') logCr
]

{ #category : #sensor }
BorgTest class >> testSensorMCP [
	<script>
	| tmp1 |
	tmp1 := MCP3008Device index: 0.
	Transcript
		show: (tmp1 read: 3);
		show: (tmp1 read: 4)
]

{ #category : #sensor }
BorgTest class >> testUltrasonicSensor [
	<script>
	| tmp1 tmp2 |
	tmp2 := 1.
	tmp1 := Borg new.
	tmp1
		ultrasonic:
			(BorgUltrasonicSensor
				ultrasonicSensorEcho: #(18 1 #input)
				trigger: #(17 0 #output)).
	tmp1 ultrasonic getWallDistance inspect
]

{ #category : #motors }
BorgTest class >> turn [
	<script>
	| tmp1 |
	tmp1 := [ | tmp2 |
	tmp2 := Borg
		initializeBorgWithBiMotors: BiMotors initializePythonMotors.
	tmp2 execute: #power withArguments: 40.
	[ true ] whileTrue: [ tmp2 executeMotorCommand: #left ] ] fork.
	tmp1 inspect
]
