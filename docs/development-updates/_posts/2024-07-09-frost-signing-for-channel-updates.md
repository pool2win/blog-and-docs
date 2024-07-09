---
layout: post
title: FROST Threshold Signatures for Multiple Channel Updates
---

Chris Belcher proposed a [hub based payout solution for
P2Pool](https://bitcointalk.org/index.php?topic=2135429.0) that won't
consume blockspace linearly with number of miners in a pool. The
drawback of the approach was the requirement for a centralised
hub. Belcher showed how that can be overcome using multiple hubs that
each manage a fraction of the payouts. With Schnorr Signature now
available in Bitcoin and advances in Threshold Signatures theory and
practice, I show in this post how the hub based model will work with
FROST Threshold Signatures.

# Hub Based Payouts

I had [slightly modified Belcher's
construction](https://github.com/pool2win/blog-and-docs/blob/badb88046eef875867ed7084904bc378c6ccf073/proposal/proposal.pdf)
to convert the channel from bidirectional to a one way payment
channel. After all, the miner doesn't need to pay the hub. I use this
modified construction in the rest of the post.

The hub based payout mechanism has two components:

1. A coinbase that pays to hub and miner, or to the hub on revealing a
preimage, or to the miner after a timeout.
![coinbase]({{site.baseurl}}/assets/coinbase.png){:style="float: left; width: 100%;"}
2. Multisig payment channel like construction between the Hub and each miner.
![funding-tx]({{site.baseurl}}/assets/funding-tx.png){:style="float: left; width="100%" }

There is also a protocol to release payments to miners once the pool
finds a block. The construction doesn't allow the hub to deny payout
to miners once the bitcoin block is found. Refer to my proposal or
Belcher's post on bitcoin talk for details.

# Replacing the Hub with a Federation

We ideally want to move to a fully decentralised mining pool. However,
the requirement for miners to run services and maintain them is too
much of a friction point. Instead, we can make substantial leaps by
moving to an open source federated pool that anyone can join to help
decentralise bitcoin mining and earn some bitcoin yield in the
process. The full design of such a pool is still a work in progress
and I will write that out in detail soon. In this post, I focus only
on the part where once a bitcoin block is found the hub (the
federation in our case) has to update the funding transaction with new
balances for all miners.

The question has been how can we arrange a federation to sign
thousands of such funding transaction using a threshold signature
scheme. The answer is in precomputing the nonces (as FROST recommends)
and then at the time of signing, have all the parties broadcast their
shares to all other parties. Each party then has access to all the
signed funding transactions.

The rounds required to generate nonces are run a priori, so they are
not on the critical path of signature generation.

When we need to generate a signature, the following protocol is
run. This protocol is loosely defined here to communicate the high
level picture only.

1. All federation members compute the new balances due to all
   miners.Remember this payout is for a block discovered a 100
   blocks ago. So all members have built a consistent view by now of
   the shares from 100 blocks ago. More on how this eventual
   consistency is achieved in the write up about the federated pool
   that is coming soon.
2. All members have a consistent updated funding transaction for each
   miner.
3. Given everyone has the message and the nonces, they immediately use
   their current public key share that was computed earlier using
   Pedersen's DKG and broadcast their share of all the signatures for each
   transaction to all members.
4. Once a member has received all of the above broadcasts for itself,
   it can immediately construct the signature and hand it to the
   miners.

# Complexity

The above has the communication complexity of $O(n^2)$ as all members
send one message to all other members. However, the round complexity
is one. Everyone sends all the messages in the same round. In case of
failures, we need to run the round again and we can parallelise these
rounds as proposed by [ROAST](https://eprint.iacr.org/2022/550.pdf).

# Conclusion

Signing all the channel updates in Belcher's construction definitely
seems doable. I want to wrap up my work with FROST Federation and then
simulate such a round to measure the latencies for 10, 50 and 100
member strong federation.
