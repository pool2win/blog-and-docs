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
3.  Let's say the difficulty is adjusted by stratum to send a single
    share every 15s.

For the above we get the number of share validations to run per
second.

    (/ 100000 15.0) ~ 6666 validations per second

This number of hashes, 7000 or so is literally peanuts compared to
millions of hashes we can run on i9 or Ryzen 9 machines. Ref
[OpenBenchmarking](https://openbenchmarking.org/test/pts/openssl&eval=375e4665476bc507fd02b2459105dec77138b4c9#metrics)
