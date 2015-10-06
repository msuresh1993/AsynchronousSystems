------------------------ MODULE MC_timeclockcorrect ------------------------
EXTENDS timeclocks
CONSTANT NumOfNats, NumOfProcs
\*M == INSTANCE Mutex
\*THEOREM Spec => M!Spec
MC_Nat == 0 .. NumOfNats
MC_Proc == 1..NumOfProcs
\*MC_MNext == [ M!Next]_state
\*from lamport slides
Constraint == \A p \in Proc : clock[p] < NumOfNats \*lamport slides
MutualExclusion == \E p, q \in Proc : (p#q) => ({state[p], state[q]}) # "owner" 
StarvationFreedom == \A p \in Proc : (state[p] = "waiting") ~> (state[p] = "owner") \* the same as fairness (strong) 
\*end from lamport slides 
=============================================================================
\* Modification History
\* Last modified Tue Oct 06 01:35:55 EDT 2015 by ASUS
\* Created Mon Oct 05 03:05:52 EDT 2015 by ASUS
