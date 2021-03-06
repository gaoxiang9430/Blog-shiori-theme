+++
date = "2016-08-07T21:45:10+08:00"
draft = true
title = "Detecting Energy Bugs and Hotspots in Mobile Apps"
tags = [ "Android", "Non-function property", "blog" ]
+++

Over the recent years, the popularity of smartphones has increased dramatically. As we all know, smartphone is an energy-limited device. So, it is important to develop tools and techniques that aid in energy-efficient application development. Energy inefficiencies in smartphone can broadly be categorized into energy hotspots and energy bugs. An energy hotspot can be described as a scenario where executing an application causes the smartphone to consume abnormally high amount of battery power. In constract, energy bugs can be described as a scenario where a malfunctioning application prevents the smartphone from becoming idle, even after it has completed execution and there is no user activity.
This paper presented an automated test generation framework that detect energy hotspots and bugs in Android applications. This framework systematically generates test inputs that are likely to capture energy hotspots and bugs.

----
#### Introduction ####
Table 1 lists the different type pf energy hotspots and bugs that can be found in android applications.
![hello](file:///home/xiang/Workspaces/blog/blog/image/detecting energy bugs and hotspot.png)
However, it is difficult to detect those bugs and hotspots, due to the absence of any extre-functional property annotations in the application code. Some previous work shown that I/O components are primary sources of energy consumption in a smartphone. One crucial observation is that I/O components are usually accessed in application code via system calls. In other words, most of the classified energy hotspots/bugs are exposed via the invocation of system call. This paper concentrate on the traces that access to system call(s).

----
#### Framework ####
The framework of the strategy is shown in Fig 2. This framework contains two essential components:
	
	1. guilded exploration of select event traces that are more likely to uncover hotspots/bugs(Preprocessing the Application);
	2. detection of hotspots/bugs in a given event trace for an application(Test Generation).

![image](/image/framework.png)

----
##### Preprocessing the Application #####
Preprocessing the appication can be devided into 3 steps:
	1. EFG extraction
	2. Event trace generation
	3. Extraction of system call sequence for each event trace
**Event Flow Gragh Extraction**:
This paper build EFG based on the UI model. To construct EFG, this paper use two third-party tools Hierarchy Viewer and Dynodroid. The formar one provides information about UI element of the application and the later one explore these event sequence automatically. Original Dynodroid does not generate the EFG by itself, this paper modified the source code to build EFG.
__Event Trace Generation__:
An event trace is defined as a path of arbitrary length in the EFG. Such a path must start from an event in the root screen of the respective application. Based on the EFG, we generate a complete set of event traces upto length *k*, and store them in a database for further analysis during test generation.
__Extraction of System Call__:
I/O components are one of the major sources of energy consumption in smartphone, and those components mainly excuted by system call. This paper execute the all the event trace to collect the system call traces. Thus, for each event trace generated from the EFG, we can generate the respective system call trace.

----
##### Test Generation #####
**Technique of Hotspot/Bug Detection**
Firstly, this paper defined Utilization(U) as the weighted sum of utilization reate of all major power consuming hardware components in a device, over a given period of time. *It seems that the utilization is the energy consumption of the hardware.* And then, they defined Energy-consumption to Utilization ratio is the measure of energy-inefficiency of an application for a given time period. If E/U ratio of an application is high, it implies that the energy-consumption is high while utilization is low.
To detect the energy hotspots/bugs during an event trace, they first obtain the E/U ratio in four stages: pre-excution stage(PRE), execution stage(EXE), recovery stage(REC) and post execution stage(POST). If the E/U in PRE and POST is different, it means that there is an energy bug. Meanwhile, the subsequences in E/U that are abnormally different from the rest of the subsequences in the EXC and REC stage means a hotspot.
**Guidance Heuristics for Test Generation**
The guidance function uses three parameters to rank the unexplored event traces:

	1. number of system calls in the event trace;
	2. similarrity to previously explored, hotspot/bug revealing event traces
	3. starvation of event traces due to un explored system calls.
