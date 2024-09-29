---
layout: post
title: FROST KeyGen For Frost Federation With Broadcast
---

In this post we explain why we plan to use the implementation of FROST
KeyGen from ZF FROST crate and how we by pass a well understood
requirement for an agreement protocol in the second round of KeyGen.

### FROST KeyGen And Need For Agreement

[FROST](https://eprint.iacr.org/2020/852) specifies a KeyGen protocol
and provides an implementation in Rust as part of the [ZF
FROST](https://github.com/ZcashFoundation/frost) crate. We will use
the ZF FROST crate for threshold signatures and since the crate is the
best reviewed FROST implementation, we also want to use the DKG
implementation provided by the crate.

There is a small [problem with FROST
KeyGen](https://github.com/ZcashFoundation/frost/issues/577), in that
it requires an agreement in the second round. There are other ongoing
efforts to provide a DKG without agreement, most notably
[ChillDKG](https://github.com/BlockstreamResearch/bip-frost-dkg),
however, the motivational use cases for ChillDKG are hardware wallets
that won't be always connected and online.

### Bracha's Broadcast As An Alternative

The [FROST book](https://frost.zfnd.org/) points to using an
echo-broadcast to provide reliable BFT broadcast by
[Goldwasser-Lindell
2003](https://eprint.iacr.org/2002/040.pdf). [Bracha](https://dl.acm.org/doi/10.1145/800222.806743)
pointed out that a BFT reliable broadcast is enough for executing MPC
protocols. Using Bracha's protocol, we'll get robustness, however we
limit t < n/3.

For the sake of simplicity, we plan to use Bracha's BFT broadcast for
enabling FROST KeyGen. The advantage is that Bracha's echo broadcast
protocol is well understood and reviewed. The disadvantage is that it
is not the most efficient protocol. However, we need to run a DKG once
every two weeks or even less frequently between 50 to 1000 parties. If
we take another minute to run the DKG we will be fine. Especially,
since the mining protocol that depends on FROST is delay tolerant. We
have written about the the mining protocol's use of FROST in other
posts on this blog.

However, if we find that Bracha is too slow after initial experiments,
there are other alternatives too, for example
[Cachin's](https://ieeexplore.ieee.org/abstract/document/1541196)
information dispersal protocol.

### How Reliable BFT Broadcast Solves The KeyGen Issue?

This is how we can use Bracha's protocol during round 2 of FROST
KeyGen. We add a new step 1.1 right after step 1 of round 2 of FROST
KeyGen.

The new step 1.1 requires that

1. Each party reliably broadcasts a hash of their secret share (l,
f_i(l)) using Bracha's protocol.
1. Each party waits till it has accepted the required threshold, T,
number of share hashes. This threshold, T, is the threshold parameter
to the FROST instance.
1. Continue to step 2 of round 2 from FROST KeyGen.

The broadcast protocol makes sure that is a party accepts a hash of a
share, then every other correct process will eventually accept the
hash of the share. With t < n/3 for the broadcast, in the above
example A can't equivocate.


### Links

There is a
[discussion](https://github.com/ZcashFoundation/frost/issues/577#issuecomment-2353520613)
around this proposal on the ZF FROST github repo.
