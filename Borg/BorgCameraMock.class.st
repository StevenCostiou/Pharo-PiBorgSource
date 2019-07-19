Class {
	#name : #BorgCameraMock,
	#superclass : #AbstractSensor,
	#category : #Borg
}

{ #category : #private }
BorgCameraMock >> calculAngleFromPictureSize: arg1 toDestinationPoint: arg2 [
	| tmp1 tmp2 tmp3 |
	tmp1 := arg1 x / 2 - arg2 x.
	tmp2 := arg1 y - arg2 y.
	tmp3 := (tmp1 / tmp2) arcTan.
	^ tmp3 * (180 / Float pi)
]

{ #category : #API }
BorgCameraMock >> calculAngleToDestinationOfPicture: arg1 [
	| tmp1 |
	tmp1 := ColorForm fromFileNamed: arg1.
	^ self
		calculAngleFromPictureSize: tmp1 width @ tmp1 height
		toDestinationPoint: (self calculDestinationPointOfAColorForm: tmp1)
]

{ #category : #private }
BorgCameraMock >> calculDestinationPointOfAColorForm: arg1 [
	| tmp1 tmp2 tmp3 tmp4 |
	tmp1 := arg1 rectangleEnclosingPixelsNotOfColor: Color white.
	tmp2 := tmp1 corner - tmp1 origin.
	tmp3 := tmp2 / 2.
	tmp4 := (tmp3 x + tmp1 origin x) @ (tmp3 y + tmp1 origin y).
	^ tmp4
]

{ #category : #private }
BorgCameraMock >> takeAPicture [
	
]
