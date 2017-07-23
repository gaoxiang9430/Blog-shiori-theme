+++
date = "2016-10-06T21:45:10+08:00"
draft = true
title = "Control Flow Integrity(First formal English Presentation)"
tags = [ "CFI", "security", "blog" ]
+++

Most external attacks aim to control software behaviors. To achieve this, those attacks want to change the software control-flow graph. For example, the buffer overflow attack, attackers can change the return address after a function call completed. And even control the software to excute the system library functions.
To deal with the problem, many previous works had proposed good ideas. Such as stack canaries, this mechainism add a canary before the return address, if an attack try to change the address, it mush change the canary first. In this situation, system can detect this the malicious behavior. However, attackers can bypass the protections by hooking the canary checking function. And for other protection mechainisms, attckers can bypass them, too.

---
##### CFI #####
This paper proposed Control-Flow Integrity(CFI). CFI enforces software execution must follow a path of a Control-Flow Graph(CFG) determined ahead of time. For example, after a function call, it must return to the caller, which prevent the program from jumping to library function even though the return address modified by the attackers. The most important part in this process is to pre-determine the CFG. This paper provided 3 method
	
	1. static source code analysis
	2. static binary code analysis
	3. execution profiling

Before we start to introduce the CFI details, we first give the assumptions.

	1. UWC Non-Writeable Code :  NWC is already true on most current systems, except during the loading of dynamic libraries and runtime code-generation
	2. NXD Non-Executable Data : NXD is supported in hardware on the latest x86 processors
	3. UNQ Unique IDs : After CFI instrumentation, the bit patterns chosen as IDs must not be present anywhere in the code memory except in IDs and ID-checks.

The first step for CFI enforcement is to construct the control flow graph. We can build CFG from source code or binary code using some standard control flow analysis tools. When building the control flow graph, we must ensure that the program is executed in a security enviornment.
The second step is to label each control flow operation.
The third step is to insert IDs and ID-checks to binary code.

----
##### CFI measurement #####
Each binary takes about 10 seconds, with the size of the binary increasing by an average 8%.
Takes 16% longer time to execute, on average. Because the IDs and ID-checks have the same locality properties as executing code, they are not penalized by the high memory latency.On the other hand, in almost cases, the eax and ecx registers can be used directly at function calls and returns.

