From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] jbd_commit_transaction() races with
	journal_try_to_drop_buffers() causing DIO failures
Date: Mon, 12 May 2008 12:23:26 -0700
Message-ID: <1210620206.3661.21.camel@localhost.localdomain>
References: <20080306174209.GA14193@duck.suse.cz>
	 <1209166706.6040.20.camel@localhost.localdomain>
	 <20080428122626.GC17054@duck.suse.cz>
	 <1209402694.23575.5.camel@badari-desktop>
	 <20080428180932.GI17054@duck.suse.cz>
	 <1209409764.11872.6.camel@localhost.localdomain>
	 <20080429124321.GD1987@duck.suse.cz>
	 <1209654981.27240.19.camel@badari-desktop>
	 <20080505170636.GK25722@duck.suse.cz>
	 <1210372072.3639.52.camel@localhost.localdomain>
	 <20080512155419.GD15856@duck.suse.cz>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Badari Pulavarty <pbadari@us.ibm.com>, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40307 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757518AbYELTXj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2008 15:23:39 -0400
In-Reply-To: <20080512155419.GD15856@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-05-12 at 17:54 +0200, Jan Kara wrote:
>   Hello,
> 
> On Fri 09-05-08 15:27:52, Mingming Cao wrote:
> > > > I was able to reproduce the customer problem involving DIO
> > > > (invalidate_inode_pages2) problem by writing simple testcase
> > > > to keep writing to a file using buffered writes and DIO writes
> > > > forever in a loop. I see DIO writes fail with -EIO.
> > > > 
> > > > After a long debug, found 2 cases how this could happen.
> > > > These are race conditions with journal_try_to_free_buffers()
> > > > and journal_commit_transaction().
> > > > 
> > > > 1) journal_submit_data_buffers() tries to get bh_state lock. If
> > > > try lock fails, it drops the j_list_lock and sleeps for
> > > > bh_state lock, while holding a reference on the buffer.
> > > > In the meanwhile, journal_try_to_free_buffers() can clean up the
> > > > journal head could call try_to_free_buffers(). try_to_free_buffers()
> > > > would fail due to the reference held by journal_submit_data_buffers()
> > > > - which in turn causes failues for DIO (invalidate_inode_pages2()).
> > > > 
> > > > 2) When the buffer is on t_locked_list waiting for IO to finish,
> > > > we hold a reference and give up the cpu, if we can't get
> > > > bh_state lock. This causes try_to_free_buffers() to fail.
> > > > 
> > > > Fix is to drop the reference on the buffer if we can't get
> > > > bh_state lock, give up the cpu and re-try the whole operation -
> > > > instead of waiting for the vh_state lock.
> > > > 
> > > > Does this look like a resonable fix ?
> > >   As Mingming pointed out there are few other places where we could hold
> > > the bh reference. Note also that we accumulate references to buffers in the
> > > wbuf[] list and we need that for submit_bh() which consumes one bh
> > > reference. Generally, it seems to me as a too fragile and impractical
> > > rule "nobody can hold bh reference when not holding page lock" which is
> > > basically what it comes down to if you really want to be sure that
> > > journal_try_to_free_buffers() succeeds. And also note that in principle
> > > there are other places which hold references to buffers without holding the
> > > page lock - for example writepage() in ordered mode (although this one is
> > > in practice hardly triggerable). So how we could fix at least the races
> > > with commit code is to implement launder_page() callback for ext3/4 which
> > > would wait for the previous transaction commit in case the page has buffers
> > > that are part of that commit (I don't want this logic in
> > > journal_try_to_free_buffers() as that is called also on memory-reclaim
> > > path, but journal_launder_page() is fine with me). 
> > 
> > I am not sure how we are going to gurantee that by the time
> > journal_try_to_free_buffers() get called, the page has buffers are not
> > as part of the current transaction commit(which could be different than
> > the one we waited in ext3_launder_page())?  
>   Hmm, you are right. It is not enough to just wait in ext3_launder_page()
> because we don't have a transaction for direct_IO started yet. But if we
> actually released buffers from the page there, it should be fine.
> 

Do you mean calling journal_try_to_free_buffers() inside
ext3_launder_page()? I think we still need some lock to serialize
launder_page() with kjournald commit code(not sure if is that Okay?),
otherwise there is always a window that by the time
try_to_free_buffers() get called, the current transaction has be
changed...

> > It seems more realistic to fix the races one by one to me.
>   Not to me, really. The scheme for buffer references you are trying to
> impose is awkward to say the least. First, it is completely
> counter-intuitive (at least to me ;), second, it is impractical as well.

Sigh...I am not very happy with the solution either, but I could not see
a decent solution that could fix this problem.  Currently we constantly
hit EIO error only in 10 minutes with the simple parallel buffered IO
and direct IO:(...


> For example in your scheme, you have no sensible way of locking ordered
> data mode buffer - you cannot just do: get the reference and do
> lock_buffer() because that violates your requirements.  The only reasonable
> way you could do that is to lock the page to make sure buffer won't go away
> from you - but you cannot currently do that in journal commit code because
> of lock ordering. So the only way I can see which is left is: get some jbd
> spin lock to serialize with journal_try_to_free_buffers(), get the buffer
> reference, try to lock buffer, if it fails, drop everything and restart.
> And this is IMO no-go...
>   And BTW even if you fix such races, I think you'll still have races like:
> CPU1:                                      CPU2:
>   filemap_write_and_wait()
>                                            dirty a page
>                                            msync() (dirties buffers)
>   invalidate_inode_page2_range() -> -EIO
> 

I could see this is possible with mapped IO. But for buffered IO, since
direct IO is holding a i_mutex, this case should not happen,right?


>   The code could historically always return EIO when mixing buffered and
> unbuffered accesses and the question is, under which circumstances is this
> acceptable?  I agree that the current state when if you do "buffered write,
> DIO write" in sequence and you'll possibly get EIO is bad and we should fix
> it. But I'm not sure we should fix the EIO return under all possible
> circumstances at all costs...
> 
> > There is still a window that journal_submit_data_buffers() already
> > removed the jh from the bh (when found the buffers are already being
> > synced), but still keep a reference to the buffer head.
> > journal_try_to_free_buffers() could be called. In that case
> > try_to_free_buffers() will be called since there is no jh related to
> > this buffer, and failed due to journal_submit_data_buffers() hasn't
> > finish the cleanup business yet. 
> > 
> > For this new race, we could just grab the j_list_lock when re-try
> > try_to_free_buffers() to force waiting for journal_commit_transaction()
> > to finish it flush work. But not sure if this is acceptable approach?
> > 
> > Patch like this? Comments?
> >
> > ---------------------------------------------------------------------
> > There are a few cases direct IO could race with kjournal flushing
> > data buffers which could result direct IO return EIO error.
> > 
> > 1) journal_submit_data_buffers() tries to get bh_state lock. If
> > try lock fails, it drops the j_list_lock and sleeps for
> > bh_state lock, while holding a reference on the buffer.
> > In the meanwhile, journal_try_to_free_buffers() can clean up the
> > journal head could call try_to_free_buffers(). try_to_free_buffers()
> > would fail due to the reference held by journal_submit_data_buffers()
> > - which in turn causes failues for DIO (invalidate_inode_pages2()).
> > 
> > 2) When the buffer is on t_locked_list waiting for IO to finish,
> > we hold a reference and give up the cpu, if we can't get
> > bh_state lock. This causes try_to_free_buffers() to fail.
> > 
> > 3) when journal_submit_data_buffers() saw the buffer is dirty but failed
> > to lock the buffer bh1, journal_submit_data_buffers() released the
> > j_list_lock and submit other buffers collected from previous check, with
> > the reference to bh1 still hold. During this time
> > journal_try_to_free_buffers() could clean up the journal head of bh1 and
> > remove it from the t_syncdata_list. Then try_to_free_buffers() would
> > fail because the reference held by journal_submit_data_buffers()
> > 
> > 4) journal_submit_data_buffers() already removed the jh from the bh
> > (when found the buffers are already being synced), but still keep a
> > reference to the buffer head. journal_try_to_free_buffers() could be
> > called. In that case try_to_free_buffers() will be called since there is
> > no jh related to this buffer, and failed due to
> > journal_submit_data_buffers() hasn't finish the cleanup business yet. 
> > 
> > Fix for first three races is to drop the reference on the buffer head
> >  when release the j_list_lock,
> > give up the cpu and re-try the whole operation. 
> > 
> > This patch also fixes the race that data buffers has been
> > flushed to disk and journal head is cleard
> > by journal_submit_data_buffers() but did not get a chance to release
> >  buffer head reference before the journal_try_to_free_buffers() kicked in.
> > 
> > 
> > Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
> > Signed-off-by: Mingming Cao <mcao@us.ibm.com>
> > ---
> >  fs/jbd/commit.c      |   21 ++++++++++++++++-----
> >  fs/jbd/transaction.c |   13 +++++++++++++
> >  2 files changed, 29 insertions(+), 5 deletions(-)
> > 
> > Index: linux-2.6.26-rc1/fs/jbd/commit.c
> > ===================================================================
> > --- linux-2.6.26-rc1.orig/fs/jbd/commit.c	2008-05-03 11:59:44.000000000 -0700
> > +++ linux-2.6.26-rc1/fs/jbd/commit.c	2008-05-09 14:44:36.000000000 -0700
> > @@ -79,12 +79,16 @@ nope:
> >  
> >  /*
> >   * Try to acquire jbd_lock_bh_state() against the buffer, when j_list_lock is
> > - * held.  For ranking reasons we must trylock.  If we lose, schedule away and
> > + * held.  For ranking reasons we must trylock.  If we lose,  unlock the buffer
> > + * if needed, drop the reference on the buffer, schedule away and
> >   * return 0.  j_list_lock is dropped in this case.
> >   */
> > -static int inverted_lock(journal_t *journal, struct buffer_head *bh)
> > +static int inverted_lock(journal_t *journal, struct buffer_head *bh, int locked)
> >  {
> >  	if (!jbd_trylock_bh_state(bh)) {
> > +		if (locked)
> > +			unlock_buffer(bh);
> > +		put_bh(bh);
> >  		spin_unlock(&journal->j_list_lock);
> >  		schedule();
> >  		return 0;
> > @@ -209,19 +213,24 @@ write_out_data:
> >  		if (buffer_dirty(bh)) {
> >  			if (test_set_buffer_locked(bh)) {
> >  				BUFFER_TRACE(bh, "needs blocking lock");
> > +				put_bh(bh);
> >  				spin_unlock(&journal->j_list_lock);
> >  				/* Write out all data to prevent deadlocks */
> >  				journal_do_submit_data(wbuf, bufs);
> >  				bufs = 0;
> > -				lock_buffer(bh);
> >  				spin_lock(&journal->j_list_lock);
> > +				continue;
>   ^^^ Here you can see what I wrote above. Basically you just busy-loop
> wait for buffer lock. You should at least put schedule() there so that you
> don't lockup the CPU but it's ugly anyway.
> 
Yup. 

The conflict is that if we still held the bh refrence after released the
j_list_lock, journal_try_to_free_buffers() could came in returns EIO to
direct IO since buffer is busy(); but if we release the bh reference
after released the j_list_lock, it made possible that
journal_try_to_free_buffers() to free that buffer, so we can't do
lock_buffer() here anymore so we have to loop here. This is a trade
off ...

On the other hand, the journal_submit_data_bufferes() continue process
this buffer after regrab the j_list_lock even if it's has been removed
from the t_syncdata_list by __journal_try_to_free_buffers(). IMO this is
not the optimized way.

> >  			}
> >  			locked = 1;
> >  		}
> > -		/* We have to get bh_state lock. Again out of order, sigh. */
> > -		if (!inverted_lock(journal, bh)) {
> > -			jbd_lock_bh_state(bh);
> > +		/*
> > +		 * We have to get bh_state lock. If the try lock fails,
> > +		 * release the ref on the buffer, give up cpu and retry the
> > +		 * whole operation.
> > +		 */
> > +		if (!inverted_lock(journal, bh, locked)) {
> >  			spin_lock(&journal->j_list_lock);
> > +			continue;
> >  		}
>   ^^^ And here you add a place where we are not guaranteed to make any
> progress... If someone intensively spins on that buffer, commit code could
> cycle here forever (or at least for quite a long time).
> 
> >  		/* Someone already cleaned up the buffer? */
> >  		if (!buffer_jbd(bh)
> > @@ -430,8 +439,7 @@ void journal_commit_transaction(journal_
> >  				err = -EIO;
> >  			spin_lock(&journal->j_list_lock);
> >  		}
> > -		if (!inverted_lock(journal, bh)) {
> > -			put_bh(bh);
> > +		if (!inverted_lock(journal, bh, 0)) {
> >  			spin_lock(&journal->j_list_lock);
> >  			continue;
> >  		}
> > Index: linux-2.6.26-rc1/fs/jbd/transaction.c
> > ===================================================================
> > --- linux-2.6.26-rc1.orig/fs/jbd/transaction.c	2008-05-03 11:59:44.000000000 -0700
> > +++ linux-2.6.26-rc1/fs/jbd/transaction.c	2008-05-09 09:53:57.000000000 -0700
> > @@ -1714,6 +1714,19 @@ int journal_try_to_free_buffers(journal_
> >  			goto busy;
> >  	} while ((bh = bh->b_this_page) != head);
> >  	ret = try_to_free_buffers(page);
> > +	if (ret == 0) {
> > +		/*
> > +		 * it is possible that journal_submit_data_buffers()
> > +		 * still holds the bh ref even if clears the jh
> > +		 * after journal_remove_journal_head,
> > +		 * which leads to try_to_free_buffers() failed
> > +		 * let's wait for journal_submit_data_buffers()
> > +		 * to finishing remove the bh from the sync_data_list
> > +		 */
> > +		spin_lock(&journal->j_list_lock);
> > +		ret = try_to_free_buffers(page);
> > +		spin_unlock(&journal->j_list_lock);
> > +	}
> >  busy:
> >  	return ret;
> >  }
> 
> 									Honza

