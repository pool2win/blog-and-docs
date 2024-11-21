---
layout: post
title: Radpool and Fedipool
image: assets/radpool-logo.png
---

There have been a few discussions around Fedipool in the past. I want
explain how Radpool design is different from Fedipool and from my
perspective a design that has better chances of adoption.

Links to previous discussions

- [Github Discussion](https://github.com/fedimint/fedimint/discussions/1504)
- [Delving Bitcoin discussion](https://delvingbitcoin.org/t/fedimint-overview-and-fedipool-theorizing/110/1)

Now the comparison

## Payout Mechanism

Radpool uses DLC contracts to payout miners from liquidity locked into
the contracts by Mining Service Providers - the federation members in
a way.

Fedipool pays out miners in ecash tokens, which can be used in the
ecash economy, but to convert to BTC, the miner needs to get
permission from the mint.

🤩 Radpool's payout lets miners exit unilaterally

## DKG and FROST

Fedipool [uses
Musig](https://github.com/fedimint/fedimint/blob/569e6d9e9f55671da6ac1682dcc1794835cb1559/docs/lifecycle.md?plain=1#L6)
to sign transactions as the federation. This creates a limit on the
size of the federation, as even one node failing will result in the
federation stalling.

Radpool is built from the ground up with DKG and FROST in mind. The
design provides solutions for robust DKG and threshold signatures
using optimisations to ROAST (mentioned in the paper itself).

🤩 Radpool uses robust DKG and TSS - scale with fault tolerance

## Federation Membership

Fedimint uses federation where the [members/guardians are
trusted](https://fedimint.org/docs/TradeOffs/Trust-Trade-Offs) as the
community model. I argue, this model of the federation member stiffles
the growth of the network as the trust model allows the pool to grow
only so much.

In Radpool, the membership of the federation is decided using the
hashrate that each member's miners bring to the pool. Also, a new
member has to wait for two weeks before it can participate in the DKG
or the threshold signature for the pool.

🤩 Radpool uses PoW to prevent Sybil and reduce trust

## Open Network

Again, given the Fedimint trust model, the federation is a closed
federation, where members can only join if they are trusted by other
parties.

Radpool's federation is an open federation, where anyone can join the
federation. In fact, Radpool provides the network effect that each
additional miner or MSP makes Radpool more useful for everyone already
on the network. So current Radpool MSPs are incentivized to let new
members in.

🤩 Radpool benefits from Network Effects - More MSPs the Better for
Everyone

## Accounting

Since Fedipool will be a closed network, the share accounting can be
made transparent and auditable.

Radpool, is an open federation and therefore the accounting
information is freely available to anyone who connects to the
federation to receive the share information. Think of MSPs and
bittorrent seeds for share database.

🤩 Radpool freely provides access to share database. Fedipool can do
this too.
