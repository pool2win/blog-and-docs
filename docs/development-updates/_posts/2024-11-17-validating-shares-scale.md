---
layout: post
title: Validating Shares is Not a Challenge
image: assets/radpool-logo.png
---

Evaluate the CPU required to validate all shares received at MSPs.

Assume:

1.  100,000 ASICs machines sending work directly to the pool
2.  The above gives us about 23.4 Eh/s or 3% of bitcoin network
    hashrate.
3.  Let's say the difficulty is adjusted by startum to send a single
    share every 15s.

For the above we get the number of share validations to run per
second.

    (/ 100000 15.0) ~ 6666 validations per second

This number of hashes, 7000 or so is literally peanuts compared to
16-32 million hashes we can run on i9 or Ryzen 9 machines.

Let's put it another way, with 16 million hashes per second, we can
handle 16 million \* 15 \* 60 S21 pros, or about 14.4 million S21 Pros,
that is about four times the current network hashrate.
