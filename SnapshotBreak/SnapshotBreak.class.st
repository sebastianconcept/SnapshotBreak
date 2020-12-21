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
SnapshotBreak class >> maxHistory [
	"Answer the maximum number of images to keep in the destination folder."

	^ OSEnvironment current
		at: 'MAX_SNAPSHOTBREAK_IMAGES'
		ifAbsent: [ 5 ]
]

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
	self hasTooMany
		ifTrue: [ self terminate ]
		ifFalse: [ self saveImageAndTerminateCurrentProcess ]
]

{ #category : #actions }
SnapshotBreak >> destinationDirectory [
	"Answers the directory file reference where the snapshot will be saved."

	^ fileName asFileReference parent
]

{ #category : #accessing }
SnapshotBreak >> fileName [
	^ fileName
]

{ #category : #accessing }
SnapshotBreak >> fileName: anObject [
	fileName := anObject
]

{ #category : #testing }
SnapshotBreak >> hasTooMany [
	"Answers true if there are too many snapshots."

	^ self imageEntries size > self class maxHistory
]

{ #category : #accessing }
SnapshotBreak >> imageEntries [
	^ self destinationDirectory entries
		select: [ :each | each extension = 'image' ]
]

{ #category : #'priv handling' }
SnapshotBreak >> saveImageAndTerminateCurrentProcess [
	[ Smalltalk saveAs: fileName.
	Processor activeProcess terminate ] fork.
	super defaultAction
]

{ #category : #actions }
SnapshotBreak >> terminate [
	Processor activeProcess terminate
]
