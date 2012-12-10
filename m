From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] ext3: Warn if mounting rw on a disk requiring
 stable page writes
Date: Mon, 10 Dec 2012 11:41:34 +0100
Message-ID: <20121210104134.GB7213@quack.suse.cz>
References: <20121121020056.10225.15220.stgit@blackbox.djwong.org>
 <20121121021543.GI10507@quack.suse.cz>
 <20121121211319.GA32202@blackbox.djwong.org>
 <20121121213333.GF30250@quack.suse.cz>
 <20121122084713.69e5b1fc@notabene.brown>
 <20121122014755.GH8740@blackbox.djwong.org>
 <20121122091240.GA11154@quack.suse.cz>
 <20121127021740.GA11869@blackbox.djwong.org>
 <20121205121228.GB5706@quack.suse.cz>
 <20121208010958.GB22952@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, NeilBrown <neilb@suse.de>,
	axboe@kernel.dk, lucho@ionkov.net, ericvh@gmail.com, tytso@mit.edu,
	rminnich@sandia.gov, viro@zeniv.linux.org.uk,
	martin.petersen@oracle.com, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46071 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577Ab2LJKlk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Dec 2012 05:41:40 -0500
Content-Disposition: inline
In-Reply-To: <20121208010958.GB22952@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 07-12-12 17:09:58, Darrick J. Wong wrote:
> On Wed, Dec 05, 2012 at 01:12:28PM +0100, Jan Kara wrote:
> > On Mon 26-11-12 18:17:40, Darrick J. Wong wrote:
> > > On Thu, Nov 22, 2012 at 10:12:40AM +0100, Jan Kara wrote:
> > > > On Wed 21-11-12 17:47:55, Darrick J. Wong wrote:
> > > >   I'll check the patches. Fixing PageWriteback logic for ext3 is not easily
> > > > doable due to lock ranking constraints - PageWriteback has to be set under
> > > > PageLocked but that ranks above transaction start so kjournald cannot grab
> > > > page locks so it cannot set PageWriteback... And changing the lock ordering
> > > > is a major surgery.
> > > > 
> > > > What could be doable is waiting for buffer locks from ext3's ->write_begin
> > > > and ->page_mkwrite implementations in case stable writes are required. If
> > > > your approach with a separate page bit doesn't work out (and I have some
> > > > doubts about that as mm people are *really* thrifty with page bits).
> > > > 
> > > > > > > 	/*
> > > > > > > 	 * In data=ordered mode, kjournald writes buffers without setting
> > > > > > > 	 * PageWriteback bit thus generic code does not properly wait for
> > > > > > > 	 * writeback of those buffers to finish.
> > > > > > > 	 */
> > > > > > > 	if (!read_only &&
> > > > > > > 	    test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA &&
> > > > > 
> > > > > test_opt(sb, DATA_FLAGS) != EXT3_MOUNT_WRITEBACK_DATA
> > > > > 
> > > > > since I bet data=journal mode is also borken wrt PageWriteback.
> > > >   It is broken wrt PageWriteback but it actually waits for buffer locks in
> > > > ->write_begin() so at least write path should be properly protected. But
> > > > mmap is not handled properly there (although that wouldn't be that hard to
> > > > fix). So I agree the condition should rather be what you suggest.
> >   Sorry for late reply. I was on vacation...
> 
> No worries; I have plenty of other patchsets to work on. :)
> 
> > > Hm.  In journal mode, write_begin calls do_journal_get_write_access on each
> > > buffer for a given page, and in turn, jbd's do_get_write_access calls
> > > lock_buffer.  Is that what you're referring to by "actually waits for buffer
> > > locks"?  I'm wondering how that helps us, since afaict PG_writeback doesn't get
> > > set in that path, and I think it's a little early to be setting PG_writeback
> > > anyway.
> >   It does help us. In ext3 data writeback is done either by flusher thread,
> > that happens under PG_Writeback and generic code waits for that as need, or
> > by kjournald - that happens under buffer lock and as you properly observed
> > do_get_write_access() waits for that (and actually copies data that should
> > go to disk to a separate buffer if needed).
> 
> Hm.  jbd2 calls generic_writepages to flush those buffers out, which sets
> PG_writeback like you'd expect.  It'd be nice if you could do that like ext4
> does... but then the ext3 writepage functions can call journal start/stop.
  Yes, it would be nice if ext3 did it the way ext4 does but as I already
said earlier, that's a major change to the way locking is done. ext3 has
lock ordering PageLock -> transaction start, while ext4 has lock ordering
transaction start -> PageLock. This influences a lot of places so it's too
big change to do to ext3 which is in maintenance only mode.

> Maybe we could call block_write_full_page directly?
  You have to have the page locked to call that function. Otherwise someone
could invalidate the page under your hands (or do other sort of things
function does not expect).

> > > If the page has to be locked before the transaction starts, how much of a
> > > problem is it to set PG_writeback?  Even though that seems a bit early to be
> > > doing that?
> >   Well, what you would need to make things consistent is to set
> > PG_writeback from kjournald so that all writeback happens with PG_writeback
> > set on the page. But setting has to happen while the page is locked and
> > kjournald can never block on page lock because that would cause
> > deadlocks...
> 
> Right now we try to submit_bh() everything on commit->t_sync_datalist without
> the page lock.  I guess we could try to lock (and set writeback on) every page
> on that list, and anything that we can lock then goes on a new
> t_locked_for_sync list.  If we find a page that's already locked, simply back
> out to the main kjournald loop and try the whole mess again.  Once all the
> pages are on the locked_for_sync list, then we can unlock the pages and
> actually commit the transaction.
  That's just more complicated way of implementing page lock ;) It won't
remove deadlocks.

> But, uck, that feels like courting disaster.  Do people sleep with a page
> locked?
  Yes, they do - for example in ext3_write_begin(), ext3_journal_start()
can sleep waiting for kjournald to commit a transaction :). That's the
deadlock I'm talking about...

>  I'm unsure of the wisdom of making jbd do that.  Can we stall out
> forever if someone keeps shoving pages onto t_sync_data?
  That's not an issue. Once transaction commit starts, no new buffers can
be added to it.

  Hum, I was thinking about how to implement proper exclusion in ext3 using
buffer locks and it won't be easy. Buffered writes are simple enough but
mmap is tricky - we'd have to writeprotect the page at the moment we add
buffer to t_sync_datalist (at that moment we hold the page lock so that is
doable). That page_mkwrite will have to wait for transaction commit (or
write the buffers) if underlying buffers are in t_sync_datalist. That will
make mixing of buffered IO and mmap writes to the same page very slow but
maybe that would be acceptable. I'll think about it some more...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
