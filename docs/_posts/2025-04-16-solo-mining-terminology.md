---
layout: post
title: Solo Mining
image: assets/BC_Logo_.png
---

There's many subtleties in solo mining nomenclature that often confuse people.

I think there are two axis here:

1. Who builds the block template?
2. Are block rewards shared between miners?

|------------------------|----------------|-----------------------|
| Block Template Builder | Reward Shared? | Mining Type           |
|------------------------|----------------|-----------------------|
| Miners                 | No             | Solo                  |
| Pool operator          | No             | Solo Pool             |
| Miners                 | Yes            | SV2/DATUM             |
| Pool operator          | Yes            | PPLNS/Tides/FPPS, etc |
|------------------------|----------------|-----------------------|

If we consider who builds the coinbase then we get a different view

|------------------------|--------------------|------------------|------------------------------------------|
| Block Template Builder | Coinbase builder / | Mining Type      | Example                                  |
|                        | validator          |                  |                                          |
|------------------------|--------------------|------------------|------------------------------------------|
| Miners                 | Miners             | Solo             | Local CKPool solo / Local Public Pool    |
| Pool operator          | Pool operator      | Traditional pool | Antpool, Ocean, CKPool solo, Public Pool |
| Miners                 | Pool operator      | SV2/DATUM        | Ocean, Demand                            |
| Pool operator          | Miner              | --               | --                                       |
|------------------------|--------------------|------------------|------------------------------------------|

So where does P2Pool fit in here? We need to look at the three axis
together.

|------------------------|----------------|-----------------------------------|-------------------|
| Block Template Builder | Reward shared? | Coinbase built/validated by pool? | Example           |
| Miner                  | Yes            | Yes                               | SV2/DATUM         |
| Miner                  | No             | Yes                               | --                |
| Miner                  | Yes            | No                                | P2Pool            |
| Miner                  | No             | No                                | Local ckpool solo |
|------------------------|----------------|-----------------------------------|-------------------|
| Pool operator          | Yes            | Yes                               | Trad Pool         |
| Pool operator          | No             | Yes                               | ckpool solo       |
| Pool operator          | Yes            | No                                | --                |
| Pool operator          | No             | No                                | --                |
|------------------------|----------------|-----------------------------------|-------------------|

Hope this helps. Here's a twitter discussion around this:
[https://x.com/jungly/status/1912395953883009044](https://x.com/jungly/status/1912395953883009044)
