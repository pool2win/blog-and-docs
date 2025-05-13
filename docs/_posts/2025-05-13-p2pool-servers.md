---
layout: post
title: "Trusting the Trustless: How Public P2Pool Nodes Worked for Bitcoin Miners"
date: 2025-05-13
categories: bitcoin p2pool decentralization
image: assets/p2poolv2.png
---

In the early days of Bitcoin mining, **P2Pool** emerged as a
decentralized mining pool protocol, allowing miners to collaborate
without relying on a central authority. But as the network grew, so
did the need for more accessible solutions. The community started to
use P2Pool server nodes. In this post I look into why some miners
found the solution acceptable. The post is motivated by the question -
should P2Poolv2 support such server nodes?

Here's an image of how the setup looked in the past.

![OG P2Pool's Servers]({{site.baseurl}}/assets/p2pool-servers.excalidraw.png "OG P2Pool's Servers")

## The Mechanics Behind Public P2Pool Nodes

**P2Pool** operated by creating a separate blockchain, known as the
"sharechain," where miners submit shares that collectively contribute
to finding a valid Bitcoin block. Each node maintained this
sharechain, ensuring transparency and decentralization.

Public P2Pool nodes took this a step further by allowing miners to
connect their ASICs directly to these nodes via the Stratum
protocol. These nodes handled the heavy lifting: maintaining the
sharechain, aggregating shares, constructing valid blocks, and
broadcasting them to the Bitcoin network.

## The Trust Dynamics

While P2Pool's design minimized trust requirements, connecting to a
public node introduced certain dependencies:

- **Reliability**: Miners depended on the node operator's
  infrastructure. Downtime or misconfigurations could lead to missed
  rewards.

- **Accurate Share Tracking**: Operators needed to ensure that all
  valid shares were correctly propagated and recorded.

However, it's crucial to note what miners didn't have to trust:

- **Fund Custody**: Payouts were made directly to miners' Bitcoin
  addresses via the coinbase transaction. There was no intermediary
  holding the funds.

- **Reward Distribution**: The P2Pool protocol's PPLNS
  (Pay-Per-Last-N-Shares) model ensured fair distribution based on
  contributed work, reducing the potential for operator manipulation.

## Why Did Miners Opt for Public Servers?

Running a P2Pool node required technical expertise and resources. Not
all miners had the capability or desire to manage their own
nodes. Public nodes offered a plug-and-play solution, allowing miners
to participate in decentralized mining without the overhead.

## Conclusion

Public P2Pool servers bridged the gap between full decentralization
and user accessibility. They allowed miners to benefit from P2Pool's
trustless design while outsourcing the operational complexities. While
they introduced some dependencies, the core principles of
decentralization and direct payouts remained intact.

I am leaning towards providing such a setup for P2Poolv2 as
well. Well, let's put it another way, if someone makes such a change
and submits a patch, we'll probably accept it the change.
