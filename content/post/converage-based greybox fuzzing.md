+++
date = "2016-08-08T21:45:10+08:00"
draft = true
title = "Coverage-based Fuzzing as Markov Chain"
tags = [ "Fuzzing", "blog" ]
+++

This paper introduced Markov Chain into greybox Fuzzing to explore the state space of programs more systematically. The chain specifies the probability that fuzzing an input that exercises path *i* generates an input that exercise path *j*. Then, they assign each fuzzed test input an energy that controls the amount of fuzz generated at each iteration. And they find that greybox fuzzing is most efficient if the exploration focuses on the low-density region. Meanwhile, they implemented the exponential schedule as an extention of AFL.

---
#### Introduction ####
Converage-based greybox fuzzing (CGF) is a path exploration strategy by fuzzing seed test input to find new excution path. CGF uses lightweigh instrumentation to determine a unique identifier for each program path that is exercised by a generated input. The fuzzer mutates the discovered seed inputs in a continuous loop. If a generated input exercises a new path, the fuzzer retains the input, otherwise it discard it. Increasing the efficiency of greybox fuzzing means to expose significantly more vulnerability and achieve more coverage within the same time. However, there is a tendency that most generated paths exercise few high-density region.
Markov chain is random process that undergoes transitions form one state to another on a state space. A famous use of Markov chains is for computation of the Google PageRank. In Coverage-based Fuzzing, they regard each path as a state, and the process to generate a new path *j* from discovered path *i* as state transition. And then, Markov Chain will determine the probability to reach *j* from *i*.

---
#### Markov Chain Model ####
The probability matrix P = (pij ) of the Markov chain is defined as follows. If path i is a discovered path exercised by ti ∈ T , then pij is the probability that randomly mutating ti generates an input that exercises the path j. Else if path i is an undiscovered path that is not exercised by some t ∈ T , pij = pji for all tj ∈ T . tj∈ T. In other words, without loss of generality they assume that generating tj from ti is as likely as generating ti from tj and that until the undiscovered path j is exercised it has no other undiscovered neighbors.
The stationary distribution π of the Markov chain gives the probability that a random walker that takes N steps spends roughly N πi time periods in state i. They call a high-density region of π a neighborhood of paths I where μi∈I (πi ) > μtj ∈T (πj ) and μ is the arithmetic mean. Similarly, we call a low-density region of π a neighborhood of paths I where μi∈I (πi) < μtj∈T(πj). To find more undiscovered paths, the strategies explore low-density regions more efficiently.

---
#### Boosting Greybox Fuzzing ####
The most efficient greybox fuzzer explores an undiscovered state in a low-density region while expending the least amount of energy. More specifically.
1. Search Strategy. The fuzzer chooses i ∈ S such that ∃j ∈ S − where πj is low and E[Xij ] is minimal.
2. Power Schedule. The fuzzer assigns the energy p(i) = E[Xij ] to the chosen state i in order to limit the fuzzing time to the minimum that is required to be expected to discover a path in a low-density region.

---
##### Power Schedules #####
Cut-Off Exponential (COE) is an exponential schedule that prevents high-frequency paths to be fuzzed until they become low-frequency paths. The COE increases the fuzzing time of ti exponentially each time s(i) that ti is chosen from the circular queue. The energy p(i) is computed as

![hello](/image/formular.png)

where β > 1 is a constant that puts the fuzzer in exploration mode for ti that have only recently been discovered (i.e., s(i) is low), and where μ is the mean number of fuzz exercising a discovered path

![test](/image/formular2.png)

where S is the set of discovered paths. Intuitively, high-frequency paths where f (i) > μ that receive a lot of fuzz even from fuzzing other test inputs are considered low-priority and not fuzzed at all until they are below the mean again. The constant M provides an upper bound on the number of test inputs that are generated per fuzzing iteration.

