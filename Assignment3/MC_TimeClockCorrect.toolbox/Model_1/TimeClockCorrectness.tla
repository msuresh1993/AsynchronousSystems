------------------------ MODULE TimeClockCorrectness ------------------------
EXTENDS timeclocks
CONSTANT NumOfNats, NumOfProcs
\*M == INSTANCE Mutex
\*THEOREM Spec => M!Spec
MC_Nat == 0 .. NumOfNats
MC_Proc == 1..NumOfProcs
\*MC_MNext == [ M!Next]_state
Constraint == \A p \in Proc : clock[p] < NumOfNats
=============================================================================
\* Modification History
\* Last modified Mon Oct 05 02:47:46 EDT 2015 by ASUS
\* Created Mon Oct 05 00:12:51 EDT 2015 by ASUS
