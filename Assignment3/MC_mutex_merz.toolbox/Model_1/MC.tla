---- MODULE MC ----
EXTENDS MC_mutex_merz, TLC

\* CONSTANT definitions @modelParameterConstants:0Sites
const_1444093781586151000 == 
MC_Sites
----

\* CONSTANT definitions @modelParameterConstants:1any
const_1444093781596152000 == 
0
----

\* CONSTANT definitions @modelParameterConstants:2maxClock
const_1444093781606153000 == 
5
----

\* CONSTANT definitions @modelParameterConstants:3NumOfSites
const_1444093781617154000 == 
2
----

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_1444093781627155000 ==
LiveSpec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_1444093781637156000 ==
Mutex
----
\* PROPERTY definition @modelCorrectnessProperties:0
prop_1444093781647157000 ==
Live
----
=============================================================================
\* Modification History
\* Created Mon Oct 05 21:09:41 EDT 2015 by ASUS
