---- MODULE MC ----
EXTENDS timeclocks, TLC

\* CONSTANT definitions @modelParameterConstants:0Proc
const_144401933821044000 == 
MC_Proc
----

\* CONSTANT definitions @modelParameterConstants:1\ll(X, Y)
const_144401933822045000(X, Y) == 
<
----

\* CONSTANT definition @modelParameterDefinitions:0
def_ov_144401933823146000 ==
MC_Nat
----
\* SPECIFICATION definition @modelBehaviorSpec:0
spec_144401933824147000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_144401933825248000 ==
\A p, q \in Proc : (p #q) => ({state[p], state[q]} #{"owner"})
----
\* PROPERTY definition @modelCorrectnessProperties:0
prop_144401933826249000 ==
\A p \in Proc : (state[p] =  "waiting" ) ~> (state[p] =  "owner" )
----
=============================================================================
\* Modification History
\* Created Mon Oct 05 00:28:58 EDT 2015 by ASUS
