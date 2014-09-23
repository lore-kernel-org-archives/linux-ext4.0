From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC] mke2fs -E hash_alg=siphash: any interest?
Date: Tue, 23 Sep 2014 19:22:06 -0400
Message-ID: <20140923232206.GI17784@thunk.org>
References: <24F09699-B86B-4F73-8D93-1650B2BFC483@dilger.ca>
 <20140923230023.19419.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44508 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbaIWXWK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 19:22:10 -0400
Content-Disposition: inline
In-Reply-To: <20140923230023.19419.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 23, 2014 at 07:00:23PM -0400, George Spelvin wrote:
> It's worse than that.  The dcache has an great hit rate, and you have to
> force misses.  But if you actually hit the disk a lot, that will dwarf
> hashing performance into unmeasurability.
> 
> So it requires a very cleverly designed benchmark to highlight it.

Well, yes.  That's why I suggested doing something with a RAM disk.
Perhaps creating a huge number of zero length files, then unmounting
the the file system and remounting it, and then deleting the huge
number of zero length files.

If that doesn't show an improvement, then it's unlikely any real world
use case would likely show an improvement.... 

> By criterion 2, SipHash *is* significantly stronger: it's presented at
> crypto conferences, been studied, and is widely used.
> 
> halfmd4 a very ad-hoc primitive that I don't think anyone's looked at
> seriously.
> 
> It's not obviously terrible, and it's possible that halfmd4 is more work
> to break, but we won't know until someone with cryptanalytic skill takes
> a swing at it.

The other thing to consider is what you get if you manage to crack the
crypto, which is that you might be able to force the worst case
performance, and possibly cause a directory creation to fail with an
ENOENT if the huge number of hash collisions cause the two-level htree
to overfill.

Neither is going to get you a huge amount, so it this decreases the
incentive for someone to spend a lot of effort trying to attack the
system.  I'm quite certain though that if there is some way such a
failure could cause an Iranian nuclear centrifuge to fail
catastrophically, our friends at Fort Meade would have absolutely no
problems finding an attack.  After all, they did for MD5.  :-)

Cheers,

					- Ted
