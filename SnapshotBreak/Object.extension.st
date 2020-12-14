Extension { #name : #Object }

{ #category : #'*SnapshotBreak' }
Object >> snapshotBreak: prefix assert: conditionBlock [
	conditionBlock value
		ifTrue:
			[ SnapshotBreak to: '/tmp/SnapshotBreak/' , prefix , '-' , UUID new asString36 ]
]
