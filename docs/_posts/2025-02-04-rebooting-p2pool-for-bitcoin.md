---
layout: post
title: Rebooting P2Pool For Bitcoin
image: assets/BC_Logo_.png
---

[P2Pool](http://p2pool.in/) for bitcoin was a project that provided
miners way to build block templates and earn payouts directly from the
the block coinbase. In this post, I describe an approach to reboot
P2Pool. The pool is being developed in Rust and leans on excellent
libraries like rust-bitcoin and libp2p. The repository is here on
github:
[https://github.com/pool2win/p2pool-v2](https://github.com/pool2win/p2pool-v2)

## P2Pool Limitations

There were two problems that lead to P2Pool losing favour with miners:

1. P2Pool had a simple linear blockchain where each block is a share
   found by a miner. The share identifies the miner and the
   blocktemplate used by the miner for mining the share. However,
   since P2Pool used a linear chain, a lot of the shares were
   orphaned. Miners were therefore not paid for all their work.
1. The payouts for miners directly from the coinbase stop being
   economically viable as fee rates went up. Further still, as some
   mining hardware put restrictions on the coinbase size, P2Pool could
   not accommodate enough miners to reduce variance in payouts for
   miners.
   

The need for P2Pool is found in the various efforts to reboot
P2Pool. Chris Belcher wrote a proposal describing a way to [scale
payouts by using payment
channels](https://bitcointalk.org/index.php?topic=2135429.0) instead
of paying directly from the coinbase. His proposal was aware of a
shortcoming that the payouts were managed by a centralised hub. He
proposed a solution to address that by using a federation of
hubs. However, the problem of high number of orphans remained in this
design.

## Rebooting P2Pool

The above mentioned problems can be solved by borrowing solutions and
techniques used in other blockchains.

### Uncle Blocks

Uncle blocks were first introduced by the Ethereum blockchain to
handle faster block times. If a block was orphaned but referenced to
by future blocks as an uncle blocks, both the uncle block and the
referring block earned block rewards. The most work chain was replaced
by the heaviest observed sub-tree or GHOST.

The GHOST solution has been analysed in academic research and its
problems have been well studied. We can lean on this research and use
uncle blocks to substantially reduce the number of orphan blocks.

![Uncle Blocks](/assets/uncles.png)

The image above shows an example chain with uncle blocks that will
help scale the pool to accommodate larger number of miners than with a
linear chain as in the original P2Pool.

### Atomic Swaps of Shares

We propose using a limited transaction engine on the share chain to
support atomic swaps between the shares on the P2Pool share chain and
bitcoin.

The idea is that market makers or larger miners will buy the shares of
smaller miners for bitcoin using atomic swaps. When the payout period
arrives, the larger miners or the market makers who have purchased the
shares of the smaller miners are paid for the shares of the smaller
miners too.

The image below shows shares mined by different miners bitcoin blocks
at the top, and the P2Pool chain in two different stages. The shares
$p$ and $q$ are bought by miners $a$ and $b$. In this case the payout
for share $p$ will go to miner $a$ and for $q$ will go to miner
$b$. The miners that found $p$ and $q$ have already received bitcoin
from miners $a$ and $b$ at price the trading parties agreed on.

![Trading Shares](/assets/share-trade.png)

Such a solution is non-custodial and allows for a decentralised
market place for mining shares.

## Future Work

Once the above solution is built, we can work on scaling the chain by
allowing increased number of uncles, and we can develop new payout
mechanisms like using atomic swaps over lightning network or using Ark
or any other layer twos that become possible on bitcoin as bitcoin
evolves.


