"
A CallbackForWin64X64 is a callback for platforms with x64/x86_64 processors using the Win64 ABI.
"
Class {
	#name : #CallbackForWin64X64,
	#superclass : #Callback,
	#category : #'Alien-Core'
}

{ #category : #accessing }
CallbackForWin64X64 class >> abi [
	^'X64Win64'
]

{ #category : #'class initialization' }
CallbackForWin64X64 class >> isForCurrentPlatform [
	| processor |
	(#('Win32' 'Win64') includes: (SmalltalkImage current getSystemAttribute: 1001)) ifFalse:
		[^false].
	processor := (SmalltalkImage current getSystemAttribute: 1003) asLowercase.
	^processor first = $x and: [processor = 'x64' or: [('x86#64*' match: processor)]]
]

{ #category : #signatures }
CallbackForWin64X64 >> intcharstarRetint: callbackContext regs: regsAlien [
	<signature: #(int (*)(int, char *))>
	^callbackContext wordResult:
		(block
			value: (regsAlien signedLongLongAt: 1)
			value: (Alien forPointer: (regsAlien unsignedLongLongAt: 9)))
]

{ #category : #evaluation }
CallbackForWin64X64 >> valueInContext: callbackContext [ "<VMCallbackContext32|VMCallbackContext64> ^<Integer>"
	numEvaluatorArgs = 2 ifTrue:
		[^self perform: evaluator
			with: callbackContext
			with: callbackContext intregargsp].
	numEvaluatorArgs = 3 ifTrue:
		[^self perform: evaluator
			with: callbackContext
			with: callbackContext intregargsp
			with: callbackContext stackp].
	numEvaluatorArgs = 4 ifTrue:
		[^self perform: evaluator
			with: callbackContext
			with: callbackContext intregargsp
			with: callbackContext stackp
			with: callbackContext floatregargsp].
	numEvaluatorArgs = 1 ifTrue: "legacy support"
		[^self perform: evaluator
			with: callbackContext].
	self error: 'invalid evaluator argument count'
]

{ #category : #signatures }
CallbackForWin64X64 >> voidstarvoidstarRetint: callbackContext regs: regsAlien [
	<signature: #(int (*)(const void *, const void *))>
	^callbackContext wordResult:
		(block
			value: (Alien forPointer: (regsAlien unsignedLongLongAt: 1))
			value: (Alien forPointer: (regsAlien unsignedLongLongAt: 9)))
]
