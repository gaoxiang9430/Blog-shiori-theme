+++
date = "2016-12-24T21:45:10+08:00"
draft = true
title = "Precise Interprocedural DataFlow Analysis Via Graph Reachability"
tags = [ "Android", "Program analysis", "blog" ]
+++

Data flow analysis can be used to find the data dependency between different functions, statements and variables. For current programming language, data flow analysis is a very complex problem. In the 1990s, there are some reseaches proposed some good ideas to deal with this problem. Thomas[[1]](#1) etc proposed to transform dataflow-analysis into a graph-reachability problem. In this paper, they defined a IFDS problem(interprocedural, finite, distributive, subset).

---
#### Super Graph ####

In the IFDS problem, the program is represented using a directed graph called super graph. Each flow graph has start nodes, exit nodes. The other nodes represent the statements except a procedure call which is represented by two nodes, a call node and a return-site node. The edge in the super graph is the relationship between different statements including the intraprocedural edges and the procedure call. For procedure call statement, super graph has three kinds of edges:

	1. call-to-return-site: intraprocedural edge from call ro return-site, which is used to conduct the procedural summary(will be mentioned later).
	2. call-to-start: intre-procedural edge from c to the start node of the called procedure.
	3. exit-to-return-dite: intre-procedural edge from the exit node of the called procedure to r.
	
Actually, a modified control flow graph can be used as the super graph.

---
#### IFDS problem ####

The IFDS problem is based on the super graph. It introduce a domain D field which represents the data flow fact. Then they defined distributive functions which reflect the transmission between data flow facts along with the super graph edge. Here is an example of flow function:
![image](/image/flow_function.png)
Zero means the initialized state, so it is always true. When the statement `x.f = in` is excuted, it will create a edge from in to x.f in the flow fact. Just as the edges in super graph, there are four kinds flow function: normal flow function, call flow function, return flow function and callToReturn flow function.

---
#### From Dataflow Problem to Path Reachability Problem ####

After build the flow fact graph, the data flow problem can be converted to a path reachability problem. An edge (Sp, D1) -> (N, D2) states that the analysis concluded that D2 holds at N if D1 hotlds at point Sp, that is there is path from Sp to N in the super graph, as well a fact flow from D1 to D2 along with the path.

---
#### Algorithm for Reachability Problem ####

![](/image/algorithm.png)
This algorithm use PathEdge to record the valid flow fact edges in the IFDS problem. Summary edge is used to record the same-level realizable paths that run from nodes of the form (n, d1), where n belong to Call, to (returnSite (n), d2). In terms of the dataflow problem being solved, summary edges represent (partial) information about how the dataflow value after a call depends on the dataflow value before the call. WorkListaccumulates sets of path edges and summary edges.
If statement n is call statement(line 14-19), it will put path edge (Sp, d) -> (Sp, d) to the worklist. In this case path edge (Sp, d) -> (Sp, d) represents the 0-length suffix of a realizable path from (Smain, 0) -> (Sp, d). If there is a summary edge or edge in super graph, it will insert a path from call site to return site.
If statement n is exit statement(line 21-28), it will create a new summary edge in line 25. and add a path edge from call site to return site.
As for a normal statement, it will propagate flow fact and add path edge as well.

After this, the path edge will record all the flow fact infomation. If we want to calculate the data flow between variable a and b, we can chech a reachability of the flow fact. If we can find a flow fact path between a and b, a data dependency is found too.

<h6 id="1">[1]Reps T, Horwitz S, Sagiv M. Precise interprocedural dataflow analysis via graph reachability[C]//Proceedings of the 22nd ACM SIGPLAN-SIGACT symposium on Principles of programming languages. ACM, 1995: 49-61.</h6>
