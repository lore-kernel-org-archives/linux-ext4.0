From: linux@horizon.com
Subject: Re: [RFC] mke2fs -E hash_alg=siphash: any interest?
Date: 21 Sep 2014 17:04:16 -0400
Message-ID: <20140921210416.27127.qmail@ns.horizon.com>
References: <20140921175515.GA30646@thunk.org>
Cc: linux-ext4@vger.kernel.org
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:42400 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751313AbaIUVET (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Sep 2014 17:04:19 -0400
In-Reply-To: <20140921175515.GA30646@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I'm certainly not against adding a new hash function.  The reality is
> that it would be quite a while before we could turn it on by default,
> because of the backwards compatibility concerns.

Well, yes, obviously!  My itch is just that I want to use it myself;
I prefer it for security and cleanliness reasons.  The benchmarks are
mostly to prove that it isn't slower.

> The question I would ask is whether we can show an anctual performance
> improvement with the hash being used in situ.

I quite agree, but I'll have to have a working patch before such
a test can be made.

One things I'm coming across immediately that I have to ask for
design guidance on is the hash algorithm number assignment:

- Should I leave room for more hashes with a signed/unsigned distinction,
  or should I assume that's a historical kludge that won't be perpetuated?
  SipHash is defined on a byte string, so there isn't really a signed
  version.
- Should I use a new EXT2_HASH_SIPHASH_62 = 6, or should I
  renumber the (internal-only) EXT2_HASH_*_UNSIGNED values and use
  EXT2_HASH_SIPHASH_4_2 = 4?

None of this is truly final, but it would make my life easier if I
didn't have to change it on my test filesystems too often.
