TITLE Project 6: String Primitives and Macros    (Proj6_Allendr.asm)

; Author: Drew Allen
; Last Modified: 3/13/21
; OSU email address: Allendr@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:    6             Due Date:  3/14/21
; Description: This program implements two macros for string processing and tests them
;				with several procedures
				

INCLUDE Irvine32.inc

mGetString MACRO prompt, inputBuffer, inputLength, bytesRead
	PUSHAD
	MOV		EDX, prompt
	CALL	WriteString

	MOV		EDX, inputBuffer
	MOV		ECX, inputLength
	CALL	ReadString
	MOV		bytesRead, EAX

	POPAD
ENDM

mDisplayString MACRO storedArray
	PUSH	EDX
	MOV		EDX, storedArray
	CALL	WriteString
	CALL	CrLf
	POP		EDX
ENDM


	ARRAYSIZE			=			10

.data

	openingTitle		BYTE		"PROJECT 6: String Primitives and Macros",0
	author				BYTE		"By Drew Allen",0
	instructionsOne		BYTE		"Please input ten signed decimal integers that can each fit in a 32 bit register.",0
	instructionsTwo		BYTE		"Then this program will display a list of the numbers, their sum, and their average.",0
	userPrompt			BYTE		"Enter a signed integer: ",0
	errorMessage		BYTE		"ERROR: Invalid input. Entry was too large or not a signed number.",0
	tryAgainPrompt		BYTE		"Please try again: ",0
	listMessage			BYTE		"Here are the numbers you entered: ",0
	sumMessage			BYTE		"The sum is: ",0
	averageMessage		BYTE		"The average is: ",0
	goodbyeMessage		BYTE		"Thanks for playing! Goodbye.",0

	userInputBuffer		BYTE		13 DUP(?)
	userDigitsEntered	SDWORD		?
	userArray			SDWORD		ARRAYSIZE DUP(?)
	convertedInput		SDWORD		?



.code
main PROC
	mDisplayString		OFFSET	openingTitle
	mDisplayString		OFFSET	author
	CALL	CrLf
	mDisplayString		OFFSET	instructionsOne
	mDisplayString		OFFSET	instructionsTwo

	PUSH	userDigitsEntered ; EBP + 28
	PUSH	SIZEOF userInputBuffer ; EBP + 24
	PUSH	convertedInput	; EBP + 20
	PUSH	OFFSET userPrompt ; EBP + 16 
	PUSH	OFFSET userInputBuffer ;EBP+12
	PUSH	OFFSET errorMessage ; EBP+8
	CALL	ReadVal
	

	CALL	WriteVal



	Invoke ExitProcess,0	; exit to operating system
main ENDP

ReadVal PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSHAD

	JMP	_try

	_errorTryAgain:
		mDisplayString [EBP+8]
	_try:
		mGetString [EBP+16], [EBP+12], [EBP+24], [EBP+28]


	MOV		ESI, [EBP+12]
	MOV		ECX, [EBP+28]
	MOV		EAX, 0
	MOV		EDX, 0 ; DX == 1: number is negative. == 0: positive. save until end and use to decide of IMUL needed on final number
	_conversionLoop:
		PUSH	EAX
		LODSB
		MOV		EBX, 0
		MOV		BL, AL
		POP		EAX
		
		CMP		EBX, 43
		JE		_skipToEnd
		CMP		EBX, 45
		JE		_skipToEndNegative

		_notSignSymbol:
			CMP		EBX, 48
			JL		_errorTryAgain
			CMP		EBX, 57
			JG		_errorTryAgain

			SUB		EBX, 48
			PUSH	EDX
			MOV		EDX, 10
			MUL		EDX
			POP		EDX
			ADD		EAX, EBX
			JO		_errorTryAgain
			JMP		_skipToEnd

		_skipToEndNegative:
			MOV		EDX, 1
		
		_skipToEnd:
		LOOP _conversionLoop

	MOV		[EBP+20], EAX

	POPAD
	POP		EBP
	RET		24 ; N equal to the number of bytes of parameters which were pushed on the stack before the CALL statement.
ReadVal ENDP

WriteVal PROC
	PUSH	EBP
	MOV		EBP, ESP


	POP		EBP
	RET		; N equal to the number of bytes of parameters which were pushed on the stack before the CALL statement.
WriteVal ENDP


END main