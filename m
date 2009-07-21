From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] fix softlockups in ext2/3 when trying to allocate
	blocks
Date: Tue, 21 Jul 2009 11:15:52 -0400
Message-ID: <20090721151550.GA2451@localhost.localdomain>
References: <20090706194739.GB19798@dhcp231-156.rdu.redhat.com> <20090720233735.e3c711d1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
	emcnabb@redhat.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50921 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272AbZGUPQI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jul 2009 11:16:08 -0400
Content-Disposition: inline
In-Reply-To: <20090720233735.e3c711d1.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 20, 2009 at 11:37:35PM -0700, Andrew Morton wrote:
> On Mon, 6 Jul 2009 15:47:39 -0400 Josef Bacik <josef@redhat.com> wrote:
> 
> > This isn't a huge deal, but using a big beefy box with more CPUs than what is
> > sane, you can get a nice flood of softlockup messages when running heavy
> > multi-threaded io tests on ext2/3.  The processors compete for blocks from the
> > allocator, so they will loop quite a bit trying to get their allocation.  This
> > patch simply makes sure that we reschedule if need be.  This made the softlockup
> > messages disappear whereas before they happened almost immediately.  Thanks,
> 
> The softlockup threshold is 60 seconds.  For the kernel to spend 60
> seconds continuous CPU time in the filesystem is very bad behaviour, and
> adding a rescheduling point doesn't fix that!
>

In RHEL its set to 10 seconds, so its not totally unreasonable.
 
> > Tested-by: Evan McNabb <emcnabb@redhat.com>
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> > ---
> >  fs/ext2/balloc.c |    1 +
> >  fs/ext3/balloc.c |    2 ++
> >  2 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> > index 7f8d2e5..17dd55f 100644
> > --- a/fs/ext2/balloc.c
> > +++ b/fs/ext2/balloc.c
> > @@ -1176,6 +1176,7 @@ ext2_try_to_allocate_with_rsv(struct super_block *sb, unsigned int group,
> >  			break;				/* succeed */
> >  		}
> >  		num = *count;
> > +		cond_resched();
> >  	}
> >  	return ret;
> >  }
> > diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> > index 27967f9..cffc8cd 100644
> > --- a/fs/ext3/balloc.c
> > +++ b/fs/ext3/balloc.c
> > @@ -735,6 +735,7 @@ bitmap_search_next_usable_block(ext3_grpblk_t start, struct buffer_head *bh,
> >  	struct journal_head *jh = bh2jh(bh);
> >  
> >  	while (start < maxblocks) {
> > +		cond_resched();
> >  		next = ext3_find_next_zero_bit(bh->b_data, maxblocks, start);
> >  		if (next >= maxblocks)
> >  			return -1;
> > @@ -1391,6 +1392,7 @@ ext3_try_to_allocate_with_rsv(struct super_block *sb, handle_t *handle,
> >  			break;				/* succeed */
> >  		}
> >  		num = *count;
> > +		cond_resched();
> >  	}
> >  out:
> >  	if (ret >= 0) {
> 
> I worry that something has gone wrong with the reservations code.  The
> filesystem _should_ be able to find a free block without any contention
> from other CPUs, because there's a range of blocks reserved for this
> inode's allocation attempts.
> 

Sure, the problem is if we run out of blocks in that reservation window, or
somebody else runs out of blocks in their reservation window, we start trying to
steal blocks from other inodes reservation windows.

> Unless the workload has a lot of threads writing to the _same_ file. 
> If it does that then yes, we'll have lots of CPUs contenting for blocks
> within that inode's reservation window.  Tell us about the workload please.
>

The workload is on a box with 32 CPUs and 32GB of ram.  Its running some sort of
kernel compiling stress test, which from what I understand is running a kernel
compile per CPU.  Then on top of that there is a dd running at the same time.
 
> But that shouldn't be happening either because all those write()ing
> threads will be serialised by i_mutex.
> 
> So I don't know what's happening here.  Possibly a better fix would be
> to add a lock rather than leaving the contention in place and hiding
> it.  Even better would be to understand why the contention is happening
> and prevent that.
> 

I could probably add some locking in here to help the problem, but I'm worried
about the performance impact that would have.  This is just a crap situation,
since we are quickly exhausting our reservation windows and devovling to just
schlepping through the block bitmaps for free space, and thats where we start to
suck hard.  I can look into it some more and possibly come up with something
else, this just seemed to be the quickest way to fix the problem with affecting
as little people as possible, especially since it's only reproducing on a box
with 32 CPUs and 32GB of RAM.  Thanks,

Josef
