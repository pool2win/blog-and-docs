---
layout: post
title: DSL Taproot Coinbase & Optimised Docker Image
---

We are using the Bitcoin DSL to capture the workings for Braidpool's
payout mechanism. For this I had to wrap up a couple of loose ends in
the DSL. I also optimised the Docker notebook image, so it is close to
1GB than to 4GB.

As part of the work, we are now able to specify a taproot script for
a block's coinbase.

```
extend_chain taproot: { internal_key: @internal_key, leaves: [ @alice_timelock , 'sha256(@secret)' ]}
```


We also had to fix a small bug where spending leaves was not correctly
using the X only pubkey.
