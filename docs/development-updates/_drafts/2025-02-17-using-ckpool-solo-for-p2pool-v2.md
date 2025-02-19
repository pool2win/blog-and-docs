---
layout: post
title: Using CKPool for P2Pool
image: assets/BC_Logo_.png
---

Building P2Poolv2 is made possible with over a decade of work that has
gone into the Bitcoin ecosystem. The obvious tools to use are the rust
libraries for bitcoin script and block validation. However, when it
comes to mining there is a tool that one can't avoid but use, and that
is CKPool. In P2Poolv2, we need a few things that a normal solo pool
instance doesn't need and in this post I describe how we have extended
CKPool to provide the APIs we need and how we consume the data
provided by CKPool, i.e. the workbases and shares.

## CKPool - Battle Tested Pool Implementation

[CKPool](https://bitbucket.org/ckolivas/ckpool) is a pool
implementation by Con Kolivas that has been in production use for a
long time now. It is implemented in C and is highly optimised to
provide a pool instance. It is the code that runs the ckpool solo
instance [handling over 180 PH/s](https://solostats.ckpool.org/).

In P2Poolv2, we need a stratum server for each miner that is running a
p2pool node. It is kind of a no brainer to use a FOSS tool like CKPool
that has been in production and therefore is battle tested to handle a
diverse range of mining hardware.

## Using CKPool in P2Poolv2

A P2poolv2 node needs to interact with CKPool running in solo
mode. The interactions are:

1. Receive shares from the stratum part of the pool. P2Pool then has
   to send these shares to the p2p network so that all other nodes can
   run share accounting.
1. Receive the blocktemplate the pool is using to build work for the
   ASICs machines. We need this for the other nodes on the p2p network
   to validate that the shares they receive from a node belong to a
   bitcoin block - even if it doesn't have enough work to meet the
   current bitcoin difficulty.
1.  We need  a  way to  send  the coinbase  to CKPool  to  use in  the
   blocktemplate. CKPool  generates a coinbase  to payout to  a single
   P2PKH address - we will need to make a change here as well. We will
   need to send up to 10 addresses here.
2. We also need a way to adjust difficulty for miners connected to the
   CKPool solo server. P2Pool node can observe the hashrate on the
   network and update the suggested difficulty used in CKPool solo.
   
   
### Receiving Shares and Block Templates from CKPool

This is the easy part, so I have made this change and shared it on [my
fork of CKPool on
BitBucket](https://bitbucket.org/p2pool-v2/ckpool-solo/). The patch is
simple:

1. We open a ZMQ PUB socket that the P2poolv2 node connects to.
2. Whenever a new blocktemplate is used or the coinbase changes or a
   new work is generated with an updated nTime field, we push the work
   base to the ZMQ PUB socket.

The P2Poolv2 node thus has access to the work definition and the
shares for each of the workbases.

### Coinbase (TODO)

For now, CKPool directly talks to bitcoind and generates the coinbase
for a P2PKH provided in the config file. With P2Pool, we will need to
send payouts to more than one address, and these addresses will
dynamically change based on the share accounting.

There are two options here:

1. We use P2Pool node as a proxy to bitcoind, so that CKPool receives
   a blocktemplate with a coinbase with null values of enonce1 and
   enonce2. We will then need to change the coinbase generation
   function to handle this blocktemplate with a prebuilt coinbase.
2. The second option is that we push the list of addresses the
   coinbase should include outputs for and then update the CKPool
   coinbase generation function to allow 10/20 outputs instead of
   currently used two addresses - one for payout, one for donation.
   
### Difficulty Update (TODO)

P2Poolv2 nodes will adjust difficulty based on the hashrate on the p2p
network.

The obvious thing to do here is to let CKPool get the diffculty to use
from the P2Poolv2 node. I am leaning towards P2Poolv2 node pushing the
difficulty to CKPool, so CKPool doesn't have to make a network call to
pull the latest difficulty when it needs to use it.

## Conclusion

For now, we are able to use CKPool with a single payout address to
receive shares and workbases. However, we still need to provide the
interaction between CKPool and P2Poolv2 for handling coinbase
generation and updating miner difficulty.
