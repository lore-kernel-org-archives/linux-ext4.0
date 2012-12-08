From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/4] ext3: Warn if mounting rw on a disk requiring stable
 page writes
Date: Fri, 7 Dec 2012 17:09:58 -0800
Message-ID: <20121208010958.GB22952@blackbox.djwong.org>
References: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
 <20121121020056.10225.15220.stgit@blackbox.djwong.org>
 <20121121021543.GI10507@quack.suse.cz>
 <20121121211319.GA32202@blackbox.djwong.org>
 <20121121213333.GF30250@quack.suse.cz>
 <20121122084713.69e5b1fc@notabene.brown>
 <20121122014755.GH8740@blackbox.djwong.org>
 <20121122091240.GA11154@quack.suse.cz>
 <20121127021740.GA11869@blackbox.djwong.org>
 <20121205121228.GB5706@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: NeilBrown <neilb@suse.de>, axboe@kernel.dk, lucho@ionkov.net,
	ericvh@gmail.com, tytso@mit.edu, rminnich@sandia.gov,
	viro@zeniv.linux.org.uk, martin.petersen@oracle.com,
	david@fromorbit.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
	bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27955 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377Ab2LHBLN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Dec 2012 20:11:13 -0500
Content-Disposition: inline
In-Reply-To: <20121205121228.GB5706@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 05, 2012 at 01:12:28PM +0100, Jan Kara wrote:
> On Mon 26-11-12 18:17:40, Darrick J. Wong wrote:
> > On Thu, Nov 22, 2012 at 10:12:40AM +0100, Jan Kara wrote:
> > > On Wed 21-11-12 17:47:55, Darrick J. Wong wrote:
> > > > On Thu, Nov 22, 2012 at 08:47:13AM +1100, NeilBrown wrote:
> > > > > On Wed, 21 Nov 2012 22:33:33 +0100 Jan Kara <jack@suse.cz> wrote:
> > > > > 
> > > > > > On Wed 21-11-12 13:13:19, Darrick J. Wong wrote:
> > > > > > > On Wed, Nov 21, 2012 at 03:15:43AM +0100, Jan Kara wrote:
> > > > > > > > On Tue 20-11-12 18:00:56, Darrick J. Wong wrote:
> > > > > > > > > ext3 doesn't properly isolate pages from changes during writeback.  Since the
> > > > > > > > > recommended fix is to use ext4, for now we'll just print a warning if the user
> > > > > > > > > tries to mount in write mode.
> > > > > > > > > 
> > > > > > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > > > > ---
> > > > > > > > >  fs/ext3/super.c |    8 ++++++++
> > > > > > > > >  1 file changed, 8 insertions(+)
> > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> > > > > > > > > index 5366393..5b3725d 100644
> > > > > > > > > --- a/fs/ext3/super.c
> > > > > > > > > +++ b/fs/ext3/super.c
> > > > > > > > > @@ -1325,6 +1325,14 @@ static int ext3_setup_super(struct super_block *sb, struct ext3_super_block *es,
> > > > > > > > >  			"forcing read-only mode");
> > > > > > > > >  		res = MS_RDONLY;
> > > > > > > > >  	}
> > > > > > > > > +	if (!read_only &&
> > > > > > > > > +	    queue_requires_stable_pages(bdev_get_queue(sb->s_bdev))) {
> > > > > > > > > +		ext3_msg(sb, KERN_ERR,
> > > > > > > > > +			"error: ext3 cannot safely write data to a disk "
> > > > > > > > > +			"requiring stable pages writes; forcing read-only "
> > > > > > > > > +			"mode.  Upgrading to ext4 is recommended.");
> > > > > > > > > +		res = MS_RDONLY;
> > > > > > > > > +	}
> > > > > > > > >  	if (read_only)
> > > > > > > > >  		return res;
> > > > > > > > >  	if (!(sbi->s_mount_state & EXT3_VALID_FS))
> > > > > > > >   Why this? ext3 should be fixed by your change to
> > > > > > > > filemap_page_mkwrite()... Or does testing show otherwise?
> > > > > > > 
> > > > > > > Yes, it's still broken even with this new set of changes.  Now that I think
> > > > > > > about it a little more, I recall that writeback mode was actually fine, so this
> > > > > > > is a little harsh.
> > > > > > > 
> > > > > > > Hm... looking at the ordered code a little more, it looks like
> > > > > > > ext3_ordered_write_end is calling journal_dirty_data_fn, which (I guess?) tries
> > > > > > > to write mapped buffers back through the journal?  Taking it out seems to fix
> > > > > > > ordered mode, though I have a suspicion that it might very well break ordered
> > > > > > > mode too.
> > > > > >   Oh, right. kjournald writing buffers directly (without setting
> > > > > > PageWriteback) will break things. So please, change warning to:
> > > > 
> > > > Maybe we should just fix this anyway?
> > > > 
> > > > I still have the patch that adds PG_stable (and changes the
> > > > wait_for_page_stable() test to use this flag instead of PG_writeback) kicking
> > > > around in my tree.  I wrote a patch to jbd that changes journal_do_submit_data
> > > > to set PG_stable, call clear_page_dirty_for_io(), and unsets the stable bit in
> > > > the end_io processing.
> > > > 
> > > > It seems to get rid of the checksum-after-write errors, though I'm not
> > > > convinced it's correct.  But, I'll send both patches along.
> > >   I'll check the patches. Fixing PageWriteback logic for ext3 is not easily
> > > doable due to lock ranking constraints - PageWriteback has to be set under
> > > PageLocked but that ranks above transaction start so kjournald cannot grab
> > > page locks so it cannot set PageWriteback... And changing the lock ordering
> > > is a major surgery.
> > > 
> > > What could be doable is waiting for buffer locks from ext3's ->write_begin
> > > and ->page_mkwrite implementations in case stable writes are required. If
> > > your approach with a separate page bit doesn't work out (and I have some
> > > doubts about that as mm people are *really* thrifty with page bits).
> > > 
> > > > > > 	/*
> > > > > > 	 * In data=ordered mode, kjournald writes buffers without setting
> > > > > > 	 * PageWriteback bit thus generic code does not properly wait for
> > > > > > 	 * writeback of those buffers to finish.
> > > > > > 	 */
> > > > > > 	if (!read_only &&
> > > > > > 	    test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA &&
> > > > 
> > > > test_opt(sb, DATA_FLAGS) != EXT3_MOUNT_WRITEBACK_DATA
> > > > 
> > > > since I bet data=journal mode is also borken wrt PageWriteback.
> > >   It is broken wrt PageWriteback but it actually waits for buffer locks in
> > > ->write_begin() so at least write path should be properly protected. But
> > > mmap is not handled properly there (although that wouldn't be that hard to
> > > fix). So I agree the condition should rather be what you suggest.
>   Sorry for late reply. I was on vacation...

No worries; I have plenty of other patchsets to work on. :)

> > Hm.  In journal mode, write_begin calls do_journal_get_write_access on each
> > buffer for a given page, and in turn, jbd's do_get_write_access calls
> > lock_buffer.  Is that what you're referring to by "actually waits for buffer
> > locks"?  I'm wondering how that helps us, since afaict PG_writeback doesn't get
> > set in that path, and I think it's a little early to be setting PG_writeback
> > anyway.
>   It does help us. In ext3 data writeback is done either by flusher thread,
> that happens under PG_Writeback and generic code waits for that as need, or
> by kjournald - that happens under buffer lock and as you properly observed
> do_get_write_access() waits for that (and actually copies data that should
> go to disk to a separate buffer if needed).

Hm.  jbd2 calls generic_writepages to flush those buffers out, which sets
PG_writeback like you'd expect.  It'd be nice if you could do that like ext4
does... but then the ext3 writepage functions can call journal start/stop.

Maybe we could call block_write_full_page directly?

> > If the page has to be locked before the transaction starts, how much of a
> > problem is it to set PG_writeback?  Even though that seems a bit early to be
> > doing that?
>   Well, what you would need to make things consistent is to set
> PG_writeback from kjournald so that all writeback happens with PG_writeback
> set on the page. But setting has to happen while the page is locked and
> kjournald can never block on page lock because that would cause
> deadlocks...

Right now we try to submit_bh() everything on commit->t_sync_datalist without
the page lock.  I guess we could try to lock (and set writeback on) every page
on that list, and anything that we can lock then goes on a new
t_locked_for_sync list.  If we find a page that's already locked, simply back
out to the main kjournald loop and try the whole mess again.  Once all the
pages are on the locked_for_sync list, then we can unlock the pages and
actually commit the transaction.

But, uck, that feels like courting disaster.  Do people sleep with a page
locked?  I'm unsure of the wisdom of making jbd do that.  Can we stall out
forever if someone keeps shoving pages onto t_sync_data?

I actually tried a dumb trylock_page loop in journal_do_submit_data, but it
quickly stalled.

Ok, enough rambling, I'll give a few of my harebrained suggestions a try and
see what results.

--D
> 
> 									Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
