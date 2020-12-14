"
Provides a breakpoint that saves the image on the spot and quits.

Meant to be useful to gather all the diagnostic info possible in tricky cases in production.
"
Class {
	#name : #SnapshotBreak,
	#superclass : #Halt,
	#instVars : [
		'fileName'
	],
	#category : #SnapshotBreak
}

{ #category : #accessing }
SnapshotBreak class >> to: aFileName [
	"Signal a new exception of self saving a snapshot of 
	this image halted on the process that signalled it."

	^ self new
		fileName: aFileName;
		signal
]

{ #category : #'priv handling' }
SnapshotBreak >> defaultAction [
	[ Smalltalk saveAs: fileName.
	Smalltalk snapshot: true andQuit: true ] fork.
	super defaultAction
]

{ #category : #accessing }
SnapshotBreak >> fileName [
	^ fileName
]

{ #category : #accessing }
SnapshotBreak >> fileName: anObject [
	fileName := anObject
]
