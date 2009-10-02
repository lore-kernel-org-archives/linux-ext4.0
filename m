From: Jody McIntyre <scjody@sun.com>
Subject: Re: [patch 4/4] [ext3] Add journal guided resync (data=declared	mode)
Date: Fri, 02 Oct 2009 11:53:43 -0400
Message-ID: <20091002155343.GA22539@clouds>
References: <20091001223929.120106893@sun.com>
 <20091001224021.757201872@sun.com> <19141.23743.35576.466246@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andreas Dilger <adilger@sun.com>
To: Neil Brown <neilb@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:43966 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbZJBPxw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Oct 2009 11:53:52 -0400
Content-disposition: inline
In-reply-to: <19141.23743.35576.466246@notabene.brown>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 02, 2009 at 11:51:59AM +1000, Neil Brown wrote:

> I have thought about this sort of thing from time to time and I have a
> very different idea for how the necessary communication between the
> filesystem and MD would happen.  I think my approach would completely
> address this problem, and doesn't need to add any ioctls (which I am not
> keen on).
> 
> I would add two new BIO_RW_ flags to be used with WRITE requests.
> The first flag would mean "don't worry about a crash in the middle of
> this write,  I will validate it after a crash before I rely on the
> data."
> The second would mean "last time I wrote data near here there might
> have been a failure, be extra careful".
> 
> So the first flag would be used during normal filesystem writes for
> every block that gets recorded in the journal, and for every write
> to the journal.
> 
> The second flag is used after a crash to re-write every block that
> could have been in-flight during the crash.  Some of those blocks will
> be read from the journal and written to their proper home, other will
> be read from wherever they are and written back there.
> 
> The first flag would be interpreted by MD as "don't set the bitmap
> bit".  The second flag would be interpreted as "don't trust the
> parity block, but do a reconstruct-write".
> 
> With this scheme you would still need a write-intent-bitmap on the MD
> array, but no bits would ever be set if the filesystem were using the
> new flags, so no performance impact.  You probably could run without a
> bitmap, in which case the flag would me "don't mark the array as
> active".

That makes a lot of sense.  The original design used something similar to
your second flag to do all the resync work.  I changed to an IOCTL approach
because there's no good way for a flagged IO to return "the resync you
requested could not be done so don't skip the automated resync."  But with
your suggestion, there's no need to explicitly skip the automated resync at
the end either - it just won't act on those blocks, assuming all blocks
were previously written with the first flag.

I don't like the IOCTLs either :)

> I'm not entirely sure about the second flag.  Maybe it would be better
> to make it a flag for READ and have it mean "validate and correct any
> redundancy information (duplicates or parity) for this block before
> returning it.  Then we could have just one flag, which meant different
> things for READ and WRITE.

Yes, it needs to be a READ flag to avoid an unnecessary read-write cycle.
The list of declare blocks in the ext3 journal just lists the block
numbers, not their contents (this is equivalent to data=ordered, not
data=journaled).

It would be nice to also have a WRITE flag though, for those cases
(metadata) where we do know what's being written to the block.

In any case, I think it's less confusing to have two flags: the "don't
worry about this block for now" flag and the "resync this block now" flag.

There's still one complication though, and an IOCTL may still be necessary:
at fsck time, we need to perform a journal recovery from e2fsck (userland.)
Clearly, resyncing the declared blocks (plus the journal and affected
metadata blocks) must be done before e2fsck does any writes to these
blocks.  An IOCTL seemed to be the best way to do that, but I'm open to
other suggestions.

> What do you think?

I'll send a new patchset, hopefully today.

Cheers,
Jody

> NeilBrown
