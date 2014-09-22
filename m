From: "George Spelvin" <linux@horizon.com>
Subject: RE: [RFC] mke2fs -E hash_alg=siphash: any interest?
Date: 21 Sep 2014 22:31:05 -0400
Message-ID: <20140922023105.16748.qmail@ns.horizon.com>
References: <BAY179-W560EC72EB98547138373E3FDB20@phx.gbl>
Cc: linux@horizon.com, linux-ext4@vger.kernel.org
To: thomas_reardon@hotmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:16280 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751843AbaIVCbH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Sep 2014 22:31:07 -0400
In-Reply-To: <BAY179-W560EC72EB98547138373E3FDB20@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Is protection against hash DoS important for local on-disk format?
> 
> I can't come up with a scenario, but maybe there is one.  The kinds of
> DoS contemplated are really Google-scale, not really at the scale of
> ext4 directories,

Yes.  It's the standard hash collision attack: if someone can force too
many hash collisions, they can force the hash tree to have pessimal
performance, including excessive disk space allocation in an attempt to
split directory pages.

In fact, I'm not sure if the code copes with more than 4096 bytes of
directory entry with a single hash value or it will cause some sort of
error.

I'm sure Ted knows the details, but the entire reason that cryptographic
hashes are used by ext3/4 is that it's a potential problem.

Anyway, in addition to being a local DoS, plenty of systems create files
with network-controllable names, like PHP session IDs.  (The alphabet
and length are controlled, but that still leaves a lot of flexibility.)

SipHash is designed and widely used for exactly this.

> I ask because if hash perf is the main goal here, then CityHash and
> particularly SpookyHash are better candidates. The latter has good
> performance even on legacy ARMv5 hardware.

Both SipHash and SpookyHash are 64-bit ARX (add, rotate, XOR) designs,
so they have very similar performance characteristics.

SipHash does more mix operations than SpookyHash, both for zero-length
messages (24 vs. 11) and long messages (8 per 8 bytes, vs. 12 per 32
bytes), but is actually reasonably secure.

But in the typical-filename-length range, they aren't too far off from
each other.
