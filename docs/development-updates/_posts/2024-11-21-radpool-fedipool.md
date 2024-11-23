---
layout: post
title: Radpool and Fedipool
image: assets/radpool-logo.png
---

There have been a few discussions around Fedipool in the past. I
explain how Radpool design is different from Fedipool. I also point
out to how the Radpool network 1) can scale for providing payout
variance reduction, and 2) provide a payout mechanism that provides
unilateral exits.

Links to previous discussions on Fedipool

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

Fedipool bitcoin multisig to sign transactions as the federation. This
limits the size of the federation to the largest multisig possible on
chain. A larger federation is more resilient to centralisation
pressures.

Radpool is built from the ground up with DKG and FROST, which lets the
network make progress as long as a threshold number of parties are
honest and functional. The design provides solutions for robust DKG
and threshold signatures using optimisations to ROAST (mentioned in
the paper itself).

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
or the threshold signature for the pool. This distributes trust across
multiple parties who all benefit from the network making progress and
staying honest. The only way to attack the pool is to to get 60% of
the Radpool hashrate spread between multiple MSPs. See
[Membership](https://www.radpool.xyz/1/frost-federation.html#_membership)
for details.

🤩 Radpool uses PoW to prevent Sybil attack and reduce trust

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

Fedipool will be a closed network, however, the share accounting can
be made transparent and auditable. In this way, the two pools are
similar. I want to point out that Radpool is an open federation and
therefore the accounting information is freely available to anyone who
connects to the federation. Think of MSPs as bittorrent seeds for the
shares database.

🤩 Radpool freely provides access to share database. Fedipool can do
this too.
