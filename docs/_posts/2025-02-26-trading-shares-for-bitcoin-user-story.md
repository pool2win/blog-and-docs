---
layout: post
title: Trading Shares For Bitcoin - User Story
image: assets/BC_Logo_.png
---

To scale P2Pool, we need a payout mechanism that works past the limit
imposed by bitmain on the number of outputs in a coinbase
transaction. In P2Poolv2 we are aiming to provide transactions on the
P2Pool blockchain and then support trading of P2Pool coinbase
transactions with BTC. In this post, we describe the user experience
of trading the shares for bitcoin, capturing the high requirements for
any solutions we develop in the future.

# Payout User Story for P2Poolv2

P2Pool was a blockchain of shares contributed by miners. Think of it
as a blockchain of bitcoin weak blocks. However, P2Pool encountered a
scaling limitation when bitmain put a limit on the size of the
bitcoin coinbase transaction.

P2Pool used to pay all miners directly from the coinbase, however,
with the limit imposed by bitmain, P2Pool could no longer scale to
accomodate more than a few hundred miners. This was not enough
hashrate for providing any meaningful reduction in payout variance.

To scale P2Pool, we need a payout mechanism that works past this limit
imposed by bitmain on the number of outputs in a coinbase
transaction. In P2Poolv2 we are aiming to provide transactions on the
P2Pool blockchain and then support trading of P2Pool coinbase
transactions with BTC.

By paying only a few market makers, say 10-50 market makers, via
coinbase, and paying other miners when market makers buy their
coinbases, we can scale the payout mechanism of P2Pool.

# Background

The original P2Pool was a blockchain where each block is a share mined
by a miner.

The miner built their own blocktemplate and broadcast it. All other
miners validate the blocktemplate and any shares the miner broadcasts
as solutions for the blocktemplate.

## P2Poolv2's sharechain

The v2 sharechain is exactly the above, with two differences:

1. Transactions support on the sharechain. These transactions are
   structured exactly as bitcoin - using Script and the UTXO model. We
   use rust-bitcoin to implement this, in effort to be as close to
   bitcoin as possible.

1. The coinbase of each block has a single output, paying the miner an
   amount derived from their share of the pool's hashrate - we use
   PPLNS here.

![P2Pool and bitcoin blocks](/assets/payout-story/bitcoin-pool-block-relation.excalidraw.png "P2Pool and Bitcoin Blocks")

## P2Poolv2's Payout Structure

We are working on p2poolv2 where a few parties are paid via the
coinbase and the others have to trade their coinbases with market
makers to earn BTC for their shares.

The figure below shows a coinbase from P2Poolv2 where the market
makers are paid from the pool coinbase. The miners instead are paid
out when they trade their P2Pool coinbase outputs for BTC.

![P2Pool Coinbase](/assets/payout-story/payout-coinbase.excalidraw.png "P2Pool Coinbase"){:width="30%"}


## Trading Window for P2Pool Coinbases

There are a couple of constraints that we need to keep in mind when
enabling the trade of p2pool coinbase for BTC.

1. A P2Pool coinbase maturity. The coinbases can be traded after a
   day's worth of blocks. Given blocks are every 30s on P2Pool, we
   have to wait for 2880 blocks before the coinbases can be spent.
2. PPLNS accounting window. After a certain depth, coinbases can no
   longer be traded as the shares are then used to calculate the
   payouts in the next bitcoin coinbase.
   
The figure below shows the trading window, assuming an 8 bitcoin block
window.

![Trading Window](/assets/payout-story/trading-coinbase-for-payout.excalidraw.png "Trading Window")


## Miner Trading Experience

We want to provide the equivalent of the following trading experience
to the miner.


1. A Miner starts mining on P2Pool and earns some shares. These
   earnings are captured as a coinbase output on the P2Pool block. The
   amount on the coinbase output reflects the miner's hashrate on the
   pool.
1. The Miner enters a contract with a market maker to trade P2Pool
   coinbase outputs for BTC. At this point we setup the LN channels or
   Ark VTXOs to enable the swap of the miner's p2pool coinbase UTXO
   with market maker's BTC.
1. At any given time, if the miner has any P2Pool coinbase outputs in
   the current trading window, the miner's P2Pool coinbase outputs are
   traded for BTC.
1. The market maker buys the P2Pool coinbase outputs and when it comes
   time to compute who is paid how much from the pool, the market
   maker gets paid in lieu of the miner who sold their coinbases to
   the market maker.
