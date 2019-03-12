HW02
===
This is the hw02 sample. Please follow the steps below.

# Build the Sample Program

1. Fork this repo to your own github account.

2. Clone the repo that you just forked.

3. Under the hw02 dir, use:

	* `make` to build.

	* `make clean` to clean the ouput files.

4. Extract `gnu-mcu-eclipse-qemu.zip` into hw02 dir. Under the path of hw02, start emulation with `make qemu`.

	See [Lecture 02 ─ Emulation with QEMU] for more details.

5. The sample is designed to help you to distinguish the main difference between the `b` and the `bl` instructions.  

	See [ESEmbedded_HW02_Example] for knowing how to do the observation and how to use markdown for taking notes.

# Build Your Own Program

1. Edit main.s.

2. Make and run like the steps above.

# HW02 Requirements

1. Please modify main.s to observe the `push` and the `pop` instructions:  

	Does the order of the registers in the `push` and the `pop` instructions affect the excution results?  

	For example, will `push {r0, r1, r2}` and `push {r2, r0, r1}` act in the same way?  

	Which register will be pushed into the stack first?

2. You have to state how you designed the observation (code), and how you performed it.  

	Just like how [ESEmbedded_HW02_Example] did.

3. If there are any official data that define the rules, you can also use them as references.

4. Push your repo to your github. (Use .gitignore to exclude the output files like object files or executable files and the qemu bin folder)

[Lecture 02 ─ Emulation with QEMU]: http://www.nc.es.ncku.edu.tw/course/embedded/02/#Emulation-with-QEMU
[ESEmbedded_HW02_Example]: https://github.com/vwxyzjimmy/ESEmbedded_HW02_Example

--------------------

- [ ] **If you volunteer to give the presentation next week, check this.**

--------------------
# Emdedded_HW02

## 1. 實驗題目

比較push及pop功能中Regist順序是否影響輸出結果

比較`push {r0, r1, r2}` 與 `push {r2, r0, r1}`是否一樣

## 2. 實驗步驟

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


1.將100,200,300放入r0,r1,r2

![](https://github.com/Hung17/ESEmbedded_HW02/blob/master/images/1.png)

2.將 r0,r1,r2 push進入stack

3.依照sp發現資料向下堆疊到0x200000f4，輸入x 0x200000f4指令確認stack內容

![](https://github.com/Hung17/ESEmbedded_HW02/blob/master/images/2.png)

4.將stack內容pop出來並存入r3,r4,r5

![](https://github.com/Hung17/ESEmbedded_HW02/blob/master/images/3.png)

5.將r3,r4,r5資料清為0，將1,2,3的值存入r0,r1,r2(更換資料觀察stack內資料變化)

![](https://github.com/Hung17/ESEmbedded_HW02/blob/master/images/4.png)

6.改變register順序，將 r2,r0,r1 push進入stack

7.依照sp發現資料向下堆疊到0x200000f4，輸入x 0x200000f4指令確認stack內容

![](https://github.com/Hung17/ESEmbedded_HW02/blob/master/images/5.png)

8.將stack內容pop出來並更改pop順序存入r5	,r4	,r3

![](https://github.com/Hung17/ESEmbedded_HW02/blob/master/images/6.png)

## 3. 結果與討論

1.從實驗中（step3 and step7）可以發現不論register的順序，執行push時，會依照register號碼大小，由大至小，依序將register的值push進stack

示意 ： Stack是往下長的，register的內容由register number愈大的先放進stack

	|		0x20000100	0x00000000
	|		0x200000fc	0x0000012c	//register 2 data		|
	|		0x200000f8	0x000000c8	//register 1 data		| （push進來的順序）
	V		0x200000f4	0x00000064	//register 0 data		V
	


2.而相反的(step4 and step8)，可以發現不論register的順序，執行pop時，會依照register號碼大小，由小至大，依序將stack位置最低的值的值pop至register

示意 ： Stack是往下長的，pop時,存放資料中位置最低的stack將資料pop出來存入register,存入順序是依據register number大小，由小至大，存入資料

	|		0x20000100	0x00000000
	|		0x200000fc	0x0000012c	//pop給register 5 data		^
	|		0x200000f8	0x000000c8	//pop給register 4 data		| (pop出stack的順序)
	V		0x200000f4	0x00000064	//pop給register 3 data		|
	

結論:push及pop功能中Regist順序並不會影響輸出結果

