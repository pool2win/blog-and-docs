---
layout: post
title: BFT Agreement and Threshold Signatures
---

Two distributed system protocols need to come and work together for
Braidpool to work. These are a 1) BFT consensus protocol and 2)
threshold signatures. In this post, I describe what each of these
provide and requirements from a network model for each of them.

A BFT consensus protocol will help all miners agree on the share of
work contributed over a given period of time. Whereas, a threshold
signature is required to custody the funds that will be distributed to
miners by the pool.

## BFT Consensus

In very simple terms the outcome of a byzantine fault tolerant
consensus is an agreement on a given value. If a threshold number of
parties are honest they will reach an agreed upon result that one of
them proposed.

### Asynchronous Network Model

BFT consensus protocols like HotStuff, Narwhal and Bullshark provide a
byzantine fault tolerant protocol in an asynchronous setting.

Let's say this is a solved problem and we pick one of these to provide
an agreement between miners on the amount of valid work contributed.


## Threshold Signatures

Threshold signatures provide a byzantine fault tolerant way for a
group of parties to sign a message without the secret key being known
to any single party.

Threshold signature protocols have requirements that are harder to
satisfy. In an earlier post on [FROST Library for Point to Point
Networks]({% post_url 2024-05-04-p2p-channels-for-frost %}), I
described the requirements for point to point and broadcast
communication channels.

### Partial Synchrony and Rounds

However, one key detail missing from the post on FROST channel
requirements was that FROST also requires the **partially
synchronous** communication model where parties make progress in
rounds.

If a party A doesn't receive a message from another party B in a given
"round", aka a time period, then A assumes B is faulty. This will
result in A excluding B from the next round of communication, even if
B still includes A in their next round. These discrepancies are then
resolved by FROST and similar round based protocols. The catch is that
the clocks of all parties are to be synchronised to within a fraction
of a round's time period. Which can also be read to mean that each
round has to be substantially larger than the maximum round trip
time between any two parties.

The GHOST DAG is a byzantine fault tolerant protocol that plays with a
round time period based on the size of the network. You can say the
round time period is dynamically defined by GHOST.

## Conclusion

A byzantine fault tolerant agreement protocol (non censorship
resistant) is possible in an asynchronous network model. The threshold
signature protocol however still requires a partial synchrony network
model.
