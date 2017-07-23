+++
date = "2017-03-03T21:45:10+08:00"
draft = true
title = "Model-based Whitebox Fuzzing"
tags = [ "Fuzzing", "blog" ]
+++

Many real-world programs take highly structured and complex files as inputs. The automated testing of those programs is non-trivial. Traditional writebox test based on fuzzing or symbolic excution may produce inputs which do not satisfy file format. And blackbox test based on fuzzing can not reach the crash location quickly. Model-based Whitebox Fuzzing(MoWF) combine model-based blackbox fuzzing and the writebox fuzzing that generates valid files efficiently that exercise critical target lications effectively.

----
#### introduction ####
For some file-processing programs, the exercising of some paths may depend on the presense of a specific data chunk, a specific value of a data field in a data chunk or/and the intergrity of the data chunk. Hence, an efficient test generation technique not only sets specific values of the fields but also adds/removes complete chunks and establishes their integrity. Model-based blackbox fuzzers may generate valid random file which satisfy the file format. However, those random inputs can not guarantee high path coverange. Whitebox fuzzers empoly symbolic execution to explore program paths more systematically. Given a valid file, they can generate the specific value for data field quite comfortably. However, when it comes to adding or deleting data chunks or enforcing integrity constraints, they are bogged down by the large search space of invaild inputs.
MoWF is the marrige of model-based blackbox fuzzers and writebox fuzzers. Unlike model-based blackbox fuzzing, MoWF is directed and enumerates the specific values of data field more systematically. Unlike whitebox fuzzing, MoWF does not get bogged down by the large search space of invalid inputs or require any seed input files.

----
#### Model-based Whritebox Fuzzing ####
##### Initializztion #####
MoWF take a program *P* an input model *M*, a set of target location *L* in *P*, and seed input *T*. If no target location is provided, MoWF uses static analysis to identify dangerous lication in the program, such location for potential null pointer dereferences or divisions by zero. MoWF use IDAPro to dissamble the program binary *P* and perform some lightweight analysis to indetify instructions that conform th the patterns shown in the following list:

```
div register
div [ebp + argument_offset]
mov operand, [register]
mov operand, [ebp + argument_offset]
mov [register], operand
mov [ebp + argument_offset], operand
```

If there is no seed inputs provided, MoWF leverages the input model *M* to instantiate a seed file.

-----
##### Selection Seed file #####
MoWF selects an input *t* whose distance to target location *l* is smallest as seed file. The distance between an input *t* and a program location *l* is defined as follows.
```
Given an input t, a program P and a program location l in P. Let Ω(t) be the set of nodes in the Control Flow Graph (CFG) of P that are exercised by t. The distance δ(t, l) from t to l is the number of nodes on the shortest path from any b ∈ Ω(t) to l.
```
The remaining seed files are sent to the file cracker to construct the fragment pool. And the fragment pool take an important role during data chunk transplantation.

----
##### Determine crucial IFs #####
Next, MoWF executes *t* on *P* to determine the crucial IFs *N*. A crucial IFs is evaluated in different directions depending on the type of the data chunks prisent in *t*. The definition of Crucial IFs is as follows:
```
Given input t for program P and a target location l in P, an if-statement b in P is crucial if
1) the statement b is executed by t in P,
2) only one direction of b has been taken,
3) the negation of the branch condition at b reduces the distance to l, and
4) let φ(b) be the branch condition at b; the outcome of φ(b)
depends on a field in t that specifies the chunk’s type.
```
For each crucial IF identified, MoWF employs the file stitcher to negate its branch condition by adding or removing a chunk.

----
##### File Repair #####
Given a file *f* and the input model *M*, the file repair tool re-establishes the integrity of the file. MoWF utilizes the fixup and transformers that can be specified in *M* in the Peach framework.

----
##### Symbolic Execution #####
After creating the input file, MoWF reuses the target search strategy for symbolic exploration implemented in Herculers. The search stategy of Hercules is targeted in the sense that it explores program paths towards a target location by pruning irrelevant paths.

----
##### Handling Incomplete Memory Modeling #####
Hercules do not support memory allocation with symbolic size. If a symbolic size is given it is concretized before allocating heap memory. The concretization mechanism could prevent us from exposing heap buffer overflow vulnerabilities. In the extension of Hercules, they leverage recent advance in maximal satisfication with Z3 using a whitelist to mark certain clauses as "soft clauses".
