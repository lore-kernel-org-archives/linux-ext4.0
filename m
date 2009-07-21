From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] fix softlockups in ext2/3 when trying to allocate
	blocks
Date: Tue, 21 Jul 2009 12:06:56 -0400
Message-ID: <20090721160655.GA2521@localhost.localdomain>
References: <20090706194739.GB19798@dhcp231-156.rdu.redhat.com> <20090720233735.e3c711d1.akpm@linux-foundation.org> <20090721151550.GA2451@localhost.localdomain> <20090721155019.GB14105@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, emcnabb@redhat.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Mingming Cao <cmm@us.ibm.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755577AbZGUQHd@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090721155019.GB14105@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 21, 2009 at 05:50:20PM +0200, Jan Kara wrote:
> On Tue 21-07-09 11:15:52, Josef Bacik wrote:
> > On Mon, Jul 20, 2009 at 11:37:35PM -0700, Andrew Morton wrote:
> > > On Mon, 6 Jul 2009 15:47:39 -0400 Josef Bacik <josef@redhat.com> wrote:
> > > 
> > > > This isn't a huge deal, but using a big beefy box with more CPUs than what is
> > > > sane, you can get a nice flood of softlockup messages when running heavy
> > > > multi-threaded io tests on ext2/3.  The processors compete for blocks from the
> > > > allocator, so they will loop quite a bit trying to get their allocation.  This
> > > > patch simply makes sure that we reschedule if need be.  This made the softlockup
> > > > messages disappear whereas before they happened almost immediately.  Thanks,
> > > 
> > > The softlockup threshold is 60 seconds.  For the kernel to spend 60
> > > seconds continuous CPU time in the filesystem is very bad behaviour, and
> > > adding a rescheduling point doesn't fix that!
> > >
> > 
> > In RHEL its set to 10 seconds, so its not totally unreasonable.
> >  
> > > > Tested-by: Evan McNabb <emcnabb@redhat.com>
> > > > Signed-off-by: Josef Bacik <josef@redhat.com>
> > > > ---
> > > >  fs/ext2/balloc.c |    1 +
> > > >  fs/ext3/balloc.c |    2 ++
> > > >  2 files changed, 3 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> > > > index 7f8d2e5..17dd55f 100644
> > > > --- a/fs/ext2/balloc.c
> > > > +++ b/fs/ext2/balloc.c
> > > > @@ -1176,6 +1176,7 @@ ext2_try_to_allocate_with_rsv(struct super_block *sb, unsigned int group,
> > > >  			break;				/* succeed */
> > > >  		}
> > > >  		num = *count;
> > > > +		cond_resched();
> > > >  	}
> > > >  	return ret;
> > > >  }
> > > > diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> > > > index 27967f9..cffc8cd 100644
> > > > --- a/fs/ext3/balloc.c
> > > > +++ b/fs/ext3/balloc.c
> > > > @@ -735,6 +735,7 @@ bitmap_search_next_usable_block(ext3_grpblk_t start, struct buffer_head *bh,
> > > >  	struct journal_head *jh = bh2jh(bh);
> > > >  
> > > >  	while (start < maxblocks) {
> > > > +		cond_resched();
> > > >  		next = ext3_find_next_zero_bit(bh->b_data, maxblocks, start);
> > > >  		if (next >= maxblocks)
> > > >  			return -1;
> > > > @@ -1391,6 +1392,7 @@ ext3_try_to_allocate_with_rsv(struct super_block *sb, handle_t *handle,
> > > >  			break;				/* succeed */
> > > >  		}
> > > >  		num = *count;
> > > > +		cond_resched();
> > > >  	}
> > > >  out:
> > > >  	if (ret >= 0) {
> > > 
> > > I worry that something has gone wrong with the reservations code.  The
> > > filesystem _should_ be able to find a free block without any contention
> > > from other CPUs, because there's a range of blocks reserved for this
> > > inode's allocation attempts.
> > > 
> > 
> > Sure, the problem is if we run out of blocks in that reservation window, or
> > somebody else runs out of blocks in their reservation window, we start trying to
> > steal blocks from other inodes reservation windows.
>   Yes, but that should happen only if start running of blocks (all the free
> blocks are reserved). We scan all the groups and try to establish a
> reservation window in each of them... Hmm, looking into the code, we also
> skip groups with less than window_size/2 blocks free. But that should be at
> most 2MB so it shouldn't be a big deal.  How big is the filesystem and how full
> does it get?

Sorry, not entirely sure on the details here, it should just be a clean fs, no
idea how big.  I can't get ahold of the original reporter.

>   BTW: You write above you can see the problem on ext2/3. Can you really
> observe it on ext2? I ask because on ext3, the pressure for free blocks is
> much higher in stress tests which create & remove files since the space of
> removed files can be used only after a transaction with delete is
> committed.
>   Also have you verified that we indeed take the 'repeat' loop in
> ext2_try_to_allocate() often (that's when we race with other threads
> allocating blocks)?
> 

Hrm I thought it was reproduced on ext2, but looking back at the bz that wasn't
actually said, so I'm not sure if this happens on ext2.

> > > Unless the workload has a lot of threads writing to the _same_ file. 
> > > If it does that then yes, we'll have lots of CPUs contenting for blocks
> > > within that inode's reservation window.  Tell us about the workload please.
> > >
> > 
> > The workload is on a box with 32 CPUs and 32GB of ram.  Its running some sort of
> > kernel compiling stress test, which from what I understand is running a kernel
> > compile per CPU.  Then on top of that there is a dd running at the same time.
>   And the kernel compile is single-threaded? My question should probably be
> - roughly how many parallel writers are there?
> 

Sorry I'm not sure, I'm waiting for the original reporter to pop back up so I
can get those details.

> > > But that shouldn't be happening either because all those write()ing
> > > threads will be serialised by i_mutex.
> > > 
> > > So I don't know what's happening here.  Possibly a better fix would be
> > > to add a lock rather than leaving the contention in place and hiding
> > > it.  Even better would be to understand why the contention is happening
> > > and prevent that.
> > > 
> > 
> > I could probably add some locking in here to help the problem, but I'm worried
> > about the performance impact that would have.  This is just a crap situation,
>   Yeah, I don't like the locking too much either. I'd first like to
> understand what exactly happens on your box. One low-cost thing we could
> try is that we won't scan groups for free blocks starting with group 0 but
> starting with some random group and wrapping around, like we do it when
> searching for free inodes. That should spread writers a bit.
> 
> > since we are quickly exhausting our reservation windows and devovling to just
> > schlepping through the block bitmaps for free space, and thats where we start to
> > suck hard.  I can look into it some more and possibly come up with something
> > else, this just seemed to be the quickest way to fix the problem with affecting
> > as little people as possible, especially since it's only reproducing on a box
> > with 32 CPUs and 32GB of RAM.  Thanks,
>   Well, that's not a small machine but not particularly huge either so I
> think we should cope reasonably with it.
> 

Agreed.  As soon as the original reporter pops back up again I will get some
more details from him and see about getting a more complete picture of what
exactly is going on.  Thanks,

Josef
