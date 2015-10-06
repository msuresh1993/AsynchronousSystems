---- MODULE MC ----
EXTENDS TimeClockCorrectness, TLC

\* CONSTANT definitions @modelParameterConstants:0Proc
const_14440278695471044000 == 
MC_Proc
----

\* CONSTANT definitions @modelParameterConstants:1\ll(a, b)
const_14440278695631045000(a, b) == 
a<b
----

\* CONSTANT definitions @modelParameterConstants:2NumOfProcs
const_14440278695791046000 == 
2
----

\* CONSTANT definitions @modelParameterConstants:3NumOfNats
const_14440278695941047000 == 
5
----

\* CONSTANT definition @modelParameterDefinitions:0
def_ov_14440278696101048000 ==
MC_Nat
----
\* CONSTRAINT definition @modelParameterContraint:0
constr_14440278696251049000 ==
Constraint
----
\* SPECIFICATION definition @modelBehaviorSpec:0
spec_14440278696411050000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_14440278696571051000 ==
\A p, q \in Proc : (p #q) => ({state[p], state[q]} #{"owner"})
----
\* PROPERTY definition @modelCorrectnessProperties:0
prop_14440278696721052000 ==
\A p \in Proc : (state[p] =  "waiting" ) ~> (state[p] =  "owner" )
----
=============================================================================
\* Modification History
\* Created Mon Oct 05 02:51:09 EDT 2015 by ASUS
