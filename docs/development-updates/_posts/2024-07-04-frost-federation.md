---
layout: post
itle: FROST Federation Using Rust
---

We need a threshold signature to manage the payout on a decentralised
mining pool. FROST and ROAST are threshold signature schemes with the
smallest network communication overhead with proven security
guarantees. However, FROST places some [requirements on the
communication channels between
peers](https://frost.zfnd.org/terminology.html#peer-to-peer-channel). The
[FROST federation](https://github.com/pool2win/frost-federation)
provides a Rust implementation for nodes that talk to each other over
point to point communication and provide the network guarantees
required by FROST.

The explicit requirements for network communication required by FROST
are

1. Peers will communicate using reliable, secure and authenticated
point to point network channels.
2. The network model will provide an implementation of Echo Broadcast
or equivalent protocol for one to all communication.

The broadcast from the second requirement has to use the reliable,
secure and authenticated point to point channels from the first
requirement.

These requirements are what I am providing in the FROST federation
implementation in Rust.

## Need for FROST Federation

In the absence of a covenants in bitcoin, a decentralised mining pool
will need a threshold signature scheme. The centralised hubs in Chris
Belcher's payment channels proposal that I have included in [my
proposal](https://github.com/pool2win/blog-and-docs/blob/main/proposal/proposal.pdf)
for [Braidpool](https://github.com/pool2win/braidpool/) will also
replaced by a threshold signature scheme. The bitcoin ecosystem is
missing an library that can use peer to peer threshold signature
schemes. My effort is focussed on providing an implementation that
will be easy to use in any of the decentralised mining solutions or
other applications that need a threshold signature scheme on always
available services.

## What does the FROST Federation do?

FROST is increasingly being used to provide wallets where a threshold
signatures control the spending conditions and transaction
signing. Implementing such a scheme needs to handle the challenge of
all the parties not being on-line all the time.

In contrast, to build services where multiple parties are always
on-line, we need to rethink how the multiple parties decide on
allowing new parties to join and allowing parties to leave the
federation. Once we know when parties can join and leave we need to
devise a way for federation membership to change. We depend on a
bitcoin transaction signed by a the threshold signature of existing
federation members.

When a new member wants to join, all federation members either sign a
new bitcoin transaction where the new member has an input and an
output. Existing members can choose to not sign such a transaction,
resulting in failed agreement on membership change. This serves as an
BFT agreement between current federation members to allow a new member
into the federation.

We can decide on a simple message instead of a bitcoin transaction to
signed as a membership change agreement, but by locking bitcoin into a
transaction we have a scheme similar to [joinmarket fidelity
bonds](https://github.com/JoinMarket-Org/joinmarket-clientserver/blob/master/docs/fidelity-bonds.md). By
locking in liquidity into a federation, the parties are encouraged to
contribute to the successful operation of a the federation. If a party
is not aligned with the majority, the non-compliant party is kicked
out of the federation.

In the case of a decentralised mining pool, the federation members are
the parties acting as hubs making payouts to miners. We will get into
the details of how the federation will be used to manage payouts for
miners in a different post. Here we continue to focus on what the
FROST federation will do.

The FROST federation provides the following features:

1. The FROST federation is open to new members, i.e. the federation is
   designed to allow new members to join when a threshold of the
   members agree.
2. Members can leave at any time. When a member stops participating,
   the rest of the federation continues without the failed member.
3. The federation is used to repeatedly generate public keys that are
   used for generating bitcoin addresses.
4. The federation is used to sign transactions that require signatures
   for the above generated public keys.
5. Before signing a transaction the federation members validate the
   transaction being signed. In the case of decentralised mining, this
   checks the miner payouts. In the case of other applications, this
   will be some other check.

## Implementation Progress

The current implementation of [FROST
federation](https://github.com/pool2win/frost-federation) is available
on github.

The following components are complete and tested using unit tests:

1. Secure and authenticated point to point communication using Noise
   framework.
2. Reliable communication using positive acknowledgements and time-outs on the
   sender.

### Test Coverage

When writing async network programming code in Rust, we need to switch
to advanced usage of Rust generics and mocks and this takes effort to
setup. I have invested in this early and the repository tracks the
current test coverage.

## Current Work

Currently I am working on implementing an Echo Broadcast protocol. It
is a simple protocol, however, it requires keeping track of messages
sent and echos received.

Finally, once all of the network stack is working, we need to
integrate the [FROST implementation by the team at
ZCashFoundation](https://github.com/ZcashFoundation/frost).

## Open Questions

We need to investigate how the network model requirements can be
satisfied over a multi-hop p2p network. My current intuition is that a
secure, authenticated channels on multi-hop p2p networks will only
work with the [KK noise
protocol](https://noiseprotocol.org/noise.html#payload-security-properties)
and will remain susceptible to man in the middle attack as peers
forward messages across the network. 

If we are able to provide a multi-hop secure and authenticated
communication channel, will reduce to the echo broadcast
implementation in a point to point network?

Before we take the FROST federation to a multi-hop P2P network, the
above two questions need to be looked into.
