---
layout: post
title: FROST Library for Point to Point Networks
---

This post outlines the communication requirements for implementing
FROST in a point to point communication model, and describe my plans
to build a Rust library providing FROST in a such network model. The
library will be used to build a decentralised mining solution for
bitcoin.

## Motivation

Threshold Signatures in point to point networks enable multiple
parties to agree on the state of system at regular intervals. This
enables applications where members of the network need to agree on a
state and create a joint signature to make progress.

The prime motivation for working on this is to provide a decentralised
mining solution. When miners co-ordinate over a P2P network they need
to collectively sign bitcoin transactions for paying out all the
miners in proportion to the work done by miners. Threshold signatures
will allow producing signatures for the transactions. Members will
also indirectly agree on the proportion of work done when they agree
on the payout amounts for all miners before the sign a bitcoin
transaction.

## FROST Communication Requirements

To implement FROST both broadcast and one to one communication
channels are required. This post highlights these requirements and
present the design we follow for building a decentralised mining
solution.

### Unicast Channels

From section on [peer to peer
channels](https://frost.zfnd.org/terminology.html#peer-to-peer-channel)

1. Authenticated
1. Reliable
1. Confidential
1. Unordered

Authentication and Confidentiality are satisfied by using [Noise_XX
protocol](https://noiseprotocol.org/noise.html). `XX` implies both
parties transmit their static keys. The `XX` handshake supports mutual
authentication and transmission of static public keys and therefore
provides the requirements of Authentication and Confidential channels
between any two parties.

Reliability is satisfied by using point to point noise channels using
TCP.

Unordered communication is a relaxation on the requirements and
therefore we don't need to address it further.

### Broadcast Channels

From section on [broadcast
channels](https://frost.zfnd.org/terminology.html#broadcast-channel)

1. **Consistent**. Each participant has the same view of the message
   sent over the channel.
2. **Authenticated**. Players know that the message was in fact sent
   by the claimed sender. In practice, this requirement is often
   fulfilled by a PKI.
3. **Reliable Delivery**. Player $i$ knows that the message it sent
   was in fact received by the intended participants.
4. **Unordered**. The channel does not guarantee ordering of messages.

According to FROST documentation the [echo-broadcast
protocol](https://eprint.iacr.org/2002/040) is sufficient and we don't
need a byzantine broadcast channel. We therefore provide an
implementation of the echo-broadcast protocol on top of point to point
noise channels.

With the point to point noise channels on TCP we get Authenticated,
Reliable and Ordered broadcast. Consistency is sufficiently satisfied
by the echo-broadcast protocol.

## Implementation Plan

I have started work on the using noise point to point channels and
echo-broadcast as a Rust library. With FROST integrated into such a
library I will achieve the following two outcomes:

1. Have practical results on the limits of scaling FROST.
1. Have a Rust library any application can use.

## Previous Work

I wrote a blog post earlier about using [FROST for Braidpool]({%
post_url 2023-08-22-frost-for-braidpool %}) and there the broadcast
channel didn't meet the requirements listed above.
