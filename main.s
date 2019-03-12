.syntax unified

.word 0x20000100
.word _start

.global _start
.type _start, %function
_start:

	//
	//mov # to reg
	//
	movs	r0,	#100
	movs	r1,	#200
	movs	r2,	#300

	//
	//push
	//
	push	{r0,	r1,	r2}

	//
	//pop
	//
	pop	{r3	,r4	,r5}

	//
	//clean reg
	//
	movs	r3,	#0
	movs	r4,	#0
	movs	r5,	#0

	//
	//mov # to reg
	//
	movs	r0,	#1
	movs	r1,	#2
	movs	r2,	#3

	//
	//push
	//
	push	{r2,	r0,	r1}

	//
	//pop
	//
	pop	{r5	,r4	,r3}

	//
	//b bl
	//
	b	label01


sleep:
	b	sleep

label01:
		nop
		nop
		bx lr
