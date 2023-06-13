------------------------ MODULE ShamirSecretSharing ------------------------
(***************************************************************************)
(* Sepcification for simple Shamir Secret Sharing. This is not a veriable  *)
(* secret sharing scheme.                                                  *)
(*                                                                         *)
(* We specify that dealer first sends shares to all players, and once all  *)
(* players have received their shares the can eventually reconstruct the   *)
(* secret.                                                                 *)
(*                                                                         *)
(* We do not deal with the communication protocol between players to send  *)
(* their shares to each other before reconstructing the secret.            *)
(***************************************************************************)

EXTENDS Integers, Sequences

CONSTANT
        Dealer,         \* The dealer sharing the secret with the players
        Players,        \* Set of all players
        Coefficients    \* The coefficient of the polynomial. These are provided by the model
        
VARIABLES
        shares,             \* Function mapping Player to computed shares
        shares_sent,        \* Function mapping Player to shares received
        shares_received,    \* Function mapping Player to received shares
        reconstructed       \* Function mapping Player to flag if secret
                            \* has been successfully constructed
        
vars == <<shares, shares_sent, shares_received, reconstructed>>
-----------------------------------------------------------------------------
NoValue == -1

Init == 
        \* Compute shares as a + bx + cx^2
        /\ shares = [p \in Players |-> Coefficients[1] + Coefficients[2] * p + Coefficients[3] * p ^ 2]
        /\ shares_sent = [p \in Players |-> NoValue]
        /\ shares_received = [p \in Players |-> NoValue]
        /\ reconstructed = [p \in Players |-> FALSE]

(***************************************************************************)
(* The type invariant for all variables.                                   *)
(***************************************************************************)
TypeOK ==
        /\ shares \in [Players -> Int]
        /\ shares_sent \in [Players -> Int]
        /\ shares_received \in [Players -> Int]
        /\ reconstructed \in [Players -> BOOLEAN]
-----------------------------------------------------------------------------

(***************************************************************************)
(* Send the share to Player p.                                             *)
(***************************************************************************)
SendShare(p) ==
        /\ shares_sent[p] = NoValue
        \* Send a share that has not been sent to anyone
        /\ shares_sent' = [shares_sent EXCEPT ![p] = shares[p]]
        /\ UNCHANGED <<shares, shares_received, reconstructed>>
        
(***************************************************************************)
(* Receive the share at Player p. It should have been sent before.         *)
(***************************************************************************)
ReceiveShare(p) ==
        /\ shares_received[p] = NoValue
        /\ shares_sent[p] # NoValue
        /\ shares_received' = [shares_received EXCEPT ![p] = shares_sent[p]]
        /\ UNCHANGED <<shares, shares_sent, reconstructed>>
                
(***************************************************************************)
(* Reconstruct secret at Player p. It should have been received            *)
(***************************************************************************)
Reconstruct(p) ==
        /\ shares_received[p] # NoValue
        /\ reconstructed' = [reconstructed EXCEPT ![p] = TRUE]
        /\ UNCHANGED <<shares, shares_sent, shares_received>>

-----------------------------------------------------------------------------
(***************************************************************************)
(* The next step either sends shares, receieves them or reconstructs the   *)
(* secret.                                                                 *)
(***************************************************************************)
Next == 
        \/ \exists p \in Players: 
            SendShare(p) \/ ReceiveShare(p) \/ Reconstruct(p)

Spec == 
        /\ Init
        /\ [][Next]_vars

(***************************************************************************)
(* Liveness states that eventually all players reconstruct the secret.     *)
(***************************************************************************)
Liveness == \A p \in Players: WF_vars(Reconstruct(p))

(***************************************************************************)
(* For a fair specification, we assure the spec takes next steps and       *)
(* liveness is guaranteed.                                                 *)
(***************************************************************************)
FairSpec == Spec /\ Liveness         
=============================================================================
\* Modification History
\* Last modified Tue Jun 13 21:26:31 CEST 2023 by kulpreet
\* Created Fri Jun 09 17:03:07 CEST 2023 by kulpreet
