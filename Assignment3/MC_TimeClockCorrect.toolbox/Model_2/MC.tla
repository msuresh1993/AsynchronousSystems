---- MODULE MC ----
EXTENDS MC_timeclockcorrect, TLC

\* CONSTANT definitions @modelParameterConstants:0Proc
const_1444096460119328000 == 
MC_Proc
----

\* CONSTANT definitions @modelParameterConstants:1NumOfProcs
const_1444096460129329000 == 
4
----

\* CONSTANT definitions @modelParameterConstants:2NumOfNats
const_1444096460139330000 == 
3
----

\* CONSTANT definitions @modelParameterConstants:3\ll(num1, num2)
const_1444096460149331000(num1, num2) == 
num1 < num2
----

\* CONSTANT definition @modelParameterDefinitions:0
def_ov_1444096460159332000 ==
MC_Nat
----
\* CONSTRAINT definition @modelParameterContraint:0
constr_1444096460170333000 ==
Constraint
----
\* SPECIFICATION definition @modelBehaviorSpec:0
spec_1444096460180334000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_1444096460191335000 ==
MutualExclusion
----
\* PROPERTY definition @modelCorrectnessProperties:0
prop_1444096460202336000 ==
Liveness
----
\* PROPERTY definition @modelCorrectnessProperties:1
prop_1444096460212337000 ==
StarvationFreedom
----
=============================================================================
\* Modification History
\* Created Mon Oct 05 21:54:20 EDT 2015 by ASUS
