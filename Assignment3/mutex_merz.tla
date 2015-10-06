----------------------------- MODULE mutex_merz -----------------------------

EXTENDS Naturals, TLC, Sequences  
CONSTANT Sites, any, maxClock

max(x,y) == IF x < y THEN y ELSE x
permSites == Permutations(Sites)

(* --algorithm MutexLamport
       variables 
      procQueue = [to \in Sites |-> [from \in Sites |-> <<>> ]];
      idS = {} ;

       macro send(to, msg)
       begin
         procQueue[to][self] := Append(procQueue[to][self], msg);
       end macro;

       macro recv(from, got)
       begin
         when procQueue[self][from] # <<>> ;
           got := Head(procQueue[self][from]);
         procQueue[self][from] := Tail(procQueue[self][from]);
       end macro;

       (* check if process may enter critical section: this is the case if:  *)
       (* 1. the request by this process is the oldest pending request and   *)
       (* 2. every other process has sent some message with higher clock     *)
       (*    value than that of the own request.                             *)
       macro check_access()
       begin
         enter_cs :=
            /\ reqClk[self] # 0 (* process wants access to critical section *)
            /\ \A p \in Sites :  (* condition 1 above *)
                  \/ p = self
                  \/ reqClk[p] = 0
                  \/ reqClk[self] < reqClk[p]
                  \/ reqClk[self] = reqClk[p] /\ self < p
            /\ \A p \in Sites : (* condition 2 above *)
                  \/ p = self
                  \/ msgClk[p] > reqClk[self];
       end macro;

       (* broadcast request to enter critical section to all other processes *)
       procedure bcst_request()
       begin
         bcrq1:  (* "atomic" must be labeled *)
           atomic
         bcrq2:  (* "foreach" must be labeled *)
         foreach p \in Sites \ {self} do
               send(p, [kind |-> "request", clk |-> myClk]);
         end foreach;
         bcrq3:  (* an atomic needs two labels so I put a label here ... *)
             reqClk[self] := myClk;
           end atomic;
         end_bcrq :
           return;      
       end procedure;

       (* broadcast free messages after exit from critical section *)
       procedure bcst_free()
         begin
          bcfr1:
            atomic
          bcfr2:
          foreach p \in Sites \ {self} do
        send(p, [kind |-> "free", clk |-> myClk]);
          end foreach;
          bcfr3:
              reqClk[self] := 0;
            end atomic;
          end_bcfr :
           return ;
       end procedure;

       (* scan mailbox for new messages from any process and handle *)
       (* the first waiting message from all processes              *)
       procedure handle_messages()
       variables rcvd = [kind |-> "", clk |-> 0];
       begin
         rcv_msg1:
           atomic
         rcv_msg2:
         foreach p \in Sites do
           if procQueue[self][p] # << >> then
         recv(p, rcvd);
         myClk := max(rcvd.clk, myClk) + 1;
         if rcvd.kind = "request" then
            (* remember clock value for new request *)
            reqClk[p] := rcvd.clk;
            send(p, [kind |-> "ack", clk |-> myClk]);
         elsif rcvd.kind = "free" then
            (* remove pending request from sending process *)
            reqClk[p] := 0;
         end if;
         (* in any case update the clock value for sending process *)
         msgClk[p] := rcvd.clk;
           end if;
         end foreach;
         rcv_msg3:
             skip;
           end atomic;
         end_rcv :
       return;
       end procedure;

       process Site \in Sites
       variables
          myClk = 1,          (* current clock reading *)
          enter_cs = FALSE,   (* permission to enter crit. sect. *)
          reqClk = [p \in Sites |-> 0], 
              (* clock for last request received per process (0 iff no request) *)
          msgClk = [p \in Sites |-> 0];
              (* last clock value received in any message, per process *)
       begin
         site:
           while myClk < maxClock do      (* force finite state space *)
         ncs:
           either
                  call bcst_request();    (* request critical section *)
           or
                  call handle_messages(); (* handle messages and loop *)
                continue:
                  goto ncs;
               end either;
         try:
           while ~ enter_cs do
                  call handle_messages();
                check:
                  check_access();
           end while;
         cs:
           skip;
         exit:
               enter_cs := FALSE;
               call bcst_free();
           end while;
       end process;
  end algorithm
*)
\* BEGIN TRANSLATION 
VARIABLES procQueue, idS, cp, depth, pc, stack, rcvd, Site_data

vars == << procQueue, idS, cp, depth, pc, stack, rcvd, Site_data >>

ProcSet == (Sites)

Init == (* Global variables *)
        /\ procQueue = [to \in Sites |-> [from \in Sites |-> <<>> ]]
        /\ idS = {}
        /\ cp = any
        /\ depth = 0
        (* Procedure handle_messages *)
        /\ rcvd = [ self \in ProcSet |-> [kind |-> "", clk |-> 0]]
        (* Process Site *)
        /\ Site_data = [self \in Sites |-> [ myClk |-> 0,
                                             enter_cs |-> FALSE,
                                             reqClk |-> [p \in Sites |-> 0],
                                             msgClk |-> [p \in Sites |-> 0]]]
        /\ stack = [self \in ProcSet |-> << >>]
        /\ pc = [self \in ProcSet |-> CASE self \in Sites -> "site"]

bcrq1(self) == /\ pc[self] = "bcrq1"
               /\ cp = any \/ cp = self
               /\ cp' = self
               /\ depth' = depth + 1
               /\ pc' = [pc EXCEPT ![self] = "bcrq2" ]
               /\ UNCHANGED << procQueue, idS, stack, rcvd, Site_data >>

bcrq2(self) == /\ pc[self] = "bcrq2"
               /\ cp = self
               /\ IF Sites \ {self} # {} /\ idS = {}
                     THEN LET _idS == Sites \ {self} IN
                          /\ pc' = [pc EXCEPT ![self] = "bcrq2" ]
                          /\ idS' = _idS
                          /\ UNCHANGED procQueue
                     ELSE /\ IF Sites \ {self} # {}
                                THEN /\ LET p == CHOOSE p \in idS : TRUE IN
                                        LET _procQueue == [procQueue EXCEPT ![p][self] = Append(procQueue[p][self], ([kind |-> "request", clk |->Site_data[self]. myClk]))] IN
                                        LET _idS == idS \ { p } IN
                                        /\ IF _idS # {} (* !!! *)
                                              THEN /\ pc' = [pc EXCEPT ![self] = "bcrq2" ]
                                                   /\ procQueue' = _procQueue
                                                   /\ idS' = _idS
                                              ELSE /\ pc' = [pc EXCEPT ![self] = "bcrq3" ]
                                                   /\ procQueue' = _procQueue
                                                   /\ idS' = _idS
                                ELSE /\ pc' = [pc EXCEPT ![self] = "bcrq3" ]
                                     /\ UNCHANGED << procQueue, idS >>
               /\ UNCHANGED << cp, depth, stack, rcvd, Site_data >>

bcrq3(self) == LET _reqClk == [Site_data[self].reqClk EXCEPT 
                                 ![self] = Site_data[self].myClk] IN
               /\ pc[self] = "bcrq3"
               /\ cp = self
               /\ depth' = depth - 1
               /\ cp' = IF depth - 1 = 0 THEN any ELSE self
               /\ pc' = [pc EXCEPT ![self] = "end_bcrq" ]
               /\ Site_data' = [Site_data EXCEPT ![self].reqClk = _reqClk]
               /\ UNCHANGED << procQueue, idS, stack, rcvd >>

end_bcrq(self) == /\ pc[self] = "end_bcrq"
                  /\ cp = any \/ cp = self
                  /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc ]
                  /\ stack' = [stack EXCEPT ![self] = Tail(stack[self]) ]
                  /\ UNCHANGED << procQueue, idS, cp, depth, rcvd, Site_data >>

bcst_request(self) == bcrq1(self) \/ bcrq2(self) \/ bcrq3(self)
                         \/ end_bcrq(self)

bcfr1(self) == /\ pc[self] = "bcfr1"
               /\ cp = any \/ cp = self
               /\ cp' = self
               /\ depth' = depth + 1
               /\ pc' = [pc EXCEPT ![self] = "bcfr2" ]
               /\ UNCHANGED << procQueue, idS, stack, rcvd, Site_data >>

bcfr2(self) == /\ pc[self] = "bcfr2"
               /\ cp = self
               /\ IF Sites \ {self} # {} /\ idS = {}
                     THEN LET _idS == Sites \ {self} IN
                          /\ pc' = [pc EXCEPT ![self] = "bcfr2" ]
                          /\ idS' = _idS
                          /\ UNCHANGED procQueue
                     ELSE /\ IF Sites \ {self} # {}
                                THEN /\ LET p == CHOOSE p \in idS : TRUE IN
                                        LET _procQueue == [procQueue EXCEPT ![p][self] = Append(procQueue[p][self], ([kind |-> "free", clk |->Site_data[self]. myClk]))] IN
                                        LET _idS == idS \ { p } IN
                                        /\ IF _idS # {}  (* !!! *)
                                              THEN /\ pc' = [pc EXCEPT ![self] = "bcfr2" ]
                                                   /\ procQueue' = _procQueue
                                                   /\ idS' = _idS
                                              ELSE /\ pc' = [pc EXCEPT ![self] = "bcfr3" ]
                                                   /\ procQueue' = _procQueue
                                                   /\ idS' = _idS
                                ELSE /\ pc' = [pc EXCEPT ![self] = "bcfr3" ]
                                     /\ UNCHANGED << procQueue, idS >>
               /\ UNCHANGED << cp, depth, stack, rcvd, Site_data >>

bcfr3(self) == LET _reqClk == [Site_data[self].reqClk EXCEPT 
                                 ![self] = 0] IN
               /\ pc[self] = "bcfr3"
               /\ cp = self
               /\ depth' = depth - 1
               /\ cp' = IF depth - 1 = 0 THEN any ELSE self
               /\ pc' = [pc EXCEPT ![self] = "end_bcfr" ]
               /\ Site_data' = [Site_data EXCEPT ![self].reqClk = _reqClk]
               /\ UNCHANGED << procQueue, idS, stack, rcvd >>

end_bcfr(self) == /\ pc[self] = "end_bcfr"
                  /\ cp = any \/ cp = self
                  /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc ]
                  /\ stack' = [stack EXCEPT ![self] = Tail(stack[self]) ]
                  /\ UNCHANGED << procQueue, idS, cp, depth, rcvd, Site_data >>

bcst_free(self) == bcfr1(self) \/ bcfr2(self) \/ bcfr3(self)
                      \/ end_bcfr(self)

rcv_msg1(self) == /\ pc[self] = "rcv_msg1"
                  /\ cp = any \/ cp = self
                  /\ cp' = self
                  /\ depth' = depth + 1
                  /\ pc' = [pc EXCEPT ![self] = "rcv_msg2" ]
                  /\ UNCHANGED << procQueue, idS, stack, rcvd, Site_data >>

rcv_msg2(self) == /\ pc[self] = "rcv_msg2"
                  /\ cp = self
                  /\ IF Sites # {} /\ idS = {}
                        THEN LET _idS == Sites IN
                             /\ pc' = [pc EXCEPT ![self] = "rcv_msg2" ]
                             /\ idS' = _idS
                             /\ UNCHANGED << procQueue, rcvd, Site_data >>
                        ELSE /\ IF Sites # {}
                                   THEN /\ LET p == CHOOSE p \in idS : TRUE IN
                                         /\ IF procQueue[self][p] # << >>
                                               THEN LET _rcvd == Head(procQueue[self][p]) IN
                                                    LET _procQueue == [procQueue EXCEPT ![self][p] = Tail(procQueue[self][p])] IN
                                                    LET _myClk == max(_rcvd.clk,Site_data[self]. myClk) + 1 IN
                                                    /\ procQueue[self][p] # <<>>
                                                    /\ IF _rcvd.kind = "request"
                                                          THEN LET _reqClk == [Site_data[self].reqClk EXCEPT 
                                                                                 ![p] = _rcvd.clk] IN
                                                               LET __procQueue == [_procQueue EXCEPT ![p][self] = Append(_procQueue[p][self], ([kind |-> "ack", clk |-> _myClk]))] IN
                                                               LET _msgClk == [Site_data[self].msgClk EXCEPT 
                                                                                 ![p] = _rcvd.clk] IN
                                                               LET _idS == idS \ { p } IN
                                                               /\ IF _idS # {} (* !!! *)
                                                                     THEN /\ pc' = [pc EXCEPT ![self] = "rcv_msg2" ]
                                                                          /\ procQueue' = __procQueue
                                                                          /\ idS' = _idS
                                                                          /\ rcvd' = [rcvd EXCEPT ![self] = _rcvd ]
                                                                          /\ Site_data' = [Site_data EXCEPT ![self].myClk = _myClk ,
                                                                                                            ![self].reqClk = _reqClk ,
                                                                                                            ![self].msgClk = _msgClk]
                                                                     ELSE /\ pc' = [pc EXCEPT ![self] = "rcv_msg3" ]
                                                                          /\ procQueue' = __procQueue
                                                                          /\ idS' = _idS
                                                                          /\ rcvd' = [rcvd EXCEPT ![self] = _rcvd ]
                                                                          /\ Site_data' = [Site_data EXCEPT ![self].myClk = _myClk ,
                                                                                                            ![self].reqClk = _reqClk ,
                                                                                                            ![self].msgClk = _msgClk]
                                                          ELSE /\ IF _rcvd.kind = "free"
                                                                     THEN LET _reqClk == [Site_data[self].reqClk EXCEPT 
                                                                                            ![p] = 0] IN
                                                                          LET _msgClk == [Site_data[self].msgClk EXCEPT 
                                                                                            ![p] = _rcvd.clk] IN
                                                                          LET _idS == idS \ { p } IN
                                                                          /\ IF _idS # {} (* !!! *)
                                                                                THEN /\ pc' = [pc EXCEPT ![self] = "rcv_msg2" ]
                                                                                     /\ procQueue' = _procQueue
                                                                                     /\ idS' = _idS
                                                                                     /\ rcvd' = [rcvd EXCEPT ![self] = _rcvd ]
                                                                                     /\ Site_data' = [Site_data EXCEPT ![self].myClk = _myClk ,
                                                                                                                       ![self].reqClk = _reqClk ,
                                                                                                                       ![self].msgClk = _msgClk]
                                                                                ELSE /\ pc' = [pc EXCEPT ![self] = "rcv_msg3" ]
                                                                                     /\ procQueue' = _procQueue
                                                                                     /\ idS' = _idS
                                                                                     /\ rcvd' = [rcvd EXCEPT ![self] = _rcvd ]
                                                                                     /\ Site_data' = [Site_data EXCEPT ![self].myClk = _myClk ,
                                                                                                                       ![self].reqClk = _reqClk ,
                                                                                                                       ![self].msgClk = _msgClk]
                                                                     ELSE LET _msgClk == [Site_data[self].msgClk EXCEPT 
                                                                                            ![p] = _rcvd.clk] IN
                                                                          LET _idS == idS \ { p } IN
                                                                          /\ IF _idS # {} (* !!! *)
                                                                                THEN /\ pc' = [pc EXCEPT ![self] = "rcv_msg2" ]
                                                                                     /\ procQueue' = _procQueue
                                                                                     /\ idS' = _idS
                                                                                     /\ rcvd' = [rcvd EXCEPT ![self] = _rcvd ]
                                                                                     /\ Site_data' = [Site_data EXCEPT ![self].myClk = _myClk ,
                                                                                                                       ![self].msgClk = _msgClk]
                                                                                ELSE /\ pc' = [pc EXCEPT ![self] = "rcv_msg3" ]
                                                                                     /\ procQueue' = _procQueue
                                                                                     /\ idS' = _idS
                                                                                     /\ rcvd' = [rcvd EXCEPT ![self] = _rcvd ]
                                                                                     /\ Site_data' = [Site_data EXCEPT ![self].myClk = _myClk ,
                                                                                                                       ![self].msgClk = _msgClk]
                                               ELSE LET _idS == idS \ { p } IN
                                                    /\ IF _idS # {} (* !!! *)
                                                          THEN /\ pc' = [pc EXCEPT ![self] = "rcv_msg2" ]
                                                               /\ idS' = _idS
                                                          ELSE /\ pc' = [pc EXCEPT ![self] = "rcv_msg3" ]
                                                               /\ idS' = _idS
                                                    /\ UNCHANGED << procQueue, 
                                                                    rcvd, 
                                                                    Site_data >>
                                   ELSE /\ pc' = [pc EXCEPT ![self] = "rcv_msg3" ]
                                        /\ UNCHANGED << procQueue, idS, rcvd, 
                                                        Site_data >>
                  /\ UNCHANGED << cp, depth, stack >>

rcv_msg3(self) == /\ pc[self] = "rcv_msg3"
                  /\ cp = self
                  /\ TRUE
                  /\ depth' = depth - 1
                  /\ cp' = IF depth - 1 = 0 THEN any ELSE self
                  /\ pc' = [pc EXCEPT ![self] = "end_rcv" ]
                  /\ UNCHANGED << procQueue, idS, stack, rcvd, Site_data >>

end_rcv(self) == LET _rcvd == Head(stack[self]).rcvd IN
                 /\ pc[self] = "end_rcv"
                 /\ cp = any \/ cp = self
                 /\ pc' = [pc EXCEPT ![self] = Head(stack[self]).pc ]
                 /\ stack' = [stack EXCEPT ![self] = Tail(stack[self]) ]
                 /\ rcvd' = [rcvd EXCEPT ![self] = _rcvd ]
                 /\ UNCHANGED << procQueue, idS, cp, depth, Site_data >>

handle_messages(self) == rcv_msg1(self) \/ rcv_msg2(self)
                            \/ rcv_msg3(self) \/ end_rcv(self)

site(self) == /\ pc[self] = "site"
              /\ cp = any
              /\ IF Site_data[self].myClk < maxClock
                    THEN /\ pc' = [pc EXCEPT ![self] = "ncs" ]
                    ELSE /\ pc' = [pc EXCEPT ![self] = "Done" ]
              /\ UNCHANGED << procQueue, idS, cp, depth, stack, rcvd, 
                              Site_data >>

ncs(self) == /\ pc[self] = "ncs"
             /\ cp = any
             /\ \/ /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "bcst_request",
                                                            pc        |->  "try" ] >>
                                                        \o stack[self] ]
                   /\ pc' = [pc EXCEPT ![self] = "bcrq1" ]
                   /\ UNCHANGED rcvd
                \/ LET _rcvd == [kind |-> "", clk |-> 0] IN
                   /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "handle_messages",
                                                            pc        |->  "continue",
                                                            rcvd      |->  rcvd[self] ] >>
                                                        \o stack[self] ]
                   /\ pc' = [pc EXCEPT ![self] = "rcv_msg1" ]
                   /\ rcvd' = [rcvd EXCEPT ![self] = _rcvd ]
             /\ UNCHANGED << procQueue, idS, cp, depth, Site_data >>

continue(self) == /\ pc[self] = "continue"
                  /\ cp = any
                  /\ pc' = [pc EXCEPT ![self] = "ncs" ]
                  /\ UNCHANGED << procQueue, idS, cp, depth, stack, rcvd, 
                                  Site_data >>

try(self) == /\ pc[self] = "try"
             /\ cp = any
             /\ IF ~Site_data[self]. enter_cs
                   THEN LET _rcvd == [kind |-> "", clk |-> 0] IN
                        /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "handle_messages",
                                                                 pc        |->  "check",
                                                                 rcvd      |->  rcvd[self] ] >>
                                                             \o stack[self] ]
                        /\ pc' = [pc EXCEPT ![self] = "rcv_msg1" ]
                        /\ rcvd' = [rcvd EXCEPT ![self] = _rcvd ]
                   ELSE /\ pc' = [pc EXCEPT ![self] = "cs" ]
                        /\ UNCHANGED << stack, rcvd >>
             /\ UNCHANGED << procQueue, idS, cp, depth, Site_data >>

check(self) == LET _enter_cs == /\Site_data[self]. reqClk[self] # 0
                                /\ \A p \in Sites :
                                      \/ p = self
                                      \/Site_data[self]. reqClk[p] = 0
                                      \/Site_data[self]. reqClk[self] <Site_data[self]. reqClk[p]
                                      \/Site_data[self]. reqClk[self] =Site_data[self]. reqClk[p] /\ self < p
                                /\ \A p \in Sites :
                                      \/ p = self
                                      \/Site_data[self]. msgClk[p] >Site_data[self]. reqClk[self] IN
               /\ pc[self] = "check"
               /\ cp = any
               /\ pc' = [pc EXCEPT ![self] = "try" ]
               /\ Site_data' = [Site_data EXCEPT ![self].enter_cs = _enter_cs]
               /\ UNCHANGED << procQueue, idS, cp, depth, stack, rcvd >>

cs(self) == /\ pc[self] = "cs"
            /\ cp = any
            /\ TRUE
            /\ pc' = [pc EXCEPT ![self] = "exit" ]
            /\ UNCHANGED << procQueue, idS, cp, depth, stack, rcvd, Site_data >>

exit(self) == LET _enter_cs == FALSE IN
              /\ pc[self] = "exit"
              /\ cp = any
              /\ stack' = [stack EXCEPT ![self] = << [ procedure |->  "bcst_free",
                                                       pc        |->  "site" ] >>
                                                   \o stack[self] ]
              /\ pc' = [pc EXCEPT ![self] = "bcfr1" ]
              /\ Site_data' = [Site_data EXCEPT ![self].enter_cs = _enter_cs]
              /\ UNCHANGED << procQueue, idS, cp, depth, rcvd >>

Site(self) == site(self) \/ ncs(self) \/ continue(self) \/ try(self)
                 \/ check(self) \/ cs(self) \/ exit(self)

Next == (\E self \in ProcSet:  \/ bcst_request(self) \/ bcst_free(self)
                               \/ handle_messages(self))
           \/ (\E self \in Sites: Site(self))
           \/ (* Disjunct to prevent deadlock on termination *)
              (\A self \in ProcSet: pc[self] = "Done" /\ UNCHANGED vars)

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 
qInv == \A p,q \in Sites: Len(procQueue[p][q]) < 3

Mutex == \A p,q \in Sites : 
            (pc[p] = "cs" /\ pc[q] = "cs") => p = q
Fairness ==
  (* progress hypothesis for all processes (including procedures), 
     but needs to be written as strong fairness because of the atomic blocks *)
  /\ \A p \in Sites : SF_vars(Site(p))
  /\ \A p \in ProcSet :
          /\ SF_vars(bcst_request(p))
          /\ SF_vars(bcst_free(p))
          /\ SF_vars(handle_messages(p))
AlwaysReleases == \A p \in Sites : WF_vars(exit(p))
LiveSpec == Init /\ [][Next]_vars /\ Fairness /\ AlwaysReleases

Live == \A p \in Sites :
            pc[p] = "try" ~> pc[p] = "cs"

=============================================================================
\* Modification History
\* Last modified Mon Oct 05 20:41:02 EDT 2015 by ASUS
\* Created Mon Oct 05 12:53:14 EDT 2015 by ASUS
