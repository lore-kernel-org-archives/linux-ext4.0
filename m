From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd_commit_transaction() races with
	journal_try_to_drop_buffers() causing DIO failures
Date: Tue, 13 May 2008 16:20:34 +0200
Message-ID: <20080513142034.GB20806@duck.suse.cz>
References: <20080428122626.GC17054@duck.suse.cz> <1209402694.23575.5.camel@badari-desktop> <20080428180932.GI17054@duck.suse.cz> <1209409764.11872.6.camel@localhost.localdomain> <20080429124321.GD1987@duck.suse.cz> <1209654981.27240.19.camel@badari-desktop> <20080505170636.GK25722@duck.suse.cz> <1210372072.3639.52.camel@localhost.localdomain> <20080512155419.GD15856@duck.suse.cz> <1210620206.3661.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Badari Pulavarty <pbadari@us.ibm.com>, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760404AbYEMOUw@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1210620206.3661.21.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 12-05-08 12:23:26, Mingming Cao wrote:
> On Mon, 2008-05-12 at 17:54 +0200, Jan Kara wrote:
> > On Fri 09-05-08 15:27:52, Mingming Cao wrote:
> > > > > I was able to reproduce the customer problem involving DIO
> > > > > (invalidate_inode_pages2) problem by writing simple testcase
> > > > > to keep writing to a file using buffered writes and DIO writes
> > > > > forever in a loop. I see DIO writes fail with -EIO.
> > > > > 
> > > > > After a long debug, found 2 cases how this could happen.
> > > > > These are race conditions with journal_try_to_free_buffers()
> > > > > and journal_commit_transaction().
> > > > > 
> > > > > 1) journal_submit_data_buffers() tries to get bh_state lock. If
> > > > > try lock fails, it drops the j_list_lock and sleeps for
> > > > > bh_state lock, while holding a reference on the buffer.
> > > > > In the meanwhile, journal_try_to_free_buffers() can clean up the
> > > > > journal head could call try_to_free_buffers(). try_to_free_buffers()
> > > > > would fail due to the reference held by journal_submit_data_buffers()
> > > > > - which in turn causes failues for DIO (invalidate_inode_pages2()).
> > > > > 
> > > > > 2) When the buffer is on t_locked_list waiting for IO to finish,
> > > > > we hold a reference and give up the cpu, if we can't get
> > > > > bh_state lock. This causes try_to_free_buffers() to fail.
> > > > > 
> > > > > Fix is to drop the reference on the buffer if we can't get
> > > > > bh_state lock, give up the cpu and re-try the whole operation -
> > > > > instead of waiting for the vh_state lock.
> > > > > 
> > > > > Does this look like a resonable fix ?
> > > >   As Mingming pointed out there are few other places where we could hold
> > > > the bh reference. Note also that we accumulate references to buffers in the
> > > > wbuf[] list and we need that for submit_bh() which consumes one bh
> > > > reference. Generally, it seems to me as a too fragile and impractical
> > > > rule "nobody can hold bh reference when not holding page lock" which is
> > > > basically what it comes down to if you really want to be sure that
> > > > journal_try_to_free_buffers() succeeds. And also note that in principle
> > > > there are other places which hold references to buffers without holding the
> > > > page lock - for example writepage() in ordered mode (although this one is
> > > > in practice hardly triggerable). So how we could fix at least the races
> > > > with commit code is to implement launder_page() callback for ext3/4 which
> > > > would wait for the previous transaction commit in case the page has buffers
> > > > that are part of that commit (I don't want this logic in
> > > > journal_try_to_free_buffers() as that is called also on memory-reclaim
> > > > path, but journal_launder_page() is fine with me). 
> > > 
> > > I am not sure how we are going to gurantee that by the time
> > > journal_try_to_free_buffers() get called, the page has buffers are not
> > > as part of the current transaction commit(which could be different than
> > > the one we waited in ext3_launder_page())?  
> >   Hmm, you are right. It is not enough to just wait in ext3_launder_page()
> > because we don't have a transaction for direct_IO started yet. But if we
> > actually released buffers from the page there, it should be fine.
> > 
> 
> Do you mean calling journal_try_to_free_buffers() inside
> ext3_launder_page()? I think we still need some lock to serialize
> launder_page() with kjournald commit code(not sure if is that Okay?),
> otherwise there is always a window that by the time
> try_to_free_buffers() get called, the current transaction has be
> changed...
  Once we succeed with removing journal heads from data buffers in
journal_try_to_free_buffers(), they can be added only if someone dirties
the page via mmap and writepage is called (which I'd currently neglect as
too rare and not common usage). So after that moment, once commit code
drops references to buffer heads, we can happily remove those buffers. 

> > > It seems more realistic to fix the races one by one to me.
> >   Not to me, really. The scheme for buffer references you are trying to
> > impose is awkward to say the least. First, it is completely
> > counter-intuitive (at least to me ;), second, it is impractical as well.
> 
> Sigh...I am not very happy with the solution either, but I could not see
> a decent solution that could fix this problem.  Currently we constantly
> hit EIO error only in 10 minutes with the simple parallel buffered IO
> and direct IO:(...
  Yes, buffered and unbuffered writes should happily live together...

> > For example in your scheme, you have no sensible way of locking ordered
> > data mode buffer - you cannot just do: get the reference and do
> > lock_buffer() because that violates your requirements.  The only reasonable
> > way you could do that is to lock the page to make sure buffer won't go away
> > from you - but you cannot currently do that in journal commit code because
> > of lock ordering. So the only way I can see which is left is: get some jbd
> > spin lock to serialize with journal_try_to_free_buffers(), get the buffer
> > reference, try to lock buffer, if it fails, drop everything and restart.
> > And this is IMO no-go...
> >   And BTW even if you fix such races, I think you'll still have races like:
> > CPU1:                                      CPU2:
> >   filemap_write_and_wait()
> >                                            dirty a page
> >                                            msync() (dirties buffers)
> >   invalidate_inode_page2_range() -> -EIO
> > 
> 
> I could see this is possible with mapped IO. But for buffered IO, since
> direct IO is holding a i_mutex, this case should not happen,right?
  Yes.

> > > @@ -209,19 +213,24 @@ write_out_data:
> > >  		if (buffer_dirty(bh)) {
> > >  			if (test_set_buffer_locked(bh)) {
> > >  				BUFFER_TRACE(bh, "needs blocking lock");
> > > +				put_bh(bh);
> > >  				spin_unlock(&journal->j_list_lock);
> > >  				/* Write out all data to prevent deadlocks */
> > >  				journal_do_submit_data(wbuf, bufs);
> > >  				bufs = 0;
> > > -				lock_buffer(bh);
> > >  				spin_lock(&journal->j_list_lock);
> > > +				continue;
> >   ^^^ Here you can see what I wrote above. Basically you just busy-loop
> > wait for buffer lock. You should at least put schedule() there so that you
> > don't lockup the CPU but it's ugly anyway.
> > 
> Yup. 
> 
> The conflict is that if we still held the bh refrence after released the
> j_list_lock, journal_try_to_free_buffers() could came in returns EIO to
> direct IO since buffer is busy(); but if we release the bh reference
> after released the j_list_lock, it made possible that
> journal_try_to_free_buffers() to free that buffer, so we can't do
> lock_buffer() here anymore so we have to loop here. This is a trade
> off ...
> 
> On the other hand, the journal_submit_data_bufferes() continue process
> this buffer after regrab the j_list_lock even if it's has been removed
> from the t_syncdata_list by __journal_try_to_free_buffers(). IMO this is
> not the optimized way.
  Well, you are going to hit this path for example when the buffer is under
IO just now. So it happens quite often e.g. when the machine is under
memory pressure and writes-out dirty data more aggressively.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
