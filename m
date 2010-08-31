From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH] ext4: fix 50% disk write performance regression
Date: Mon, 30 Aug 2010 20:37:10 -0400
Message-ID: <20100831003710.GA4272@thunk.org>
References: <20100829231126.8d8b2086.billfink@mindspring.com>
 <20100830174000.GA6647@thunk.org>
 <20100830164958.edb64c63.bill@wizard.sci.gsfc.nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bill Fink <billfink@mindspring.com>,
	"adilger@sun.com" <adilger@sun.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Fink, William E. (GSFC-6061)" <william.e.fink@nasa.gov>
To: Bill Fink <bill@wizard.sci.gsfc.nasa.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58313 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797Ab0HaAhT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Aug 2010 20:37:19 -0400
Content-Disposition: inline
In-Reply-To: <20100830164958.edb64c63.bill@wizard.sci.gsfc.nasa.gov>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 30, 2010 at 04:49:58PM -0400, Bill Fink wrote:
> > Thanks for reporting it.  I'm going to have to take a closer look at
> > why this makes a difference.  I'm going to guess though that what's
> > going on is that we're posting writes in such a way that they're no
> > longer aligned or ending at the end of a RAID5 stripe, causing a
> > read-modify-write pass.  That would easily explain the write
> > performance regression.
> 
> I'm not sure I understand.  How could calling or not calling
> ext4_num_dirty_pages() (unpatched versus patched 2.6.35 kernel)
> affect the write alignment?

Suppose you have 8 disks, with stripe size of 16k.  Assuming that
you're only using one parity disk (i.e., RAID 5) and no spare disks,
that means the optimal I/O size is 7*16k == 112k.  If we do a write
which is smaller than 112k, or which is not a multiple of 112k, then
the RAID subsystem will need to do a read-modify-write to update the
parity disk.  Furthermore, the write had better be aligned on an 112k
byte boundary.  The block allocator will guarantee that block #0 is
aligned on a 112k block, but writes have to also be right size in
order to avoid the read-modify-write.

If we end up doing very small writes, then it can end up being quite
disatrous for write performance.

> I was wondering if the locking being done in ext4_num_dirty_pages()
> could somehow be affecting the performance.  I did notice from top
> that in the patched 2.6.35 kernel, the I/O wait time was generally
> in the 60-65% range, while in the unpatched 2.6.35 kernel, it was
> at a higher 75-80% range.  However, I don't know if that's just a
> result of the lower performance, or a possible clue to its cause.

I/O wait time would tend to imply that the raid controller is taking
longer to do the write updates, which would tend to confirm that we're
doing more read-modify-write cycles.  If we were hitting spinlock
contention, this would show up as more system CPU time consumed.

	    	       	       	       - Ted
