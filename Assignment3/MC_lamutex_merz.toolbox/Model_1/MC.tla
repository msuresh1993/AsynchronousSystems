---- MODULE MC ----
EXTENDS MC_lamutex_merz, TLC

\* CONSTANT definitions @modelParameterConstants:0N
const_144409185320528000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:1maxClock
const_144409185321529000 == 
5
----

\* CONSTRAINT definition @modelParameterContraint:0
constr_144409185322630000 ==
ClockConstraint
----
\* SPECIFICATION definition @modelBehaviorSpec:0
spec_144409185323731000 ==
LiveSpec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_144409185324732000 ==
Mutex
----
\* PROPERTY definition @modelCorrectnessProperties:0
prop_144409185325833000 ==
Liveness
----
=============================================================================
\* Modification History
\* Created Mon Oct 05 20:37:33 EDT 2015 by ASUS
