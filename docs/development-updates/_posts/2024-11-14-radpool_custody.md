---
layout: post
title: Radpool Federation
image: /assets/drake-blocktemplates-hashrate.jpg
---

I published a new design [https://radpool.xyz](Radpool), for a
decentralised mining pool where the miners are paid out using DLC
contracts between Miner Service Providers (MSPs) and miners. The DLC
contract attestations are published by a federation of MSPs using a
FROST threshold signature.

The concern is that smaller miners will be uncomfortable that larger
miners are in custody of their funds. In this post I point out that
neither miners nor MSPs custody funds in the Radpool.

## Miners Don't Custody Other Miner's Coins

Miner's vote for an MSP by choosing to send their hashrate through an
MSP to Radpool. In a way, the MSP is a syndicate for the MSP, and the
MSP can change their syndicate by switching to a different MSP.

Each MSP represents a mix of miner interests. It is possible a miner
starts an MSP simply to represent itself. Such an MSP could charge 0%
fees to the miner and make sure the miner directly participates in the
threshold signature.

In the end, miner's _can_ potentially be a direct participant in the
threshold signature, however, **miners don't want the legal
complications of building block templates and distributing block
rewards**.

![Drake Block templates vs trade hashrate]({{site.baseurl}}/assets/drake-blocktemplates-hashrate.jpg)


## Radpool Federation Doesn't Custody Coins Either

The Radpool federation signs attestations to settle miner-MSP
contracts, it does so because the federation won't sign the coinbase
unless DLC attestations are published at regular intervals.

A miner's coins are locked in the DLC contract and released to the
miner when the syndicate publishes an attestation. This period of
contract duration is the time the coins are subject to the federation
publishing an attestation. Once the attestation is published, the
contract is immediately settled and the miners has full custody of the
coins.

![Radpool Custody]({{site.baseurl}}/assets/radpool-custody.png)

The state transition diagram shows the states that the MSP's coins go
through. It shows that the coins once paid out to Miner remain in
it's custody.
